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

### release

No extra setup — the agent runs `scripts/release.sh` directly from the installed skill directory. Requires `npm`, `git`, and `gh` (GitHub CLI).
