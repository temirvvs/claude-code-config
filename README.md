# claude-code-config

My `~/.claude` config, synced across machines and into Claude Code cloud sessions.

## What's tracked

- `rules/`: global rules for every project, loaded natively from `~/.claude/rules/`
  - `working.md`: how to work (reuse open source, install checks, `notes/`, no ambiguity)
  - `response-style.md`: how replies read
  - `writing-style.md`: documents, code comments, and questions to the user
- `CLAUDE.md`: rules about this repo itself (sync, public-repo hygiene, README upkeep)
- `cloud/setup.sh`: the cloud environment setup script (rules hooks + ponytail)
- `settings.json`: enabled plugins + marketplace sources, default permission mode (`auto`), default model (`opus`), per-model effort levels (`high` on Opus 5, `xhigh` on Opus 5.5), and an `autoMode.environment` description for the auto-mode classifier
- `commands/`: custom slash commands (e.g. `/techdebt`)
- `notes/`: dated notes on config changes

Everything else (`plugins/`, `skills/`, conversation history, caches, sessions, pastes, plans) is
gitignored as local, regenerable, or reinstallable from `settings.json`.

This repo is public. It holds no secrets or personal data.

## Cloud sessions

Cloud sessions (claude.ai/code, `claude --cloud`, routines) run on a fresh machine that
never sees this Mac's `~/.claude`
([docs](https://code.claude.com/docs/en/cloud-environments#what-carries-over-from-your-setup)).
Plugins declared in a repo's settings don't load there either. Each cloud environment
can run a setup script before Claude Code starts, and whatever it installs into that
machine's `~/.claude` applies to every repo opened in the environment. This follows
[ArloL/claude-code-web-environment-setup](https://github.com/ArloL/claude-code-web-environment-setup)
and [ProgDroid/claude-setup](https://github.com/ProgDroid/claude-setup), which verified it
against live sessions.

The environment's **Setup script** field holds one line, set once:

```sh
bash -c "$(curl -fsSL https://raw.githubusercontent.com/temirvvs/claude-code-config/main/cloud/setup.sh)"
```

`cloud/setup.sh` installs:

- **Rules hooks**: three SessionStart hooks in the machine's `~/.claude/settings.json`, one per rules file. At each session start (and after `/clear` or compaction) each hook fetches its file from GitHub with its saved ETag. An unchanged file gets `304 Not Modified` and no download. The hook prints the file, which Claude Code adds to context. If a fetch fails with nothing cached, it prints a notice telling Claude to tell you.
- **Ponytail**: installed at user scope from a codeload.github.com tarball, because `git clone` of another repo gets a 403 from the cloud's GitHub proxy.

When changes arrive:

| Change | Reaches cloud sessions |
|---|---|
| Edit a file in `rules/` | Next session start, within GitHub's 5-minute raw-file cache |
| Edit `cloud/setup.sh`, or a new ponytail release | Next environment rebuild: about every 7 days, or at once when the Setup script field or allowed network hosts change |

Limits:

- A hook's output is capped at 10,000 characters, so each rules file must stay under that.
- Each cloud environment needs the one line in its Setup script field.

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
