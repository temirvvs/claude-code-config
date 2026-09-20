# claude-code-config

My `~/.claude` config, synced across machines.

## What's tracked

- `settings.json` — enabled plugins + marketplace sources
- `CLAUDE.md` — global user instructions
- `scripts/auto-sync-config.sh` — the auto-sync script below
- `commands/` — custom slash commands (e.g. `/techdebt`)

Everything else (`plugins/`, `skills/`, conversation history, caches, sessions) is
gitignored — local, regenerable, or reinstallable from `settings.json`.

## Auto-sync

A `Stop` hook in `settings.json` runs `scripts/auto-sync-config.sh` after every
Claude Code turn. It stages `settings.json`, `CLAUDE.md`, `README.md`, and itself,
and if anything changed, commits and pushes to `origin main` automatically. A
failed push (e.g. offline) just warns — it never blocks the session.

## Standing instructions (CLAUDE.md)

Besides this repo's own auto-sync and install-review rules, `CLAUDE.md` also carries a
cross-project habit: in every project worked on (not just this one), keep a `notes/`
directory updated after every PR, and point that project's own `CLAUDE.md` at it so
future sessions pick it up without being re-told.

It also carries a full prose-style guide (adapted from [andrewroxby/claude-style-patch](https://github.com/andrewroxby/claude-style-patch))
governing how responses are written: plain declarative sentences, no colon-hinged
sentences, no announcing a point before making it, no stacked compression.

## Set up on a new machine

```sh
git clone git@github.com:temirvvs/claude-code-config.git ~/.claude
```

Then launch Claude Code — it reinstalls the plugins listed in `settings.json` from
their marketplaces automatically.
