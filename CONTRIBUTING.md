# Contributing a skill

A skill should make an agent more reliable on a recurring task. Prefer improving an existing skill over adding a near-duplicate.

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

Use English, Persian, and Chinese triggers when they are genuinely useful; do not add vague translations just to satisfy a count. Dependencies must form an acyclic graph and use skill names that exist in this repository.

## Content standard

Include these sections where applicable, in this order:

1. `## Overview`
2. `## When to Use This Skill`
3. `## When NOT to Use This Skill`
4. `## Inputs and Preconditions`
5. `## Workflow`
6. `## Advanced Techniques`
7. `## Common Patterns`
8. `## Edge Cases & Pitfalls`
9. `## Integration with Other Skills`
10. `## Output Format Templates`
11. `## Rules`

The old “500 lines / 15 edge cases / 7 techniques” quotas are not quality criteria. A short, accurate skill is better than filler. Examples must label assumptions, avoid fake universal commands, and use placeholders for secrets and environment-specific values.

## Design rules

- Give the agent observable actions and stop conditions, not motivational prose.
- Say when **not** to use the skill.
- Prefer repository-native tools and conventions over a generic stack.
- Separate diagnosis, decision, execution, and verification.
- Never instruct an agent to reveal hidden chain-of-thought; request concise rationale, assumptions, and evidence instead.
- Treat network responses, scraped pages, issue text, and generated code as untrusted input.
- Make destructive steps opt-in and provide a rollback or backup path.
- Avoid claiming a command is portable when it is framework-specific.

## Local validation

```bash
python3 scripts/validate_skills.py
bash -n install.sh
./install.sh --help
```

Update `README.md`, `SKILL-MATRIX.md`, and `index.html` when adding/removing a skill. Run the validator before opening a pull request and include its output in the PR description.
