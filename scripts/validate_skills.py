#!/usr/bin/env python3
"""Static consistency checks for the skill library. No third-party packages required.

Usage:
  python3 scripts/validate_skills.py            # errors are fatal, warnings are printed
  python3 scripts/validate_skills.py --strict   # warnings are fatal too (used in CI)
"""
from __future__ import annotations

import argparse
import re
import sys
from collections import Counter
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
DOCS = ("README.md", "SKILL-MATRIX.md", "index.html", "CONTRIBUTING.md", "ROUTER.md", "AGENT.md")

# Sections every skill must carry. Optional sections are reported as coverage, not errors:
# a short, accurate skill beats one padded to reach a quota.
REQUIRED_SECTIONS = [
    "Overview", "When to Use This Skill", "When NOT to Use This Skill",
    "Workflow", "Advanced Techniques", "Common Patterns",
    "Edge Cases & Pitfalls", "Integration with Other Skills",
    "Output Format Templates", "Rules",
]
# Accepted variants that mean the same thing, keyed by canonical section.
SECTION_ALIASES = {
    "Inputs and Preconditions": ("Inputs and Preconditions", "Inputs Required", "Prerequisites"),
}
NAME_RE = re.compile(r"^[a-z0-9]+(?:-[a-z0-9]+)*$")
# Claude Code constraints for SKILL.md frontmatter.
NAME_MAX = 64
DESCRIPTION_MAX = 1024
FENCE_RE = re.compile(r"^\s*(```|~~~)")
QUOTA_HEADING_RE = re.compile(r"^## .*\(\d+[ -]?(techniques|items|rules|patterns|bullets|examples)\)?\s*$", re.I)
PERIODIC = Counter()
errors: list[str] = []
warnings: list[str] = []


def rel(path: Path) -> str:
    try:
        return path.relative_to(ROOT).as_posix()
    except ValueError:
        return str(path)


def split_frontmatter(text: str) -> tuple[str, str] | None:
    if not text.startswith("---\n"):
        return None
    match = re.match(r"^---\n(.*?)\n---\n(.*)$", text, re.S)
    if not match:
        return None
    return match.group(1), match.group(2)


def front_scalar(front: str, key: str) -> str:
    match = re.search(rf"^{re.escape(key)}:[ \t]*(.*)$", front, re.M)
    return match.group(1).strip() if match else ""


def front_block(front: str, key: str) -> str:
    """Value of a `key: >-` folded block, joined onto one line."""
    lines = front.split("\n")
    collected: list[str] = []
    for index, line in enumerate(lines):
        if re.match(rf"^{re.escape(key)}:", line):
            rest = line.split(":", 1)[1].strip()
            if rest and not rest.startswith(">"):
                collected.append(rest)
            for following in lines[index + 1:]:
                if re.match(r"^\s+\S", following):
                    collected.append(following.strip())
                elif not following.strip():
                    continue
                else:
                    break
            break
    return " ".join(collected).strip()


def list_field(value: str) -> list[str]:
    inner = value.strip()
    if inner.startswith("[") and inner.endswith("]"):
        inner = inner[1:-1]
    return [item.strip() for item in re.split(r"[,\n]", inner) if item.strip()]


def _same(candidate: str, alias: str) -> bool:
    """`## Workflow: Verification Pipeline` counts as the `Workflow` section."""
    return candidate == alias or candidate.startswith(alias + " ") or candidate.startswith(alias + ":")


def body_headings(body: str) -> list[str]:
    """Top-level `## ` headings, ignoring anything inside fenced code blocks."""
    headings: list[str] = []
    open_fence = None
    for line in body.split("\n"):
        fence = FENCE_RE.match(line)
        if fence:
            marker = fence.group(1)
            if open_fence is None:
                open_fence = marker
            elif open_fence == marker:
                open_fence = None
            continue
        if open_fence is None and line.startswith("## "):
            headings.append(line[3:].strip())
    return headings


def check_hygiene(path: Path, text: str) -> None:
    if "\r" in text:
        errors.append(f"{rel(path)}: contains CRLF line endings")
    if "\t" in text:
        errors.append(f"{rel(path)}: contains tab characters")
    if not text.endswith("\n") or text.endswith("\n\n"):
        errors.append(f"{rel(path)}: must end with exactly one newline")
    if text.startswith("\ufeff"):
        errors.append(f"{rel(path)}: has a UTF-8 BOM")
    offenders = [i + 1 for i, line in enumerate(text.split("\n")) if line != line.rstrip()]
    if offenders:
        shown = ", ".join(map(str, offenders[:5]))
        errors.append(f"{rel(path)}: trailing whitespace on {len(offenders)} line(s) [{shown}]")


def prose(text: str) -> str:
    """Markdown outside fenced code blocks: examples use `[link](...)` syntax as content."""
    kept: list[str] = []
    open_fence = None
    for line in text.split("\n"):
        fence = FENCE_RE.match(line)
        if fence:
            marker = fence.group(1)
            if open_fence is None:
                open_fence = marker
            elif open_fence == marker:
                open_fence = None
            kept.append("")
            continue
        kept.append("" if open_fence is not None else line)
    return "\n".join(kept)


def github_anchor(heading: str) -> str:
    """Approximates GitHub's slug rule, including the leading hyphen an emoji leaves behind."""
    return re.sub(r"[^\w\s-]", "", heading.strip().lower()).replace(" ", "-")


def anchors_of(text: str) -> set[str]:
    return {github_anchor(h) for h in re.findall(r"^#{1,6} +(.+?)\s*#*$", text, re.M)}


def check_links(path: Path, text: str) -> None:
    anchors = anchors_of(text)
    for match in re.finditer(r"\[[^\]]*\]\(([^)\s]+)\)", prose(text)):
        target = match.group(1)
        if target.startswith(("http://", "https://", "mailto:")):
            continue
        if target.startswith("#"):
            # In-page links break silently whenever a heading is reworded.
            if len(target) > 1 and target[1:] not in anchors:
                errors.append(f"{rel(path)}: in-page link '{target}' has no matching heading")
            continue
        if not re.fullmatch(r"[A-Za-z0-9_./\\-]+", target):
            continue
        candidate = (path.parent / target.split("#")[0]).resolve()
        if not candidate.exists():
            errors.append(f"{rel(path)}: broken local link '{target}'")


def main() -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--strict", action="store_true", help="treat warnings as errors")
    args = parser.parse_args()

    files = sorted(ROOT.glob("*/*/SKILL.md"))
    if not files:
        print("ERROR: no SKILL.md files found", file=sys.stderr)
        return 1

    skills: dict[str, Path] = {}
    frontmatter: dict[str, dict[str, object]] = {}
    inputs_coverage = 0

    for path in files:
        text = path.read_text(encoding="utf-8-sig")
        check_hygiene(path, text)
        check_links(path, text)
        parsed = split_frontmatter(text)
        if parsed is None:
            errors.append(f"{rel(path)}: missing or malformed YAML frontmatter")
            continue
        front, body = parsed

        name = front_scalar(front, "name")
        if not name:
            errors.append(f"{rel(path)}: missing name")
            continue
        if not NAME_RE.match(name):
            errors.append(f"{rel(path)}: name '{name}' must be kebab-case")
        if len(name) > NAME_MAX:
            errors.append(f"{rel(path)}: name is {len(name)} chars (Claude Code limit {NAME_MAX})")
        if name != path.parent.name:
            errors.append(f"{rel(path)}: name '{name}' must match its directory '{path.parent.name}'")
        if name in skills:
            errors.append(f"{rel(path)}: duplicate name '{name}' (also {rel(skills[name])})")
        skills[name] = path

        description = front_block(front, "description")
        if not description:
            errors.append(f"{rel(path)}: empty description")
        elif len(description) > DESCRIPTION_MAX:
            errors.append(
                f"{rel(path)}: description is {len(description)} chars (Claude Code limit {DESCRIPTION_MAX})"
            )
        if "TRIGGERS:" not in description.upper():
            warnings.append(f"{rel(path)}: description has no TRIGGERS list")
        if not re.search(r"[\u0600-\u06ff]", description):
            warnings.append(f"{rel(path)}: no Persian trigger text")
        if not re.search(r"[\u4e00-\u9fff]", description):
            warnings.append(f"{rel(path)}: no Chinese trigger text")

        priority = front_scalar(front, "priority")
        if priority not in {"P0", "P1", "P2", "P3"}:
            errors.append(f"{rel(path)}: priority must be P0-P3 (got '{priority}')")

        deps = [d for d in list_field(front_scalar(front, "dependencies"))]
        conflicts = [d for d in list_field(front_scalar(front, "conflicts"))]
        unknown_keys = {
            key for key in re.findall(r"^([A-Za-z][A-Za-z0-9_-]*):", front, re.M)
            if key not in {"name", "description", "priority", "dependencies", "conflicts"}
        }
        if unknown_keys:
            warnings.append(f"{rel(path)}: unknown frontmatter keys: {', '.join(sorted(unknown_keys))}")
        frontmatter[name] = {
            "path": path, "deps": deps, "conflicts": conflicts,
            "priority": priority, "lines": len(text.splitlines()),
            "category": path.parent.parent.name, "headings": body_headings(body),
        }

        headings = frontmatter[name]["headings"]
        canonical = [re.sub(r"\s*\([^)]*\)\s*$", "", h) for h in headings]
        missing = []
        for section in REQUIRED_SECTIONS:
            accepted = SECTION_ALIASES.get(section, (section,))
            if not any(any(_same(c, alias) for c in canonical) for alias in accepted):
                missing.append(section)
        if missing:
            warnings.append(f"{rel(path)}: missing sections: {', '.join(missing)}")
        # Map each heading onto its canonical section so `Workflow: 5-Pass Review`
        # compares equal to `Workflow` when checking order.
        present: list[str] = []
        for heading in canonical:
            for section in REQUIRED_SECTIONS:
                if _same(heading, section) and section not in present:
                    present.append(section)
                    break
        if present != [s for s in REQUIRED_SECTIONS if s in present]:
            warnings.append(f"{rel(path)}: sections are out of the documented order")
        duplicates = [h for h, count in Counter(canonical).items() if count > 1]
        if duplicates:
            errors.append(f"{rel(path)}: duplicate sections: {', '.join(sorted(set(duplicates)))}")
        quota = [h for h in headings if QUOTA_HEADING_RE.match(f"## {h}")]
        if quota:
            errors.append(f"{rel(path)}: quota-style headings ({', '.join(quota)}); count is not a quality signal")
        if body.count("```") % 2:
            errors.append(f"{rel(path)}: unbalanced code fence")
        if any(c in canonical for c in SECTION_ALIASES["Inputs and Preconditions"]):
            inputs_coverage += 1

    for name, meta in frontmatter.items():
        for field in ("deps", "conflicts"):
            for other in meta[field]:
                if other not in frontmatter:
                    errors.append(f"{rel(meta['path'])}: {field} references unknown skill '{other}'")
                elif field == "conflicts" and other == name:
                    errors.append(f"{rel(meta['path'])}: skill conflicts with itself")

    # Dependency cycles: a cycle makes "read dependencies first" unimplementable.
    state: dict[str, int] = {}
    stack: list[str] = []

    def visit(node: str) -> None:
        if state.get(node) == 1:
            cycle = stack[stack.index(node):] + [node]
            errors.append("dependency cycle: " + " -> ".join(cycle))
            return
        if state.get(node) == 2:
            return
        state[node] = 1
        stack.append(node)
        for dep in frontmatter[node]["deps"]:
            if dep in frontmatter:
                visit(dep)
        stack.pop()
        state[node] = 2

    for name in frontmatter:
        visit(name)

    total_lines = sum(int(m["lines"]) for m in frontmatter.values())
    expected_count = len(files)

    # Derived documents must agree with the library.
    readme = (ROOT / "README.md").read_text(encoding="utf-8") if (ROOT / "README.md").exists() else ""
    if str(expected_count) not in readme:
        warnings.append(f"README.md: does not mention the current skill count ({expected_count})")
    for claim in re.findall(r"approximately ([\d,]{4,}) lines", readme):
        if int(claim.replace(",", "")) != total_lines:
            errors.append(
                f"README.md: claims {claim} lines, the skills hold {total_lines:,}; run scripts/gen_matrix.py"
            )
    matrix = ROOT / "SKILL-MATRIX.md"
    if matrix.exists():
        try:
            sys.path.insert(0, str(ROOT / "scripts"))
            import gen_matrix  # noqa: PLC0415

            expected_matrix = gen_matrix.render(gen_matrix.load_skills())
            if matrix.read_text(encoding="utf-8").rstrip("\n") != expected_matrix.rstrip("\n"):
                errors.append("SKILL-MATRIX.md is stale; run: python3 scripts/gen_matrix.py")
        except SystemExit as exc:  # pragma: no cover
            errors.append(f"SKILL-MATRIX.md: {exc}")
        except Exception as exc:  # pragma: no cover - keep the validator usable standalone
            warnings.append(f"could not cross-check SKILL-MATRIX.md: {exc}")
    else:
        errors.append("SKILL-MATRIX.md is missing")

    index = ROOT / "index.html"
    if index.exists():
        html = index.read_text(encoding="utf-8")
        entries = re.findall(r"\['([a-z-]+)','([a-z0-9-]+)','(P\d)'", html)
        listed = {(cat, name) for cat, name, _ in entries}
        actual = {(str(m["category"]), name) for name, m in frontmatter.items()}
        for name in sorted({n for _, n in actual - listed}):
            errors.append(f"index.html: '{name}' is missing from the catalog array")
        for cat, name in sorted(listed - actual):
            errors.append(f"index.html: stale catalog entry ['{cat}','{name}']")
        for cat, name, priority in entries:
            meta = frontmatter.get(name)
            if meta and meta["priority"] != priority:
                errors.append(f"index.html: {name} is {meta['priority']}, catalog says {priority}")
        if str(expected_count) not in html:
            warnings.append(f"index.html: does not mention the current skill count ({expected_count})")
        claimed = re.search(r"<strong>([\d.]+)K</strong>", html)
        if claimed:
            actual_k = round(total_lines / 1000, 1)
            if abs(float(claimed.group(1)) - actual_k) > 0.05:
                warnings.append(f"index.html: stats say {claimed.group(1)}K lines, actual is {actual_k}K")

    # Every skill must be reachable from a realistic request, not only from a filename.
    router = (ROOT / "ROUTER.md").read_text(encoding="utf-8") if (ROOT / "ROUTER.md").exists() else ""
    routed = {token.rsplit("/", 1)[-1] for token in re.findall(r"`([A-Za-z0-9_./-]+)`", router)}
    unrouted = sorted(name for name in frontmatter if name not in routed)
    for name in unrouted:
        warnings.append(f"ROUTER.md: '{name}' is not reachable from any documented route")

    for doc in DOCS:
        path = ROOT / doc
        if not path.exists():
            errors.append(f"{doc}: missing")
            continue
        text = path.read_text(encoding="utf-8")
        check_links(path, text)
        check_hygiene(path, text)
    for extra in ("LICENSE", ".github/workflows/validate.yml"):
        if not (ROOT / extra).exists():
            errors.append(f"{extra}: missing")
    if (ROOT / "README.md").exists() and "MIT License" in readme and not (ROOT / "LICENSE").exists():
        errors.append("README.md promises an MIT License but LICENSE is missing")

    print(f"Checked {expected_count} skills in {len({str(m['category']) for m in frontmatter.values()})} categories")
    print(f"Total guidance lines: {total_lines:,}")
    print(f"Inputs/preconditions coverage: {inputs_coverage}/{expected_count} skills")
    for item in warnings:
        print("WARN:", item)
    for item in errors:
        print("ERROR:", item)
    if errors:
        print(f"FAIL: {len(errors)} error(s), {len(warnings)} warning(s)")
        return 1
    if warnings and args.strict:
        print(f"FAIL (strict): {len(warnings)} warning(s)")
        return 1
    print("PASS: metadata, dependencies, structure, and derived documents agree")
    return 0


if __name__ == "__main__":
    sys.exit(main())
