#!/usr/bin/env python3
"""Static checks for the skill library; no third-party packages required."""
from __future__ import annotations
import re, sys
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
FILES = sorted(ROOT.glob("**/SKILL.md"))
REQUIRED = [
    "Overview", "When to Use This Skill", "When NOT to Use This Skill",
    "Workflow", "Advanced Techniques", "Common Patterns",
    "Edge Cases & Pitfalls", "Integration with Other Skills",
    "Output Format Templates", "Rules",
]
errors: list[str] = []
warn: list[str] = []
skills: dict[str, tuple[Path, list[str]]] = {}

for path in FILES:
    text = path.read_text(encoding="utf-8-sig")
    if not text.startswith("---\n") or "\n---\n" not in text[4:]:
        errors.append(f"{path}: missing YAML frontmatter")
        continue
    front, body = text[4:].split("\n---\n", 1)
    def scalar(key: str) -> str | None:
        m = re.search(rf"^{re.escape(key)}:\s*(.+)$", front, re.M)
        return m.group(1).strip() if m else None
    name = scalar("name")
    priority = scalar("priority")
    if not name or not re.fullmatch(r"[a-z0-9]+(?:-[a-z0-9]+)*", name):
        errors.append(f"{path}: invalid or missing name")
        continue
    if name in skills:
        errors.append(f"{path}: duplicate name {name}")
    deps = re.findall(r"[a-z0-9]+(?:-[a-z0-9]+)*", scalar("dependencies") or "")
    if priority not in {"P0", "P1", "P2", "P3"}:
        errors.append(f"{path}: priority must be P0-P3")
    if not re.search(r"TRIGGERS:", front, re.I):
        warn.append(f"{path}: description has no TRIGGERS list")
    missing = [h for h in REQUIRED if not re.search(rf"^## {re.escape(h)}(?:\s|:|$)", body, re.M)]
    if missing:
        warn.append(f"{path}: missing sections: {', '.join(missing)}")
    if not re.search(r"[\u0600-\u06ff]", front):
        warn.append(f"{path}: no Persian trigger text")
    if not re.search(r"[\u4e00-\u9fff]", front):
        warn.append(f"{path}: no Chinese trigger text")
    skills[name] = (path, deps)

for name, (path, deps) in skills.items():
    for dep in deps:
        if dep not in skills:
            errors.append(f"{path}: unknown dependency {dep}")

# Detect dependency cycles with DFS.
state: dict[str, int] = {}
stack: list[str] = []
def visit(node: str) -> None:
    if state.get(node) == 1:
        cycle = stack[stack.index(node):] + [node]
        errors.append("dependency cycle: " + " -> ".join(cycle))
        return
    if state.get(node) == 2: return
    state[node] = 1; stack.append(node)
    for dep in skills.get(node, (None, []))[1]: visit(dep)
    stack.pop(); state[node] = 2
for name in skills: visit(name)

expected = len(FILES)
for doc in (ROOT / "README.md", ROOT / "SKILL-MATRIX.md", ROOT / "index.html"):
    text = doc.read_text(encoding="utf-8")
    if str(expected) not in text:
        warn.append(f"{doc}: does not mention current skill count ({expected})")

print(f"Checked {expected} skills")
for item in warn: print("WARN:", item)
for item in errors: print("ERROR:", item)
if errors:
    sys.exit(1)
print("PASS: metadata, dependencies, and count checks")
