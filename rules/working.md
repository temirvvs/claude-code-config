# Working Rules

Don't build from scratch what an open-source repository already does, in any project. Before building a tool, feature, script, or component, search GitHub and other open-source sources for a repo that does it or most of it. If using that repo (as a dependency, a fork, or adapted code) saves time over writing it ourselves, use it, name the repo, and check that its license allows our use. Build from scratch only when no suitable repo exists or adapting one would take longer, and say which of those applies before starting. Adopting a repo still goes through the install check below.

Before installing any skill, plugin, or tool, anywhere, not just from this repo: check its source for safety (bundled hooks, network calls, executed scripts) and check whether it duplicates or overlaps with something already installed. A literal duplicate of an already-installed source (same upstream repo) gets rejected outright, no confirmation needed. A partial overlap (same territory from a different author, or two plugins sharing a skill name) gets flagged with a clear recommendation before installing; it never gets installed silently.

Keep the running install log up to date: https://claude.ai/code/artifact/92a00a36-9672-4392-abdb-0b23cd85604d. It lists only things actually installed, what they are, their source, and what they do. Items that were reviewed and rejected don't belong in it.

In every project repo you work in (not just this one): maintain a `notes/` directory and keep it updated after every PR, in that project's own words about what changed and why. If that project's own `CLAUDE.md` doesn't already point at it, add a line there saying notes live in `notes/` and should be kept current, so any future session finds them without being told again. This repo keeps session/ephemeral config notes in `notes/`; keep them current after each PR or significant config change.

After a change in any project repo, check whether that project's own `CLAUDE.md` needs updating so it stays accurate — new conventions, decisions that override what's written, or structure the file describes that no longer matches reality. Update it only when skipping the update would leave the file wrong or misleading; making a change is not by itself a reason to touch it. Don't pad it with anything a future session could reconstruct just by reading the code.

I strongly dislike ambiguity, everywhere. This applies to what you build as much as to how you write.
- A feature shouldn't pretend to know something it doesn't. If "smart" practice, recommendations or a "weak skills" list has no data behind it, hide it or say plainly what unlocks it. Don't fill the gap with a guess.
- Labels, counts and buttons should say exactly what they do and what they're based on. For example, "Weighted toward Circles and Quadratics" is better than "your weakest skills".
- In replies, name the specific file, value, option or outcome. If something is unknown or unverified, say that outright rather than hedging.
- Never guess. Ground facts in authoritative sources and cite them. If no authoritative source exists, say so rather than inventing a stand-in.
- If a website or source can't be reached (blocked, needs a login, a PDF won't parse), tell me and I'll get it. Don't work around it with a guess.
