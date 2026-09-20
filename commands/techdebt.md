---
description: Find and remove duplicated code before ending the session
---

Scan the current project for duplicated or near-duplicate code: repeated logic across files, copy-pasted functions or components, and near-identical blocks that differ only in naming.

For each finding: report the file locations and lines, explain what's duplicated, and propose the smallest consolidation (extract one shared helper, delete the redundant copy, or point one at the other) — never introduce a new abstraction beyond what removing the duplication actually requires.

Apply the fixes you're confident about. For anything ambiguous (unclear which copy is canonical, or a fix that would need to touch unrelated code) ask before changing it, rather than guessing.

End with a short summary: what was removed or consolidated, and what's left because it was ambiguous.
