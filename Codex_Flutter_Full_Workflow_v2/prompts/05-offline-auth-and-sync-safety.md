# 05 — Offline-first / authentication / cross-user change safety

Use `$flutter-architecture-guard` and `$codex-efficient-workflow`.
TASK ID: [ID]
EXISTING OFFLINE/AUTH/DATABASE CONTRACT PATHS: [REAL PATHS]
EXACT BEHAVIOR TO CHANGE: [SHORT STATEMENT]
EXPECTED ACCEPTANCE / ERROR / ACCOUNT-SWITCH BEHAVIORS: [TEST CASES]

Step 1 is a READ-ONLY contract review: inspect relevant UI/use-case/repository, local persistence, outbox/sync and backend contracts. Identify what exists versus only documented; do not fabricate migrations or server functions.

For any proposed implementation, enumerate data ownership, offline behavior, ordering, idempotency, conflict policy, UI's local-vs-remote confirmation and sign-out/account-switch consequences. If key behavior is unresolved in the product requirements, stop with a precise decision question; do not silently choose a policy. Propose SQL migrations for review if required; never auto-apply production migrations, weaken RLS, expose service keys or delete local unsynced data.

Once contracts are verified, implement only the explicitly approved bounded slice, with focused tests for at least happy path, offline failure/retry, duplicate submission, authorization/account isolation and the relevant sign-out consequence. Run scoped analyzer/tests and report factual evidence.
