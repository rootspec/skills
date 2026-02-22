# Changelog

## [Unreleased]

### Fixed

- Renamed `catalog/` → `skills/` so `npx skills add <repo>` discovers all skills without manual workarounds

## [1.1.0] - 2026-02-22

### Added

- `dev` skill — manage dev server with start/stop/restart/status; setup detects framework and writes package.json scripts

### Changed

- `release` skill — add setup step to ensure `release` script exists in package.json; run via `npm run release` instead of direct path

## [1.0.0] - 2026-02-21

### Added

- `commit` skill — stages files, updates CHANGELOG.md, and creates a Conventional Commit
- `issues` skill — view, add, update, or close issues tracked in ISSUES.md
- `release` skill — guides through changelog updates and runs the release script
