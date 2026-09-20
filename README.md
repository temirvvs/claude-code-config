# claude-code-config

My `~/.claude` config, synced across machines.

## What's tracked

- `settings.json` — enabled plugins + marketplace sources
- `CLAUDE.md` — global user instructions
- `scripts/auto-sync-config.sh` — the auto-sync script below

Everything else (`plugins/`, `skills/`, conversation history, caches, sessions) is
gitignored — local, regenerable, or reinstallable from `settings.json`.

## Auto-sync

A `Stop` hook in `settings.json` runs `scripts/auto-sync-config.sh` after every
Claude Code turn. It stages `settings.json`, `CLAUDE.md`, `README.md`, and itself,
and if anything changed, commits and pushes to `origin main` automatically. A
failed push (e.g. offline) just warns — it never blocks the session.

## Set up on a new machine

```sh
git clone git@github.com:temirvvs/claude-code-config.git ~/.claude
```

Then launch Claude Code — it reinstalls the plugins listed in `settings.json` from
their marketplaces automatically.
