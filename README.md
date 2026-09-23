# claude-code-config

My `~/.claude` config, synced across machines.

## What's tracked

- `settings.json` — enabled plugins + marketplace sources, default permission mode (`auto`)
- `CLAUDE.md` — global user instructions
- `scripts/auto-sync-config.sh` — the auto-sync script below
- `commands/` — custom slash commands (e.g. `/techdebt`)

Everything else (`plugins/`, `skills/`, conversation history, caches, sessions) is
gitignored — local, regenerable, or reinstallable from `settings.json`.

## Auto-sync (disabled)

This repo used to auto-commit and push on every Claude Code turn via a `Stop`
hook running `scripts/auto-sync-config.sh`. That hook has been removed from
`settings.json`. The script still exists but nothing calls it — sync changes
to `origin main` manually (`git add`, `git commit`, `git push`) when you want
them saved.

## Standing instructions (CLAUDE.md)

Besides this repo's own auto-sync and install-review rules, `CLAUDE.md` also carries a
cross-project habit: in every project worked on (not just this one), keep a `notes/`
directory updated after every PR, and point that project's own `CLAUDE.md` at it so
future sessions pick it up without being re-told. It also carries a matching rule for
that project's `CLAUDE.md` itself: after a change, check whether the file needs
updating to stay accurate, and only touch it when skipping the update would leave it
wrong — not on every change, and never just to restate what the code already shows.

It also carries a full prose-style guide (adapted from [andrewroxby/claude-style-patch](https://github.com/andrewroxby/claude-style-patch))
governing how responses are written: plain declarative sentences, no colon-hinged
sentences, no announcing a point before making it, no stacked compression.

## Set up on a new machine

```sh
git clone git@github.com:temirvvs/claude-code-config.git ~/.claude
```

Then launch Claude Code — it reinstalls the plugins listed in `settings.json` from
their marketplaces automatically.
