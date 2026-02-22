---
name: dev
description: Use when the user wants to manage the dev server — setup, start, stop, restart, or check status.
argument-hint: "[setup|start|stop|restart|status]"
---

## Human usage

After setup, use these commands directly:

- `npm run dev` / `npm run dev:start` — start server in background (detached via nohup)
- `npm run dev:stop` — stop server (Ctrl+C won't work since it's detached)
- `npm run dev:status` — check PID and log location
- `npm run dev:restart` — restart server
- `tail -f logs/dev.log` — stream live logs
- `PORT=5173 npm run dev` — override port

PID file: `.dev/dev.pid` — Log file: `logs/dev.log`

---

You are managing the dev server. The argument determines the action.

## `/dev setup`

Only run setup if `dev:raw` is missing from `package.json`.

1. Read `package.json` and config files to detect framework and dev command:
   - `nuxt.config.*` → command `nuxt dev`, default port 3000
   - `vite.config.*` → command `vite`, default port 5173
   - `next.config.*` → command `next dev`, default port 3000
   - Else: inspect existing `dev` script for clues; if still unclear, ask the user
2. Check config files for port overrides (e.g. `devServer.port`, `server.port`)
3. Propose detected command and port to user for confirmation
4. Write `dev:raw` to `package.json` with the confirmed command
5. Add these wrapper scripts to `package.json`:
   ```json
   "dev": ".agents/skills/dev/scripts/dev.sh start",
   "dev:start": ".agents/skills/dev/scripts/dev.sh start",
   "dev:stop": ".agents/skills/dev/scripts/dev.sh stop",
   "dev:restart": ".agents/skills/dev/scripts/dev.sh restart",
   "dev:status": ".agents/skills/dev/scripts/dev.sh status"
   ```
   Note: `dev:raw` stays as-is (it holds the actual dev command).

## `/dev start`

Run: `npm run dev:start`

If `dev:raw` is not in `package.json`, tell the user to run `/dev setup` first.

## `/dev stop`

Run: `npm run dev:stop`

## `/dev restart`

Run: `npm run dev:restart`

## `/dev status`

Run: `npm run dev:status`
