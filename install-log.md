# Install log

Everything actually installed, with its source, what it does, and its review. Items reviewed and rejected don't belong here. `rules/working.md` requires keeping this current.

Last updated 2026-09-26.

## Claude Code plugins and skills

### agent-skills plugin

- **Source:** [addyosmani/agent-skills](https://github.com/addyosmani/agent-skills)
- **What it does:** 25 skills covering the full dev lifecycle: spec-driven dev, planning, TDD, debugging, code review, security, performance, shipping, observability, etc.
- **Status:** Installed (v0.6.10) at user scope; `cloud/setup.sh` installs it in cloud sessions from the main-branch tarball (v0.6.11 there as of 26 Sep 2026). Overlaps 2 skill names exactly (test-driven-development, performance-optimization) with superpowers/rampstack-starter. Both kept active, because there's no clean way to remove one skill from a plugin bundle without losing its other, unrelated skills.

### ponytail plugin

- **Source:** [DietrichGebert/ponytail](https://github.com/DietrichGebert/ponytail)
- **What it does:** Lazy-senior-dev mode. A SessionStart hook injects a ruleset (YAGNI, stdlib before dependencies, smallest working diff) into every session, plus `/ponytail-review`, `/ponytail-audit`, `/ponytail-debt` and a ponytail-mcp stdio server.
- **Status:** Installed (v4.10.0, MIT) at user scope; `cloud/setup.sh` installs it in cloud sessions. Source reviewed 26 Sep 2026. Hooks, scripts and ponytail-mcp make no network calls and send no telemetry. They read the `PONYTAIL_*` vars plus `CLAUDE_CONFIG_DIR`, `CLAUDE_PLUGIN_ROOT`, `XDG_CONFIG_HOME`, `APPDATA`, `PLUGIN_DATA`, `COPILOT_PLUGIN_DATA`, `CURSOR_VERSION`, `CURSOR_PROJECT_DIR` and `QODER_SESSION_ID` (`GITHUB_REF_TYPE` and `GITHUB_REF_NAME` appear only in the release-check script). They write `~/.claude/.ponytail-active`, `~/.claude/.ponytail-statusline-nudged` and, when a default mode is set, `~/.config/ponytail/config.json`. `uninstall.js` edits `settings.json` when the user runs it. `benchmarks/` calls the OpenAI and Anthropic APIs, but nothing invokes it at runtime. Partial overlap kept on purpose: `/techdebt` hunts duplicated code, agent-skills:code-simplification refactors for clarity, ponytail targets over-engineering.

### hallmark skill

- **Source:** [nutlope/hallmark](https://github.com/nutlope/hallmark)
- **What it does:** Anti-AI-slop design skill for new pages. Picks one of 21 themes and a page structure, and runs 57 slop-test gates. Verbs: audit, redesign, study (extract a design's DNA from a URL or screenshot).
- **Status:** Installed (commit `13ac0ec`, MIT) at `~/.claude/skills/hallmark` via codeload tarball; `cloud/setup.sh` installs it in cloud sessions. Markdown only, no hooks or scripts. Partial overlap with agent-skills:frontend-ui-engineering, kept on purpose. `rules/working.md` gives Hallmark visual direction and frontend-ui-engineering implementation and accessibility, with the project's own design system winning over both.

### obsidian plugin

- **Source:** [kepano/obsidian-skills](https://github.com/kepano/obsidian-skills)
- **What it does:** 6 skills for Obsidian vault files: obsidian-markdown (wikilinks, callouts, properties), obsidian-bases (`.base` views/filters/formulas), json-canvas (`.canvas`), obsidian-cli (drive a running vault, plugin/theme debugging), defuddle (HTML to clean Markdown), knap (render Markdown from templates + JSON/CSV).
- **Status:** Installed (v1.0.1). Docs only, with no hooks, scripts, MCP servers or executables, and nothing runs at install. defuddle and knap ask for a global npm install of those CLIs, and obsidian-cli documents `obsidian eval` (runs JS in a live vault); both happen only on invoke. No overlap with the 4 marketplaces already installed.

### warp plugin

- **Source:** [warpdotdev/claude-code-warp](https://github.com/warpdotdev/claude-code-warp)
- **What it does:** Native Warp terminal notifications. Session start, stop, stop failure, idle prompt, permission request, prompt submit and tool complete each emit an OSC escape sequence that Warp turns into a desktop notification.
- **Status:** Installed (v2.2.0, MIT) at user scope; Mac only, not in `cloud/setup.sh`. Source reviewed 26 Sep 2026: bash scripts, no network calls, no telemetry. Seven hooks build a JSON payload and write it to `/dev/tty`, or return it as `terminalSequence` on Claude Code 2.1.141+, so a non-Warp terminal ignores the sequence. The payload carries the prompt text, the last response text, the transcript path, cwd and session id, and all of it stays in the terminal emulator. One file write: the session-start hook appends `export CLAUDE_CODE_VERSION` to `$CLAUDE_ENV_FILE`. Needs jq, which is installed. Nothing else installed does notifications, so no overlap.

### stripe plugin

- **Source:** claude-plugins-official → [stripe/ai](https://github.com/stripe/ai)
- **What it does:** 9 Stripe skills (best practices, docs, Connect, Apps, Projects, directory, pay, upgrade), the `/explain-error` and `/test-cards` commands, a company-researcher agent, and the hosted MCP server at mcp.stripe.com.
- **Status:** Installed (v0.9.2, MIT) at user scope. Disabled 26 Sep 2026 because nothing here uses it and it was adding a startup hook and a feedback prompt to unrelated sessions. Re-enable with `claude plugin enable stripe@claude-plugins-official`. The MCP is remote HTTP, and nothing runs locally for it. Source reviewed 26 Sep 2026. The five node hooks (SessionStart, UserPromptSubmit, PostToolUse, PostToolUseFailure, PostToolBatch) do two things worth knowing. Session start runs `stripe --version`, `stripe whoami` and `npm view @stripe/cli version`, so it reaches the npm registry. When a Stripe skill runs, PostToolUse calls `stripe agent report_usage --type skill --name <skill>`, which is usage telemetry to Stripe, and passes `$STRIPE_API_KEY` when that variable is set. Both are no-ops while the Stripe CLI is absent, and it is absent on this Mac, because `getStripeCliGuidance` returns as soon as `stripe --version` fails with ENOENT, ahead of the npm and whoami calls. Verified 26 Sep 2026 by running the session-start hook with a stub npm on PATH, which stayed uncalled without stripe and ran once stripe was there. The hooks also inject a "send Stripe feedback" prompt after turns whose transcript matches `/stripe/i`, sampled at 1%, which is why it fires on sessions doing no Stripe work. No overlap with anything else installed.

### /techdebt command

- **Source:** Built in-session, no external source
- **What it does:** Custom slash command that scans the current project for duplicated or near-duplicate code and consolidates what it's confident about.
- **Status:** Installed (`commands/techdebt.md`). Mac only, not in `cloud/setup.sh`.

### claude-style-patch

- **Source:** [andrewroxby/claude-style-patch](https://github.com/andrewroxby/claude-style-patch)
- **What it does:** Prose-style rules (no colon-hinged sentences, no announcing, no stacked compression).
- **Status:** Installed (CC0), adapted into `rules/response-style.md`.

### ~/.claude auto-sync hook

- **Source:** Built in-session, no external source
- **What it does:** Stop hook that auto-committed and pushed `settings.json`, `CLAUDE.md` and `README.md` to this repo after every turn.
- **Status:** Disabled. The Stop hook is removed from `settings.json`, and the script no longer runs.

## MCP servers

### Supabase MCP

- **Source:** https://mcp.supabase.com/mcp (official, hosted)
- **What it does:** Lets Claude manage the Supabase project: run SQL, apply migrations, read logs, fetch keys and docs.
- **Status:** Installed at user scope (global, `~/.claude.json`). Remote HTTP + OAuth, nothing runs locally. Not pinned to a `project_ref`, so it can reach every project in the Supabase account.

### Vercel MCP

- **Source:** https://mcp.vercel.com (official, hosted)
- **What it does:** Lets Claude search Vercel docs, manage projects and deployments, and read deploy logs.
- **Status:** Installed at user scope (global, `~/.claude.json`). Remote HTTP + OAuth, nothing runs locally. Chose the bare MCP over the vercel-plugin bundle (unreviewed hooks/skills).

### GitHub MCP (github plugin)

- **Source:** claude-plugins-official → https://api.githubcopilot.com/mcp/ (official, hosted by GitHub)
- **What it does:** Lets Claude work with GitHub directly: repos, issues, pull requests, code review and search.
- **Status:** Installed at user scope. Remote HTTP, nothing runs locally; the plugin is only an `.mcp.json`. Connects only when `GITHUB_PERSONAL_ACCESS_TOKEN` is set in the shell that launches Claude Code. Overlaps the gh CLI, which is already logged in.

### godot-ai MCP

- **Source:** [hi-godot/godot-ai](https://github.com/hi-godot/godot-ai) (PyPI package `godot-ai`)
- **What it does:** Stdio MCP server for the Godot engine: scenes, nodes, scripts, resources, animation, tilemaps, signals, running the project and taking editor screenshots. Attaches to a Godot editor plugin on ports 8001 and 8002.
- **Status:** Installed at user scope in `~/.claude.json`, launched by `uvx --from godot-ai==4.2.3` at each session, so it fetches from PyPI when the cache is cold. Local only, not in `cloud/setup.sh`, and useless without a Godot editor running. Reviewed 26 Sep 2026 from sources rather than by reading the server code. PyPI lists 4.2.3 as the current release, the repo is MIT with 2.6k stars and was pushed the same day, and every pinned dependency resolves to a real current package (httpx2 and httpcore2 by Tom Christie under pydantic, fastmcp-slim by the FastMCP authors, mcp and mcp-types by the MCP project). PyPI metadata declares no license, while the repo says MIT. The invocation is locked down: `--isolated`, `--no-config`, `--no-env-file`, `--no-sources`, `--no-build`, `--keyring-provider disabled`, `--disable-telemetry`, empty env. No overlap with anything else installed.

## Other tools

### chrome-relay (CLI + Chrome extension)

- **Source:** [kiluazen/chrome-relay](https://github.com/kiluazen/chrome-relay)
- **What it does:** Drives your real, already logged-in Chrome from the terminal (click, fill, screenshot, run JS), fully local.
- **Status:** Installed and verified (v0.8.2).

### ruff, pyright, swiftlint

- **Source:** Homebrew
- **What it does:** Fast Python lint/type-check and Swift lint, for quick verify loops.
- **Status:** Installed.

### Jellyfin (media server)

- **Source:** Homebrew cask `jellyfin` → repo.jellyfin.org official DMG (SHA-256 pinned)
- **What it does:** Local media server for movies and shows, with a web UI on localhost that streams to other devices on the LAN.
- **Status:** Installed (v12.1). The cask only copies the app, with no install scripts. No other media server installed, so no overlap.

### Open Subtitles (Jellyfin plugin)

- **Source:** Official Jellyfin plugin repo (repo.jellyfin.org), owner jellyfin
- **What it does:** Downloads subtitles from opensubtitles.com.
- **Status:** Installed (v25.0.0.0). Needs an opensubtitles.com login under Dashboard → Plugins → Open Subtitles before it can download anything.

### File Transformation (Jellyfin plugin)

- **Source:** [IAmParadox27/jellyfin-plugin-file-transformation](https://github.com/IAmParadox27/jellyfin-plugin-file-transformation)
- **What it does:** Lets other plugins change the Jellyfin web page as it is served, without editing files on disk. Required by Home Screen Sections.
- **Status:** Installed (v3.0.1.0, ABI 12.1.0, checksum verified by Jellyfin). Source reviewed: only calls endpoints other plugins register, which resolve to localhost. GPL-3.0.

### Plugin Pages (Jellyfin plugin)

- **Source:** [IAmParadox27/jellyfin-plugin-pages](https://github.com/IAmParadox27/jellyfin-plugin-pages)
- **What it does:** Lets plugins add per-user settings pages to the Jellyfin menu. Required by Home Screen Sections.
- **Status:** Installed (v3.0.1.0, ABI 12.1.0). Source reviewed: no network calls, no processes.

### Home Screen Sections (Jellyfin plugin)

- **Source:** [IAmParadox27/jellyfin-plugin-home-sections](https://github.com/IAmParadox27/jellyfin-plugin-home-sections)
- **What it does:** Replaces the Jellyfin home page with streaming-style rows: Continue Watching/Next Up, My List, Recently Added Movies/Shows, Because You Watched, Genre, Collections, Watch It Again.
- **Status:** Installed (v3.0.2.0, ABI 12.1.0). Source reviewed: daily read-only download of translation files from the author's GitHub; Jellyseerr, *arr and LibreTranslate calls only if configured (none are). Repo added: iamparadox.dev manifest. No overlap with other installed plugins.
