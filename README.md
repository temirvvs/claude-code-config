# claude-code-config

My `~/.claude` config, synced across machines and into Claude Code cloud sessions.

## What's tracked

- `rules/`: global rules for every project, loaded natively from `~/.claude/rules/`
  - `working.md`: how to work (reuse open source, install checks, `notes/`, no ambiguity)
  - `response-style.md`: how replies read
  - `writing-style.md`: documents, code comments, and questions to the user
- `CLAUDE.md`: rules about this repo itself (sync, public-repo hygiene, README upkeep)
- `cloud-hooks.json`: the SessionStart hooks that deliver `rules/` to cloud sessions
- `.claude/settings.json`: a copy of those hooks, so cloud sessions on this repo get the rules too
- `settings.json`: enabled plugins + marketplace sources, default permission mode (`auto`), default model (`opus`), per-model effort levels (`high` on Opus 5, `xhigh` on Opus 5.5), and an `autoMode.environment` description for the auto-mode classifier
- `commands/`: custom slash commands (e.g. `/techdebt`)
- `notes/`: dated notes on config changes

Everything else (`plugins/`, `skills/`, conversation history, caches, sessions, pastes, plans) is
gitignored as local, regenerable, or reinstallable from `settings.json`.

This repo is public. It holds no secrets or personal data.

## Cloud sessions

Cloud sessions (claude.ai/code, `claude --cloud`, routines) run on a fresh clone of one
repo and never see `~/.claude`
([docs](https://code.claude.com/docs/en/cloud-environments#what-carries-over-from-your-setup)).
They do run SessionStart hooks committed in that repo's `.claude/settings.json`, and a
SessionStart hook's output becomes context Claude sees
([docs](https://code.claude.com/docs/en/hooks)).

`cloud-hooks.json` holds one hook per rules file. Each hook:

1. Exits at once unless `CLAUDE_CODE_REMOTE=true`, so local sessions, which already load `~/.claude/rules/`, skip it.
2. Fetches the file from `raw.githubusercontent.com` with its saved ETag. If the file hasn't changed, GitHub answers `304 Not Modified` and the hook reuses its cached copy instead of downloading again.
3. Prints the file, which Claude Code adds to context. If the fetch fails and no copy is cached, it prints a notice telling Claude to tell you.

The hooks run on `startup`, `clear`, and `compact`, but not on `resume`, because a
resumed transcript already holds the rules.

Limits:

- A hook's output is capped at 10,000 characters, so each rules file must stay under that.
- Only single-repo cloud sessions run repo hooks. Multi-repo sessions and Projects threads don't.
- A repo gets the hooks when a session working in it merges `cloud-hooks.json` into its `.claude/settings.json` (a rule in `rules/working.md`).
- GitHub's raw CDN caches files for up to 5 minutes, so a pushed change can take that long to reach new cloud sessions.

## Auto-sync (disabled)

This repo used to auto-commit and push on every Claude Code turn via a `Stop` hook.
That hook and its script are gone. The one exception is `rules/`: `CLAUDE.md` tells
Claude to commit and push changes there in the same turn, because cloud sessions only
see what's on GitHub. Sync everything else to `origin main` manually.

## Standing instructions

`rules/working.md` carries rules for every project:

- Before building anything from scratch, search for an open-source repo that already does it, and use it (as a dependency, fork, or adapted code, license permitting) whenever that saves time.
- Check any skill, plugin, or tool for safety and overlap before installing it, and keep the install log current.
- Keep a `notes/` directory updated after every PR, and point the project's own `CLAUDE.md` at it.
- Update a project's `CLAUDE.md` only when skipping the update would leave it wrong.
- No ambiguity in features, labels, or replies. Never guess; cite sources.
- Add the cloud hooks to each repo worked in.

`rules/response-style.md` is a full prose-style guide (adapted from
[andrewroxby/claude-style-patch](https://github.com/andrewroxby/claude-style-patch)):
plain declarative sentences, no colon-hinged sentences, no announcing a point before
making it, no stacked compression. Every response ends with a one- or two-sentence
**TLDR** line, the one summary the guide allows.

## Set up on a new machine

```sh
git clone git@github.com:temirvvs/claude-code-config.git ~/.claude
```

Then launch Claude Code. It reinstalls the plugins listed in `settings.json` from
their marketplaces automatically.
