#!/bin/bash
# Usage: ./scripts/release.sh [major|minor|patch]
#
# Bumps version, updates changelog, commits, tags, and creates GitHub release.

set -e

TYPE=${1:-patch}

# Ensure we're on main and up to date
BRANCH=$(git branch --show-current)
if [ "$BRANCH" != "main" ]; then
  echo "Error: Must be on main branch (currently on $BRANCH)"
  exit 1
fi

# Check for uncommitted or untracked files
if [ -n "$(git status --porcelain)" ]; then
  echo "Error: Uncommitted or untracked files. Commit or stash first."
  git status --short
  exit 1
fi

# Remind to update changelogs
echo ""
echo "Before releasing, ensure you've updated:"
echo "  - CHANGELOG.md (under [Unreleased])"
echo ""
read -p "Have you updated your changelog(s)? (y/n) " -n 1 -r
echo
if [[ ! $REPLY =~ ^[Yy]$ ]]; then
  echo "Update changelogs first, then re-run."
  exit 1
fi

# Bump version in package.json
npm version $TYPE --no-git-tag-version

# Get new version
VERSION=$(node -p "require('./package.json').version")

# Update CHANGELOG (move Unreleased to new version with today's date)
DATE=$(date +%Y-%m-%d)
sed -i '' "s/## \[Unreleased\]/## [Unreleased]\n\n## [$VERSION] - $DATE/" CHANGELOG.md

# Commit and tag
git add package.json package-lock.json CHANGELOG.md
git commit -m "v$VERSION"
git tag -a "v$VERSION" -m "Release v$VERSION"

echo "Created commit and tag for v$VERSION"
echo ""

# Push
git push && git push --tags

# Extract changelog section and create GitHub release
NOTES=$(sed -n "/## \[$VERSION\]/,/## \[/p" CHANGELOG.md | sed '$d' | tail -n +2)

gh release create "v$VERSION" --title "v$VERSION" --notes "$NOTES"

echo ""
echo "Released v$VERSION"
