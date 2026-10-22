# StreakUp v1 Feature Registry

| Field             | Value                                                                                          |
| ----------------- | ---------------------------------------------------------------------------------------------- |
| Status            | **Approved — v1 slice registry; feature-specific implementation gates are tracked per slice**  |
| Order             | Suggested by [ROADMAP.md](ROADMAP.md); blocked slices may be reordered around independent work |
| Product authority | [PRD v1.0](PRD.md)                                                                             |
| Foundations       | [Architecture](ARCHITECTURE.md), [Database](DATABASE.md), [UI/UX](UI_UX_FOUNDATION.md)         |
| Governance        | [StreakUp Constitution](../.specify/memory/constitution.md) v2.0.0                             |

Each entry is an approved roadmap slice; its per-feature gate determines whether implementation may proceed. For every feature with user-facing UI, follow Understand + Specify → Design Reference (if UI exists) → Plan → Implement + Test → Finalize. A required UI MUST NOT be implemented before its PNG design is explicitly approved, and implementation plans MUST cite the exact approved PNG files. Use [DESIGN_SYSTEM.md](design/DESIGN_SYSTEM.md), approved reusable PNG references in `docs/design/references/`, and feature-specific screen PNGs in `docs/design/screens/<feature-id>/`. “None” under product blockers means no additional open product decision has been identified for that slice; PRD alignment and clarification still apply. Dependencies are direct planning prerequisites, not permission to skip feature gates. A PRD requirement spanning slices is complete only when all its slices are verified: for example, `FR-002` spans habit creation, later edits, visibility and reminder integration; `FR-003` spans lifecycle and deletion. All affected P0 UI work includes English/Arabic RTL, accessibility, privacy and appropriate Pending/Synced/Failed states (`FR-023`, `NFR-003`, `NFR-008`–`NFR-012`). All database impact is **conceptual**; feature specifications and approved plans define actual Isar collections, Supabase migrations, RLS, indexes, contracts and tests. `SL-01` is **Completed / Converged** as recorded in [PROJECT_STATE.md](PROJECT_STATE.md); `SL-02` implementation and foundation cleanup are complete for foundation review, with live/device release evidence explicitly outstanding in [PROJECT_STATE.md](PROJECT_STATE.md). Every other entry remains **Registered / not specified**.

## A. App, account, and personal daily loop — P0

### SL-01 — Bilingual app shell and shared feedback

- **Priority / suggested order / status:** P0 enabling / 01 / Historically Completed, Converged; foundation cleanup implemented and ready for review (`Implementation Allowed: NO` for further SL-01 expansion). Earlier specification/design/tasks/visual verification and CodeRabbit review remain historical facts; current architecture and automated evidence are recorded in [PROJECT_STATE.md](PROJECT_STATE.md).
- **PRD requirement IDs:** `FR-023`, `FR-022`; `NFR-001`, `NFR-003`, `NFR-009`–`NFR-011`; `UX-003`, `UX-011`–`UX-014`; `P0-F013`.
- **Dependencies:** Approved architecture and `UXF-01`–`UXF-05`, `UXF-07`.
- **Product decisions blocking it:** None identified for technical planning. Approved identity, root-screen references, and SL-01 variants establish the visual direction; exact font family and pixel metrics require implementation validation, not a new product decision.
- **Database impact:** None for shell; do not add product tables. Locale preference persistence is specified with `SL-11`.
- **UI/PNG design impact:** Four-tab shell, global Inbox/Profile/Sync entry, reusable components, global feedback, status variants, English/Arabic RTL and large text. Required screen PNGs belong in `docs/design/screens/001-bilingual-shell-feedback/`; approved reusable reference PNGs belong in `docs/design/references/`.
- **Offline/sync impact:** Shell renders Online/Offline/Reconnecting reachability only. Pending/Synced/Failed badges accept feature-owned values; no shell action map, simulated sync engine or global inline-error registry.

### SL-02 — Account access and session isolation

- **Priority / suggested order / status:** P0 / 02 / Implemented; foundation review pending. Automated regression evidence is recorded in PROJECT_STATE.md. Live/device release checks remain open; this is not a release-readiness claim.
- **PRD requirement IDs:** `FR-001`, `BR-020`, `PERM-001`, `NFR-007`, `P0-F001`; account-lifecycle boundary from `BR-022`.
- **Dependencies:** `SL-01`; approved Supabase Auth direction and account-isolation boundary. Production local persistence remains pending feature planning.
- **Product decisions blocking it:** None for technical planning. The Product Owner clarified email/password access, email recovery, first-entry email verification, and account-scoped retention of unsynced work across sign-out, subsequent sign-in as another account, and confirmed session expiry. The 2026-09-30 decision permits one active account per device and removes the dedicated Switch Account feature. Fresh registration/sign-in/recovery require network; no offline login promise is added.
- **Database impact:** Supabase Auth identity and account-scoped local-data boundary; no custom credential store in Isar. Product schemas, Isar models, and sync/outbox mechanics remain pending their feature plans.
- **UI/PNG design impact:** Eight active Product Owner-approved PNGs in `docs/design/screens/002-account-access-session-isolation/`: sign in, registration, email verification, password recovery, recovery email sent, session restoring, session expired, and sign-out pending-work warning. The ninth historical PNG, SL02-UI-008, is RETIRED and preserved. Exact paths are registered in `docs/design/DESIGN_MANIFEST.md`; the approved SL-01 RTL and shared-shell references remain supporting visual authority.
- **Offline/sync impact:** A previously authenticated user may continue eligible account-scoped personal work offline when the session has not been confirmed invalid. Confirmed expiry hides protected UI and preserves local intent until same-account reauthentication. Voluntary sign-out is allowed after an explicit pending/unknown-work warning; another account requires subsequent sign-in; another account can neither access nor sync that work. General sync mechanics belong to SL-03.

### SL-03 — Local-first write, sync, and recovery path

- **Priority / suggested order / status:** P0 enabling / 03 / Registered, not specified.
- **PRD requirement IDs:** `FR-020`–`FR-022`, `BR-022`, `BR-023`, `NFR-002`–`NFR-006`, `NFR-012`, `UX-003`, `UX-010`, `UX-014`, `P0-F012`.
- **Dependencies:** `SL-02`; `DB-01`–`DB-07`. Validate the pattern with `SL-04`'s first owned-habit command, without making the two slices circular prerequisites.
- **Product decisions blocking it:** `OQ-009` for conflict choice; sign-out/subsequent-sign-in retention follows SL-02; no dedicated switch feature. Account-deletion retention remains with SL-22. Exact command/feed contract also needs technical `T-02` approval.
- **Database impact:** Account-isolated Isar outbox, cursor, tombstone and recovery concepts; Supabase idempotency receipt, authorized change feed and revision contract, added only with real feature migrations.
- **UI/PNG design impact:** Sync & Recovery, action-level Pending/Synced/Failed, global pending indicator, retry and preserved-intent conflict states.
- **Offline/sync impact:** Transactional local write before network, durable retries, server acknowledgment and canonical reconciliation into Isar; connectivity alone never claims backend reachability.

### SL-04 — Owned habit creation, schedule, and list

- **Priority / suggested order / status:** P0 / 04 / Registered, not specified.
- **PRD requirement IDs:** `FR-002`, `FR-004`, `FR-020`, `BR-001`, `BR-011`, `PERM-001`, `FLOW-001`, `NFR-002`, `P0-F002`.
- **Dependencies:** `SL-01`–`SL-03`; approved occurrence/schedule model before final spec. `FR-002` includes optional category/icon input; richer taxonomy is P1 `SL-23`.
- **Product decisions blocking it:** `OQ-004` schedule period/deadline/time-zone meaning. No schedule semantics are inferred from UI controls.
- **Database impact:** Feature-driven owned-habit/schedule-version Isar concepts; first PostgreSQL owner-only records, RLS, revision, command receipt and change-feed migration.
- **UI/PNG design impact:** Habits list and Create Habit with Private default, schedule, optional details/category/icon/target, validation, empty and offline-save states.
- **Offline/sync impact:** Creation saves locally and queues a stable-ID command; list reads Isar; server correction/conflict is reconciled visibly.

### SL-05 — Today and occurrence check-in

- **Priority / suggested order / status:** P0 / 05 / Registered, not specified.
- **PRD requirement IDs:** `FR-004`, `FR-005`, `FR-020`, `BR-003`, `PERM-002`, `FLOW-001`, `FLOW-003`, `NFR-002`–`NFR-006`, `UX-001`, `UX-002`, `P0-F003`.
- **Dependencies:** `SL-03`, `SL-04` and an approved occurrence definition.
- **Product decisions blocking it:** `OQ-004` and the linked late offline upload acceptance rule.
- **Database impact:** Stable occurrence/check-in facts in Isar; PostgreSQL uniqueness/accepted-command transaction and revisioned canonical outcome.
- **UI/PNG design impact:** Today Pending/Completed/Missed, no habits/no due habits/all complete, one-tap local success, duplicate and failed-sync states.
- **Offline/sync impact:** One locally durable check-in per eligible occurrence with immediate feedback; server validates, deduplicates retries and reconciles authoritative result.

### SL-06 — Personal streak and completion history

- **Priority / suggested order / status:** P0 / 06 / Registered, not specified.
- **PRD requirement IDs:** `FR-006`, `BR-004`, `BR-011`, `FLOW-003`, `NFR-004`, `NFR-005`, `P0-F004`.
- **Dependencies:** `SL-04`, `SL-05` and accepted schedule/occurrence facts.
- **Product decisions blocking it:** `OQ-004` deadline, pause/time-zone/travel interpretation.
- **Database impact:** Rebuildable local streak projections over versioned facts; only canonical check-in/restore facts and needed revisions remotely, no client-authored authoritative streak counter.
- **UI/PNG design impact:** Habit detail/history, current versus longest streak, missed state, provisional local result and non-shaming copy.
- **Offline/sync impact:** Deterministic local projection from Isar facts, recalculated after canonical reconciliation; no streak result is silently rewritten.

### SL-07 — Future habit edits, pause/resume, and archive

- **Priority / suggested order / status:** P0 / 07 / Registered, not specified.
- **PRD requirement IDs:** `FR-002`, `FR-003`, `FR-020`, `BR-011`, `BR-012`, `PERM-001`, `FLOW-001`, `NFR-004`, `P0-F002`.
- **Dependencies:** `SL-03`, `SL-04`, `SL-06`; challenge obligation checks become relevant with `SL-16`–`SL-18`.
- **Product decisions blocking it:** `OQ-004` effective occurrence/time-zone rule; `OQ-009` concurrent edit resolution.
- **Database impact:** Effective-dated habit/schedule revisions, archive state distinct from deletion, conflict copy and tombstone-aware reconciliation as needed.
- **UI/PNG design impact:** Edit Habit, pause/resume, archive confirmation and preserved-history states; future-only change explanation.
- **Offline/sync impact:** Local-first versioned edits and lifecycle commands; preserve both local intent and server revision on conflict. Pausing cannot bypass accepted challenge obligations.

### SL-08 — Habit visibility sharing and revocation

- **Priority / suggested order / status:** P0 / 08 / Registered, not specified.
- **PRD requirement IDs:** `FR-002`, `FR-011`, `BR-001`, `BR-018`, `BR-023`, `PERM-003`, `PERM-009`, `NFR-008`, `UX-008`, `UX-010`, `P0-F002`.
- **Dependencies:** `SL-03`, `SL-04`; friend-visible projection is consumed by `SL-14`.
- **Product decisions blocking it:** `OQ-009` for concurrent offline visibility edits. `UXF-08` already resolves delayed remote-effect wording.
- **Database impact:** Owner-only habit source, narrow authorized shared projection, visibility revision and recipient-scoped revocation/tombstone feed.
- **UI/PNG design impact:** Private/Shared selector, recipient explanation, Pending offline privacy reduction, Failed sync and recovery states.
- **Offline/sync impact:** Privacy reduction saves locally but takes effect for other users only after successful sync; UI says so explicitly. Server rechecks every friend read.

### SL-09 — Permanent habit deletion control

- **Priority / suggested order / status:** P0 / 09 / Registered, not specified.
- **PRD requirement IDs:** `FR-003`, `BR-011`, `PERM-001`, `UX-005`, `NFR-004`, `P0-F002`.
- **Dependencies:** `SL-03`, `SL-04`, `SL-07`; historical check-in and challenge references must be understood.
- **Product decisions blocking it:** `OQ-010`/`OQ-008` retention and historical handling; `OQ-009` deletion/edit conflict behavior.
- **Database impact:** Explicit delete intent, server deletion marker/revision, authorized tombstones and policy-driven purge; archive remains separate.
- **UI/PNG design impact:** Consequence-first destructive confirmation, locally Pending delete, failure/recovery and history treatment.
- **Offline/sync impact:** Queue deletion intent locally; remote access/history changes await server acceptance and cannot silently erase unsynced work.

### SL-10 — Local scheduled habit reminders

- **Priority / suggested order / status:** P0 / 10 / Registered, not specified.
- **PRD requirement IDs:** `FR-009`, `FR-019`, `FR-020`, `BR-019`, `FLOW-001`, `NFR-002`, `P0-F005`.
- **Dependencies:** `SL-04`; schedule edits in `SL-07` drive rescheduling.
- **Product decisions blocking it:** `OQ-004` time-zone/schedule boundary where it affects trigger interpretation. Required transactional-notice exceptions under `BR-019` are handled in `SL-21`.
- **Database impact:** Isar/local reminder preference and schedule metadata; remote preference sync only as approved by the feature spec.
- **UI/PNG design impact:** Reminder control in Create/Edit Habit, permission-denied and disabled states, localized notification copy.
- **Offline/sync impact:** Local OS scheduling works from stored schedule without network; delivery never writes a check-in, and preference changes remain locally durable.

### SL-11 — Basic profile and language selection

- **Priority / suggested order / status:** P0 / 11 / Registered, not specified.
- **PRD requirement IDs:** `FR-018`, `FR-020`, `FR-023`, `BR-020`, `NFR-008`–`NFR-011`, `P0-F010`, `P0-F013`.
- **Dependencies:** `SL-01`, `SL-02`, `SL-06`; challenge result summary integrates after `SL-19`.
- **Product decisions blocking it:** None for basic information and locale selection. Account deletion is separately blocked in `SL-22`.
- **Database impact:** Minimal owned profile/safe summary projection and appropriate local profile/locale preference storage; no new cross-user visibility by default.
- **UI/PNG design impact:** Profile/settings, current/longest streak, basic completion summary, challenge results when available; device locale initially with explicit English/Arabic selection and 0–9 numerals (`UXF-07`).
- **Offline/sync impact:** Appropriate owned profile edits save locally first; challenge results remain last server-confirmed state; language choice and local UI work offline.

### SL-12 — Personal Streak Restore use

- **Priority / suggested order / status:** P0 / 12 / Registered, not specified.
- **PRD requirement IDs:** `FR-007`, `BR-004`–`BR-007`, `FLOW-003`, `NFR-005`, `UX-006`, `P0-F004`.
- **Dependencies:** `SL-03`, `SL-05`, `SL-06`; canonical balance/ledger command boundary.
- **Product decisions blocking it:** `OQ-004` calendar-month boundary and eligible post-miss Restore window. Gift receiving cap is handled in `SL-15`.
- **Database impact:** Personal allowance/usage ledger and eligible-restoration facts, server-side atomic balance validation; local provisional view and outbox if offline initiation is permitted by the feature spec.
- **UI/PNG design impact:** Restore availability, explicit use/confirmation, missed-to-restored personal streak and no-challenge-point explanation.
- **Offline/sync impact:** Preserve local intent and show provisional Pending when queued; canonical allowance and accepted Restore come from Supabase. Never credit a challenge point.

## B. Friends, sharing, and gifts — P0

### SL-13 — Friend requests and relationship removal

- **Priority / suggested order / status:** P0 / 13 / Registered, not specified.
- **PRD requirement IDs:** `FR-010`, `FR-021`, `BR-002`, `BR-018`, `BR-023`, `PERM-003`, `PERM-004`, `FLOW-004`, `NFR-007`, `NFR-008`, `P0-F006`.
- **Dependencies:** `SL-02`, `SL-03`; current server authorization and revocation feed.
- **Product decisions blocking it:** `OQ-006` P0 friend identifier/discovery. `UXF-08` already approves the offline-removal warning.
- **Database impact:** Friend request/relationship state, constraints, RLS, current-permission checks and removal invalidation; Isar stores only minimum queued social metadata.
- **UI/PNG design impact:** Friends/requests, accept/reject/remove, unavailable and offline Pending/Failed states; removal warns that remote effect waits for sync.
- **Offline/sync impact:** Queue supported requests/removal where specified; another user's relationship/access changes only after Supabase accepts them. Removal revokes future friend-only reads.

### SL-14 — Permission-filtered friend progress

- **Priority / suggested order / status:** P0 / 14 / Registered, not specified.
- **PRD requirement IDs:** `FR-011`, `BR-001`, `BR-002`, `BR-018`, `PERM-003`, `PERM-009`, `NFR-008`, `P0-F006`.
- **Dependencies:** `SL-08`, `SL-13`; server-authorized sharing projection.
- **Product decisions blocking it:** None beyond the approved visibility policy and friend identity dependency; do not infer access to private habits.
- **Database impact:** Narrow RLS-safe friend-visible read model with revocation/change-feed invalidation; no durable cache of another user's private habit details.
- **UI/PNG design impact:** Shared friend progress and no-shared-content/unavailable states; private habits remain undiscoverable.
- **Offline/sync impact:** Stale/offline social data is labeled as such; server reauthorizes each remote read and invalidates revoked local metadata.

### SL-15 — Restore request, response, and gift transfer

- **Priority / suggested order / status:** P0 / 15 / Registered, not specified.
- **PRD requirement IDs:** `FR-008`, `BR-005`, `BR-008`–`BR-010`, `PERM-004`, `PERM-007`, `FLOW-004`, `UX-006`, `UX-007`, `P0-F004`, `P0-F006`.
- **Dependencies:** `SL-03`, `SL-12`, `SL-13`; social event integration with `SL-21`.
- **Product decisions blocking it:** `OQ-001` receiving cap, `OQ-002` request anti-spam limits and `OQ-004` month boundary.
- **Database impact:** Request lifecycle and uniqueness, giver/requester ledger transfer in one trusted PostgreSQL transaction, idempotency receipt and authorized event projection.
- **UI/PNG design impact:** Request/accept/decline flow, one-active-request feedback, balance states, non-coercive copy; **consequence-first gift confirmation** shows one Restore deducted from giver (`UXF-06`).
- **Offline/sync impact:** Supported offline requests/responses remain Pending; no transfer or changed balance is effective for another user before canonical acceptance. Failed transfer retains recovery.

## C. Private challenges — P0

### SL-16 — Challenge creation and invitations

- **Priority / suggested order / status:** P0 / 16 / Registered, not specified.
- **PRD requirement IDs:** `FR-012`, `FR-013`, `FR-021`, `BR-013`, `BR-014`, `PERM-005`, `PERM-006`, `FLOW-002`, `P0-F007`.
- **Dependencies:** `SL-03`–`SL-05`, `SL-13`; invitation events integrate with `SL-21`.
- **Product decisions blocking it:** `OQ-003` equivalent-habit association and `OQ-004` challenge date/occurrence time-zone semantics.
- **Database impact:** Challenge/invitation/participant concepts, locked-rule version and current membership authorization, trusted create/invite/cancel commands.
- **UI/PNG design impact:** Challenges list/invitations, create/configure, pre-start cancellation and locked-rules explanation; offline queued labels.
- **Offline/sync impact:** Supported creation/invites queue locally but are not visible/effective for invitees until server acceptance; Realtime may prompt refresh only.

### SL-17 — Participation, leave, and creator removal

- **Priority / suggested order / status:** P0 / 17 / Registered, not specified.
- **PRD requirement IDs:** `FR-013`, `FR-015`, `BR-012`, `BR-015`, `BR-016`, `PERM-005`, `PERM-006`, `FLOW-002`, `FLOW-005`, `UX-005`, `UX-009`, `P0-F007`.
- **Dependencies:** `SL-16`; accepted normal check-ins from `SL-05`.
- **Product decisions blocking it:** `OQ-005` rejoin rule; `OQ-003`/`OQ-004` through the challenge contract.
- **Database impact:** Participant lifecycle with history-preserving Left/Removed state, membership revision, authorization and trusted leave/remove commands.
- **UI/PNG design impact:** Participant list, accept/decline, leave/remove consequence confirmation, ineligible-to-win and historical state variants.
- **Offline/sync impact:** Pending social action does not alter another user's effective membership; Supabase decides the canonical transition and reconciles Isar.

### SL-18 — Canonical challenge scoring and leaderboard

- **Priority / suggested order / status:** P0 / 18 / Registered, not specified.
- **PRD requirement IDs:** `FR-013`, `FR-014`, `BR-003`, `BR-007`, `BR-013`, `BR-017`, `PERM-005`, `FLOW-002`, `NFR-005`, `P0-F008`.
- **Dependencies:** `SL-05`, `SL-12`, `SL-16`, `SL-17`.
- **Product decisions blocking it:** `OQ-003` equivalence, `OQ-004` eligibility/late uploads and architecture's late-finalization rule.
- **Database impact:** Supabase-owned score ledger, unique contribution per eligible participant/challenge/occurrence, trusted atomic derivation and permission-filtered leaderboard read.
- **UI/PNG design impact:** Leaderboard with ties, last confirmed score, pending personal check-in beside score, no Restore-to-point implication.
- **Offline/sync impact:** Isar may show provisional personal progress; points/ranking change only after accepted canonical check-in. Reconcile corrections visibly.

### SL-19 — Automatic challenge close and minimal preserved result

- **Priority / suggested order / status:** P0 / 19 / Registered, not specified.
- **PRD requirement IDs:** `FR-016`, `BR-015`–`BR-017`, `BR-021`, `FLOW-002`, `FLOW-005`, `NFR-005`, `P0-F007`, `P0-F008`.
- **Dependencies:** `SL-17`, `SL-18` and trusted server scheduling/orchestration.
- **Product decisions blocking it:** Late-arrival cutoff and whether a finalized ranking may change; `OQ-004` deadline; `OQ-010`/`OQ-008` for deleted-user anonymization/retention.
- **Database impact:** Canonical close/final result snapshot and historical participant references, with approved anonymization and idempotent closure.
- **UI/PNG design impact:** Completed challenge detail, final ranking/ties, left/removed and anonymous participant treatment. Dedicated browsing remains P1 `SL-25`.
- **Offline/sync impact:** Final result is server-confirmed; cached result may be stale offline and must reconcile after a late accepted event under the approved rule.

## D. Communication and account privacy — P0

### SL-20 — Peer reminder nudges

- **Priority / suggested order / status:** P0 / 20 / Registered, not specified.
- **PRD requirement IDs:** `FR-017`, `BR-019`, `PERM-004`, `FLOW-002`, `UX-007`, `NFR-007`, `P0-F009`.
- **Dependencies:** `SL-13`, `SL-14`; event display/delivery integrates with `SL-21`.
- **Product decisions blocking it:** Nudge rate/mute and recipient-control policy under `BR-019` is not specified; do not silently reuse `OQ-002` restore-request thresholds.
- **Database impact:** Trusted nudge command, recipient eligibility/rate controls and minimal authorized event record; no habit completion write.
- **UI/PNG design impact:** Send-nudge action, non-shaming copy, recipient controls, Pending/Failed and no-permission states.
- **Offline/sync impact:** A queued nudge is not delivered until Supabase accepts it; delivery failure never changes completion or streak.

### SL-21 — Product Inbox and notification delivery

- **Priority / suggested order / status:** P0 / 21 / Registered, not specified.
- **PRD requirement IDs:** `FR-019`, `BR-019`, `FLOW-001`, `FLOW-002`, `FLOW-004`, `NFR-010`, `NFR-011`, `P0-F011`.
- **Dependencies:** `SL-10`, `SL-13`, `SL-15`–`SL-16`, `SL-20`; technical push/local integration `T-04`.
- **Product decisions blocking it:** `BR-019` required transactional notices versus mute/disable policy. Exact nudge/restore controls depend on their own slices.
- **Database impact:** Authoritative social/product event records, recipient-scoped authorization, deduplication and delivery metadata; minimal push payloads.
- **UI/PNG design impact:** Inbox, unread/empty/stale states, safe destination resolution, denied push permission and English/Arabic RTL notification copy.
- **Offline/sync impact:** In-app event state comes from accepted server events; push/Realtime only prompt refresh. Cached permitted events may render offline with freshness label.

### SL-22 — Account deletion and privacy closure

- **Priority / suggested order / status:** P0 privacy boundary / 22 / Registered, not specified.
- **PRD requirement IDs:** `BR-021`, `BR-022`, `PERM-009`, `NFR-007`, `NFR-008`, `UX-005`; account/privacy boundary of `P0-F001`, `P0-F010`.
- **Dependencies:** `SL-02`, `SL-03`, `SL-09`, `SL-19`; historical challenge result and outbox handling.
- **Product decisions blocking it:** `OQ-008`, `OQ-010` legal/retention/anonymization; architecture's unsynced local account-data decision.
- **Database impact:** Account deletion command, visibility removal, approved retention/purge and backup policy, minimal anonymous historical reference and local-store disposal/recovery.
- **UI/PNG design impact:** Consequence-first deletion confirmation, pending-data warning and eventual state; exact copy awaits approved retention behavior.
- **Offline/sync impact:** Do not represent a locally queued deletion as remotely complete; pending actions and server data follow the approved account-lifecycle policy.

## E. Conditional P1 slices — schedule and specification approval required

### SL-23 — Richer habit categories and icons

- **Priority / suggested order / status:** P1 conditional / 23 / Registered, not specified.
- **PRD requirement IDs:** `FR-024`, `PERM-001`, `FLOW-001`, `NFR-009`–`NFR-011`, `P1-F001`; baseline optional category/icon in `FR-002` remains P0.
- **Dependencies:** `SL-04`, `SL-07`; explicit P1 scheduling decision.
- **Product decisions blocking it:** Exact richer taxonomy/customization scope requires its feature specification; no P0 category/icon requirement is deferred into P1.
- **Database impact:** Only category/icon fields or reference data justified by the approved P1 spec; no effect on occurrence or streak identity.
- **UI/PNG design impact:** Category/icon picker and list/detail variants in both languages, with accessible labels.
- **Offline/sync impact:** Owned selection edits follow the local-first habit edit path; classification never changes streak logic.

### SL-24 — Basic habit statistics

- **Priority / suggested order / status:** P1 conditional / 24 / Registered, not specified.
- **PRD requirement IDs:** `FR-025`, `BR-004`, `NFR-005`, `P1-F002`.
- **Dependencies:** `SL-05`, `SL-06`; explicit P1 scheduling decision.
- **Product decisions blocking it:** `OQ-004` period/deadline meaning for percentage and weekly/monthly totals; denominator presentation belongs in the feature spec.
- **Database impact:** Rebuildable Isar aggregate/projection over accepted versioned facts; add remote aggregate only if justified by scale/privacy review.
- **UI/PNG design impact:** Simple totals, percentage and history/calendar view with provisional versus synced context.
- **Offline/sync impact:** Local statistics recalculate after reconciliation and disclose when pending check-ins affect the displayed value.

### SL-25 — Dedicated challenge history browsing

- **Priority / suggested order / status:** P1 conditional / 25 / Registered, not specified.
- **PRD requirement IDs:** `FR-026`, `BR-015`–`BR-017`, `BR-021`, `PERM-005`, `NFR-005`, `NFR-008`, `P1-F003`.
- **Dependencies:** `SL-19`; explicit P1 scheduling decision.
- **Product decisions blocking it:** Late-finalization and `OQ-008`/`OQ-010` retention/anonymization decisions inherited from canonical history.
- **Database impact:** Indexed authorized history query/read model over existing final records; no new scoring authority.
- **UI/PNG design impact:** Dedicated history list/filter/detail and ties/anonymous-participant states beyond P0 minimal preserved result.
- **Offline/sync impact:** Cached authorized history may be stale; canonical final records refresh and reconcile without relying on push.

### SL-26 — Friend activity summary

- **Priority / suggested order / status:** P1 conditional / 26 / Registered, not specified.
- **PRD requirement IDs:** `FR-027`, `BR-001`, `BR-018`, `PERM-003`, `NFR-008`, `P1-F004`.
- **Dependencies:** `SL-13`, `SL-14`; explicit P1 scheduling decision.
- **Product decisions blocking it:** Exact activity fields/time span require a feature spec; never infer visibility beyond explicitly shared data.
- **Database impact:** Narrow permission-filtered aggregate/projection, revocation-aware feed and RLS/denial tests.
- **UI/PNG design impact:** Friend activity summary with private/empty/stale/unavailable states and no private-habit hints.
- **Offline/sync impact:** Cached summary is labeled stale offline and invalidated on friendship or sharing revocation.

### SL-27 — Rich friend search

- **Priority / suggested order / status:** P1 conditional / 27 / Registered, not specified.
- **PRD requirement IDs:** `FR-028`, `BR-018`, `PERM-003`, `NFR-007`, `NFR-008`, `P1-F005`.
- **Dependencies:** `SL-13`; explicit P1 scheduling decision.
- **Product decisions blocking it:** `OQ-006` approved identifiers and privacy/discovery limits; richer matching behavior needs feature clarification.
- **Database impact:** Purpose-limited searchable projection/index with abuse limits and no private account-data exposure.
- **UI/PNG design impact:** Search/results, no-result, rate-limit and privacy-safe identity states.
- **Offline/sync impact:** Search requires server reachability; do not treat cached/no-results as a current global lookup.

### SL-28 — Fine-grained notification preferences

- **Priority / suggested order / status:** P1 conditional / 28 / Registered, not specified.
- **PRD requirement IDs:** `FR-029`, `BR-019`, `PERM-001`, `NFR-009`–`NFR-011`, `P1-F006`.
- **Dependencies:** `SL-10`, `SL-20`, `SL-21`; explicit P1 scheduling decision.
- **Product decisions blocking it:** `BR-019` required notice exceptions and supported category/mute policy.
- **Database impact:** Per-category preference data only for approved categories; synchronized server delivery policy where needed.
- **UI/PNG design impact:** Notification-settings controls, permission/mute explanations and bilingual accessibility variants.
- **Offline/sync impact:** Offline preference edits save locally and queue; server delivery uses the last accepted preference until sync succeeds.

### SL-29 — Dedicated archived-habit browsing

- **Priority / suggested order / status:** P1 conditional / 29 / Registered, not specified.
- **PRD requirement IDs:** `FR-030`, `BR-011`, `PERM-001`, `NFR-002`, `P1-F007`.
- **Dependencies:** `SL-07`; explicit P1 scheduling decision.
- **Product decisions blocking it:** None beyond archive-versus-deletion behavior already specified in P0.
- **Database impact:** Indexed local archived-habit query over existing records; no new deletion rule or production table by default.
- **UI/PNG design impact:** Dedicated archive list/detail and preserved-history states.
- **Offline/sync impact:** Browsing works from Isar offline; archive state/revisions reconcile through the existing outbox path.

### SL-30 — Guided onboarding

- **Priority / suggested order / status:** P1 conditional / 30 / Registered, not specified.
- **PRD requirement IDs:** `FR-031`, `NFR-009`–`NFR-011`, `P1-F008`.
- **Dependencies:** `SL-01`, `SL-04`, `SL-06`, `SL-12`, `SL-13`, `SL-16`; explicit P1 scheduling decision.
- **Product decisions blocking it:** Exact onboarding steps and dismissal/re-entry behavior need feature clarification; no new reward mechanic is implied.
- **Database impact:** Minimal local completion/dismissal state if specified; no new server data by default.
- **UI/PNG design impact:** English/Arabic RTL guided introduction to habits, streaks, friends, challenges and Restores, with skip/accessibility states as specified.
- **Offline/sync impact:** Educational content should render from bundled/local resources; no network prerequisite for core habit access.

## Registry control

- `SL-01`–`SL-22` collectively cover the PRD's P0 features. `SL-23`–`SL-30` map one-to-one to the eight conditional P1 features. The initial slice order can change only with dependency, blocker, and traceability updates in this registry and the roadmap.
- `OQ-007` remains a product scope decision for the PRD's Admin role. It has **no invented implementation slice** until the Product Owner defines reporting/moderation behavior and priority.
- A future feature specification must name its registry ID; cite applicable `FR`, `BR`, `NFR`, `PERM`, and `FLOW` IDs; resolve listed blockers; define acceptance criteria, required PNG screens/states, local/remote contracts, privacy tests, and recovery cases. Plans and tasks must cite exact approved PNG paths. Status changes to Specified, Planned, Implementing, or Verified require the constitution's actual evidence, not merely a roadmap update.

## Lean delivery amendment — 2026-10-01

Default Spec Kit artifacts are concise spec.md and plan.md; tasks may be in the plan. Clarification, separate consistency analysis, tasks.md and review are not mandatory stages. Ask only for blocking product decisions and check consistency during planning. Add deeper artifacts only for concrete persistence, sync, ownership, authorization, cross-user, scoring or destructive privacy risks. Reuse approved source material by reference. CodeRabbit is removed from future gates/dependencies/handoffs; historical review facts remain historical.

UI needs an approved PNG/design before implementation. Codex uses it for hierarchy, sections, states, interactions, visual language and RTL, without design exploration. Implementation is functional and reasonably close; final visual polish is a later Product Owner pass. Verify relevant states/interactions, overflow, structural RTL, compact phones, keyboard/insets and accessibility proportionately. No exhaustive screenshot matrix or pixel-perfect gate. Finalize with analyzer, relevant automated tests, useful lightweight runtime checks, implementation guides and project-state updates.
