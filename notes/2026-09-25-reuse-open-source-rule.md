# 2026-09-25 — open-source reuse rule, rules/ split, cloud delivery, repo made public

## What changed

- New rule: before building anything from scratch, search for an open-source repo that
  does it and use it when that saves time. Also saved as a pinned auto memory,
  `reuse-before-building.md`.
- The global rules moved out of `CLAUDE.md` into `rules/working.md`,
  `rules/response-style.md`, and `rules/writing-style.md`, word for word.
  `~/.claude/rules/` loads natively (verified with `claude -p`). `CLAUDE.md` now holds
  only rules about this repo.
- `cloud-hooks.json` delivers `rules/` to cloud sessions. See README "Cloud sessions".
- The repo went public. Before that, `settings.json` `autoMode.environment` lost the
  machine details (media tooling, a local project path, shell-history wording) and now
  says the repo is public. The commit that first added those lines was rewritten
  before the visibility change, so they never appear in public history.
- `.gitignore` now covers `ide/`, `paste-cache/`, and `plans/`.

## Why the rules are split

User-level config never reaches cloud sessions, so a repo-committed SessionStart hook
fetches the rules and prints them into context. A hook's output is capped at 10,000
characters (hooks doc, "Output limits"). The old `CLAUDE.md` was 14,114, so it was split
by topic into files that each fit. Each file needs its own hook.

## Prior art checked

No finished tool does this. `surreptakos/claude-dotfiles#154` (plugin-based, closed as
not planned, partly working) and `mark-brannan/dotfiles#17` (spec only) cover the same
problem.
