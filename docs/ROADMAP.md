# StreakUp v1 Implementation Roadmap

| Field | Value |
| --- | --- |
| Status | **Approved — v1 implementation roadmap; feature specifications and code remain gated** |
| Phase | Roadmap / Feature Registry |
| Scope | Android and iOS v1 P0; P1 only if schedule allows |
| Product authority | [PRD v1.0](PRD.md) |
| Governance | [StreakUp Constitution](../.specify/memory/constitution.md) v2.0.0 |
| Slice details | [FEATURE_REGISTRY.md](FEATURE_REGISTRY.md) |

This approved roadmap orders **specification and later implementation slices**. It does not authorize code or a production schema. For every feature containing user-facing UI, delivery follows: Understand + Specify → Design Reference (if UI exists) → Plan → Implement + Test → Finalize. A required screen MUST NOT be implemented until its PNG design is explicitly approved. Technical plans MUST reference the exact approved PNG files. Store reusable approved visual references in `docs/design/references/` and feature screen designs in `docs/design/screens/<feature-id>/`. The [architecture](ARCHITECTURE.md), [database foundation](DATABASE.md), and [approved UI/UX foundation](UI_UX_FOUNDATION.md) set cross-cutting boundaries. Specifications may record genuine unresolved decisions. Dependent implementation waits for a blocking product decision; independent work may advance.

## 1. Planning rules

- Deliver thin, testable user outcomes. Do not build an unused generic schema or a complete sync framework ahead of a real aggregate; validate the local-first/outbox/reconciliation pattern with the first habit path, then extend it feature by feature (`DB-01`–`DB-07`, `FR-020`–`FR-022`).
- Every offline-capable personal write commits to Isar with durable intent before network work. Shared actions stay Pending for other users until Supabase accepts them. Reconciliation returns canonical state to Isar; Bloc/Cubit observes local state (`BR-022`, `BR-023`).
- Keep Supabase authoritative for access, social effects, restore transfers, challenge points, and final results. Include RLS/grant/constraint tests and authorized tombstones/change-feed handling in the slice that introduces each boundary.
- English/Arabic, RTL, accessibility, privacy, Pending/Synced/Failed, and failure recovery belong in **every affected P0 slice**, not a translation or hardening phase at the end (`FR-023`, `NFR-003`, `NFR-008`–`NFR-012`).
- Complete and approve each feature's required PNG screen designs before its UI implementation. Use [DESIGN_SYSTEM.md](design/DESIGN_SYSTEM.md) and approved PNG references in `docs/design/references/`; store feature screens in `docs/design/screens/<feature-id>/`. Final palette/font/icon choices remain pending visual approval until established by the first approved reference PNG screens (`UXF-03`).
- P1 slices remain conditional on schedule and an explicit release-scope decision. P2/P3 or new admin tooling are not silently added.

## 2. Suggested delivery sequence

Order numbers are the registry's suggested implementation order, **not** permission to implement and not a claim that open product decisions are resolved. Where a blocker delays a slice, advance an independent slice with its own completed specification and gates.

| Stage | Order / slice IDs | Outcome and exit evidence |
| --- | --- | --- |
| A. App and account foundation | 01–03: `SL-01`–`SL-03` | Bilingual shell, Supabase Auth/account isolation, Isar local-first and outbox/recovery pattern. Exercise a real command path with the first habit slice; prove restart survival, safe account separation, and visible Pending/Failed. |
| B. Personal daily loop | 04–06: `SL-04`–`SL-06` | Create an owned private habit with schedule, view Today, check in once per occurrence, and see deterministic personal streak/history. Test offline restart, duplicate submission, DST/time-zone boundaries, and server reconciliation. |
| C. Personal management | 07–12: `SL-07`–`SL-12` | Future-facing edits, pause/archive, visibility/revocation, deletion controls, local reminders, profile/language, and explicit self Restore. Each item retains its own blocker and can move when clarified; deletion does not hold up reminders/profile. |
| D. Trusted social loop | 13–15: `SL-13`–`SL-15` | Friend requests/removal, permission-filtered shared progress, and Restore requests/gifts. Confirm offline social Pending wording, revocation feed, one active request per friend, atomic balance transfer, and consequence-first gift confirmation. |
| E. Private challenges | 16–19: `SL-16`–`SL-19` | Create/invite, participate/leave/remove, server-owned score ledger and leaderboard, automatic close and minimal preserved result. Validate one point per eligible occurrence, ties, no Restore-to-score leakage, and late-sync finalization rule. |
| F. Communication and privacy closure | 20–22: `SL-20`–`SL-22` | Peer nudges, authoritative product Inbox/push delivery, and account deletion/privacy closure. Social event generation may start in earlier slices; this stage completes the shared Inbox and delivery behavior. Verify muted/failed delivery never changes progress. |
| G. Optional P1 | 23–30: `SL-23`–`SL-30` | Richer categories/icons, statistics, challenge history browsing, friend activity, richer friend search, notification preferences, archive browsing, and onboarding only if schedule allows and each is specified. |

### Release checkpoints

| Checkpoint | Minimum evidence before proceeding |
| --- | --- |
| First personal vertical path | Approved occurrence/deadline rule; account-isolated Isar write and outbox; idempotent Supabase acknowledgment; Isar reconciliation; English/Arabic RTL UI with local success distinct from remote sync status. |
| First cross-user path | Current RLS/grants and narrow shared projections; permission revocation/tombstone behavior; offline action visibly Pending for others; denial tests for removed friends and private habits. |
| First challenge score path | Approved equivalence, time-zone/deadline and late-upload rules; PostgreSQL uniqueness and trusted transaction; ties and Restore separation; multi-device tests. |
| Release candidate | All P0 specifications and verification complete; Android/iOS and English/Arabic RTL; offline/restart/retry/conflict, privacy and authorization checks; no known silent-loss, private-data disclosure, or score integrity defects; launch legal/retention decisions resolved. |

## 3. Decisions that gate slices

| Decision | Slices affected | Required resolution |
| --- | --- | --- |
| `OQ-004` occurrence deadline/time zone plus late offline check-in rule | `SL-04`–`SL-07`, `SL-10`, `SL-12`, `SL-15`–`SL-19`, P1 statistics/history | Define scheduled occurrence, month boundary, travel/DST and server acceptance before calculation or schema relies on them. |
| `OQ-009` offline edit conflict | `SL-03`, `SL-07`–`SL-09` | Approve visible resolution for competing edit/visibility/delete intent; preserve original local action. |
| `OQ-006` P0 friend identifier/discovery | `SL-13`, `SL-15`–`SL-16`, `SL-27` | Define how users find/add a friend without exposing private account data. |
| `OQ-001`, `OQ-002` gift receiving and request anti-spam | `SL-15`; nudge policy also needs explicit clarification in `SL-20` | Set balance/abuse limits before transfer/request rules are implemented. |
| `OQ-003`, `OQ-005` challenge equivalence and rejoin | `SL-16`–`SL-19` | Set eligibility and membership semantics before scoring. |
| **Late challenge finalization** (architecture product decision) | `SL-18`–`SL-19`, `SL-25` | Set late-arrival cutoff and whether a preserved final ranking may change. |
| **Unsynced account data on sign-out/subsequent-sign-in/deletion** (architecture product decision) | `SL-02`, `SL-03`, `SL-22` | SL-02 retains original-account work across sign-out and subsequent sign-in; no dedicated switch in v1 (2026-09-30). Preserve isolation; deletion retention remains a separate decision. |
| `OQ-008`, `OQ-010` launch jurisdictions and retention | `SL-09`, `SL-22`, release candidate | Define deletion, anonymization, backup/receipt/tombstone retention and launch environment constraints. |
| `BR-019` required notices, mute and nudge controls | `SL-20`, `SL-21`, `SL-28` | Clarify which notices are required and the permitted mute/rate-limit behavior. |
| `OQ-007` reporting/admin workflow | **Not scheduled as an implementation slice** | PRD identifies an admin role but leaves its user-facing reporting workflow TBD. Product must define scope and priority before a slice is added. |

Technical gates remain `T-01` (Isar distribution and at-rest protection), `T-02` (sync contracts, cursor and RPC/Edge boundary), `T-04` (push/local notification integration), and `T-05` (observability, environment and release pipeline). These do not replace the product decisions above. `UXF-06`–`UXF-08` are resolved in the approved [UI/UX foundation](UI_UX_FOUNDATION.md): Restore gift confirmation is consequence-first; device locale plus explicit Profile language selection and 0–9 numerals are approved; offline privacy reduction/removal must explain its delayed remote effect.

## 4. Scope accounting

The registry maps all P0 product features (`P0-F001`–`P0-F013`) and all conditional P1 features (`P1-F001`–`P1-F008`) to slices. P0's minimal preserved challenge result is in `SL-19`; dedicated browsing is P1 `SL-25`. P0 habit creation includes the PRD's optional category/icon input; richer categories/icons remain P1 `SL-23`. P0 friend addition requires the identifier decision `OQ-006`; richer search remains P1 `SL-27`. Basic reminder controls are P0 `SL-10`; fine-grained category preferences are P1 `SL-28`. No P2/P3 capability is in this roadmap.

## Lean delivery amendment — 2026-10-01

Default Spec Kit artifacts are concise spec.md and plan.md; tasks may be in the plan. Clarification, separate consistency analysis, tasks.md and review are not mandatory stages. Ask only for blocking product decisions and check consistency during planning. Add deeper artifacts only for concrete persistence, sync, ownership, authorization, cross-user, scoring or destructive privacy risks. Reuse approved source material by reference. CodeRabbit is removed from future gates/dependencies/handoffs; historical review facts remain historical.

UI needs an approved PNG/design before implementation. Codex uses it for hierarchy, sections, states, interactions, visual language and RTL, without design exploration. Implementation is functional and reasonably close; final visual polish is a later Product Owner pass. Verify relevant states/interactions, overflow, structural RTL, compact phones, keyboard/insets and accessibility proportionately. No exhaustive screenshot matrix or pixel-perfect gate. Finalize with analyzer, relevant automated tests, useful lightweight runtime checks, implementation guides and project-state updates.
