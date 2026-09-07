## What changes

<!-- One paragraph. Name the skills touched and the behavior an agent gains or loses. -->

## Why it is better

<!-- What fails or wastes context without this change? Link an issue if one exists. -->

## Validation

Paste the output of both commands; CI runs the same checks.

```text
python3 scripts/validate_skills.py --strict
./install.sh --self-test
```

- [ ] `SKILL-MATRIX.md` regenerated with `python3 scripts/gen_matrix.py` (never hand-edited)
- [ ] `README.md` and the `index.html` catalog updated if a skill was added, removed, or reprioritized
- [ ] `ROUTER.md` can still reach every skill from a realistic request
- [ ] no secrets, client names, or machine-specific paths in examples
- [ ] claims that depend on a tool version say which version they were written against
