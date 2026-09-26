# 2026-09-26 — agent-skills in cloud sessions, ponytail in the install log

A cloud session audited itself against the install log and found two real gaps.
Both are fixed here.

## agent-skills was missing from cloud sessions

`rules/working.md` hands UI implementation and accessibility to
`agent-skills:frontend-ui-engineering`, but `cloud/setup.sh` installed only
ponytail and hallmark. Cloud UI work had Hallmark's visual direction and nothing
owning the implementation half.

`cloud/setup.sh` now has an `install_plugin <repo> <plugin@marketplace>`
function, used for ponytail and agent-skills. Two steps matter:

- Tarball from codeload, because `git clone` of another repo gets a 403 from the
  cloud's GitHub proxy (already true for ponytail).
- `jq '.plugins |= map(.source = "./")'` on `.claude-plugin/marketplace.json`.
  addyosmani/agent-skills declares its plugin source as a github repo, so
  installing from the local marketplace would send the fetch back through that
  proxy. Ponytail already declares `./`, so the rewrite is a no-op there.

Verified on this Mac by running the function against a throwaway
`CLAUDE_CONFIG_DIR` and `HOME`: both plugins installed and enabled, and
`skills/frontend-ui-engineering/SKILL.md` was in the install path. The cloud
tarball tracks `main`, which is v0.6.11; the Mac has v0.6.10 from the
marketplace.

## ponytail had no row in the install log

Reviewed v4.10.0 (MIT) before adding the row:

- `hooks/`, `scripts/` and `ponytail-mcp/` make no network calls and send no
  telemetry.
- Env reads are `PONYTAIL_*`, `CLAUDE_CONFIG_DIR`, `CLAUDE_PLUGIN_ROOT`,
  `XDG_CONFIG_HOME`, `APPDATA` and host-detection vars for Cursor, Copilot,
  Codex and Qoder.
- Writes are `~/.claude/.ponytail-active`, `.ponytail-statusline-nudged` and a
  mode state file. `scripts/uninstall.js` and `scripts/cursor-hooks.js` edit
  settings files, and only when run by hand.
- `benchmarks/` calls the OpenAI and Anthropic APIs, but no hook or command
  invokes it.
- Registered hooks: SessionStart, SubagentStart, UserPromptSubmit, all three
  running node scripts inside the plugin.

Overlap is partial and kept. `/techdebt` hunts duplicated code,
`agent-skills:code-simplification` refactors for clarity, ponytail targets
over-engineering.

## Still open

- `warp@claude-code-warp` and `stripe@claude-plugins-official` are installed and
  have no row in the install log either.
- The `cloud/setup.sh` change needs an environment rebuild, or a touch of the
  Setup script field, before cloud sessions get agent-skills.
