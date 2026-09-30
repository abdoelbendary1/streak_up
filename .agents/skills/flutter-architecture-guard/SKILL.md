---
name: flutter-architecture-guard
description: Protect an existing Flutter project's architectural and business contracts during Codex changes. Use for feature implementation, refactors, reviews, offline synchronization, auth, persistence, routing, or dependency changes.
---

# Architecture and business-contract guard

This is a **repository-conformance** skill, not a generic Clean Architecture generator.

1. Read the existing applicable architecture and database contracts; inspect adjacent production code before recommending any pattern. Derive facts from files, not from this skill's example stack. Record relevant boundaries in 5–10 lines.
2. Keep state transitions and business rules in the established presentation/domain/data layers. Do not import repositories/services into leaf UI when the repo already uses Bloc/Cubit or other managed state; do not silently change the chosen state-management or DI approach.
3. Trace each changed behavior across relevant interfaces/use cases/repositories/serialization/persistence/transport/UI. Make contract-affecting changes intentionally and coherently; avoid speculative edits to unrelated layers.
4. For offline-first apps: write locally according to the existing durable outbox contract; keep operations idempotent and account-scoped; distinguish local success from remote confirmation; preserve ordering and reconciliation rules; handle sign-out/account switch without exposing another account's unsynced records. Treat server authorization and scoring as server-enforced where the project requires it.
5. Security: never disable RLS, weaken auth or leak credentials to make development tests pass. Do not apply production migrations, purge local stores or change remote resources without explicit authorization and a reviewed plan.
6. Before modifying, state any architectural exception needed. If the task cannot be completed within the existing contracts, stop at a precise proposed contract change rather than silently rewriting architecture.
7. Add targeted tests for changed behavior and error/edge paths. Run `flutter analyze` and scoped tests; state what was not tested. Avoid unnecessary mocking of simple pure logic; prefer existing test patterns.

**Output:** verified repo conventions; boundary/file map; behavior preserved; tests/evidence; exact issues requiring separate approval. Never claim a governance or CodeRabbit gate passed without artifacts.
