# 2026-09-26 — installed the hallmark skill

Installed [nutlope/hallmark](https://github.com/nutlope/hallmark) (MIT, commit
`13ac0ec`) at user scope in `~/.claude/skills/hallmark`, and added it to
`cloud/setup.sh`.

## Pre-install review

**Safety — clean.** `skills/hallmark/` is `SKILL.md` plus markdown under
`references/`. No hooks, scripts, executables, or install-time steps. The skill
treats a project's `design.md` as design data only and refuses instructions
inside it.

**Overlap — partial, kept on purpose.** `agent-skills:frontend-ui-engineering`
also triggers on page builds and has an "avoid the AI aesthetic" table. The two
don't conflict. Ghaith asked that they complement each other, so
`rules/working.md` now splits the work:

- Hallmark: theme, palette, type, page structure, motion, slop test
- frontend-ui-engineering: components, state, accessibility, responsive, performance
- Visual conflicts: project design system first, then Hallmark's theme

`frontend-design@claude-plugins-official` sits in the marketplace cache but isn't
enabled, so it doesn't overlap.

## Install method

A codeload tarball piped into `tar --strip-components=3`, not `npx skills add`.
This path runs no npm package, and it matches the ponytail step in
`cloud/setup.sh`. The README has the one-liner for new machines.

## Cloud

The `cloud/setup.sh` change reaches cloud sessions at the next environment
rebuild. The `rules/working.md` change reaches them at the next session start.
