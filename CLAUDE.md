# Dev Notes

## Installed skills

This repo uses its own skills (commit, issues, release), but they are installed as copies via the skills CLI — not sourced directly from `catalog/`. Copies live in `.agents/skills/`, symlinked from `.claude/skills/`.

This is intentional: changes to `catalog/` do not immediately affect this project. After releasing a new version of this repo, update the installed skills:

```bash
npx skills update
```

When adding a new skill to `catalog/` and installing it in this project via `npx skills add`, mark the installed copy (`.agents/skills/<name>/SKILL.md`) as `internal: true`:

```yaml
metadata:
  internal: true
```

This prevents the installed copy from shadowing the catalog version for remote users. The CLI excludes internal skills when deciding whether to fall back to a recursive scan, so remote installers will discover all skills in `catalog/`.
