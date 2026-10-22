# StreakUp Project State

## Current checkpoint — SL-05 Milestone 2 (2026-10-06)

Milestone 1 is accepted. Local check-in now commits one completion and one immutable typed V1 intent in a single account-private Isar transaction, with current-date/schedule/coverage admission and non-replacing occurrence uniqueness. Duplicate requests return alreadyCompleted. Today uses a coherent local watcher snapshot for Completed + Pending sync, progress and earlier unresolved attention items; no list mutation is fabricated by Cubit. Offline/restart, local rollback/retry, stale-date rejection and A/B/A isolation pass.

Verification: final focused local Habit/interceptor suite: 68 passed; one isolated remote fixture skipped, live Supabase tests excluded. Thirteen new native cases include actual Milestone 1 schema upgrade preserving Habit/start/V1 bytes/outcomes, atomic rollback, concurrent calls, database queue delay, legacy provenance and late V1 parent acknowledgement preserving check-in date. English/Arabic compact/large-text UI, watcher-only counts, local retry, lifecycle and closed-Cubit tests pass. Analyzer clean (6.3s); normal generation/format and git diff --check pass. Android debug APK built/installed, but launch-screen/UI-automation failure prevented authenticated local completion/restart smoke; no Android completion claim is made.

No remote check-in delivery or server support exists; Pending sync is durable unresolved local state. Create Habit remote delivery remains V1. create-habit-v2 is not enabled/deployed. Milestone 3 owns server integration; Milestones 3–4 are deferred and SL-05 is not complete. No migration, Edge function, deployment, package, generic sync infrastructure, commit or push in this milestone. See [Habits implementation guide](features/habits/IMPLEMENTATION_GUIDE.md).

## Accepted Milestone 1 checkpoint (2026-10-06)

Local effective-start evidence and read-only Today are implemented. New Habit creation atomically persists Habit-local coverage date, observed UTC admission and localCreation provenance. Legacy Habits receive durable prospective legacyObservation coverage; earlier history remains unknown. Remote Create Habit remains V1 with unchanged command payload/version/endpoint; acknowledgement preserves coverage.

Today derives local Daily/selected-weekday unchecked rows and bounded Yesterday/Missed in each retained IANA timezone, with English/Arabic no-habits/nothing-due/load-error UI and local watcher/resume/calendar refresh. Rendering needs no HTTP. No occurrence/Missed rows or check-in writes/actions/collections/server support exist. create-habit-v2 is not enabled/deployed. SL-05 is not complete; Milestones 2–4 remain deferred.

Verification: actual previous-schema Isar upgrade, atomic rollback, admission sampling, restart/account separation, DST rules and V1 delivery/reconciliation pass. Focused local Habit/interceptor suite: 54 passed, one isolated remote-fixture test skipped; live Supabase suite excluded. Bilingual compact/large-text widgets and timer/resume/disposal checks pass. Analyzer: no issues (8.3s); generation, formatting and git diff --check pass. Android APK built/installed and sign-in UI rendered, but unreliable emulator input blocked authenticated Today/Create smoke; no smoke Habit was created and network settings were restored. Full Android validation remains Milestone 4.

No package, migration, remote modification, deployment, commit or push in this milestone. See [Habits implementation guide](features/habits/IMPLEMENTATION_GUIDE.md). Checkpoints below remain historical.

**Updated:** 2026-10-06
**Branch:** reimplement/sl01-sl02
**Current work:** SL-05 Milestone 2 implemented; local review gate verified
**Planning + implementation agent:** Codex
**Foundation status:** Ready for SL-03; automated foundation checks and Create Habit vertical slice passed
**Next gate:** Product Owner review of SL-05 Milestone 2; Milestones 3–4 await authorization
**Design gate:** Existing SL-01 and eight active SL-02 references approved; UI-008 retired

## Current delivery foundation

Use Understand + Specify ط·آ£ط¢آ¢ط£آ¢أ¢â€ڑآ¬ط¢آ ط£آ¢أ¢â€ڑآ¬أ¢â€‍آ¢ Design Reference (if UI exists) ط·آ£ط¢آ¢ط£آ¢أ¢â€ڑآ¬ط¢آ ط£آ¢أ¢â€ڑآ¬أ¢â€‍آ¢ Plan ط·آ£ط¢آ¢ط£آ¢أ¢â€ڑآ¬ط¢آ ط£آ¢أ¢â€ڑآ¬أ¢â€‍آ¢ Implement + Test ط·آ£ط¢آ¢ط£آ¢أ¢â€ڑآ¬ط¢آ ط£آ¢أ¢â€ڑآ¬أ¢â€‍آ¢ Finalize. Spec Kit remains lightweight with concise spec.md and plan.md, optional tasks/deeper artifacts when justified, and consistency checking during planning. Design approval remains required; functional UI reasonably close to approved references is the implementation target, with final polish in a later Product Owner pass. No mandatory separate clarification/analysis/review, CodeRabbit gate or exhaustive screenshot matrix.

## Actual implementation

SL-01 retains four primary tabs, global Inbox/Profile and contextual recovery routing, theme/localization, RTL and accessibility primitives. Shell uses presentation/cubit/screens/widgets; GoRouter owns location and ShellCubit owns locale presentation. Global feedback owns temporary Flutter snackbars only; features own inline errors/retry. Connectivity has unknown/online/offline/reconnecting reachability and no sync state or action registry. No real reachability adapter exists yet, so startup remains unknown. Simple Pending/Synced/Failed widgets accept feature-owned values.

SL-02 is implemented: email/password sign-in/registration, verification, generic recovery initiation, PKCE callback validation, isolated recovery/reset, restoration, valid-session admission, serialized transitions, stale-event rejection, protected routes and account cleanup. Flow: screen ط·آ£ط¢آ¢ط£آ¢أ¢â€ڑآ¬ط¢آ ط£آ¢أ¢â€ڑآ¬أ¢â€‍آ¢ AuthCubit ط·آ£ط¢آ¢ط£آ¢أ¢â€ڑآ¬ط¢آ ط£آ¢أ¢â€ڑآ¬أ¢â€‍آ¢ AuthSession ط·آ£ط¢آ¢ط£آ¢أ¢â€ڑآ¬ط¢آ ط£آ¢أ¢â€ڑآ¬أ¢â€‍آ¢ AuthRepository ط·آ£ط¢آ¢ط£آ¢أ¢â€ڑآ¬ط¢آ ط£آ¢أ¢â€ڑآ¬أ¢â€‍آ¢ AuthRepositoryImpl ط·آ£ط¢آ¢ط£آ¢أ¢â€ڑآ¬ط¢آ ط£آ¢أ¢â€ڑآ¬أ¢â€‍آ¢ SupabaseAuthDataSource ط·آ£ط¢آ¢ط£آ¢أ¢â€ڑآ¬ط¢آ ط£آ¢أ¢â€ڑآ¬أ¢â€‍آ¢ SDK. SecureAuthStorage persists auth/PKCE only. Cleanup revokes access first, clears outgoing presentation, preserves device reachability and precedes SDK exit. The 2026-09-30 one-account decision remains: no dedicated switch flow; A must sign out before B signs in. Pending/unknown-work warning remains conservative because no product inventory exists yet.

Read [shell implementation guide](features/shell/IMPLEMENTATION_GUIDE.md) and [auth implementation guide](features/auth/IMPLEMENTATION_GUIDE.md) for actual files, ownership, modification guidance and limits. Current feature plans/spec amendments reconcile removed global-registry ownership; historical task descriptions remain historical.

## Verification baseline and current evidence

Before production changes: flutter analyze --no-pub passed with no issues (4.2s). Full baseline flutter test --no-pub --concurrency=1 passed: 230 tests, 1 opt-in live Supabase test skipped (68s). Default concurrent Windows runner attempts stalled without reported assertion failures; serial execution completed. Existing working-tree edits were present and preserved; no alternate worktree, commit or push.

After auth restructuring: 143 focused SDK/session/callback/password-reset tests passed. After shared-system cleanup: 47 focused shell/account-cleanup/auth-safety tests passed. Final flutter analyze --no-pub: no issues (5.3s). Final flutter test --no-pub --concurrency=1 --reporter compact: 229 passed, 1 opt-in live test skipped (54s), exit 0. git diff --check passed, and current-document local Markdown links are valid. The two former global-status registry cases were replaced with four reachability/feature-owned status cases, and a global-route/account-reset snackbar regression was added; auth behavior coverage was retained. A final test attempt hit a full C: system temp drive; the successful complete run used a task-local F: TEMP/TMP directory, removed after the run. No user/system cleanup was performed. DI/routes/localizations are generated through their normal tools; no generated files are hand-edited.

## Feature code quality refactor verification (2026-10-04)

The Foundation Reset decisions and all pre-existing working-tree edits were preserved on reimplement/sl01-sl02. Baseline before this refactor: flutter analyze --no-pub found no issues (4.6s); flutter test --no-pub --concurrency=1 --reporter compact passed 229 tests, with one opt-in live test skipped (57s).

Screens now compose static headers and meaningful forms/action sections. AuthCubit owns normalization, typed presentation validation and completion state; its session snapshot is read-only. AuthSession state has named lifecycle constructors in its own file, integer generations and explicit account-scope checks. signOut() means confirmed consent; cancellation dispatches no command. Callback history is capped at 32 entries without evicting pending exchanges. The data source owns persistence/health barriers and private SDK dependencies; email-only operations do not rewrite sessions. The installed Supabase Flutter 2.17.2 unawaited persistence listener justifies retaining the single explicit SDK-format session write. Bootstrap orchestration moved out of main.dart. Destinations own scrolling/insets; top actions use IconButton. Intrinsic bottom-nav columns remain because equal Expanded columns broke the measured enlarged English label case at 320px.

Final analyzer: no issues (23.1s), exit 0. Final full suite: 236 passed, one live integration skipped (57s), exit 0. Two obsolete unconfirmed-signOut API tests were replaced by a real modal-warning cancellation regression; new coverage verifies input normalization/error separation, application invariants, observable recovery/completion state, bounded callback bursts, startup ordering/disposal and email-only persistence behavior. Existing auth safety and bilingual/compact shell regressions pass. git diff --check and local documentation links passed. No generated-source changes required regeneration.

Lightweight Android evidence: the debug APK built and installed on the existing emulator. After the interrupted debugger connection, manual relaunch displayed restoration and then the guarded Session expired screen; no uncaught application exceptions or layout overflow were observed in the scoped process logs. This checks a safe terminal startup outcome, not successful live sign-in, authenticated tabs, callback delivery or secure-storage restart guarantees. Device state was retained. No SL-03, migrations, iOS verification, commit or push.

Task-local F: TEMP/TMP avoided the nearly full C: temp drive. Temporary scripts/compiler files/logs were removed after checks; system/user files were not cleaned.

## Final feature-code foundation review (2026-10-04)

Reviewed the current screens/forms, Cubit, session flows/state/generations, persistence ownership, shell, bootstrap and controlling guidance. Three narrow corrections: verification/reset/reauthentication exit callbacks dispatch signOut without awaiting or interpreting results; recovery form uses its supplied raw-input callback for both button and keyboard submission; the shared email syntax predicate lives in domain/auth_email_rules.dart, while presentation error mapping and application invariant enforcement remain independent. Auth guide and engineering guidelines identify the final owners. No broad refactor, UI redesign, SL-03, commit or push.

Final flutter analyze --no-pub: no issues (4.3s), exit 0. Final flutter test --no-pub --concurrency=1 --reporter compact: 239 passed, one opt-in live integration skipped (110s), exit 0. Added coverage for supplied recovery-form callbacks and success/failure routing after reauthentication exit. git diff --check, changed-Dart whitespace and controlling-document links passed. Existing foundation changes were preserved; temporary review files were removed. Foundation is ready for SL-03 planning; release evidence remains separately outstanding.

## Final infrastructure simplification (2026-10-04)

Completed final infrastructure simplification on branch `reimplement/sl01-sl02`:
- **External tools at the data boundary**: Supabase Flutter package is used strictly for Auth responsibilities (session restoration, sign in/up/out, password recovery, PKCE). Dio is configured with interceptors for all feature data / CRUD operations over Supabase REST (`/rest/v1/...`). Supabase database SDK (`from()`, `rpc()`, `storage`, `realtime`) is strictly avoided for feature data.
- **Removed custom auth callback machinery**: Retired `AuthStartup`, `AndroidAuthCallbackChannel`, and `AuthCallbackHandler` in favor of standard Supabase Flutter auth & deep link handling. Standard Android and iOS URL scheme configurations are preserved.
- **Generated Injectable DI**: Replaced manual GetIt registration in bootstrap with generated `injectable` + `get_it` dependency injection. Presentation and application state ownership remain unaffected.
- **Network infrastructure**: Added `SupabaseAuthInterceptor` (request-time token injection), `ApiLoggingInterceptor` (development request/response logging with strict privacy and path redaction), and `ApiErrorInterceptor` (minimal transport failure mapping).
- **Core security & account safety**: `AuthSession` retains authoritative account ownership, state serialization, stale-event rejection, recovery isolation, and account reset cleanup.
- **Simplified Configuration**: `SupabaseConfig` simplified to static constants (`url`, `publishableKey`, `authRedirectUrl`) with validation.

## Release evidence and future work

Foundation review does not claim release readiness. Real Supabase email/redirect configuration and live auth, real Android/iOS cold/warm callbacks, restart/secure-storage and hardware accessibility checks remain outstanding release evidence. Historical SL-02 T035/T036 release reconciliation is not claimed complete. Existing automated SDK/form/layout coverage is retained; final visual polish remains a Product Owner pass. No iOS verification on Windows or unrelated remote migrations were run.

No production product schema/migration, Isar collection, outbox or SL-03 sync engine exists. DATABASE.md preserves approved data rules; future persistence features define aligned contracts only when introducing actual data. Retained future work must stay scoped to its original account and reopen only after same-account confirmation. Locale persistence belongs to SL-11. Other slices remain registered/not specified; this task does not implement or authorize SL-03.

## Historical disposition

SL-01 previously converged with 24 tests and a recorded CodeRabbit review. Those are historical facts, not the current test count or a future prerequisite. The original [simplification audit](refactoring/SL01_SL02_SIMPLIFICATION_AUDIT.md) is preserved unchanged. Earlier generated research/data-model/contracts/task logs can be consulted for a concrete historical question, but current owners are described by the implementation guides and amended plans.

## Approved design references

The Product Owner approved these exact paths, registered in [DESIGN_MANIFEST.md](design/DESIGN_MANIFEST.md):

- `docs/design/identity/VID-001-visual-identity.png` ط·آ£ط¢آ¢ط£آ¢أ¢â‚¬ع‘ط¢آ¬ط£آ¢أ¢â€ڑآ¬أ¢â‚¬إ’ visual identity.
- `docs/design/identity/LOGO.png` ط·آ£ط¢آ¢ط£آ¢أ¢â‚¬ع‘ط¢آ¬ط£آ¢أ¢â€ڑآ¬أ¢â‚¬إ’ primary logo.
- `docs/design/identity/APP Icon.png` ط·آ£ط¢آ¢ط£آ¢أ¢â‚¬ع‘ط¢آ¬ط£آ¢أ¢â€ڑآ¬أ¢â‚¬إ’ app icon.
- `docs/design/references/REF-001-today.png` ط·آ£ط¢آ¢ط£آ¢أ¢â‚¬ع‘ط¢آ¬ط£آ¢أ¢â€ڑآ¬أ¢â‚¬إ’ Today and primary shell reference.
- `docs/design/references/REF-002-habits.png` ط·آ£ط¢آ¢ط£آ¢أ¢â‚¬ع‘ط¢آ¬ط£آ¢أ¢â€ڑآ¬أ¢â‚¬إ’ Habits main screen.
- `docs/design/references/REF-003-challenges.png` ط·آ£ط¢آ¢ط£آ¢أ¢â‚¬ع‘ط¢آ¬ط£آ¢أ¢â€ڑآ¬أ¢â‚¬إ’ Challenges main screen.
- `docs/design/references/REF-004-friends.png` ط·آ£ط¢آ¢ط£آ¢أ¢â‚¬ع‘ط¢آ¬ط£آ¢أ¢â€ڑآ¬أ¢â‚¬إ’ Friends main screen.
- `docs/design/screens/001-bilingual-shell-feedback/SL01-UI-001-sync-failed-review-en.png` ط·آ£ط¢آ¢ط£آ¢أ¢â‚¬ع‘ط¢آ¬ط£آ¢أ¢â€ڑآ¬أ¢â‚¬إ’ failed sync banner and Review entry.
- `docs/design/screens/001-bilingual-shell-feedback/SL01-UI-002-offline-en.png` ط·آ£ط¢آ¢ط£آ¢أ¢â‚¬ع‘ط¢آ¬ط£آ¢أ¢â€ڑآ¬أ¢â‚¬إ’ offline banner and locally saved action status.
- `docs/design/screens/001-bilingual-shell-feedback/SL01-UI-003-large-text-en.png` ط·آ£ط¢آ¢ط£آ¢أ¢â‚¬ع‘ط¢آ¬ط£آ¢أ¢â€ڑآ¬أ¢â‚¬إ’ large-text shell layout.
- `docs/design/screens/001-bilingual-shell-feedback/SL01-UI-004-sync-issue-compact-en.png` ط·آ£ط¢آ¢ط£آ¢أ¢â‚¬ع‘ط¢آ¬ط£آ¢أ¢â€ڑآ¬أ¢â‚¬إ’ compact sync issue banner and Review entry.
- `docs/design/screens/001-bilingual-shell-feedback/SL01-UI-005-today-rtl-ar.png` ط·آ£ط¢آ¢ط£آ¢أ¢â‚¬ع‘ط¢آ¬ط£آ¢أ¢â€ڑآ¬أ¢â‚¬إ’ Arabic RTL shell.
- `docs/design/screens/002-account-access-session-isolation/SL02-UI-001-sign-in.png` ط·آ£ط¢آ¢ط£آ¢أ¢â‚¬ع‘ط¢آ¬ط£آ¢أ¢â€ڑآ¬أ¢â‚¬إ’ Sign In.
- `docs/design/screens/002-account-access-session-isolation/SL02-UI-002-registration.png` ط·آ£ط¢آ¢ط£آ¢أ¢â‚¬ع‘ط¢آ¬ط£آ¢أ¢â€ڑآ¬أ¢â‚¬إ’ Registration.
- `docs/design/screens/002-account-access-session-isolation/SL02-UI-003-email-verification.png` ط·آ£ط¢آ¢ط£آ¢أ¢â‚¬ع‘ط¢آ¬ط£آ¢أ¢â€ڑآ¬أ¢â‚¬إ’ Email Verification.
- `docs/design/screens/002-account-access-session-isolation/SL02-UI-004-password-recovery.png` ط·آ£ط¢آ¢ط£آ¢أ¢â‚¬ع‘ط¢آ¬ط£آ¢أ¢â€ڑآ¬أ¢â‚¬إ’ Password Recovery.
- `docs/design/screens/002-account-access-session-isolation/SL02-UI-004B-password-recovery-email-sent.png` ط·آ£ط¢آ¢ط£آ¢أ¢â‚¬ع‘ط¢آ¬ط£آ¢أ¢â€ڑآ¬أ¢â‚¬إ’ Password Recovery Email Sent.
- `docs/design/screens/002-account-access-session-isolation/SL02-UI-005-session-restoring.png` ط·آ£ط¢آ¢ط£آ¢أ¢â‚¬ع‘ط¢آ¬ط£آ¢أ¢â€ڑآ¬أ¢â‚¬إ’ Session Restoring.
- `docs/design/screens/002-account-access-session-isolation/SL02-UI-006-session-expired.png` ط·آ£ط¢آ¢ط£آ¢أ¢â‚¬ع‘ط¢آ¬ط£آ¢أ¢â€ڑآ¬أ¢â‚¬إ’ Session Expired / Reauthentication.
- `docs/design/screens/002-account-access-session-isolation/SL02-UI-007-sign-out-unsynced-warning.png` ط·آ£ط¢آ¢ط£آ¢أ¢â‚¬ع‘ط¢آ¬ط£آ¢أ¢â€ڑآ¬أ¢â‚¬إ’ Sign Out with Unsynced Work Warning.
**Retired historical design (excluded from active references):** `docs/design/screens/002-account-access-session-isolation/SL02-UI-008-switch-account-unsynced-warning.png` ط·آ£ط¢آ¢ط£آ¢أ¢â‚¬ع‘ط¢آ¬ط£آ¢أ¢â€ڑآ¬أ¢â‚¬إ’ retired 2026-09-30; PNG retained.
- `docs/design/screens/004-habit-create/SL04-UI-001-create-habit.png` ط·آ£ط¢آ¢ط£آ¢أ¢â‚¬ع‘ط¢آ¬ط£آ¢أ¢â€ڑآ¬أ¢â‚¬إ’ Create Habit visual reference for later SL-04 planning only.

`docs/design/screens/001-bilingual-shell-feedback/today-en.png` and `docs/design/references/REF-001-streakup-master.png` are byte-identical aliases of `REF-001-today.png`.


## Authority

For behavior use PRD and approved feature specifications. For engineering use Constitution v2.0.0, architecture/database foundations and current plans. For UI use approved feature PNGs, closest approved reference, design-system/brand tokens and UI/UX foundation. Approved governance changes do not change unrelated product/privacy/correctness rules. The roadmap/registry remains the delivery order; foundation review grants no unapproved feature scope.

## Final app foundation simplification (2026-10-04)

Branch reimplement/sl01-sl02 and all existing Foundation working-tree changes were preserved. The supplied verified baseline was analyzer clean, 239 passing tests and one opt-in live test skipped. Initial local verification stalled under the sandbox's SDK cache access; final verification used the installed SDK with cache access.

main.dart is only the Flutter entry point. app/bootstrap/app_bootstrap.dart configures dependencies, constructs the platform callback source and acquires the cold callback before resolving lazy AuthSession/Auth dependencies, then composes AuthStartup and StreakUpApp. AuthStartup owns callback subscription/validation-handler invocation, safe failure presentation, callback-before-restoration ordering, start-once behavior and disposal. AndroidAuthCallbackChannel is only platform transport. SupabaseConfig lives in app/config/supabase_config.dart with existing dart-define keys, redirect configuration and security validation preserved.

injection.dart explicitly registers constructor-injected dependencies in GetIt and owns inline shell/feedback account cleanup. Injectable, its generator/config module and configuration bridge globals are removed. The initialized SDK's SecureAuthStorage instance is retained so the SDK and data source share its persistence barrier and fail-closed latch across composition resets. core/logging/AppLogger is concrete, sink-based and privacy-safe without test-only retained entries; AppBlocObserver records lifecycle/change/error types.

Typed routes directly construct feature presentation or Shell-owned FeaturePlaceholder/ProfilePlaceholder. FeatureRouteHosts and its builders/providers are removed. ShellDestination lives under features/shell/presentation/models with labels/icons and no spec-code/path fields. The test-only unguarded router is in test/support/test_app.dart; production AppRouter requires AuthSession and retains synchronous redirects and prior-account stack replacement. StreakUpApp requires AuthCubit/AuthStartup/router and composes providers, MaterialApp, theme, localization and minimal lifetime hooks. AppTokens is removed; AppColors/AppSpacing/AppRadii/AppTypography/AppTheme each have one canonical responsibility. Placeholder copy is localized without runtime spec identity; approved color/radius/layout values and Profile warning behavior remain intact.

Normal build_runner and gen-l10n generation completed. dart format lib test and the final formatting check passed (95 files, zero remaining changes). flutter analyze --no-pub: No issues found (9.6s). flutter test --no-pub --concurrency=1 --reporter compact: 242 passed, one opt-in live integration test skipped (72s). The obsolete logger-buffer test was removed; new regressions cover channel disposal, startup transport errors, lazy DI/account UI cleanup and production root startup/unmount. Account isolation, protected-content hiding, recovery, localization/RTL, accessibility, destination scrolling and logger redaction regressions pass. git diff --check and current guidance links pass. No SL-03 implementation, UI redesign, commit or push; no live integration/device/iOS verification is claimed.


## Complete UI / presentation readability pass (2026-10-05)

Current-tree audit completed on `reimplement/sl01-sl02`, preserving all existing working-tree work. No commit, push, backend/data refactor, unit-test execution or test-source update was performed.

At entry, screens/forms were already split, forms already called AuthCubit directly, the sign-out sheet returned a boolean and screen-specific private sections existed. Legacy feedback/status UI and fake connectivity were already absent. The notification migration remained incomplete: information/completion state and manual Cubit clearing methods still existed. Every current UI file was reopened, including already modified files.

Final ownership: screens compose/navigation; forms own controllers, visibility and direct submit actions; Cubit validates and owns loading/state/repository calls; AppNotifier only displays transient notifications; AppTheme owns common styling. One root AuthNotificationListener survives route changes and shows new failures. Shared localization is in auth_messages.dart. Resend confirmations use awaited results; recovery/reset retain awaited success navigation, with reset callback/router consistently returning to sign-in. Validation stays inline. No event framework, notification state manager or local-state Cubit was added.

AuthPageScaffold names its content locally, owns one scroll view and relies on Scaffold for keyboard resizing. Verification uses AuthPageHeader and same-file badge/actions; Recovery Sent selects loading only inside Send Again; Session Expired retains meaningful private sections; Restoring uses theme styles without Bloc builders. The sign-out sheet has a readable local content column, private handle/artwork and only returns true/false.

AppTheme owns common outlined-button styling and its destructive color override, subtitle/prompt typography, input icon colors and toast colors through ColorScheme. Existing input, filled/text-button and card themes remain authoritative. Approved design, RTL, spacing and responsive intent are preserved in source. Profile now has one scroll viewport for its card and action; ordinary placeholder routes own scrolling around the shared card. AppShell stays chrome/content/navigation; GlobalRouteShell stays separate. Protected-content rendering selects only canAccessProtected. ShellTopBar stays simple. Bottom navigation's Table/IntrinsicColumnWidth, compact handling, large text, RTL, selected semantics and touch targets were preserved; no new runtime verification is claimed.

Removed this pass: AuthInfoMessageKey, AuthSubmission, infoMessage, infoMessageKey, completedSubmission and their copyWith clearing flags; AuthInfoMessageLocalization; AuthCubit.showFailure, clearFailure, clearInfo, clearInputErrors and _showInfo; SignInScreen.initialEmail, SignInForm.initialEmail, AuthTextField.hintText; unused AuthState.account, AuthState.signedOut and AuthInputErrors.first. Internal failure/input clearing remains command-owned. clearVerificationEmail now serves outgoing-account cleanup. No files were deleted this pass. The only new production file is lib/features/auth/presentation/widgets/auth_messages.dart. Implementation guides were updated to the current tree.

Final lib search contains no retired feedback/connectivity, AuthTypography, completionRevision, AuthSubmission, emailOverride, sign-out action callbacks or speculative shared state/action-sync UI. SDK/Flutter contract overrides were retained.

### Full presentation/theme inventory

All 37 files at entry were read; the new localization file was also inspected (38 final files). Auth and Shell are the only current feature presentation trees. App composition/routing/bootstrap were additionally inspected for integration.

- `lib/app/theme/app_colors.dart`
- `lib/app/theme/app_radii.dart`
- `lib/app/theme/app_spacing.dart`
- `lib/app/theme/app_theme.dart`
- `lib/app/theme/app_typography.dart`
- `lib/core/presentation/app_notifier.dart`
- `lib/core/presentation/widgets/streak_up_wordmark.dart`
- `lib/features/auth/presentation/cubit/auth_cubit.dart`
- `lib/features/auth/presentation/cubit/auth_state.dart`
- `lib/features/auth/presentation/screens/email_verification_screen.dart`
- `lib/features/auth/presentation/screens/password_recovery_screen.dart`
- `lib/features/auth/presentation/screens/password_recovery_sent_screen.dart`
- `lib/features/auth/presentation/screens/password_reset_screen.dart`
- `lib/features/auth/presentation/screens/registration_screen.dart`
- `lib/features/auth/presentation/screens/session_expired_screen.dart`
- `lib/features/auth/presentation/screens/session_restoring_screen.dart`
- `lib/features/auth/presentation/screens/sign_in_screen.dart`
- `lib/features/auth/presentation/sheets/sign_out_warning_sheet.dart`
- `lib/features/auth/presentation/validation/auth_input_validator.dart`
- `lib/features/auth/presentation/widgets/auth_buttons.dart`
- `lib/features/auth/presentation/widgets/auth_illustrations.dart`
- `lib/features/auth/presentation/widgets/auth_messages.dart`
- `lib/features/auth/presentation/widgets/auth_notification_listener.dart`
- `lib/features/auth/presentation/widgets/auth_page_header.dart`
- `lib/features/auth/presentation/widgets/auth_page_scaffold.dart`
- `lib/features/auth/presentation/widgets/auth_text_field.dart`
- `lib/features/auth/presentation/widgets/password_recovery_form.dart`
- `lib/features/auth/presentation/widgets/password_reset_form.dart`
- `lib/features/auth/presentation/widgets/registration_form.dart`
- `lib/features/auth/presentation/widgets/sign_in_form.dart`
- `lib/features/shell/presentation/cubit/shell_cubit.dart`
- `lib/features/shell/presentation/global_route_shell.dart`
- `lib/features/shell/presentation/models/shell_destination.dart`
- `lib/features/shell/presentation/screens/app_shell.dart`
- `lib/features/shell/presentation/widgets/feature_placeholder.dart`
- `lib/features/shell/presentation/widgets/profile_placeholder.dart`
- `lib/features/shell/presentation/widgets/shell_bottom_navigation.dart`
- `lib/features/shell/presentation/widgets/shell_top_bar.dart`

### Final verification

- dart format lib: passed, 62 files (one changed in final pass).
- dart run build_runner build --delete-conflicting-outputs: passed, exit 0, 3 outputs in 11s. Installed build_runner warns that the removed --delete-conflicting-outputs option is ignored. Outputs were generated normally.
- flutter analyze --no-pub: exit 1, 211 diagnostics, all in test/, 0 in lib/ (9.6s). Test references include removed feedback/connectivity and retired Auth APIs plus other previous-refactor APIs. This task forbids expanding into test updates; tests remain untouched.
- flutter analyze --no-pub lib: No issues found, exit 0 (5.0s).
- git diff --check: passed, exit 0; line-ending normalization warnings only. Untracked presentation/theme source also has no trailing whitespace.
- Unit tests and runtime/platform/screenshot checks were not run. Source preservation does not establish live visual/auth/release behavior.

The sandboxed Flutter launcher stalled on installed SDK cache access; approved SDK/package-cache access completed verification. No SDK installation or user/system cleanup occurred.

The UI pass is complete. Repository-wide analyzer readiness is NO until stale test sources are migrated in a separately authorized task. Production source is analyzer-clean; obsolete compatibility UI was not restored.

## Complete Auth architecture compliance pass (2026-10-05)

A strict Auth architecture compliance pass was executed on `reimplement/sl01-sl02` to address production architecture violations below the UI layer without changing the approved UI or starting test migrations.

### Architecture violations found and addressed
1. **AuthCubit injected AuthRepository directly**: Bypassed the Use Case boundary. Refactored so that `AuthCubit` depends strictly on 10 dedicated Use Cases (`RestoreSessionUseCase`, `SignInUseCase`, `RegisterUseCase`, `RequestPasswordRecoveryUseCase`, `ResendVerificationEmailUseCase`, `CheckVerificationUseCase`, `SubmitNewPasswordUseCase`, `SignOutUseCase`, `WatchAuthEventsUseCase`, `GetCurrentSessionUseCase`).
2. **Generic SDK executors in DataSource**: `SupabaseAuthDataSource` contained generic execution wrappers `_sdkOperation` and `_sessionOperation`, hiding SDK calls behind generic higher-order functions. Both were completely removed; all public DataSource methods now execute direct Supabase SDK calls with local try/catch and storage synchronization.
3. **Domain layer used models instead of entities**: `lib/features/auth/domain/models/` was completely removed. Replaced by `lib/features/auth/domain/entities/` containing `AuthUser`, `AuthSession`, `AuthRegistration`, `AuthFailure`, and `AuthEvent`.
4. **DTO/SDK mapping layer**: Created `lib/features/auth/data/models/auth_mapping_extensions.dart` with simple Dart extensions (`SupabaseUserX.toEntity()`, `SupabaseSessionX.toEntity()`, `SupabaseAuthResponseX.toRegistrationEntity()`) avoiding any dedicated mapper classes.

### AuthCubit result flow
Every public async Auth command in `AuthCubit` consumes a domain `Either<AuthFailure, T>` result exclusively through `result.fold(...)`:
- `restore()`: calls `_restoreSessionUseCase()`, handles left (reauthenticationRequired, network failure, or signedOut) and right (signedOut, authenticated, or verificationRequired).
- `signIn(...)`: calls `_signInUseCase(...)`, handles left (verificationStillPending or failure) and right (authenticated or verificationRequired).
- `register(...)`: calls `_registerUseCase(...)`, handles left (failure) and right (authenticated or verificationRequired).
- `requestPasswordRecovery(...)`: calls `_requestPasswordRecoveryUseCase(...)`, handles left (failure) and right (recoveryEmail set).
- `resendPasswordRecovery()`: delegates to `requestPasswordRecovery(state.recoveryEmail)`.
- `resendVerificationEmail()`: calls `_resendVerificationEmailUseCase(...)`, handles left (failure) and right (clears failure).
- `checkVerification()`: calls `_checkVerificationUseCase()`, handles left (failure) and right (authenticated or verificationRequired).
- `submitNewPassword(...)`: calls `_submitNewPasswordUseCase(...)`, handles left (failure) and right (signedOut and recovery cleared).
- `signOut()`: calls `_signOutUseCase()`, handles left and right (both ensure immediate and persistent signedOut state).

### Search audit summary
- `_sdkOperation`: 0 occurrences in `lib/`.
- `AuthResult`, `AuthSuccess`, `AuthSubmission`: 0 occurrences in `lib/`.
- `Mapper`: 0 occurrences in `lib/`.
- `domain/models`: 0 occurrences in `lib/` (directory deleted).
- `DTO`: 0 classes in `lib/` (only Tooltip substrings).
- `AuthResponse`, `SupabaseClient`, SDK `Session`: Restricted strictly to data/network layer (`supabase_auth_data_source.dart`, `auth_mapping_extensions.dart`, `auth_repository_impl.dart`, and network module).
- `result.fold`: Used across all async command completions in `AuthCubit`.

### Verification
- `dart format lib`: Passed, all files formatted.
- `dart run build_runner build`: Succeeded in 27s with 17 outputs written.
- `flutter analyze --no-pub lib`: Passed with **No issues found!** (0 errors/warnings).
- **Git**: Working tree changes preserved; no commit; no push.


## Auth domain-contract / state-transition follow-up (2026-10-05)

Continued the current architecture compliance pass on reimplement/sl01-sl02 with no test migration, broad refactor, commit or push. Cubit أ¢â€ â€™ Use Cases أ¢â€ â€™ Repository أ¢â€ â€™ DataSource, Either<AuthFailure, T>, fold and direct SDK calls are preserved.

Production usage audit found no callers of AuthSession.account or AuthRegistration.account. Both aliases were removed. AuthUser had no independent consumer: only unused mapping/computed getters produced it. It was removed, along with AuthSession.user. AuthRegistration contained only an optional session and unused user/account getters, so it was removed. Repository.register, AuthRepositoryImpl.register and RegisterUseCase.call now return Either<AuthFailure, AuthSession?>. AuthCubit.register consumes the optional session directly instead of reg.session in its verified branch and both session assignments; null registration evidence clears prior session state. AuthState.toString now labels its existing identity field userId rather than account. Session id/email consumers need no forwarding aliases; AuthSession is the only entity, with id, nullable email, emailVerified, accessTokenValid and value equality.

AuthFailure moved from domain/entities to domain/failures. AuthEvent/AuthEventKind remain meaningful repository/Cubit lifecycle events and moved to domain/events. All consuming production imports were updated; auth_entities.dart exports only AuthSession. Mapping moved from data/models/auth_mapping_extensions.dart to data/extensions/supabase_auth_extensions.dart. Only SDK Session mapping is retained. SDK User identity contributes session id/email directly, preserving nullable email. AuthResponse.session is extracted by repository _evidence. Unused SupabaseUserX and SupabaseAuthResponseX mapping extensions were removed. No mapper or DTO classes were introduced.

SignOut source review: initial SecureAuthStorage.checkHealth can fail before SDK logout. Installed GoTrue 2.27.2 clears its in-memory session before awaited PKCE removal, notification and server sign-out; subsequent DataSource PKCE/persisted-session/health steps can fail too. Local logout is therefore not guaranteed for every repository Left. Cubit captures the prior state and enters signingOut/loading; SDK events during this command are ignored because an SDK signedOut event is not proof that awaited cleanup/server work succeeded. On failure with a surviving SDK-backed session, the prior stable status and local session are preserved with loading false, the failure and return false. On failure without a local session, status becomes reauthenticationRequired, session is cleared, failure retained, loading false and return false. Success becomes signedOut, clears session/failure/outgoing input and email state, loading false, return true.

Restore now owns loading for its command and every completed branch exits restoring/loading. No session: signedOut, session/failure cleared, true. Valid verified: authenticated, returned session retained, failure cleared, true. Valid unverified: verificationRequired, returned session retained, failure cleared, true. Known recovery remains recoveryRequired. InvalidSession failure or invalid successful session evidence: reauthenticationRequired, session cleared, invalidSession failure, false. Network with local evidence: retain local session, authenticated if verified or verificationRequired otherwise, network failure, false; known recovery or confirmed reauthentication restrictions remain restricted. AccessTokenValid is never fabricated, and protected-content checks remain unchanged. Network without local evidence and other failures: signedOut, session cleared, reported failure retained, false. All settled branches have isSubmitting false.

Final requested verification only: dart format lib passed (77 files, zero changed in final pass, 0.27s); flutter analyze --no-pub lib passed with No issues found, exit 0 (3.6s). Initial analyzer's unused entity import was removed before the final successful run. No tests, generators or repository-wide analyzer were run. Final production search for AuthenticatedAccount, .account, domain/models, data/models, _sdkOperation, _sessionOperation, AuthResult, AuthSuccess and AuthSubmission has no matches; removed AuthUser/AuthRegistration also have no production references. Source is ready for separately authorized test migration; existing stale test diagnostics were left untouched.


## Final Auth identifier / token-expiry semantic checks (2026-10-05)

Only the two accepted semantic issues were changed; architecture, folders, Either/fold, sign-out/restore transitions, UI behavior and tests are unchanged. No commit or push.

AuthSession.id came from SDK Session.user.id. It is now userId with no id alias. Changed domain constructor/equality/hash, SDK mapping, Cubit stale-user comparison, app account-change comparison, state diagnostics, repository password-update identity capture and the DataSource's expectedUserId argument. SDK User.id is a legitimate SDK API and remains unchanged. Final production searches find no session.id variants or AuthSession id constructor arguments.

The previous accessTokenValid field cached accessToken.isNotEmpty && expiresAt != null && !isExpired at mapping time. Installed GoTrue 2.27.2 Session.expiresAt reads JWT exp as epoch seconds. Its actual Constants.expiryMargin is thirty seconds; the isExpired documentation comment incorrectly says ten. Retryable refresh failures retain SDK session evidence, publish failures and do not reliably replace AuthState.session. A currentSession read only remaps for its caller; failed restore/check-verification does not guarantee a fresh session projection. The previous true boolean could remain stale after token expiry.

AuthSession now stores nullable UTC expiresAt evidence, populated only when a nonempty token has known expiry; no token is retained in the domain. accessTokenValid is computed as expiry != null and now + thirty seconds < expiry on each read. Missing/empty token evidence denies access. The same entity mapped at 09:00 for a 10:00 expiry returns false at 10:05 with no successful refresh. Equality/hash use stable user/expiry evidence, not time-dependent validity, making refreshed expiry observable without unstable state equality.

AuthState.canAccessProtected and the router's access checks already read this getter and now evaluate current time. No timer, coordinator, polling, UI changes or expiry-triggered emission was introduced. Time alone does not force an existing screen to rebuild; navigation/redirect and existing state/widget evaluations use the current result. Sign-out and restore transitions were not changed.

Final requested verification: dart format lib passed, 77 files, zero changes in final pass (0.28s); flutter analyze --no-pub lib passed, No issues found, exit 0 (3.3s). No tests were run or migrated. Production Auth is ready for separately authorized test migration.


## Auth Supabase data-boundary simplification (2026-10-05)

Previous flow: UI/Form -> AuthCubit -> UseCase -> AuthRepository/AuthRepositoryImpl -> SupabaseAuthDataSource -> Supabase SDK.

Final flow: UI/Form -> AuthCubit -> UseCase -> AuthRepository -> SupabaseAuthRepository -> Supabase SDK. Constructor-injected SupabaseClient, SecureAuthStorage and AppLogger now go directly to SupabaseAuthRepository, registered as AuthRepository through regenerated Injectable DI. No DataSource registration, generic operation executor or replacement wrapper remains.

Removed lib/features/auth/data/datasources/supabase_auth_data_source.dart and lib/features/auth/data/extensions/supabase_auth_extensions.dart and their empty directories. Replaced lib/features/auth/data/repositories/auth_repository_impl.dart with supabase_auth_repository.dart. SecureAuthStorage remains for actual protected persistence and SDK storage hooks.

SupabaseAuthRepository directly owns SDK commands, current-session evidence, event projection, private session mapping and exception-to-AuthFailure mapping. Storage barriers and failure precedence, recovery non-enumeration/markers/completion, password identity guards, privacy-safe logs and cleanup ordering remain unchanged. Domain/use cases/Cubit/UI, approved sign-out and restore transitions, userId and dynamic accessTokenValid semantics are unchanged.

SDK types remain isolated to the data repository/storage and legitimate bootstrap/generated DI/network infrastructure; no SDK imports/types leaked into domain or presentation. Production search found no SupabaseAuthDataSource, datasources, supabase_auth_extensions, _sdkOperation, _sessionOperation or AuthRepositoryImpl references. SDK Session/AuthException are local repository types; other Session occurrences are localized copy/comments. AuthResponse/User are inferred locally rather than exposed.

Verification: dart format lib: Formatted 75 files (0 changed) in 0.30 seconds. dart run build_runner build --delete-conflicting-outputs: exit 0, Built with build_runner/aot in 16s; wrote 20 outputs (installed runner warns the removed flag is ignored). flutter analyze --no-pub lib: No issues found! (ran in 3.7s), exit 0. No tests run or migrated. Test migration remains the next task. No commit or push.

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

## First personal Create Habit vertical slice verified (2026-10-06)

This checkpoint verifies the concrete end-to-end Create Habit vertical slice against the real non-production development Supabase project (`mznupbyycstoksaetvtv`) and Android runtime:

- **Real Supabase deployment & JWT verification**:
  - `create-habit-v1` deployed and verified on non-production Supabase.
  - Authentic GoTrue user sign-in generates real access tokens verified by the deployed Edge function handler.
  - Strict security assertions pass: missing token -> 401 `unauthorized`, invalid token -> 401 `unauthorized`, forged root actor -> 400 `invalidRequest`, forged payload owner -> 422 `invalidPayload`.
  - Actor identity is derived strictly from verified JWT (`user.id`).
  - Remote PostgreSQL function `private.create_habit_v1` executes and returns canonical revision 1 receipts with UTC timestamps; identical duplicate command replays succeed idempotently.
- **Android Create -> Pending -> Synced runtime**:
  - Verified on Android 16 (API 36) emulator with native Isar (`libmdbx`) and Impeller backend.
  - Submitting Create Habit commits atomically to local Isar, emitting `SyncStatus.pending` immediately before remote network return.
  - Background delivery dispatches via Dio; upon receipt acknowledgement, Isar watcher updates state and transitions the habit card to `SyncStatus.synced` (green checkmark).
- **Offline flow & durability**:
  - Network disabled on emulator: creating "Offline Reading" commits locally to Isar with `Pending sync`.
  - App process force-stopped and relaunched offline: habit cleanly restored from local storage as `Pending sync` with retry indicator intact.
  - Network re-enabled: delivery triggered, receipt received, habit transitioned to `Synced`.
- **Account isolation (User A -> User B -> User A)**:
  - Account-scoped Isar instances ensure User A's habits and pending commands are completely unobservable by User B upon sign-out.
  - Signing back into User A cleanly restores User A's habits without cross-account contamination.
- **Migration history status**:
  - Migration `202610050001_create_habit_v1.sql` matches the live PostgreSQL schema on `mznupbyycstoksaetvtv` (`private.owned_habits`, `private.create_habit_receipts`, `private.create_habit_v1`, `habit_command_executor`).
  - Migration repair applied: `supabase_migrations.schema_migrations` officially records `version: '202610050001'`, `name: 'create_habit_v1'`.
  - Local and remote migration history agree; future `supabase db push` will treat `202610050001_create_habit_v1` as already applied and will not attempt to reapply it.
- **Skipped test explanation**:
  - Suite reports 42 passed, 1 skipped.
  - Skipped test: `'real HTTP Edge/PostgreSQL receipt replay reconciles real Isar after lost ack'` in `test/habits/habit_remote_integration_test.dart`.
  - Reason: Intentionally requires local isolated test environment variable `HABIT_REMOTE_TEST_URL` spun up by `supabase/tests/run_create_habit_tests.ps1` (with local PostgreSQL cluster and Deno fixture). When run standalone via `flutter test`, it skips cleanly without reducing coverage; live remote behavior is covered by `live_create_habit_integration_test.dart` and unit delivery tests by `habit_delivery_test.dart`.
- **Platform limitations**:
  - iOS runtime is NOT verified on physical device or simulator due to Windows host environment.
  - Web/Desktop out of scope per PRD/Constitution.
- **Scope boundary**:
  - Only the first personal Create Habit vertical slice is verified. SL-03 and SL-04 are NOT complete. Full sync recovery, deletions, edits, streaks, check-ins, feeds/cursors remain deferred.
