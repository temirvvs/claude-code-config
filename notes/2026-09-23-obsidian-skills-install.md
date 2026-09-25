# 2026-09-23 — installed obsidian@obsidian-skills

Added the `kepano/obsidian-skills` marketplace and installed the `obsidian` plugin
(v1.0.1) at user scope.

## Pre-install review

Required by `CLAUDE.md`. Cloned the repo and read every file before installing.

**Safety — clean.** The repo is six `SKILL.md` files plus markdown references, a
`plugin.json`, and a `marketplace.json`. No hooks, no MCP servers, no scripts, no
executables, no postinstall. Nothing runs at install time.

Two things to know about, neither hidden and neither triggered unless the skill is
invoked:

- `defuddle` and `knap` instruct a global `npm install -g` of those CLIs (both
  kepano / obsidianmd projects).
- `obsidian-cli` documents `obsidian eval code="..."`, which runs JavaScript inside a
  running Obsidian instance. That is the skill's stated purpose.

**Overlap — none.** The four marketplaces already installed (claude-code-warp,
ponytail, claude-plugins-official, addy-agent-skills) carry nothing Obsidian-related,
and none of the six skill names collide with an installed skill.

## Skills added

`obsidian-markdown`, `obsidian-bases`, `json-canvas`, `obsidian-cli`, `defuddle`, `knap`

## Also in this settings.json change

`/model` and `/effort` wrote `model: opus` and
`modelSettings["claude-opus-5"].effortLevel: high`. `README.md` line 7 now lists both.

## Committed

Pushed to `origin main` on 2026-09-25 along with the open-source reuse rule.
