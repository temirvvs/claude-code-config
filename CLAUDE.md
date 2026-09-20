This is Ghaith's `~/.claude` config, synced to `git@github.com:temirvvs/claude-code-config.git`. See `README.md` for what's tracked and why.

A `Stop` hook (`scripts/auto-sync-config.sh`) commits and pushes `settings.json`, `CLAUDE.md`, and `README.md` automatically after every turn. It only pushes what's already staged; it never rewrites content. Whenever a change to `settings.json` or `CLAUDE.md` changes what this repo does or how it's set up, update `README.md` to describe that change in the same turn, before the hook's next commit.

Before installing any skill, plugin, or tool, anywhere, not just from this repo: check its source for safety (bundled hooks, network calls, executed scripts) and check whether it duplicates or overlaps with something already installed. A literal duplicate of an already-installed source (same upstream repo) gets rejected outright, no confirmation needed. A partial overlap (same territory from a different author, or two plugins sharing a skill name) gets flagged with a clear recommendation before installing; it never gets installed silently.

Keep the running install log up to date: https://claude.ai/code/artifact/92a00a36-9672-4392-abdb-0b23cd85604d. It lists only things actually installed, what they are, their source, and what they do. Items that were reviewed and rejected don't belong in it.
