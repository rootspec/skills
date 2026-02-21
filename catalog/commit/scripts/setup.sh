#!/bin/bash
# Run from project root to check commit skill hook setup.

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
HOOK_SRC="$SCRIPT_DIR/commit-msg"
HOOK_DEST=".husky/commit-msg"

if [ ! -d ".husky" ]; then
  echo "Husky not found. Initialize it first:"
  echo ""
  echo "  npx husky init"
  echo ""
  echo "Then install the commit-msg hook:"
  echo ""
  echo "  cp \"$HOOK_SRC\" $HOOK_DEST"
  echo "  chmod +x $HOOK_DEST"
  exit 0
fi

if [ -f "$HOOK_DEST" ]; then
  echo "commit-msg hook already installed at $HOOK_DEST"
  exit 0
fi

echo "Husky is installed but commit-msg hook is missing."
echo ""
echo "Install it with:"
echo ""
echo "  cp \"$HOOK_SRC\" $HOOK_DEST"
echo "  chmod +x $HOOK_DEST"
