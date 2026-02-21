# Dev Notes

## Installed skills

This repo uses its own skills (commit, issues, release), but they are installed as copies via the skills CLI — not sourced directly from `catalog/`. Copies live in `.agents/skills/`, symlinked from `.claude/skills/`.

This is intentional: changes to `catalog/` do not immediately affect this project. After releasing a new version of this repo, update the installed skills:

```bash
npx skills update
```
