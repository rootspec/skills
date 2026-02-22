# rootspec-skills

A curated collection of AI agent skills for users of [rootspec](https://github.com/rootspec) and related projects.

Skills follow the [Agent Skills specification](https://agentskills.io/specification) and are compatible with the [`skills` CLI by Vercel](https://github.com/vercel-labs/skills).

---

## Install

```bash
npx skills add rootspec/rootspec-skills
```

---

## Available Skills

| Skill | Description |
|-------|-------------|
| **commit** | Stages files, updates CHANGELOG.md, and creates a Conventional Commit |
| **dev** | Manage the dev server — setup, start, stop, restart, or check status |
| **issues** | View, add, update, or close issues tracked in ISSUES.md |
| **release** | Guides through changelog updates and runs the release script |

---

## Additional Setup

Some skills include scripts or hooks that require manual installation after the CLI places the skill files.

### commit

The `commit-msg` hook enforces CHANGELOG.md updates for `feat:` and `fix:` commits. Git hooks can't be auto-placed by the CLI, so run the included setup script from your project root:

```bash
scripts/setup.sh
```

It will check for husky and print the exact commands needed.

### issues

Create `ISSUES.md` in the project root (can start empty):

```bash
touch ISSUES.md
```

### dev

Run `/dev setup` once per project. Claude will detect your framework and port, then write the `dev:raw` command and wrapper scripts into `package.json`.

After setup:

| Command | Action |
|---------|--------|
| `npm run dev` / `npm run dev:start` | Start server in background (detached via nohup) |
| `npm run dev:stop` | Stop server (Ctrl+C won't work since it's detached) |
| `npm run dev:status` | Show PID and log path |
| `npm run dev:restart` | Stop + start cycle |
| `tail -f logs/dev.log` | Stream live logs |
| `PORT=5173 npm run dev` | Override port at start time |

Notes:
- PID tracked in `.dev/dev.pid`, logs in `logs/dev.log`
- On start, any existing process on the port is killed before launching
- The `dev.sh` script lives in the skill directory — no copy is made to your project

### release

No extra setup — the agent runs `scripts/release.sh` directly from the installed skill directory. Requires `npm`, `git`, and `gh` (GitHub CLI).

---

## Keeping skills up to date

The skills CLI installs **copies** of skills into `.agents/skills/` — they are not live-linked to this repo. When a new version is released, update your installed skills:

```bash
npx skills update
```
