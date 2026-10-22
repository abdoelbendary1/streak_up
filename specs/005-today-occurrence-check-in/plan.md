# SL-05 technical plan — Today and occurrence check-in

**Date:** 2026-10-06
**Stage:** Technical plan only; proposed milestones, no implementation/deployment authorization.
**Inputs:** [final specification](spec.md), approved PO-01 Option A/Missed rule and current Product Owner design-gate approval.

## Outcome and inspected reality

Local Habit → Today occurrence → atomic local check-in/evidence + typed intent → Completed/Pending sync → independent Dio delivery → authenticated Edge command → PostgreSQL acceptance/deduplication → atomic local reconciliation → Completed/Synced.

Read current [project state](../../docs/PROJECT_STATE.md), [Habits guide](../../docs/features/habits/IMPLEMENTATION_GUIDE.md), [architecture](../../docs/ARCHITECTURE.md), [database](../../docs/DATABASE.md), [registry](../../docs/FEATURE_REGISTRY.md), [roadmap](../../docs/ROADMAP.md), [SL-03 spec](../003-local-first-write-sync-recovery/spec.md), [joint SL-03/SL-04 plan](../003-local-first-write-sync-recovery/plan.md), and [design manifest](../../docs/design/DESIGN_MANIFEST.md). Inspected Habit/HabitSchedule, repository/use cases, local store/entities, HabitRepositoryImpl, HabitAccountScope, Dio/Auth interceptor, Today route/shell, Create Habit handler/applied migration and test harness. Inspected SL05-UI-001–003 PNGs.

Latest guide/state control implemented ownership: account-private Isar, relaxedDurability false, watcher views, `_writes` admission queue, one finite guarded Create pass, pinned account credentials, cancellation/close-before-rebind, immutable UUID command/payload, private PostgreSQL receipts and atomic reconciliation. Today remains a placeholder. No check-ins exist. Habit createdAt is nullable server metadata; no original local start evidence. Applied `202610050001_create_habit_v1.sql` creates private.owned_habits, private.create_habit_receipts and private.create_habit_v1; revision is constrained to 1. Do not edit that applied migration or invent revision increments for this start fix.

The spec's older design-gap wording is superseded for planning by current PO approval and manifest entries SL05-UI-001–003. This review revises plan.md and only the spec wording needed to distinguish admission time from durable transaction success. Full SL-03/SL-04, feed/background services and iOS runtime are not claimed complete.

## Architecture reused / future file responsibilities

Keep check-ins under `lib/features/habits/` in the same repository/account store. Reuse Either/HabitFailure, Bloc/Cubit, UUID, timezone, injectable/get_it, typed go_router and localization. No generic Result/outbox/command bus, new DataSource, mapper service or recurrence framework.

| Proposed future source | Responsibility |
| --- | --- |
| Existing Habit domain/local models | Nullable start/provenance evidence; preserve creation metadata/sync. |
| `domain/entities/habit_occurrence.dart` | Immutable dated Today projection and Pending/Completed/Missed; sync separate. |
| `domain/entities/habit_check_in.dart` | Local/canonical completion and safe rejection evidence. |
| `domain/habit_occurrence_rules.dart` | Pure schedule/date/start/state rules with explicit UTC now and retained zone. |
| Existing repository contract and `domain/use_cases/habit_use_cases.dart` | Add watchToday, refreshToday, completeOccurrence, deliverPendingCheckIns/use cases using current thin style. |
| `data/local/habit_check_in_local_entity.dart` | One current projection per occurrence key. |
| `data/local/create_check_in_command_local_entity.dart` | Typed CheckIn V1 immutable intent/retained outcome. |
| Existing HabitLocalStore/HabitRepositoryImpl | Transactions, local snapshots, narrow parent sequencing, Dio mapping and account lifetime. Private helpers suffice. |
| `presentation/cubit/today_cubit.dart` | Watch/action/loading/errors, delivery trouble and selected Review evidence; state initially in same file. |
| `presentation/screens/today_screen.dart` | Approved sections and route lifecycle/calendar wakeup; render values/dispatch intent. |
| Existing routes/composition | Replace Today placeholder; route-scoped Cubit from current repository; reuse Create Habit route. |
| `supabase/functions/create-habit-v2/index.ts` | Separate start-evidence creation endpoint; V1 handler stays unchanged. |
| `supabase/functions/create-check-in-v1/index.ts` | Narrow authenticated command using existing verification/execution pattern. |

Later generation updates Isar parts/DI/routes/localizations normally. Extend the existing Isar-only build.yaml target to the two added collection sources/parts; suppression stays generated-output-only. No packages or files listed above are changed now.

## Effective-start solution

### New creations

Add nullable `effectiveStartLocalDate`, start source and UTC origin instant to Habit/HabitLocalEntity. Capture UTC inside the admitted creation write after timezone validation, immediately before preparing Habit/intent; derive Gregorian date in that zone. Do not capture at form opening or before queue delay. Persist evidence with Habit and immutable creation intent atomically; rollback leaves neither.

New intents use version 2 with `startEvidence` (date, observed UTC origin, source `localCreation`). Never rewrite existing V1 command IDs/version/payload. Preserve `/create-habit-v1` and its verified handler/private.create_habit_v1 behavior unchanged for V1 client commands and receipt replay. Add a separate `/create-habit-v2` handler accepting only V2 and invoking private.create_habit_v2. In HabitRepositoryImpl, a small explicit branch on immutable stored command.version chooses V1 or V2 endpoint; an unsupported version fails safely without rewriting intent. No generic API-version resolver. V2 may share the existing receipt namespace/actor-command lock, fingerprinting full version/content so cross-version UUID reuse cannot overwrite a V1 receipt. V1 replay returns its exact original stored receipt; V2 returns canonical Habit plus validated start evidence.

Forward migration adds nullable start date/source/origin to private.owned_habits. V2 validates date/instant mapping, retained zone, not-future origin and schedule, and inserts Habit/start/receipt together. Canonicalize supplied validated start, never server created_at. Client V2 validates start against frozen intent; V1 parser remains compatible and cannot clear newer local start evidence. Keep revision=1 creation metadata.

### Legacy records without original start

Original creation start stays unknown. No created_at/UUID/Isar-order backfill; pending V1 intent and accepted receipt stay byte-for-byte unchanged. Genuine localCreation evidence wins wherever present.

Review-approved narrow compatibility policy: on first upgraded account-private observation of an existing Habit, atomically persist one **prospective coverage start**, source `legacyObservation`, with observed UTC/date in the retained zone. Preserve original creation start as unknown; provenance must never claim `localCreation`. Coverage permits current/future check-ins, never earlier occurrences or Missed history. Do not populate yesterday before it. Preserve the one local observation across restart and V1 acknowledgement, including a legacy parent still pending creation.

CheckIn V1 includes explicit prospective evidence. On first canonical check-in for an owned legacy parent lacking start evidence, the server may establish compatible prospective coverage from validated command evidence in the check-in transaction. Once canonical coverage exists, later commands validate and reconcile against it; they do not lower/merge/replace it with another device baseline. Return canonical coverage/provenance and reconcile it locally without rewriting immutable pending commands. A command incompatible with existing canonical coverage receives a retained definitive outcome for Review, not an invented merge or moved occurrence date. Same-command replay keeps its original receipt.

SL-06 treats earlier dates as unknown, not Missed. No cross-device earliest-baseline merging, feed or conflict framework is planned. New V2 creation always has real localCreation evidence. Existing legacy records remain explicitly prospective; no original date is guessed. Concurrent legacy evidence follows the first canonical establishment under the parent lock, with later outcomes visible rather than a new multi-device policy.

Upgrade adds nullable fields/collections without reset. Open an actual database written by today's schema in tests; preserve IDs, original JSON bytes, outcomes and Pending creates through close/reopen. Legacy baseline initialization is idempotent/account-scoped before actionable Today. Failure is storage error, not empty. Old fixture constructors may omit evidence; start-sensitive fixtures explicitly supply it.

## Minimal local model

Occurrence identity `(lowercase Habit UUID, YYYY-MM-DD)` maps to unambiguous local key `habitUuid/YYYY-MM-DD`. No occurrence UUID, persisted Pending/Missed rows, future generation or counters.

Two collections keep uniqueness simple while retaining failed attempts: one projection per occurrence; commands preserve rejected intent if a later eligible corrected attempt replaces the projection.

| Record | Minimum content/indexes |
| --- | --- |
| HabitCheckInLocalEntity | Account, non-replacing unique occurrenceKey, Habit/date, active command reference, zone/timing evidence, independent pending/synced/failed sync outcome, nullable canonical fact/reason. No Missed flag. |
| CreateCheckInCommandLocalEntity | Unique command UUID, account, Habit/date/key, fixed type/version, frozen request JSON, unresolved/accepted/alreadyCompleted/rejected outcome, canonical receipt/reason. Index unresolved lookup; retain resolved attempts. |

Evidence carries zone, frequency/ISO weekdays, start/provenance/origin, `admittedAtUtc` as recorded completion-admission evidence. Server checks against canonical parent. Normalize UTC in repository mapping (Isar DateTime may be local representation); civil dates remain strings.

## Single-transaction local check-in

Cubit sends Habit/date, never a chosen historical time. Repository uses an injected UTC clock and active-account admission through `_writes`. After queue delay, inside the admitted write path/transaction, reread parent/projection and sample `admittedAtUtc`. Verify parent not definitively rejected, zone/schedule/start, and that this instant maps to requested scheduledLocalDate in the retained Habit timezone. Check no accepted/unresolved completion. A stale Monday row first admitted Tuesday is ineligible.

Existing completion returns already completed without another UUID/progress contribution. A rejected projection permits a fresh corrected attempt only while eligible, retaining the old rejected command. Generate one UUID and atomically persist local evidence plus the final immutable typed command in **one Isar transaction**, with a non-replacing unique occurrence key and transactional reread protecting concurrent taps. The immutable payload records admittedAtUtc, occurrence and schedule/start/zone evidence from the outset; no later confirmation/freeze phase.

`admittedAtUtc` identifies valid action admission, not filesystem/fsync commit time. Durable local success exists only after that transaction completes successfully. Only then may local observation show Completed + Pending sync, the action return success and independent network work start. Rollback or a crash before transaction completion produces no committed action; crash after successful commit but before UI/network leaves the durable pair available on restart. No second transaction, admission-awaiting-confirmation state or fabricated exact commit timestamp.

Eligibility is determined at admission after queue delay. A validly admitted action whose transaction successfully finishes across the date boundary retains its original occurrence date; a new next-day admission cannot backdate. This clarifies local transaction semantics without reopening PO-01: the action must succeed durably before local success/network, and late server arrival never shifts its admitted occurrence. Watcher drives UI; Cubit does not append rows.

## Today projection and Flutter flow

WatchTodayUseCase → HabitRepositoryImpl → HabitLocalStore returns immutable local snapshots. Use database-local invalidation/watch and read Habit plus check-in/intent data together in an Isar read transaction; do not combine watcher values into mixed pre/post-commit snapshots. Map private fields in the repository and invoke pure rules with explicit UTC now. No server request to render.

Per Habit: now's date in retained zone, start/coverage comparison, Daily/ISO weekday match, merged durably committed unresolved/accepted fact. Current due without valid completion is Pending; valid local unresolved/accepted is Completed; ended scheduled date without either is Missed. Rejection is recovery evidence, not completion. Keep completed rows and provisional sync; count once. Stable name/UUID order avoids jumping after tap. Distinguish no habits/nothing due/nonempty all-complete.

SL05-UI-001 supports a bounded Yesterday section: derive only preceding civil date per Habit timezone, scheduled on/after known start/coverage, and show Missed without completion control. No history scan; exclude Yesterday from current denominator. Keep older unresolved/rejected actions discoverable as attention items, not carried-over due rows. Current-day rejection projects uncompleted + Review; ended rejection Missed + Review. Legacy dates before coverage never become Missed.

Refresh on initial local load/change, launch/resume, visible calendar boundary and clock change. One route-owned cancellable one-shot timer wakes refreshToday at earliest next civil date among known zones; compute calendar next date, not add 24 hours. Recompute/rearm after refresh; bound sleep by a modest local reevaluation interval (e.g. 60 seconds) to catch wall-clock changes while visible. Resume rechecks immediately. Dispose on route/account exit. Timer invalidates projection only, never writes Missed or polls sync; admission independently rechecks time.

TodayCubit owns watch subscription, immutable loading/content/error state, per-key action loading/errors, delivery trouble and selected Review evidence. Small use cases use existing repository dispatch style. Screen owns lifecycle/timer/composition; rules stay outside widgets. Review uses compact inline reason/date/action under the approved card, not a full recovery destination. Retry resends original unresolved transport/reconciliation intent. Definitive rejection offers Review and only an eligible correctable current-day fresh action; unchanged rejected intent is not replayed. No new edit/auth resolution screen.

## Delivery / parent dependency / account isolation

Add deliverPendingCheckIns as one finite delivery opportunity: await existing guarded Create delivery, then reread durably committed unresolved check-ins. Require parent canonical Create acceptance before sending. Pending parent leaves completion Pending sync; definitively rejected parent atomically marks dependent evidence Failed/Review without sending. Temporary remote parent absence is not definitive invalidity. Date never shifts with parent acknowledgement.

One shared repository HTTP lane/cancel slot prevents two loops overwriting `_requestCancellation` or racing close. Keep Create-only public operation; private create-pass/check-in-pass helpers avoid nested self-await. Check-in operation runs create helper first. Join/coalesce existing passes; writes during snapshot request one later pass. No generic delivery coordinator/dependency scheduler, timer/backoff loop or background service; keep private create/check-in passes in the repository unless concrete implementation size later justifies extraction. Other accepted parents may proceed past a definitive parent failure; auth/transient/storage trouble ends the pass safely.

After the successful local transaction schedule delivery independently; completion result does not await HTTP. Today activation/resume and explicit Retry provide opportunities. Before each request capture valid original-account credentials through current readCredentials and pinned Auth interceptor. Stop on mismatched/expired actor or closed lifetime; never substitute B token for A work.

A check-in uses A's existing account-private database path. B cannot observe/upload/reconcile it. Close cancels/drains shared lane and admitted writes before store closes/rebind. Stale A result is not applied to B or closed A scope; A returning replays retained intent. Preserve HabitAccountScope/Auth ownership; no redesign. Route-scoped Cubit is disposed with outgoing account presentation.

## Edge contract and server idempotency

Plan POST `/functions/v1/create-check-in-v1`: commandId, version 1, habitId, scheduledLocalDate, payload. Payload freezes admittedAtUtc and schedule/start/zone evidence; no exact commit/fsync timestamp. No client owner/account accepted. Derive actor using the same authoritative Auth `/auth/v1/user` verification as Create Habit, never unverified decoded claims. Use existing configured Edge Dio/pinned interceptor/redacted logging; no Supabase Flutter database calls or extra DataSource.

Handler validates recognized keys/UUID/real date/version and invokes private.create_check_in_v1 with server-only connection/execution role. Missing/invalid auth 401; invalid envelope 400 (not canonical rejection); infrastructure/Auth service outage 503; canonical accepted/alreadyCompleted 200; correlated durable domain rejection 422. No credentials/payload/database exception disclosure.

Conceptual PostgreSQL changes, no SQL created:

- private.habit_check_ins: owner + Habit + civil date unique/primary key; parent linkage, retained zone/start/schedule evidence, recorded admittedAtUtc, accepting command and server acceptedAt. No occurrence UUID/counters/points. Command checks ownership; foreign key alone is insufficient.
- private.check_in_receipts: `(actor_id, command_id)` primary key, server-constructed full fingerprint (type/version/key/payload), exact canonical outcome. Typed separate receipt table; no generalized outbox.
- Transaction verifies actor, takes actor-command advisory lock, reads receipt first: identical request returns exact original; changed reuse returns commandReused without replacing receipt.
- Then lock canonical parent, verify owner/schedule/zone/start/date. Verify admittedAtUtc maps to target date in retained timezone; validate consistent recorded evidence, actual Gregorian date, non-future admission and weekday/start eligibility against canonical parent. Do not require an invented fsync timestamp. Client evidence is never authorization.
- An owned legacy parent with no canonical start evidence may establish validated prospective coverage under parent lock on its first canonical check-in. Once present, later commands reconcile against that coverage; no earliest-baseline merge/replacement. Never overwrite known localCreation start. Initial coverage establishment, completion and receipt commit together.
- Canonical uniqueness `(owner_id, habit_id, scheduled_local_date)` protects different-command concurrency. Conflict returns alreadyCompleted with authorized existing fact and stores this attempt's receipt. Consistent lock order; no Edge-memory-only locks.
- Definitive domain rejection stores reason/receipt without completion; genuine transient/auth/database trouble does not commit a rejection receipt.

PO-01: no upload-age cutoff; Tuesday receipt cannot move valid Monday completion. Server acceptedAt is metadata, not occurrence date. Offline timing is internally consistent client evidence with the approved non-cryptographic limitation; no anti-fraud or challenge finalization. Retain uniqueness/replay evidence for arbitrarily late requests; no purge policy introduced.

## Reconciliation / failure handling

Before acknowledgement validate full correlated actor/command/version/Habit/date/key/outcome/reason, canonical date/zone/schedule/start/timing and ownership. AlreadyCompleted corresponds to this attempt's receipt but canonical accepted command/time may be another original attempt: do not falsely demand both command IDs match.

One Isar transaction rereads frozen stored command/account and active projection. Accepted/alreadyCompleted writes one canonical fact, returned start evidence as applicable, Synced and full receipt/outcome together. Rejected writes Failed/reason/outcome and removes only that attempt's provisional contribution; retain evidence and any accepted completion. Stale earlier rejection cannot override newer active/canonical fact. Watcher publishes after commit.

Malformed/account-mismatched response never acknowledges. Local apply failure rolls back fact/status/receipt, leaves unresolved and recovers by same-ID replay after remote acceptance. Timeout/429/5xx/network/auth interruption stays Pending sync with safe trouble/Retry/reauthentication. Definitive rejection stays Failed/Review; no blind retry or retry-count Failed threshold. Eligible corrected current-day attempt can use a new command only with no accepted/unresolved completion; retain rejected attempt. After date end derive Missed only without accepted or unresolved valid completion.

## UI / exact approved design mapping

| State | Repository-root approved PNG |
| --- | --- |
| Normal / unchecked / Completed / Pending sync / Synced | `docs/design/references/REF-001-today.png` |
| Bounded Yesterday / Missed | `docs/design/screens/005-today-check-in/SL05-UI-001-today-missed.png` |
| No habits / reused nothing-due panel | `docs/design/screens/005-today-check-in/SL05-UI-002-today-empty.png` |
| Definitive failure / unaccepted completion / Review | `docs/design/screens/005-today-check-in/SL05-UI-003-checkin-review.png` |
| Offline / local save | `docs/design/screens/001-bilingual-shell-feedback/SL01-UI-002-offline-en.png` |
| RTL | `docs/design/screens/001-bilingual-shell-feedback/SL01-UI-005-today-rtl-ar.png` |
| Large text | `docs/design/screens/001-bilingual-shell-feedback/SL01-UI-003-large-text-en.png` |
| Compact issue / failed treatment | `docs/design/screens/001-bilingual-shell-feedback/SL01-UI-004-sync-issue-compact-en.png`, `docs/design/screens/001-bilingual-shell-feedback/SL01-UI-001-sync-failed-review-en.png` |

Current gate is approved; no exhaustive PNG matrix. Nothing-due reuses approved panel with factual localized copy, not no-habits claim/new flow. All-complete reuses existing progress/status; Review remains compact feature-owned evidence/action, not an invented recovery screen. Verify English/Arabic RTL, accessible status labels, touch targets, reduced motion, compact/large text and reading order proportionately.

No fabricated streaks/history checkmarks/reminders/deadlines/unsupported glass targets, overflow edit actions or promotional detail destinations. Date heading is orientation, not a universal date for mixed zones; use existing supporting text for differing row dates. Reuse approved structure without implementing unapproved behavior.


### Design asset verification — 2026-10-06 technical review

Verified the exact three SL-05 files in the table exist, are nonempty, and DESIGN_MANIFEST.md registers their exact paths as APPROVED: SL05-UI-001-today-missed.png, SL05-UI-002-today-empty.png and SL05-UI-003-checkin-review.png. No registration gate remains for these references. No design assets or manifest entries changed or fabricated in this review.
## Migration / rollout boundaries

Future forward migration A adds nullable start-evidence columns/constraints and private.create_habit_v2 with restricted execution. Keep existing V1 function, records and receipts intact; no guessed backfill/reset/purge. Leave the verified create-habit-v1 endpoint/handler unchanged. Deploy the separate create-habit-v2 endpoint only after database V2 support exists. Old clients and pending V1 commands keep V1; new V2 creation is enabled only after its separate endpoint is verified. Unsupported version does not justify changing stored V2 into V1; retain Pending and gate rollout.

Future forward migration B adds canonical check-in facts/typed receipts/private.create_check_in_v1, concurrency uniqueness and grants. RLS on new tables; deny public/anon/authenticated/service_role/executor direct mutations. Fixed empty search_path, qualified names and narrow function execution for existing NOLOGIN habit_command_executor. Trusted server connection assumes role. Audit permission differences and test denials independently of success.

Local upgrade expands same account database with nullable Habit evidence and two collections; preserve V1 payload bytes, outcomes and account paths. Normal generation updates parts/build target. No Auth migration or destructive reset. Future separately authorized environment order: migration A (V2 function/start columns) → separate create-habit-v2 deployment and verification → migration B → create-check-in-v1 deployment and verification → client V2/check-in enablement. Rebuild clean and upgrade from existing applied migration; exercise existing create-habit-v1 unchanged before/after V2 rollout, including old clients, pending replay and lost acknowledgements. A queued V2 command stays V2 if its endpoint is unavailable; never downgrade or rewrite it. No migrations/Edge/Supabase operations executed now.

## Focused test strategy

| Boundary | Meaningful planned evidence |
| --- | --- |
| Pure date rules | Daily/selected weekdays; true start/prospective coverage; today/yesterday per retained zone; 23/25-hour DST, travel/mixed dates; Missed excludes valid unresolved local completion. |
| Native local transaction | Atomic rollback between fact/intent writes, non-replacing uniqueness, double/concurrent tap, corrected attempt retaining failed evidence, queue delay/stale date, admittedAtUtc sampled after queue delay, rejection of next-day stale admission, valid admission with successful transaction crossing midnight, crash before commit versus restart after commit, no network before valid durable success. |
| Upgrade/restart | Actual old-schema database opens new fields/collections; V1 UUID/payload/receipt unchanged; legacy original start unknown/baseline persists; durably committed Pending survives close/reopen offline. |
| Repository/Cubit/UI | Watcher-only progress, coherent snapshot, local result before HTTP, loading/storage vs empty, no habits/nothing due/all complete, Review vs Retry, Yesterday excluded from Today count, RTL/compact/large text/semantic labels. |
| Parent delivery/account | Offline create+complete, parent acceptance before child send, lost parent response, rejected parent Review, finite snapshot/new work, cancel lane draining, no A→B credential substitution or stale apply; A→B→A restoration. |
| Actual PostgreSQL | Upgrade baseline/clean replay, unchanged V1 receipts, separate V1/V2 endpoint routing and V2 start validation, concurrent same command and different command/same occurrence, changed payload reuse, wrong owner/parent/schedule/date/start/zone/timing, one prospective legacy coverage establishment and later validation/reconciliation without merging, constraints/grants/RLS denials; no streak/score writes. |
| Edge/Auth contract | Injected handler tests and actual HTTP fixture: forged actor/owner, envelope failures, invalid token, verification outage. Later real DEV GoTrue JWT validation must be recorded separately from synthetic fixture evidence. |
| Isolated vertical path | Existing pattern: loopback PostgreSQL + production handler + Dio + native Isar, discard accepted response then replay, fault after local canonical put proving rollback/recovery, Monday record/Tuesday delivery under PO-01. |
| Android actual environment | Later authorized DEV migration/deployment; real JWT; Completed/Pending→Synced, offline force stop/reopen, late upload/date boundary, duplicates, definitive Review and A→B→A. Preserve platform compatibility; no iOS runtime claim on Windows. |

Reuse successful `supabase/tests/run_create_habit_tests.ps1` fixture/runner pattern and Habit native storage helpers; extend focused suites, not a generic platform. Later run normal generators, analyzer/relevant tests and whitespace/document links per milestone, retaining Create/interceptor regressions. Broaden auth/shared checks when those sources actually change. Unrelated stale DI/Auth test references recorded in the guide are baseline issues, not permission to rewrite Auth. No unimplemented SL-05 test is run or claimed passing in this plan-only task.

## Proposed implementation milestones — not tasks.md

| Milestone | Small reviewable scope | Exit evidence |
| --- | --- | --- |
| 1 — Effective-start compatibility + pure/local Today projection | Real local V2 start capture/immutable intent; one prospective legacy coverage observation; nullable model/schema compatibility; pure rules and coherent local projection/watch. No server implementation or Today UI construction in this milestone. | Native old-schema upgrade preserves V1 payloads/receipts; true-start/prospective provenance and unknown earlier dates verified; offline schedule/date/Missed projection passes with no future/Missed rows. V2 endpoint unavailable is explicit Pending, never fallback to V1. |
| 2 — Single-transaction durable local check-in + UI | Two typed collections, one atomic admission/evidence/intent transaction, uniqueness, Today route/Cubit/approved normal/empty/Yesterday/Review UI, calendar lifecycle refresh. | Native rollback/restart/double tap and queue/midnight admission tests pass; local success only after commit and before network; approved UI/RTL/accessibility checks. No second confirmation phase or remote acceptance claim. |
| 3 — V2 Create backend compatibility + check-in remote delivery/reconciliation | Separate create-habit-v2 handler/private.create_habit_v2; preserve V1 endpoint unchanged; check-in server artifacts in isolated harness; one repository HTTP lane, parent-first passes and atomic apply. | Actual PostgreSQL constraints/permissions, separate endpoint routing and unchanged V1 replay, Edge concurrency, PO-01 late upload, canonical prospective legacy coverage, parent order, lost acknowledgement and local rollback/replay pass. No implicit cloud changes. |
| 4 — Real DEV + Android/offline/account validation | Separately approved forward migrations/new V2/check-in endpoints on DEV; real JWT and Android offline/restart/date/account path; later final guide/state evidence update. | Migration history agrees; V1 compatibility and real JWT/denial evidence; Android Pending→Synced, late completion, Review and A→B→A pass; platform limits recorded. No iOS runtime claim. |

Each milestone requires implementation authorization separately; this plan executes none and creates no tasks.md. Milestone 1 keeps pure/local projection separate from Milestone 2's UI and single-transaction check-in; backend compatibility belongs to Milestone 3, with rollout only in separately authorized Milestone 4.

## Risks / compatibility notes / scope guard

- Legacy prospective coverage is not original creation history. Preserve provenance; SL-06 cannot interpret earlier unknown dates as Missed. Once canonical prospective coverage exists, incompatible later legacy evidence is retained for Review and reconciled against it, without earliest-baseline merge or a multi-device conflict policy/feed.
- admittedAtUtc establishes on-day eligibility; successful single-transaction completion establishes durable local success. Do not fabricate fsync timing, add confirmation states or invalidate an admitted action just because its successful transaction finishes after midnight. Test queue delay and crash/rollback boundaries.
- Current one cancel slot cannot safely host independent HTTP loops. One repository lane avoids overwriting cancellation; private helpers avoid nested self-await/deadlock. Regression-test Create callers and account close.
- V1 payloads/receipts remain immutable. New start evidence requires versioned intents and backend-first compatibility. Never edit applied SQL/history or original accepted timestamps.
- Flutter/PostgreSQL timezone data may differ: validate date/zone consistently, preserve key and show mismatch safely. Client-observed time remains the approved non-cryptographic evidence; no anti-fraud infrastructure.
- No SL-06 streak/history, Restore, reminders, Habit edit/pause/archive, friends/challenges/leaderboards, feed/cursor, generic sync/outbox engine, automatic travel migration, advanced recurrence or background synchronization. Future consumers receive stable dated facts only.

## Files changed now

Only `specs/005-today-occurrence-check-in/plan.md` revised and `specs/005-today-occurrence-check-in/spec.md` minimally clarified for admission versus durable success. No production code, tasks.md, migration file/execution, generated code, Edge deployment, Supabase modification, package change, commit or push. Existing working-tree edits preserved.
