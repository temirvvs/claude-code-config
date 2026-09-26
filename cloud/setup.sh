#!/bin/bash
# Claude Code cloud environment setup.
#
# The environment's Setup script field runs this with one line:
#   bash -c "$(curl -fsSL https://raw.githubusercontent.com/temirvvs/claude-code-config/main/cloud/setup.sh)"
#
# Runs as root before Claude Code launches. The cloud caches the resulting
# filesystem per environment and rebuilds it when the Setup script field or the
# allowed network hosts change, or about every 7 days. Changes to this file
# take effect at the next rebuild.
#
# Everything goes into ~/.claude, so it applies to every repo in the environment:
#   - SessionStart hooks that fetch rules/ from GitHub at each session start
#   - the ponytail plugin at user scope
#   - the hallmark skill at user scope

set -u # no -e: a non-zero exit stops the session from starting

REPO=temirvvs/claude-code-config
RULES="working.md response-style.md writing-style.md"
log() { echo "[setup] $*"; }

log "HOME=$HOME user=$(id -un) claude=$(claude --version 2>&1 | head -1)"

# Rules hooks.
#
# One hook per file, because Claude Code caps each hook's output at 10,000
# characters. The ETag makes a repeat fetch a 304 with no download.

hook_cmd() {
  printf '%s' "f=$1; "'c="${TMPDIR:-/tmp}/claude-rules-$f"; [ -s "$c" ] || rm -f "$c.etag"; code=$(curl -sS -m 10 --etag-compare "$c.etag" --etag-save "$c.etag.new" -o "$c.new" -w "%{http_code}" "https://raw.githubusercontent.com/'"$REPO"'/main/rules/$f" 2>/dev/null); if [ "$code" = 200 ] && [ -s "$c.new" ]; then mv "$c.new" "$c"; mv "$c.etag.new" "$c.etag"; fi; rm -f "$c.new" "$c.etag.new"; if [ -s "$c" ]; then cat "$c"; else echo "Global rules file rules/$f could not be fetched (HTTP ${code:-none}). Tell the user."; fi'
}

mkdir -p ~/.claude
settings=~/.claude/settings.json
[ -s "$settings" ] || echo '{}' > "$settings"

entry=$(for f in $RULES; do
  jq -n --arg c "$(hook_cmd "$f")" '{type: "command", timeout: 15, command: $c}'
done | jq -s '{matcher: "startup|clear|compact", hooks: .}')

# Merge into existing settings, replacing any earlier copy of these hooks.
if jq --argjson e "$entry" '
  .hooks.SessionStart = ((.hooks.SessionStart // [])
    | map(select(all(.hooks[]?; .command | contains("claude-rules-") | not))))
    + [$e]' "$settings" > "$settings.new"; then
  mv "$settings.new" "$settings"
  log "rules hooks installed: $RULES"
else
  rm -f "$settings.new"
  log "RULES HOOKS FAILED: could not update $settings"
fi

# Ponytail plugin.
#
# A git clone of another GitHub repo gets a 403 from the cloud's GitHub proxy,
# so fetch a codeload tarball and add it as a local marketplace.

dir=~/.claude-cloud/ponytail
rm -rf "$dir" && mkdir -p "$dir"
if curl -fsSL https://codeload.github.com/DietrichGebert/ponytail/tar.gz/refs/heads/main \
  | tar -xz --strip-components=1 -C "$dir"; then
  claude plugin marketplace add "$dir" 2>&1 | sed 's/^/[setup]   /'
  claude plugin install ponytail@ponytail 2>&1 | sed 's/^/[setup]   /'
else
  log "PONYTAIL FAILED: tarball download"
fi

# Hallmark skill (nutlope/hallmark), same tarball route as ponytail.

dir=~/.claude/skills/hallmark
rm -rf "$dir" && mkdir -p "$dir"
if curl -fsSL https://codeload.github.com/nutlope/hallmark/tar.gz/refs/heads/main \
  | tar -xz --strip-components=3 -C "$dir" hallmark-main/skills/hallmark; then
  log "hallmark skill installed"
else
  log "HALLMARK FAILED: tarball download"
fi

log "plugins:"
claude plugin list 2>&1 | sed 's/^/[setup]   /'
exit 0
