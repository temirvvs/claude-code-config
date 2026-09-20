#!/bin/bash
# Stop hook: commit + push ~/.claude's tracked config files after each turn.
set -u
cd ~/.claude || exit 0

git add settings.json CLAUDE.md README.md scripts/ commands/ 2>/dev/null

if git diff --cached --quiet 2>/dev/null; then
  exit 0
fi

git commit -q -m "Auto-update from Claude Code session ($(date -u +%Y-%m-%dT%H:%M:%SZ))" || exit 0

if git push origin main >/tmp/claude-config-push.log 2>&1; then
  echo '{"systemMessage": "claude-code-config: committed and pushed to GitHub."}'
else
  echo '{"systemMessage": "claude-code-config: committed locally, but push failed (offline or auth issue). Run: cd ~/.claude && git push"}'
fi
exit 0
