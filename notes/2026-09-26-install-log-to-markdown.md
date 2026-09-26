# 2026-09-26 — moved the install log into this repo

The install log was a Claude Docs page (claude.ai artifact `92a00a36…`). It now
lives in `install-log.md` at the repo root, and `rules/working.md` points there.

## Why

A file in this repo gets version history, diffs and review like the rest of the
config, and any session with this repo attached can update it.

## What changed in conversion

- One section per item with Source / What it does / Status, grouped into Claude
  Code plugins and skills, MCP servers, and other tools. The Docs page's single
  table had cells too long to read as a Markdown table.
- The text of each entry is otherwise unchanged, except for trims made because
  this repo is public. The Jellyfin entries drop the media library paths, the
  web UI port, the app data path and the subtitle language preferences.
- The claude-style-patch entry now points at `rules/response-style.md`, where the
  rules actually live, instead of `~/.claude/CLAUDE.md`.

## Open

- The Claude Docs page still exists and is no longer the source of truth.
- The five account-synced knowledge-work plugins (productivity, engineering,
  design, marketing, cowork-plugin-management) have no entry yet, pending a check
  for bundled hooks.
