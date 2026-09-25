This is Ghaith's `~/.claude` config, synced to `git@github.com:temirvvs/claude-code-config.git`. See `README.md` for what's tracked and why.

The global rules live in `rules/`. Claude Code loads `~/.claude/rules/` natively on this machine. In cloud sessions, hooks installed by `cloud/setup.sh` fetch the public GitHub copy at each session start. So:
- Commit and push any change to `rules/` in the same turn, because cloud sessions only see what's on GitHub.
- Keep each file in `rules/` under 10,000 characters. Claude Code caps a hook's output there, and anything longer reaches cloud sessions as a 2,000-character preview.
- When adding, renaming, or deleting a rules file, update `RULES` in `cloud/setup.sh`. Changes to `cloud/setup.sh` reach cloud sessions only when the environment rebuilds (about every 7 days), so tell Ghaith when one needs a sooner rebuild.

This repo is public. Never commit secrets, personal data, or details about this machine beyond what the config needs.

Auto-sync is disabled, so nothing else commits or pushes this repo automatically. Sync other changes manually when needed. Whenever a change to `settings.json`, `CLAUDE.md`, `rules/`, or `cloud/setup.sh` changes what this repo does or how it's set up, update `README.md` to describe that change in the same turn.
