# Joint SL-03 / SL-04 plan — Create Habit only

**Date:** 2026-10-05  
**Status:** Planning artifact only; no implementation authorized by this artifact  
**Input:** [SL-03 specification](spec.md), current Product Owner request, [Auth guide](../../docs/features/auth/IMPLEMENTATION_GUIDE.md), [database principles](../../docs/DATABASE.md), [design manifest](../../docs/design/DESIGN_MANIFEST.md)

## Outcome and scope

Create Habit -> atomic local Habit + durable CreateHabit intent -> local list/Pending -> Dio -> create-habit-v1 Edge Function -> PostgreSQL transaction -> canonical response -> atomic local reconciliation -> Synced.

Local commit is the user's successful creation. Network delivery is a separate operation and cannot delay or undo that local success. Isar observation supplies the list; neither CreateHabitCubit nor the screen manually appends to an in-memory list.

This request approves the technical direction and the creation schedule subset: Daily or a nonempty set of selected weekdays; retain an IANA creation timezone, such as Africa/Cairo, unchanged in V1. No occurrence/deadline/streak interpretation is added. OQ-004 remains for later occurrence/check-in work, not a reason to invent deadlines in this command. OQ-009, retention/legal decisions and missing full recovery designs remain deferred.

## Final folders and proposed files

Feature root: `lib/features/habits/`. Only populated responsibility folders are introduced. Isar generated files are generated normally, never handwritten.

| Proposed file | Immediate responsibility / why needed |
| --- | --- |
| `domain/entities/habit.dart` | SDK-free immutable owned Habit projection, including schedule, server revision and sync status, consumed by the local list. |
| `domain/entities/habit_schedule.dart` | Represents only Daily/selected weekdays plus fixed IANA creation timezone without advanced recurrence. |
| `domain/entities/habit_sync_status.dart` | Defines pending/synced/failed for this feature's visible durable state. |
| `domain/failures/habit_failure.dart` | Defines safe typed local/session/delivery/rejection failures without leaking transport exceptions. |
| `domain/repositories/habit_repository.dart` | Defines SDK-free create, watch and attempt-pending-create operations used by the feature. |
| `domain/use_cases/create_habit_use_case.dart` | Forwards validated Create Habit input to the repository and returns local acceptance. |
| `domain/use_cases/watch_habits_use_case.dart` | Supplies the local Habit observation stream to HabitListCubit. |
| `domain/use_cases/deliver_pending_habit_creates_use_case.dart` | Exposes the same narrow delivery operation for post-save, resume and explicit retry without a sync framework. |
| `data/local/habit_local_entity.dart` | Stores the account-owned local Habit projection and durable display outcome. |
| `data/local/create_habit_command_local_entity.dart` | Stores the exact immutable V1 Create Habit request and its retry/acknowledgement evidence. |
| `data/local/habit_local_store.dart` | Owns this account's Isar instance, open/close, atomic write/reconciliation and watcher queries. |
| `data/repositories/habit_repository_impl.dart` | Coordinates the local store, direct Dio request, mapping and Create Habit delivery/recovery. |
| `presentation/cubit/create_habit_cubit.dart` | Owns normalization/validation, local-submit loading/errors and success. |
| `presentation/cubit/create_habit_state.dart` | Holds field errors and local-submit state, separate from delivery status. |
| `presentation/cubit/habit_list_cubit.dart` | Owns the watch subscription and dispatches narrow delivery/retry intents. |
| `presentation/cubit/habit_list_state.dart` | Distinguishes opening/error/empty/content from locally observed Habit sync states. |
| `presentation/screens/create_habit_screen.dart` | Composes the approved form page and owns navigation after local success. |
| `presentation/screens/habits_screen.dart` | Renders the local list and creation entry within the existing shell. |
| `presentation/widgets/create_habit_form.dart` | Owns editing controllers and directly submits to CreateHabitCubit. |
| `app/habit_account_scope.dart` | Mounts the account-bound feature providers and handles serialized disposal/rebinding through injected infrastructure callbacks. |
| `supabase/functions/create-habit-v1/index.ts` | Verifies authorization and invokes only the private Create Habit transaction. |
| `supabase/migrations/<timestamp>_create_habit_v1.sql` | Later introduces only the owned Habit/creation schedule, command receipt and restricted transactional command needed for this proof. |

Generated `habit_local_entity.g.dart` and `create_habit_command_local_entity.g.dart` belong beside their source models. These names describe planned files only; no code, SQL, function or schema is created now.

No remote DataSource/API file is proposed: one explicit Dio call and small private wire/session mapping methods fit in HabitRepositoryImpl. Split a CreateHabitRemoteApi only if actual implementation makes the repository hard to scan; it is not a prerequisite. Keep meaningful screen-only row/status sections in their screen file, not a badge/component framework. No generic command entity, aggregate interface, engine, mapper service or event bus.

Existing integration files to modify later, each for a concrete reason:

- `pubspec.yaml`/lock: matching isar_community/native/generator distribution, UUID generation and supported IANA timezone acquisition/validation after compatibility verification; no dependency solely for abstraction.
- `app/bootstrap/app_bootstrap.dart` and `injection.dart`: constructor-injected account-scope creation/disposal dependencies; normal Injectable regeneration updates injection.config.dart.
- `app/streak_up_app.dart`: mount the account scope from current Auth admission, with no Isar/Dio access in widgets.
- `app/routing/app_routes.dart`: replace only Habits placeholder and add protected Create Habit navigation; regenerate app_routes.g.dart.
- `core/network/network_module.dart`: add a named configured Edge Dio with `/functions/v1` base, timeouts, publishable key and existing privacy-safe logging conventions.
- `core/network/interceptors/supabase_auth_interceptor.dart`: support an explicitly pinned, verified account/token pair for feature requests without overwriting it with a later account's token; preserve ordinary Auth infrastructure behavior.
- localization ARB files: creation, field errors and durable Pending/Synced/Failed/retry strings; regenerate localization normally.
- implementation guide/project state: record actual delivered behavior and evidence after implementation, not before it exists.

## Domain and input

Use `Either<HabitFailure, Habit>` for create: Right means the local commit succeeded, normally with pending status. `watchHabits()` returns local snapshots with typed recoverable stream errors; delivery is a separate domain operation and cannot turn the completed create result into Left.

Habit needs canonical UUID, account identity, name, optional description/category/icon/target where current PRD/reference input applies, HabitSchedule, optional server revision/metadata, sync status and safe last failure information. Isar object keys stay private. Exact optional-target/category constraints must follow product-approved supported inputs; do not invent taxonomy, arbitrary limits or scoring meaning. Private is the default; do not implement shared effects in this owned creation proof. Reminders are excluded, so do not show an active reminder control that promises scheduling.

HabitSchedule represents Daily or unique selected weekdays plus validated IANA timezone. Capture timezone at submission and persist it in both projection and immutable command payload. Never substitute a UTC offset, locale or guessed zone if acquisition fails; preserve form input and explain the failure. Daily needs no second recurrence structure. No monthly/every-X-days/multiple schedules/end dates/time-of-day deadlines/travel migration. This does not calculate occurrences.

CreateHabitCubit normalizes raw input and provides field-level errors; the domain/repository boundary defensively rejects structurally invalid input, with the same straightforward checks rather than a validation framework. Server independently validates the request. Commands cannot contain trusted ownerId.

## Local structures and durability

Use matching isar_community 3.3.2 packages as the recommended starting distribution, pending actual dependency and native-build checks. One account-private directory and uniquely named instance contains the two feature collections. Disable relaxed durability for this store; verify crash/restart behavior rather than relying only on advertised ACID support.

HabitLocalEntity stores stable Habit UUID/account identity, approved creation values/schedule, server evidence if acknowledged, pending/synced/failed and a safe failure reason. CreateHabitCommandLocalEntity stores local internal key, unique command UUID, entity UUID, account identity, fixed create type/version, immutable request payload, attempt count/last attempt/next eligibility, safe last outcome and acknowledgement state. Payload and identifiers must not change on retry. No expected revision is sent for creation: require entity absence. Store all needed replay data, never a reference to editable/disposable form state.

Both writes and pending status commit in ONE transaction. UUIDs are generated once for that submission before the transaction. Watchers notify only after commit. A transaction failure returns storage failure, sends nothing and leaves no partial accepted action. Duplicate button submission is guarded while local commit is active; network delay never holds the submit spinner. Keep acknowledged command evidence for this proof; do not introduce purge/retention policy.

Schema generation is distinct from later versioned semantic migration. Store opening/migration failure must show an error, never an empty list or reset outstanding intent. Product at-rest baseline is app-private storage/platform file protection, backup exclusions and no sensitive logs; secure Auth storage does not encrypt Isar. Android/iOS protection and native compatibility remain verification obligations.

## Account binding and request safety

The composition root injects the callbacks needed to open an account-bound Habit repository and close it; widgets never resolve GetIt or instantiate SDK clients. HabitAccountScope observes existing Auth admission and userId, immediately removes outgoing feature providers, invalidates their lifetime generation and serializes teardown/open. Dispose subscriptions, cancel outstanding HTTP work, finish local transaction ownership safely and close A's instance before exposing B's providers. Async opening must also reject stale completion. No Auth architecture replacement or new session state manager is introduced.

The repository is bound to one immutable account ID/store lifetime. For each send, obtain SDK-free current evidence through the existing Auth domain contract and require matching userId plus valid access. Infrastructure captures matching credentials and supplies a pinned request credential; a default current-token interceptor must not replace A's token with B's. Reject a mismatched/expired snapshot before dispatch. Capturing immutable request credentials prevents the read/check/send race from uploading A's intent under B. Never log that snapshot.

An already dispatched A request may commit after sign-out; cancellation cannot undo it. Its result must not access B, reopen a closed A store or mutate B's UI. Check bound lifetime/account again before applying; retained A intent permits same-ID replay on A's next valid session. Keep account stores on disk across sign-out. Known invalid/recovery/signed-out state cannot start delivery. A same-account token refresh can supply new valid credentials on a later attempt, never by rewriting queued payload ownership.

## Repository and delivery flow

1. `create`: validate eligible account/input; generate entity/command UUIDs; atomically persist Habit/command/pending; return local Right. Form navigates only on local success while mounted.
2. `watchHabits`: map this account's Isar query watcher to immutable domain snapshots; opening/error are distinct from no records.
3. `attemptPendingCreates`: guard one in-process delivery pass per repository lifetime; select eligible unacknowledged creates, preserving readiness/order; mark attempt evidence durably, then send outside any Isar transaction.
4. Accepted response: verify response command/entity/version/account consistency and complete canonical structure; atomically reconcile.
5. Network/timeout/5xx: keep pending and original intent; bounded retry eligibility/backoff/jitter. Avoid a tight loop or waiting for network in create. Resume/feature-active/explicit retry provide later opportunities; no permanent in-flight lock survives restart.
6. Definitive domain rejection: transactionally retain command/reason and mark failed. Surface a safe reason; do not blindly resend a permanent rejection as recovery. Invalid authorization pauses delivery and uses existing Auth reauthentication behavior without erasing intent.

After local save, trigger a delivery attempt independently; HabitListCubit also dispatches the same use case on activation/resume and applicable manual Retry. No connectivity framework, timer service, background guarantee or Realtime dependency. For this narrow plan, transient errors remain Pending/retryable; durable Failed is for definitive rejection or a diagnosed recovery problem. Persistent Pending trouble is visible via its last reason and Retry rather than an invented attempt-count threshold.

## Dio / Edge / PostgreSQL

Dio posts the persisted command to `/functions/v1/create-habit-v1` with commandId/entityId/version/payload, publishable configuration and pinned original-account Bearer credentials. Flutter Supabase SDK remains Auth-only. Map timeouts/network/server errors versus structured domain rejection explicitly in repository private methods; malformed/uncorrelated success is not an acknowledgement.

Edge verifies JWT with the supported Supabase Auth verification mechanism, derives actor, validates envelope and passes verified actor plus request to a private trusted PostgreSQL command. No ownerId from Flutter is authoritative. Edge contains no separate Habit transaction/receipt writes; all acceptance occurs in PostgreSQL.

The private command atomically serializes the actor/command key, compares server-computed request identity, validates approved inputs/entity absence, inserts the owned Habit/creation schedule and records canonical outcome. Concurrent same-ID requests wait/return the same committed result. Different payload/entity/version under the same command ID is rejected without mutation; a different command for an existing entity cannot overwrite it. Definitive valid-envelope rejection can record a stable rejected outcome without creating a Habit. Operational transaction failure must not record successful acceptance.

Canonical response includes command/entity/version correlation, accepted outcome, owned canonical Habit/schedule, initial server-assigned revision and timestamps. Receipt replay returns that committed creation result. PostgreSQL uniqueness and transaction boundaries prevent duplicates, not Edge memory or a read-then-insert race. Deny direct client mutations and receipt fabrication; narrow server execution privileges, explicit actor authorization and owner-only authorized reads remain mandatory even when elevated credentials bypass RLS. No service secrets in Flutter.

Future implementation needs only the private Habit/creation schedule representation, receipt, private command and narrow owner read if actually required; API exposure must not provide bypass routes. No feed/cursor/table inventory for future aggregates is designed here.

## Reconciliation

Accepted canonical Habit plus command acknowledgement/status are written in one local transaction; only this commit changes pending to synced. Local watcher then publishes Synced. No direct network-to-UI update, in-memory append or premature acknowledgement.

If reconciliation fails, the original unacknowledged command and local Habit survive. Show a safe recovery reason where writable; if the store cannot write, retain the previous durable evidence and expose a recoverable storage error. Retry the same command to obtain the receipt and apply again. Do not store a partial acknowledgement or delete intent. Definitive rejection retains locally visible failed projection and original payload. Response reconciliation proves this Create Habit path; multi-device pull/feed/cursor/tombstones/resnapshot are deferred.

## Cubit and UI

CreateHabitScreen composes/navigates; CreateHabitForm owns controllers/editing and calls its feature Cubit directly. CreateHabitCubit owns typed validation, local-save loading and bool/local result semantics. No BlocConsumer/event framework solely for navigation; awaiting local success is sufficient. Transient service notification uses AppNotifier; durable sync errors/status stay beside the Habit. Theme styling comes from AppTheme.

HabitsScreen selects loading/empty/error/content appropriately and builds from HabitListCubit snapshots only. A meaningful private same-file Habit row displays Pending/Synced/Failed with labels/icons and applicable inline reason/Retry. Do not create edit/delete/lifecycle actions. Existing shell remains unchanged except the Habits destination route content.

Approved references: [Create Habit SL04-UI-001](../../docs/design/screens/004-habit-create/SL04-UI-001-create-habit.png), [Habits REF-002](../../docs/design/references/REF-002-habits.png), SL01-UI-001 failure/Review, SL01-UI-002 offline, SL01-UI-003 large text, SL01-UI-004 compact issue and SL01-UI-005 Arabic RTL as registered in the manifest. Reference buttons/controls outside this subset cannot promise excluded behavior. Existing references do not approve unshown local-save/storage-failure/retry states; obtain owning-slice approval before implementing those UI states. Full Sync & Recovery/conflict UI is not required or added by this plan.

## Focused tests to create later

| Proposed test file | One-line responsibility / required scenarios |
| --- | --- |
| `test/habits/create_habit_cubit_test.dart` | Valid submission, field validation, local storage failure, loading and local success independent of delivery. |
| `test/habits/habit_repository_local_test.dart` | Real Isar atomic Habit/intent acceptance, failed transaction rollback, watcher visibility, offline Pending and close/reopen durability. |
| `test/habits/habit_delivery_test.dart` | Dio contract success/Pending retry/definitive Failed, malformed response, lost response, reconciliation rollback and same-ID recovery. |
| `test/habits/habit_account_isolation_test.dart` | A/B store separation, close-before-bind, pinned credential race, stale responses/open completions and A's resumed intent. |
| `test/habits/create_habit_ui_test.dart` | Form/navigation on local commit, watcher-derived immediate Habit, statuses/retry, RTL and relevant large-text/keyboard behavior. |
| `supabase/functions/create-habit-v1/index_test.ts` | JWT/envelope verification, actor derivation and endpoint outcome mapping without trusting payload owner. |
| `supabase/tests/create_habit_v1.sql` | Real database duplicate/concurrent command receipts, changed-payload reuse, entity collision, rejection atomicity and privilege/ownership denial. |

No future-feature tests or stale Auth test migration. A fake server alone cannot prove PostgreSQL idempotency; real isolated-database tests are required. Restart tests reopen the actual local store. Fault-inject the boundary after server acceptance/before local reconciliation. Verify native Android/iOS compatibility and protection when those platforms are available; Windows results cannot claim iOS device evidence.

## Implementation order and exit conditions

| Step | Work | Exit condition |
| --- | --- | --- |
| 1 | Verify matching Isar dependencies/toolchain and Android/iOS native/protection direction. | Resolution/generation compatibility demonstrated without overrides masking incompatibility; native checks and any unavailable platform evidence explicitly recorded. |
| 2 | Domain types and three use cases. | SDK-free contracts express local success, observation and separate delivery; only approved schedule subset exists. |
| 3 | Account-scoped local models/store/lifetime. | Open/close/error handling and serialization proven; B cannot bind before A closes; no database reset on failure. |
| 4 | Atomic local Create Habit. | Valid local commit returns without network; rollback yields no partial success. Include durable command here, not as a later non-atomic retrofit. |
| 5 | Local Habit observation. | Watcher-driven list publishes committed creation/Pending; no manual append. |
| 6 | Complete durable replay evidence/readiness. | Reopen preserves immutable IDs/payload and retry eligibility; step 4 already persists minimum durable intent. |
| 7 | Direct Dio request and credential/error boundary. | Request matches endpoint contract; A payload can never acquire B token; responses are correlated. |
| 8 | Edge/private PostgreSQL command. | Verified actor, atomic acceptance/receipt and real concurrent duplicate/privilege checks pass. |
| 9 | Atomic reconciliation. | Only accepted local reconciliation marks Synced; injected local failure preserves replayability. |
| 10 | Delivery triggers and narrow recovery UI. | Post-save/activation/resume/manual retry share one guarded delivery operation; no network-blocked local success or permanent restart lock. |
| 11 | Complete focused tests/native evidence. | Listed local-first, delivery, reconciliation, isolation and relevant UI cases pass; no future-feature expansion. |
| 12 | Final verification/documentation. | Format, normal DI/Isar/routes/localization generation, analyzer, scoped tests, SQL/Edge checks and diff check pass; guides/state record actual results/limits. |

Write meaningful tests alongside each boundary; step 11 integrates coverage rather than delaying all verification. Keep local-only intermediate implementations from claiming product success until atomic durable intent exists.

## Deferred work and implementation gates

Excluded: Edit/Delete/Archive/Pause, check-ins/streaks/reminders, friends/social/challenges, conflict resolution, generic feed/cursor/tombstones/resnapshot, multi-device synchronization, advanced recurrence/end dates/deadlines/travel migration and full Sync & Recovery UI. This is not full SL-04 or complete offline synchronization.

The current request resolves the schedule subset and transport direction for this proof; OQ-004 need not block creating those schedule facts, but its later deadline rules remain open. Before affected implementation: verify the proposed dependency/native compatibility and obtain approval for unshown creation/recovery UI states. If the required threat model demands application-level DB encryption, approve a supported protection/key-recovery solution before storing real sensitive product data. These are explicit checks/conditional gates, not permission to expand this plan.

No production code, migration, schema/function, Isar collection or package change was made in this task. The existing SL-03 specification is unchanged. No commit or push.

## Local-first Create Habit milestone implemented (2026-10-05)

This latest checkpoint supersedes the earlier planning-only checkpoint for the local milestone. SL-03 and SL-04 are NOT complete. Remote delivery is NOT implemented. Pending means locally committed / awaiting future delivery.

Actual implementation: CreateHabitForm -> CreateHabitCubit -> CreateHabitUseCase -> HabitRepositoryImpl -> one Isar transaction containing HabitLocalEntity + immutable CreateHabitCommandLocalEntity. Local success follows commit; Isar watcher -> WatchHabitsUseCase -> HabitListCubit -> HabitsScreen updates the list without manual append. Daily/selected ISO weekdays and fixed validated IANA creation timezone only; private creation with optional description/category/minutes. No reminders or occurrence/check-in semantics.

Each repository/store has one immutable accountId and its own application-support path/database name. HabitAccountScope is required by the current app composition to bind the repository above typed routes, queue old close before new open and discard stale opening completions. Pending work is retained after close; returning to A restores A data while B sees neither A Habits nor A commands. Repository admission checks the current protected account and drains admitted writes before close. Store-open failure has a small existing-text/button retry action, not a recovery screen. Android Habit file backup/transfer exclusions were added; no DB encryption or Android/iOS device protection is claimed.

Matching isar_community, isar_community_flutter_libs and isar_community_generator 3.3.2 resolved with the current Flutter 3.41.4 / Dart 3.11.1 toolchain, generated and passed production analysis without dependency overrides. Additional direct dependencies are path_provider, uuid, flutter_timezone and timezone for this milestone's immediate storage/identity/timezone responsibilities. Isar runs with relaxedDurability false and inspector false. Generated index-helper experimental_member_use diagnostics are suppressed only in source_gen combining-builder output through build.yaml; handwritten production code has no suppression.

Verification evidence:
- Normal localization generation and build_runner completed. Final build_runner: exit 0, Built with build_runner/aot in 24s; wrote 3 outputs. Installed runner reports --delete-conflicting-outputs was removed/ignored.
- dart format lib test: Formatted 124 files (0 changed) in 0.83 seconds in the final pass. Earlier mandated formatting also formatted four existing Auth test/support files; no unrelated Auth test migration or semantic changes.
- flutter analyze --no-pub lib: No issues found! (ran in 6.5s), exit 0.
- flutter test --no-pub test/habits: 10 tests, All tests passed!, exit 0. Real installed Windows Isar native library used; no network mocks. Atomic commit, second-insert rollback, watcher-to-list-Cubit, actual close/reopen Habit and same commandId/payload, account separation/return-to-A, account rejection, validation/loading/storage failure all passed.
- Android/iOS runtime and UI runtime verification were not performed. Close/reopen is actual store reopening, not a claim of OS process-kill verification.

Implementation details and file responsibilities: docs/features/habits/IMPLEMENTATION_GUIDE.md. Test files are test/habits/create_habit_cubit_test.dart, habit_local_persistence_test.dart and isar_test_storage.dart; persistence/isolation scenarios share one focused suite rather than speculative separate test files. Tiny domain enums and Cubit states remain in their natural files.

Explicitly deferred: Dio Create Habit request, Edge Function, PostgreSQL migration/server receipts, delivery/retries/acknowledgement, Pending -> Synced, reconciliation, feed/cursor, Realtime/background sync and Auth interceptor changes. Existing shared network/Auth code was not refactored. No generic sync/outbox/account framework was introduced. Stop at this milestone for review; next milestone is remote Create Habit only after review. No commit or push.

## First remote Create Habit delivery/reconciliation milestone (2026-10-05)

This checkpoint supersedes local-only status for the CreateHabit delivery path, not the whole SL-03/SL-04 slices. Local atomic success, watcher observation and account-private stores are preserved. Network is outside local-submit loading. One concrete deliverPendingHabitCreates operation uses named Edge Dio and immutable stored IDs/payload; post-create, Habits activation/resume and explicit Retry trigger finite guarded passes. No generic sync infrastructure or background/timer behavior.

Captured credentials are bound to the current protected account and rechecked by the interceptor; it never substitutes another account's token. Repository close cancels delivery, waits for owned work and closes before account rebind. Stale responses do not reconcile into the next account.

Production server artifacts: supabase/functions/create-habit-v1/index.ts and supabase/migrations/202610050001_create_habit_v1.sql. Verified Auth identity is derived server-side; the private restricted PostgreSQL command owns canonical data, revision/timestamps and actor + commandId receipt. Advisory locking serializes concurrent duplicates; JSONB request identity rejects changed reuse; unique entity insertion rejects collisions. Client private-schema/table/function access is denied. No server/database/service credentials enter Flutter.

Accepted correlated canonical data + command outcome + Synced commit in one Isar transaction. Definitive rejection persists Failed with safe reason and retained outcome. Network/5xx/authorization/malformed response/storage failure never erase unresolved intent. Same-ID replay recovers from lost response or failed reconciliation. Nullable outcome preserves commands created before delivery existed; actual native legacy-schema reopen verified. No extra production Isar collection.

Actual evidence: production analyzer No issues found! (ran in 3.2s), exit 0; dart format lib test passed (129 files, 3 changed, 0.56s); build_runner passed (34s, 7 outputs) and localization generated. Final reproducible isolated runner passed 42 Flutter Habit/native-Isar/interceptor tests, 6 Deno handler/HTTP-server tests, and actual PostgreSQL SQL command/permission assertions. Twelve concurrent duplicates returned the same canonical receipt. A real Dio -> production Edge handler/database execution -> isolated PostgreSQL -> native Isar test lost the first accepted response and recovered Synced using the unchanged command ID. A real local transaction fault after Habit write proved reconciliation rollback/replay. Existing local persistence/isolation tests remain green.

Test host Auth verification uses a fixed synthetic actor, and isolated PostgreSQL has minimal Auth role/user fixtures: these are not live Supabase JWT/deployment evidence. No cloud schema/deployment, Android/iOS runtime or UI runtime verification was performed. No unrelated Auth migration. An existing stale core/network/di_test.dart referencing removed FeedbackCoordinator/ConnectivityCubit was encountered and left unchanged; final regression coverage runs the actual interceptor tests only.

build.yaml was narrowed to an Isar-only build target: experimental_member_use applies only to the two production generated model parts, not handwritten code/routes/DI/other generated code. See docs/features/habits/IMPLEMENTATION_GUIDE.md for current contracts, file responsibilities, prerequisites and supabase/tests/run_create_habit_tests.ps1 reproduction. Temporary test processes were stopped by the runner.

Remote acceptance, idempotency and local reconciliation have real passing isolated-runtime evidence; ready for the next separately authorized Habit milestone. SL-03/SL-04 remain incomplete. Feed/cursor, multi-device synchronization, lifecycle changes, check-ins/streaks/reminders, social/challenges, conflict resolution and full Sync & Recovery remain deferred. No commit or push.


Final checks additionally prove nonblocking real local submit and incomplete canonical-response rejection. git diff --check passed, exit 0 (line-ending warnings only).
