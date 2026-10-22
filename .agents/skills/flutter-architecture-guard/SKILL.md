---
name: flutter-architecture-guard
description: Protect an existing Flutter project's architectural and business contracts during Codex changes. Use for feature implementation, refactors, reviews, offline synchronization, auth, persistence, routing, or dependency changes.
---

# Architecture and business-contract guard

This is a **repository-conformance** skill, not a generic Clean Architecture generator.

1. Retrieve only applicable contract sections and affected code when the task requires code inspection. Reuse established facts and a compact boundary map across stages; no fixed map length or repeated full-document reads. For documentation-only work, inspect the relevant instructions and contracts without scanning production code.
2. Keep code feature-first and state ownership explicit. Preserve approved business, SDK, security and lifecycle boundaries; choose only justified internal layers. Widgets render and dispatch intent through Bloc/Cubit, not SDK/storage calls. Do not silently change the approved state-management or DI approach.
3. Trace the actual affected data flow, state owners and relevant contracts. Do not add interfaces, use cases, repositories or coordinators to satisfy a predefined chain. Justify each by a concrete responsibility, safety boundary or meaningful test seam; avoid speculative edits to unrelated areas.
4. For offline-first apps: write locally according to the existing durable outbox contract; keep operations idempotent and account-scoped; distinguish local success from remote confirmation; preserve ordering and reconciliation rules; handle sign-out/account switch without exposing another account's unsynced records. Treat server authorization and scoring as server-enforced where the project requires it.
5. Security: never disable RLS, weaken auth or leak credentials to make development tests pass. Do not apply production migrations, purge local stores or change remote resources without explicit authorization and a reviewed plan.
6. Before modifying, state any architectural exception needed. If the task cannot be completed within the existing contracts, stop at a precise proposed contract change rather than silently rewriting architecture.
7. For code changes, preserve behavioral tests and add focused tests for concrete regression risks. Run `flutter analyze` and scoped tests; broaden regression checks for shared, security-critical or substantial changes. State what was not tested. Avoid unnecessary mocking of simple pure logic. For documentation-only changes, check consistency, links and diff scope; do not run Flutter tests.

**Output:** verified repo conventions; boundary/file map; behavior preserved; tests/evidence; exact issues requiring separate approval. Never claim a governance or CodeRabbit gate passed without artifacts.
