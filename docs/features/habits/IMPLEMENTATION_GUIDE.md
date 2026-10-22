# Habits implementation guide

## Current boundary — first personal Create Habit vertical slice verified, 2026-10-06

Local Create Habit, remote delivery/reconciliation, deployed Edge Function verification, and Android runtime synchronization are implemented and verified. Real passing evidence exists in both the isolated Windows test harness and against the non-production development Supabase environment and Android emulator. iOS runtime is not verified on device/simulator. SL-03 and SL-04 are NOT complete.

Approved creation/list references remain SL04-UI-001 and REF-002. Existing SL-01 status/error language is used for Pending/Synced/Failed and a small Retry action; no full recovery screen is added. Creation remains private, with Daily/selected ISO weekdays, fixed IANA creation timezone and optional description/category/minutes. Read-only occurrences are now derived by SL-05 Milestone 1 below; check-ins, reminders, deadlines and travel behavior remain deferred.

## SL-05 Milestone 2 — durable local check-in and Today (2026-10-06)

TodayScreen dispatches a dated occurrence through TodayCubit -> CompleteOccurrenceUseCase -> HabitRepositoryImpl. The existing account/write queue admits the action. HabitLocalStore rereads the owned parent inside one Isar transaction, samples admittedAtUtc after queue/transaction delay, and revalidates retained timezone, Daily/ISO weekday schedule, reliable coverage, current date and parent validity. A stale-date tap returns occurrenceUnavailable and refreshes Today; no historical action is written.

The same transaction inserts HabitCheckInLocalEntity and CreateCheckInCommandLocalEntity. The non-replacing unique occurrenceKey (lowercase Habit UUID + scheduled local date), transactional reread and stable command UUID prevent duplicate contributions. A normal duplicate returns alreadyCompleted without another intent. No second confirmation transaction or filesystem commit timestamp exists. Local success requires the transaction to complete; rollback produces no completion or Pending sync. No HTTP is triggered by check-in or Today rendering.

The typed V1 check-in intent freezes account scope, parent/date/key, command UUID/version and request payload containing admission instant/observed local date, retained timezone/schedule and localCreation or legacyObservation coverage evidence. Canonical fields are absent. Commands are retained unchanged for Milestone 3 replay. Create Habit V1 commands, payloads, endpoint and reconciliation remain unchanged; late parent acknowledgement cannot move the check-in date.

Today watches local Habit/check-in changes and reads Habit, completion and command evidence in one coherent database transaction before domain projection. Completed + Pending sync and current completion counts come from that snapshot, never from the action result. Pending parent creation permits local completion. Earlier unresolved actions remain informational Completed/Pending items, outside today's count, and never become Missed merely at midnight. Missed rows have no control. Per-row loading and local storage-error retry are distinct from server rejection; no Review or fabricated Synced state exists. English/Arabic compact and large-text treatment reuse REF-001 and approved SL-01 status/accessibility patterns.

The account-private store now has four typed collections. Upgrade preserves the original two collections, start provenance, IDs, V1 payload bytes and receipts without reset. build.yaml suppression remains limited to Isar-generated parts for those four collections. HabitAccountScope and Auth were not changed.

Verification: the final focused local Habit/interceptor suite passed 68 tests; one opt-in isolated HTTP/PostgreSQL fixture was skipped, and the live Supabase suite was excluded. Thirteen new native Isar cases cover atomic pair commit, injected native uniqueness failure after completion insert/rollback, retry, concurrent taps, restart, A/B/A isolation, database queue delay, retained timezone, stale/pre-coverage/rejected-parent admission, date-boundary retention, legacy provenance, actual two-collection Milestone 1 upgrade and late V1 parent acknowledgement. Bilingual 320px/1.5x text widget tests verify watcher-only completion/counts, Pending sync, per-row loading/local-error retry, no fake Synced and lifecycle refresh/disposal. Closed Cubit results are safe; a configured Dio test proves zero check-in/Today HTTP calls. Analyzer: no issues (6.3s); normal generation, formatting and git diff --check passed.

Android debug APK built and installed. The emulator remained at the Flutter launch screen and UI hierarchy reads failed; authenticated completion/restart smoke is unverified. Scoped logs showed no unhandled exception, Isar error or overflow. No smoke check-in was created; original networking is restored with the app stopped. This does not claim full Android SL-05 verification.

Only Milestones 1–2 are implemented; SL-05 is not complete. No remote check-in delivery/server support, create-habit-v2 enablement/backend, server rejection/Review reconciliation, migration, deployment, package or generic sync infrastructure was added. Milestone 3 owns server integration. No commit or push.

## SL-05 Milestone 1 — local effective start and Today (2026-10-06)

New creation samples UTC inside the admitted serialized write path after timezone validation and queue delay. coverageStartLocalDate, coverageStartObservedAtUtc and coverageStartSource=localCreation persist atomically with Habit + unchanged V1 command. The retained timezone determines the civil date. V1 acknowledgement preserves this evidence; server timestamps never replace it. The observation identifies admission, not an exact filesystem commit timestamp.

Old Habits with all three fields absent receive one atomic, account-private prospective baseline on first upgraded repository observation, with legacyObservation provenance. Original creation remains unknown; dates before coverage produce no occurrences or Missed history. Initialization is idempotent across observation/restart and leaves command bytes/outcomes unchanged. Failed initialization rolls back and surfaces a load error; partial/inconsistent evidence is never silently repaired into fabricated history. No cross-device merging exists.

habit_occurrence_rules.dart takes explicit UTC and derives current due/unchecked rows and at most the immediately previous scheduled civil date per Habit. Identity is Habit UUID + scheduled civil date. Daily/ISO weekdays, retained IANA zones, start coverage and calendar-based DST boundaries apply. Rejected Habit creations are excluded from occurrences. No occurrence or Missed rows are stored; Yesterday is informational and separate from today's due list.

TodayScreen -> TodayCubit -> WatchTodayUseCase / RefreshTodayUseCase -> account repository/store renders local data without HTTP. Local watchers, resume and a screen-owned one-shot civil-boundary timer recompute state; a maximum 60-second interval also rechecks clock changes. Disposal cancels timer/listeners. Loading, storage failure/Retry, no habits/Create Habit, nothing due/Open Habits, unchecked rows and bounded Yesterday/Missed are localized in English/Arabic. Authority: REF-001, SL05-UI-001 and SL05-UI-002. No check-in interaction or Review state is implemented.

Verification: normal Isar/route/localization generation and formatting completed. Analyzer (flutter analyze --no-pub lib): no issues, 8.3s. Focused local Habit + interceptor suite: 54 passed, one opt-in isolated HTTP/PostgreSQL fixture skipped; live Supabase tests excluded. Native Isar checks cover an actual previous-Habit-schema database, IDs/schedules/zones, exact V1 command payload bytes/outcomes, admission sampling, atomic rollback, restart and account separation. V1 endpoint/reconciliation regressions pass. English/Arabic 320px, 1.5x text widget checks pass, including timer/resume refresh and disposal. git diff --check passed.

Android: DEV debug APK built and installed on the existing emulator. Sign-in UI rendered; automated credential entry was unreliable, so authenticated Today/Create smoke behavior is unverified. No smoke Habit was created. Original network settings restored with the app stopped. This is not full Android SL-05 verification.

At the Milestone 1 checkpoint only local projection was implemented; the Milestone 2 checkpoint above supersedes that scope. At that checkpoint no check-in write/action/collection or server support existed. create-habit-v2 is not enabled/deployed; remote Create Habit remains V1. No package, migration, remote modification, deployment, commit or push was performed in this milestone.

## Local success remains local

CreateHabitForm owns controllers/editing. CreateHabitCubit owns validation, timezone capture, local-submit loading/failure/result. CreateHabitUseCase -> HabitRepositoryImpl -> one Isar transaction writes Habit + immutable CreateHabit V1 intent. Only commit produces local success. Network delivery is launched independently after commit and is never awaited by local submission; creation loading ends with the local result. Creating during an existing delivery pass schedules a later finite snapshot.

Isar -> WatchHabitsUseCase -> HabitListCubit -> HabitsScreen remains the only list update path. No command or network result is appended directly to the UI.

## Concrete delivery operation

HabitRepository.deliverPendingHabitCreates() and DeliverPendingHabitCreatesUseCase expose one feature-specific operation returning Either<HabitFailure, Unit>. One in-process pass runs at a time per account repository. It reads a finite snapshot of unresolved CreateHabit intents, stops on authorization/transient/storage trouble and is retriggered after creation, Habits activation/resume or explicit Retry. There is no timer, automatic tight retry, background service, persistent in-flight lock or generic sync framework. Accepted/rejected intents are retained and excluded from subsequent pending reads.

Dio posts `commandId`, `entityId`, `version`, and the decoded immutable stored `payload` to `/functions/v1/create-habit-v1`. Retries do not reconstruct UI input or generate IDs. The named supabaseEdgeDio uses the same configuration factory, timeouts, publishable API key, Auth interceptor and privacy-safe logging as REST Dio, with a `/functions/v1/` base URL. Flutter uses no Supabase database SDK/RPC.

## Account and credential binding

The composition root captures SupabaseRequestCredentials only when AuthState admits the bound protected account and the SDK current session matches and is valid. Credentials contain the captured userId/token/expiry, live only in memory and are neither logged nor persisted. Repository checks account availability and captured identity/expiry before each send. The Auth interceptor rechecks current SDK identity and expiry and either sends the captured token unchanged or rejects; it never replaces A's captured credential with B's token. Ordinary REST requests retain existing request-time token behavior.

HabitAccountScope remains only a concrete account repository/store lifetime binding. It closes before opening the next account and discards stale open completions. Repository close cancels the HTTP request, waits for delivery and admitted writes, then closes Isar. Results arriving after account departure are not applied. Cancellation cannot undo server acceptance; retained unresolved intent allows receipt replay when that account returns. Stores remain account-private application-support paths with relaxedDurability false and inspector false. Existing backup exclusions remain; no application-level encryption or new platform protection claim.

## Edge and private PostgreSQL command

`supabase/functions/create-habit-v1/index.ts` verifies Bearer credentials through the authoritative Supabase Auth `/auth/v1/user` endpoint, derives actor identity, validates the UUID/version/envelope, and executes only private.create_habit_v1 using server-only SUPABASE_DB_URL. Payload ownerId is never trusted. Missing/invalid authorization returns 401, invalid envelope 400, canonical acceptance 200, definitive rejection 422 and infrastructure trouble 503. Error text, payloads and credentials are not exposed.

The migration creates only private.owned_habits (including creation schedule), private.create_habit_receipts and private.create_habit_v1. A NOLOGIN habit_command_executor role can execute only the command, with no table mutations; the trusted server connection assumes it inside its transaction. Client roles have neither private-schema usage, table writes nor function execution. RLS is enabled without public/client policies. The security-definer command fixes an empty search_path and uses qualified relations.

The command verifies actor existence, takes a transaction advisory lock on actor + commandId, and compares the server-constructed JSONB request fingerprint (entityId/version/payload). Identical replay returns the stored result, including original canonical timestamps. Changed command reuse returns commandReused without replacing the original receipt. Entity uniqueness handles different-command collisions, including concurrency. Payload validation, Habit insertion and accepted/rejected receipt commit together. The server alone supplies owner, initial revision 1 and UTC timestamps. Forged extra payload owner fields are rejected.

Server deployment prerequisites (not performed): apply the migration to the target project; configure server-only database connection access for the execution role; deploy create-habit-v1 with explicit handler-owned Auth verification (`--no-verify-jwt` where the platform gateway cannot verify the project's signing-key type). The handler always verifies the Bearer token itself; disabling the optional gateway check does not bypass that check. Configure SUPABASE_URL/SUPABASE_ANON_KEY/SUPABASE_DB_URL only in the proper respective client/server environments. Never put database or service credentials in Flutter.

Implementation follows official Auth verification, direct PostgreSQL connectivity and restricted function guidance:
- https://supabase.com/docs/guides/functions/auth-legacy-jwt
- https://supabase.com/docs/guides/functions/connect-to-postgres
- https://supabase.com/docs/guides/database/functions

## Reconciliation and errors

Accepted responses must correlate commandId/entityId/version/account and contain a structurally valid owned canonical Habit, schedule, revision and UTC timestamps. One Isar transaction rereads the immutable command, writes the canonical Habit evidence + Synced and writes the command outcome/full response. The watcher publishes only after commit. Definitive rejection similarly persists Failed + safe typed reason + retained rejected command outcome. Rejected commands are not blindly replayed.

Timeout/network/429/5xx preserve Pending. Authorization stops the pass and preserves intent. Malformed/uncorrelated responses never acknowledge. Local reconciliation failure returns storage failure and leaves projection and command unresolved. Retry sends the same immutable request and reapplies the recorded canonical result. Command IDs/payloads are never deleted or changed for recovery.

The new nullable outcome field intentionally treats null as unresolved, including commands written before delivery existed. An actual legacy-schema close/reopen test proves IDs/payload remain readable and eligible. Isar returns DateTime in local representation; repository projection converts canonical timestamps back to UTC.

## Verification and reproducible tests

- Generation: build_runner passed; final run Built with build_runner/aot in 34s; wrote 7 outputs. The installed runner reports --delete-conflicting-outputs is removed/ignored. Localization generated normally.
- dart format lib test passed: 129 files, 3 changed in the last pass (0.56s).
- flutter analyze --no-pub lib: No issues found! (ran in 3.2s), exit 0.
- Final isolated runner: 42 Flutter tests (all Habit local/delivery/auth-binding/upgrade/remote cases plus existing interceptor regression tests), All tests passed! Six Deno Edge/HTTP-server tests passed. Real PostgreSQL SQL creation/replay/collision/forged-owner/grant assertions passed.
- Twelve concurrent same-command HTTP requests returned the identical canonical receipt. Native end-to-end test deliberately lost the accepted response, retained Pending, resent the same command ID, and reconciled Synced through real Isar. A separate real Isar transaction fault after Habit put rolls back both projection and acknowledgement and permits same-ID replay.
- Auth verification in the isolated HTTP fixture is a fixed synthetic identity, explicitly not a live Supabase JWT integration test. SQL Auth identities/roles are minimal isolated fixtures. PostgreSQL, the production Edge handler/database execution function, Dio HTTP and Isar are real.
- Existing unrelated core/network/di_test.dart references removed ConnectivityCubit/FeedbackCoordinator and was not migrated. Final focused run includes dio_interceptors_test.dart, not that stale DI test. Unrelated stale Auth tests remain untouched.

Windows reproduction:
`./supabase/tests/run_create_habit_tests.ps1 -PostgresBin '<installed PostgreSQL bin>' -DenoBinary '<installed deno.exe>'`

The runner creates a fresh loopback-only PostgreSQL cluster under ignored build output, starts the isolated HTTP fixture, runs SQL/Deno/Flutter tests and stops its own processes in finally. Ports 55439/56081 must be free. Installed matching Isar native library is used on Windows, not an in-memory persistence fake. HABIT_REMOTE_TEST_URL enables the HTTP integration test; without the fixture that one test is explicitly skipped rather than counted as proof.

build.yaml limits experimental_member_use suppression to combining-builder output for the two production Isar models in the habit_isar target. Isar generates index helpers calling its own experimental APIs. Handwritten code, routes, DI and other generated output receive no exception; no analyzer error or broad lint category is hidden.

## Live verification & non-production environment evidence (2026-10-06)

- **Real Supabase deployment & JWT verification**:
  - `create-habit-v1` deployed on DEV project `mznupbyycstoksaetvtv`.
  - GoTrue authentication produces genuine access tokens verified by the Edge function handler.
  - Security posture: missing token -> 401 `unauthorized`, invalid token -> 401 `unauthorized`, forged root actor -> 400 `invalidRequest`, forged payload owner -> 422 `invalidPayload`.
  - Actor is derived exclusively from verified JWT (`user.id`).
  - Remote PostgreSQL command `private.create_habit_v1` succeeds; identical duplicate replay is idempotent.
- **Android Create -> Pending -> Synced runtime**:
  - Tested on Android 16 (API 36) emulator with native Isar (`libmdbx`) and Impeller rendering backend.
  - Submission atomically commits to Isar as `Pending sync` before network return; UI immediately displays card with pending badge.
  - Asynchronous Dio delivery succeeds; receipt acknowledgement reconciles Isar entity to `Synced` (green checkmark).
- **Offline flow & durability**:
  - Form submitted while network disabled: local commit succeeds as `Pending sync`.
  - App process killed and restarted offline: habit persists as `Pending sync` with retry indicator intact.
  - Network re-enabled: delivery triggered, receipt acknowledged, habit transitioned to `Synced`.
- **Account isolation (User A -> User B -> User A)**:
  - Account-partitioned Isar stores ensure User B cannot access User A's habits upon sign-out.
  - Re-authenticating as User A restores User A's data cleanly without cross-account leakage.
- **Migration history status**:
  - SQL schema applied to database (`private.owned_habits`, `private.create_habit_receipts`, `private.create_habit_v1`, `habit_command_executor`).
  - Migration repair applied: `supabase_migrations.schema_migrations` officially records `version: '202610050001'`, `name: 'create_habit_v1'`.
  - Local and remote migration history agree; future `supabase db push` will treat `202610050001_create_habit_v1` as already applied and will not attempt to reapply it.
- **Skipped test explanation**:
  - Suite reports 42 passed, 1 skipped.
  - Skipped test: `'real HTTP Edge/PostgreSQL receipt replay reconciles real Isar after lost ack'` in `test/habits/habit_remote_integration_test.dart`.
  - Reason: Conditioned on `HABIT_REMOTE_TEST_URL`, provided when `run_create_habit_tests.ps1` runs the local synthetic HTTP/PostgreSQL test harness. Skipped during standalone `flutter test`; live coverage is provided by `live_create_habit_integration_test.dart` and unit coverage by `habit_delivery_test.dart`.
- **Platform limitations**:
  - iOS runtime is NOT verified on physical device or simulator due to Windows host environment.

## Deferred

No generic sync engine/outbox/framework, feed/cursor/tombstones/resnapshot, multi-device sync, Edit/Delete/Pause/Archive, check-ins/streaks/reminders, social/challenges, conflict resolution, background sync or full recovery screen. SL-03 and SL-04 are NOT complete. No commit or push.


Final client checks also prove real local submission ends before HTTP response, reject missing canonical optional-value keys, and clear stale delivery trouble from watcher state once no Pending Habits remain. git diff --check passed, exit 0 (line-ending warnings only).
