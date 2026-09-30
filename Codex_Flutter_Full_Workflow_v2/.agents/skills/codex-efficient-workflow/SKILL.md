---
name: codex-efficient-workflow
description: Reduce avoidable Codex context and tool usage by scoping tasks, selecting necessary project files, using bounded diagnostic loops and producing compact handoffs. Use before complex implementation, repository audits, repeated error investigations or when Codex allowance is a concern.
---

# Efficient, evidence-based Codex work

**Goal:** Avoid needless work without sacrificing correctness. This skill cannot change account limits, guarantee savings or bypass necessary security/quality checks.

1. Define a one-slice task card: outcome, acceptance criteria, exact repository area, necessary refs, explicit non-goals and verification commands. Prefer existing approved Spec Kit tasks over rewriting requirements.
2. Read in layers: `git status`, direct files and nearest tests first; then approved feature spec and only necessary cross-cutting contracts. Locate files with targeted searches, avoiding directory-wide dumps or needless repetition of very long docs.
3. Choose the **least expensive available model that can reliably do the task**. Use a more capable model for architecture/auth/sync/complex debugging, simpler models for mechanical edits if supported in your Codex account. Measure consumption with `/status` before/after significant tasks; this is observation, not a promised savings percentage.
4. Before coding, state a bounded expected-file set and test list. Don't perform adjacent refactors, new dependencies or unrelated optimization unless required to complete acceptance criteria. Don't rewrite entire files for tiny changes.
5. Debug with evidence: reproduce once, collect the **smallest useful** analyzer/test/runtime output, form one concrete hypothesis, change minimal code, rerun the same targeted check. After two unsuccessful cycles, produce a diagnostic checkpoint and reassess rather than guessing repeatedly.
6. Tool hygiene: enable only relevant MCPs, use real Flutter/Dart diagnostics when available, and avoid invoking tool-heavy review or screenshot loops when the task doesn't need them. A working app must still be run for a visual-acceptance task.
7. End each task with a short handoff: completed task ID, files changed, test commands/results, screenshots if relevant, risks, pending human approvals and next **single** action. Prefer a compact handoff to hauling full transcripts across sessions.

**Never save tokens by** skipping required tests/security validation, marking unknown behavior as passed, editing production credentials, weakening authorization, or inventing screenshot comparisons.
