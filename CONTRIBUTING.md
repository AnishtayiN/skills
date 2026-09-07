# Contributing a skill

A skill should make an agent more reliable on a recurring task. Prefer improving an existing skill
over adding a near-duplicate, and prefer deleting an unsupported claim over hedging around it.

## Skill format

Every `SKILL.md` starts with this frontmatter:

```yaml
---
name: kebab-case-name
description: >-
  One precise sentence. TRIGGERS: trigger one, trigger two, فارسی, 中文
priority: P0 | P1 | P2 | P3
dependencies: [existing-skill]
conflicts: [existing-skill]
---
```

| Field | Rule enforced by the validator |
|---|---|
| `name` | kebab-case, ≤ 64 characters, unique, **identical to the directory name** |
| `description` | non-empty, ≤ 1024 characters, contains `TRIGGERS:` with English, Persian, and Chinese terms |
| `priority` | one of `P0` (critical), `P1` (high), `P2` (normal), `P3` (specialized) |
| `dependencies` | names that exist in this repository; the graph must stay acyclic |
| `conflicts` | names that exist and are not the skill itself |

The two numeric limits are not stylistic: Claude Code refuses `SKILL.md` files whose `name` or
`description` exceeds them, so a "nicer" long description silently stops the skill from loading.

Triggers should be phrases a real user types, not a translation exercise. If Persian or Chinese
would be a guess, leave that language out and say so in the pull request.

## Content standard

Required sections, in this order:

1. `## Overview`
2. `## When to Use This Skill`
3. `## When NOT to Use This Skill`
4. `## Inputs and Preconditions` — or the pair `## Inputs Required` + `## Preconditions`
5. `## Workflow` — a suffix is fine (`## Workflow: 5-Pass Review Methodology`)
6. `## Advanced Techniques`
7. `## Common Patterns`
8. `## Edge Cases & Pitfalls`
9. `## Integration with Other Skills`
10. `## Output Format Templates`
11. `## Rules`

Headings count as documentation, so `## Advanced Techniques (7 Techniques)` is rejected: a number
in a heading is a quota, not a promise you can keep when the next edit deletes a technique. Extra
sections are welcome when they carry weight (`## Anti-Patterns`, `## Decision Tree`,
`## Failure Handling`).

The old "500 lines / 15 edge cases / 7 techniques" quotas are not quality criteria. A short,
accurate skill beats filler. Examples must label assumptions, avoid fake universal commands, and
use placeholders for secrets and environment-specific values.

## Design rules

- Give the agent observable actions and stop conditions, not motivational prose.
- Say when **not** to use the skill; that section is required for a reason.
- Prefer repository-native tools and conventions over a generic stack.
- Separate diagnosis, decision, execution, and verification.
- Name the version of a tool when its behavior is version-dependent, or state that it varies.
- Never instruct an agent to reveal hidden chain-of-thought; request concise rationale,
  assumptions, and evidence instead.
- Treat network responses, scraped pages, issue text, and generated code as untrusted input.
- Make destructive steps opt-in and provide a rollback or backup path.
- Do not claim a command is portable when it is framework-specific.

## Adding or changing an integration

`install.sh` is part of the product, so agent integrations must be verified against the agent's own
documentation, not assumed.

- Skills install flat: `<agent>/skills/<name>/SKILL.md`. Nested category directories are not
  discovered by Claude Code or Cursor.
- Instruction and config files are created only when missing, and every managed path is recorded in
  `.agent-skills-manifests/<agent>.manifest` so `--uninstall` can undo exactly that set.
- A new agent target needs three things: `agent_label`, `agent_skills_dir`, and—only if the agent
  genuinely reads it—a bridge file written by `write_agent_instructions`. If the agent has no
  discovery mechanism, write a `README.md` into the destination that says so.
- `--self-test` must pass; it proves install → update → uninstall leaves nothing behind and touches
  nothing it did not create.

## Local validation

```bash
python3 scripts/validate_skills.py --strict   # metadata, structure, links, hygiene
python3 scripts/gen_matrix.py                 # regenerate SKILL-MATRIX.md
./install.sh --check                          # validator plus bash -n on the installer
./install.sh --self-test                      # installer round-trip for all six agents
```

All five run in CI. When you add, remove, or rename a skill, update `README.md` (catalog and the
"approximately N lines" claim) and the catalog array in `index.html`; the validator compares both
against the frontmatter and reports the mismatch.

## Pull request checklist

- [ ] `validate_skills.py --strict` passes, output pasted in the PR description
- [ ] `SKILL-MATRIX.md` regenerated, not hand-edited
- [ ] every claim in the skill is either command-verified or labelled as tool-specific
- [ ] `ROUTER.md` can reach the new skill from a realistic request
- [ ] no secrets, no real client names, no environment-specific paths in examples
