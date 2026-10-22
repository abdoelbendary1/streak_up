---
name: codex-efficient-workflow
description: Reduce avoidable Codex context and tool usage by scoping tasks, selecting necessary project files, using bounded diagnostic loops and producing compact handoffs. Use before complex implementation, repository audits, repeated error investigations or when Codex allowance is a concern.
---

# Efficient, evidence-based Codex work

**Goal:** Avoid needless work without sacrificing correctness. This skill cannot change account limits, guarantee savings or bypass necessary security/quality checks.

1. Use a compact task scope: outcome, acceptance criteria, relevant paths, non-goals and verification. Reuse the user's request or approved Spec Kit task; do not create a separate task-card document merely to repeat it.
2. Retrieve context in layers: working-tree status and direct task files first; nearest tests for code changes, then only relevant spec/contract sections. Use targeted searches, reuse established facts, and skip production code/tests for instruction-only work unless needed to resolve a concrete question. Avoid directory-wide dumps and repeated full-document loading.
3. Supported usage monitoring is optional when useful. Do not require status checks or model switching. Never invent consumption measurements or savings, or reduce reasoning quality to meet a token target.
4. Before coding, state a bounded expected-file set and test list. Don't perform adjacent refactors, new dependencies or unrelated optimization unless required to complete acceptance criteria. Don't rewrite entire files for tiny changes.
5. Debug with evidence: reproduce once, collect the **smallest useful** analyzer/test/runtime output, form one concrete hypothesis, change minimal code, rerun the same targeted check. After two unsuccessful cycles, produce a diagnostic checkpoint and reassess rather than guessing repeatedly.
6. Use only directly relevant installed skills/tools; find-skills is optional discovery. Load or install additional capabilities only for a concrete benefit and within task authorization. Use real Flutter/Dart diagnostics for code changes, focused tests initially and broader regression checks for shared, security-critical or substantial changes. A visual-acceptance task still requires a running app and actual screenshot comparison. Documentation-only work uses consistency/link/diff checks, not Flutter tests.
7. Report acceptance results, changed paths, relevant verification and unresolved risks concisely in the requested format. Add a compact handoff only when another session needs it; do not repeat project instructions, established facts or a separate handoff after every stage.

**Never save tokens by** skipping required tests/security validation, marking unknown behavior as passed, editing production credentials, weakening authorization, or inventing screenshot comparisons.
