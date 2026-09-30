<!-- BEGIN CODEX_WORKFLOW_PACK_V2; merge with existing AGENTS.md, do NOT replace -->
## Codex implementation + quality workflow

- Source of truth: existing approved Spec Kit feature specs/tasks, architecture/database contracts, design manifest, and approved PNGs. Repo-specific decisions override generic skills. When conflicting or missing, report the exact conflict rather than inventing a rule.
- Read the task-specific slice and nearby implementation first. Load only the relevant sections of architecture, UI and database docs. Never reread all project documentation on every routine edit.
- Keep one task per run. No unrelated dependency upgrades, broad refactors, formatting sweeps, new architectural frameworks or uncontrolled migrations.
- For UI: use native Flutter components and existing tokens, not a bitmap-as-screen. The approved PNG is the **visual baseline at its reference viewport**, not a reason to hardcode a nonresponsive layout. Support reasonable viewport changes, keyboard, text scaling and applicable RTL.
- A UI change needs a running app screenshot at an equivalent environment, direct comparison to the approved reference, visible handling of material differences and focused automated tests. If screenshot capture is unavailable, mark visual verification **BLOCKED**, never PASS.
- For stateful/offline changes: preserve existing account ownership, privacy, local-first writes, sync/outbox guarantees, authorization and database contracts; do not assume any particular table, collection, SDK or auth implementation without repository evidence.
- Minimum validation: format only touched Dart files, run analyzer and focused relevant tests. Do not mark unrelated existing failures as introduced by the task; distinguish preexisting vs regression with evidence.
- Keep final output concise: changed paths, acceptance criteria met/unmet, exact commands with results, screenshot evidence, unresolved concerns, next smallest task and optional compact session handoff. Avoid pasting entire files or gigantic logs.
- Never claim CodeRabbit approval, screenshot match, production deployment or remote migration without actual evidence; retain the existing project's feature-state update and review gates.
<!-- END CODEX_WORKFLOW_PACK_V2 -->
