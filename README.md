# claude-code-config

My `~/.claude` config, synced across machines.

## What's tracked

- `settings.json` — enabled plugins + marketplace sources
- `CLAUDE.md` — global user instructions

Everything else (`plugins/`, `skills/`, conversation history, caches, sessions) is
gitignored — local, regenerable, or reinstallable from `settings.json`.

## Set up on a new machine

```sh
git clone git@github.com:temirvvs/claude-code-config.git ~/.claude
```

Then launch Claude Code — it reinstalls the plugins listed in `settings.json` from
their marketplaces automatically.
