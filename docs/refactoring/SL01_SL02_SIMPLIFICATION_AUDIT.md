# SL-01 / SL-02 simplification audit

**Product scope update — 2026-09-30:** The Product Owner subsequently removed the dedicated Switch Account feature from v1. Switch-specific UI, credential retention and API suggestions below describe historical implementation; future cleanup follows the amended SL-02 plan. Preserve isolation and delayed-event protection for A → sign out → sign in B. No production code or tests changed under this amendment. Storage security and T035/T036 platform/acceptance gaps remain open.

**Adoption update — 2026-09-30:** The Product Owner subsequently approved feature-first organization, single state ownership, selective architecture and incremental behavior-preserving refactoring. The identified architecture and SL-01/SL-02 responsibility amendments are now recorded in those documents, and the four local skills were aligned. Approval requests below describe the original audit state; these four engineering decisions no longer await approval. The Constitution's ordered feature workflow remains unchanged; bypassing it would require separate approval. No production refactoring has begun. Original findings, completion claims, verification evidence and unresolved storage/platform risks remain unchanged.

Audit date: 2026-09-30. Scope: source inspection and development guidance only. No production code, tests, dependencies, feature gates, commits or pushes changed. Repository: `streak_up`; the sibling checkpoint was excluded. Initial working tree was clean using a command-local Git ownership exception. Generated implementations were not read.

## Evidence and limits

Controlling references: [AGENTS.md](../../AGENTS.md), [project state](../PROJECT_STATE.md), [architecture §§2–3,7–8](../ARCHITECTURE.md), [Constitution](../../.specify/memory/constitution.md), SL-01/SL-02 [plans](../../specs/001-bilingual-shell-feedback/plan.md) / [plan](../../specs/002-account-access-session-isolation/plan.md), and [SL-02 tasks](../../specs/002-account-access-session-isolation/tasks.md). Source and relevant test assertions were inspected; tests, app, remote services and platform callbacks were not executed in this documentation-only audit. Findings about runtime failures below are concrete risks requiring reproduction, not verified incidents.

SL-01 is recorded converged. SL-02 implementation is present, but T035 platform verification and T036 acceptance reconciliation remain open. PROJECT_STATE also contains stale “implementation has not started” wording and an Antigravity owner; neither was silently corrected. No product Isar/outbox exists: retention is an approved boundary represented by presence/lifecycle seams, not demonstrated durable retention.

## Lightweight file and dependency map

Paths below are repository-relative and name handwritten sources.

| Area / owner | Files and dependencies |
| --- | --- |
| Startup/composition | `lib/main.dart` → `app/bootstrap/injection.dart`, `supabase_environment.dart`; injectable/GetIt, Supabase, logger/observer |
| SDK translation | `features/auth/data/supabase_auth_gateway.dart`: `SupabaseAuthGateway` → `SupabaseAuthClientDriver` → `GoTrueSupabaseAuthClientDriver` → GoTrueClient |
| Session/account decisions | `features/auth/application/auth_session_coordinator.dart` → `domain/auth_gateway.dart`, `auth_models.dart`, `pending_work_presence.dart`, status/logger |
| Account cleanup/pending work | `domain/pending_work_presence.dart`: lifecycle interface and `ShellAccountScopeLifecycle` reset shell/status/feedback; default presence is conservatively unknown |
| Auth presentation | `presentation/auth_cubit.dart`, individual auth screens, `widgets/auth_page_scaffold.dart`; Bloc state plus local controllers |
| Navigation | `app/routing/app_router.dart`, `app_routes.dart`, `shell_destination.dart`, `feature_route_hosts.dart`; generated typed go_router sources, coordinator refresh |
| Shell | `features/shell/presentation/app_shell.dart`, `shell_cubit.dart`, top/bottom widgets; route, locale, shared status/feedback |
| Feedback/status | `core/presentation/feedback/{feedback_models,feedback_coordinator}.dart`, shared host; `status/status_models.dart`, banners/action badges |

## Actual execution paths

* **Startup/restoration:** `main` ensures Flutter binding → awaits `configureDependencies` → validates environment → initializes Supabase with URI detection disabled, resilient session storage and SharedPreferences PKCE storage → initializes DI/observer → resolves AuthCubit → starts restoration without awaiting → supplies dependencies and AppRouter to app. AuthCubit → coordinator queued restore → AuthGateway → cached driver session/remote refresh. Verified cached identity survives temporary unavailability; confirmed rejection yields reauthentication. Coordinator applies lifecycle/status before publishing; router starts `/restoring` and refreshes from coordinator.
* **Sign In:** `SignInScreen._submit` → `AuthCubit.signIn` sets submission state → `AuthSessionCoordinator.signIn` queues operation and checks existing-account pending work → `AuthGateway.signInWithEmailPassword` implemented by `SupabaseAuthGateway` validates/maps → driver `signInWithPassword` → GoTrueClient. Result → coordinator applies scope transition/emits snapshot → Cubit copies snapshot; return outcome separately clears submission/failure. SDK events also travel driver → gateway signals → coordinator queue → same transition method. Router observes coordinator directly.
* **Registration:** screen local controllers → Cubit password-confirmation check → coordinator queued `register` → gateway `registerWithEmailPassword` → driver `signUp` with configured email redirect → SDK. Gateway maps unconfirmed identity to verification-required; coordinator publishes and router restricts shell access. Verification refresh/resend use the same boundaries; no pass-through use-case classes exist.
* **Recovery/deep links:** request screen → Cubit → coordinator → gateway/driver reset-email; receipt is held in both coordinator and Cubit. Android manifest accepts `io.streakup.app://auth-callback`. Router redirect recognizes callback, constructs normalized URI, invokes coordinator asynchronously, immediately returns a clean route; queue → gateway origin check → driver `getSessionFromUrl` → SDK. Validated recovery context permits reset; Cubit → coordinator → gateway `submitNewPassword` → SDK update. PKCE exchange correctness must be verified on the installed SDK/platform; storage wiring alone proves neither cold-start nor replay behavior.
* **Account switch/sign-out:** Cubit forwards requests → coordinator queue → presence check (pending/unknown warns) → prompt; password retained outside snapshots → confirmation consumes password → forced request → gateway sign-out/sign-in → `_applyAccountStateTransition`. Lifecycle resets prior shell/status/feedback before rebinding. Epoch changes on account/status change; `runIfScopeActive` rejects a mismatched captured identity/epoch before invoking its closure. Expiry follows provider signed-out/invalidation to reauthentication without voluntary warning.
* **Routing/bottom navigation:** AppRouter refreshes from coordinator ChangeNotifier, redirects by account state and saves sanitized internal protected paths. `MainShellRouteData.builder` derives destination from URI, schedules Cubit synchronization after frame; tap updates Cubit and invokes typed route navigation. `AppShell.activeDestination` supplies bottom selection. Global route back pops or uses Cubit's last branch when no history exists.
* **Shared status/feedback:** coordinator maps expiry/offline to ShellStatusCubit; AppShell renders status banner/action badges and SharedFeedbackHost. FeedbackCoordinator coalesces background events and owns transient/banner/inline lifetimes. Auth screens instead render AuthCubit failures/info with AuthFeedbackCallout. Account lifecycle resets both systems. This separation reflects different lifetimes, though visual/semantic styling can share primitives.

## Top maintainability findings

1. **Duplicated auth projections and two notification mechanisms.** `auth_cubit.dart` copies account state, connection, epoch, prompt and receipt from `AuthCoordinatorSnapshot`, while tracking callback-failure identity to avoid resurrecting dismissed errors. `auth_session_coordinator.dart` emits a broadcast stream plus ChangeNotifier; saved-route writes deliberately emit only the stream to avoid redirect recursion. A small change needs reasoning about snapshot timing, command outcome and two listeners. Keep coordinator as session owner, but make presentation state contain one referenced session snapshot plus UI-only fields; use one notification source with a small router bridge. Do not move session policy into the UI or merge both full classes.
2. **Router evaluation performs asynchronous work and mutates session-owned routing data.** `app_router.dart:resolveAuthRedirect` launches unawaited callback ingestion and consumes/saves destinations; coordinator methods selectively suppress notifyListeners. Debugging callback retries and redirects requires following side effects across both files. Move callback ingestion to a single app/deep-link entry, then use a deterministic redirect function. Retain token-free routes, validated reset context and same-account destination checks. An added listener should replace existing handling, not duplicate SDK/OS ingestion.
3. **Route selection is synchronized twice.** `app_routes.dart:MainShellRouteData.builder` computes active destination, queues a post-frame update, and also updates ShellCubit on tap; `shell_cubit.dart` retains selection while `AppShell` receives route-derived selection. Root app rebuilds from ShellCubit even for branch changes. Make router location authoritative; retain an explicit last-primary-destination only if global-route fallback requires it, and keep locale state independently scoped. Removing selection blindly would break `_returnToActiveBranch`.
4. **Related safety contracts are misplaced and adapter responsibilities are dense.** `domain/pending_work_presence.dart` combines presence, lifecycle and a concrete implementation importing three presentation Cubits. `data/supabase_auth_gateway.dart` contains raw models, driver interface, SDK translation, event policy, validation, recovery flags and failure mapping. The former violates the documented pure-domain direction; the latter makes SDK detail harder to find. Move concrete scope cleanup to application/composition and group driver translation separately from gateway policy, rather than adding layers. Driver methods often forward SDK calls, but they also normalize events/users and permit SDK-free fault tests: removal is not justified by forwarding alone.
5. **Presentation surface mixes independent components; shared status has multiple update authorities.** `widgets/auth_page_scaffold.dart` holds page geometry, fields, buttons, divider and error localization; screens repeat password-toggle controls. Group scaffold separately from cohesive controls/callout, extracting only the repeated visibility behavior. `status_models.dart` combines models and Cubit: counts can come from updateStatus/setNetworkState or be recomputed by upsertActionStatus. Coordinator writes only exceptional auth/transport states; lifecycle reset preserves network/cause. Define whether counts are totals or counts of loaded projections, and explicitly clear an auth issue when resolved without inventing Online. Keep existing visual/state behavior until tested and approved; do not build a generic forms/status framework.

## Simplest safe alternative

```text
Current Sign In:
Screen → AuthCubit → AuthSessionCoordinator → AuthGateway
  (SupabaseAuthGateway) → SupabaseAuthClientDriver
  (GoTrueSupabaseAuthClientDriver) → GoTrueClient
Result/events → coordinator snapshot → copied AuthState → screen
                         └ ChangeNotifier → router

Proposed:
Screen → AuthCubit (submission/feedback) → session coordinator (one session snapshot)
  → AuthGateway / Supabase adapter → SDK driver → GoTrueClient
One session notification → presentation snapshot reference + router refresh bridge
Route decision derives from session; app callback entry performs callback ingestion once
```

The proposal shortens state ownership/debugging paths rather than deleting security layers. Keep session ordering/pending warnings/scope policy separate from UI; keep SDK mapping separate from session policy. Keep AuthGateway (substitution and SDK isolation), AccountScopeLifecycle (cleanup-before-rebind), PendingWorkPresenceProvider (conservative ownership inspection), typed account states/outcomes, logger and feedback lifetimes. Keep the driver initially because existing fault tests depend on it; reconsider only after proving equivalent SDK-level testability. AuthCubit stays small; coordinator may use a private shared command-result helper for repeated queued apply patterns, without a use-case class per operation.

Concrete removable candidates: copied scalar session fields in AuthState, `_lastObservedCallbackFailure` bookkeeping after a stable error-consumption design, redundant route-selection synchronization, and one of the coordinator notification channels after migrating all consumers. These are conditional refactor targets, not authorized deletions. Keep handwritten sealed states and narrow generic AuthOutcome: finite outcomes improve safety and no elaborate generic framework was found. Retain injectable/generated routes under current governance; manual DI is not an authorized simplification.

## Safety concerns to characterize before simplifying

* Coordinator queues SDK signals but does not call `isCurrentScope` in `_onGatewaySignal`; serialization alone does not prove stale provider events cannot reactivate A after sign-out/B. `runIfScopeActive` checks before an awaited closure, not at later writes. Add delayed SDK-event and delayed-write scenarios before changing notification/queue structure.
* `_mapSnapshotToState` in gateway uses email confirmation to authenticate but does not inspect the raw snapshot's `hasActiveAccessToken`. Driver can create a snapshot from a User with no Session. Add verified-user/no-session outcomes for registration, sign-in and callback; confirm approved identity evidence before proposing a behavior fix.
* Coordinator ignores gateway sign-out outcome and may emit signed-out while SDK state remains unresolved. Resilient storage catches removal errors and switches to memory, which does not demonstrate deletion of the prior on-disk session. Characterize sign-out failure, late SDK event and restart after storage removal failure; preserve retained work while hiding protected content.
* Redirect normalizes relative callbacks into the trusted app scheme/host; test malformed path/query, repeated delivery, recovery failure and cold/warm PKCE. Session cleanup completes before snapshot changes, but protected widgets could retain a prior snapshot while asynchronous cleanup is pending; use a delayed lifecycle widget test to establish no prior-account frame.

These are concrete coverage gaps from inspected execution paths, not reasons to weaken controls or claim the current implementation is fully safe.

## Existing regression protection and limits

| Behavior | Existing tests / evidence | Concrete remaining risk |
| --- | --- | --- |
| Sign-in, registration, verification, recovery | `test/auth/auth_gateway_test.dart`, `auth_cubit_test.dart`: verified/unconfirmed mapping, mismatch, non-enumerating recovery, resend/receipt, error retry | User-without-session case; explicit verification refresh/resend and reset success/expired SDK behavior |
| Restore/expiry/offline separation | gateway tests: offline/temporary/unknown preservation, confirmed rejection, successful refresh | Storage failure/restart; late provider event after voluntary exit |
| Account isolation/unsynced warning | `auth_session_coordinator_test.dart`: A→out→B→A reset/epochs, stale closure rejection, pending/unknown/none warning, secret consumption/cancel | Real SDK event race, delayed cleanup/write, failed sign-out; no actual outbox retention yet |
| Routing/reset guard | `auth_routing_test.dart`: restoring without shell flash, saved path, verification/expiry/reset matrix; `test/shell/navigation_test.dart` | Back stack after A→B, unsafe destination cases and callback deduplication |
| Deep links/PKCE/Supabase | gateway fake callback tests; `supabase_live_integration_test.dart` environment/endpoint checks; Android intent filter; T035 recorded Android handoff | Live test may skip and is not full registration/recovery/PKCE end-to-end proof; iOS and full callback acceptance remain open |
| Environment/privacy | gateway config tests reject service secrets/non-dev placeholders; `auth_privacy_test.dart`, `test/shell/bootstrap_test.dart` redaction | Session-storage protection/removal failure requires dedicated coverage/platform evidence |
| RTL/responsiveness/accessibility | `auth_ui_test.dart` nine-state English/Arabic/viewport/text-scale/targets; shell RTL, localization, accessibility, visual_responsive_verification tests | Widget layout checks are not runtime screenshot parity or hardware accessibility acceptance |
| Status/feedback lifetimes | shell `status_test.dart`, `feedback_test.dart` | Auth issue clearing and count ownership across independent update paths |

Keep every existing behavioral assertion. If constructors change, adapt fixture setup rather than deleting tests. Add only the affected risks above to the step that touches that boundary. A future local-data feature needs durable per-account retention tests under its own approved data contract.

## Incremental refactoring order (proposal only)

Use a dedicated branch/worktree after approval, one diff per step; keep the current documentation task uncommitted. Baseline relevant tests/analyzer before each step. Every step can be reverted independently without migrations or new dependencies.

| Step | Affected files | Improvement / regression risk | Minimum verification |
| --- | --- | --- | --- |
| 1. Characterize safety gaps | `test/auth/{auth_gateway,auth_session_coordinator,auth_routing}_test.dart`, focused bootstrap/storage tests | Establish event/session/cleanup invariants; failing cases are separately reviewed bug fixes, not silently bundled refactors | Relevant auth tests and analyzer; delayed provider, no-session, failed exit/storage and protected-render tests |
| 2. Cohesive file ownership | `domain/pending_work_presence.dart`, new application lifecycle file; `data/supabase_auth_gateway.dart`, grouped driver file; scaffold/controls files if useful; import sources | Easier navigation and pure domain; risk DI bindings/exports/UI styling. No logic changes | Gateway/coordinator/bootstrap/auth UI tests, analyzer, DI generation; actual screenshots if rendered output changes |
| 3. One session projection | `auth_cubit.dart`, coordinator snapshot/notifications, `app_router.dart`, narrow refresh bridge | Remove copied state and failure identity synchronization; risk missed updates, error resurrection, disposal and queue races | Cubit/coordinator/routing/privacy tests plus delayed-event cases; analyzer and DI generation as needed |
| 4. Deterministic routing | router/routes, callback app-entry wiring, destination state in coordinator/ShellCubit | Separate callback work from redirect and remove redundant active-selection writes; risk PKCE duplicate exchange, redirect loops, global back/old-account history | Auth routing + shell navigation, unsafe/duplicate callback/back-stack tests; Android/iOS cold/warm callbacks and screenshot evidence; unavailable gates stay open |
| 5. Explicit feedback/status ownership | status models/Cubit, coordinator mapping, scope lifecycle, auth callout/shared cards | Define count source and issue-resolution lifecycle; share only visual primitives; risk false Synced/Online, lost recovery, changed RTL layout | Status/feedback/coordinator/auth UI/RTL tests, issue-clearing/count tests, analyzer, approved PNG runtime comparison for UI changes |

## Instruction review and governance conflicts

AGENTS already limits context loading and speculative frameworks. Minimal addition links new guidance and states Codex planning/implementation ownership without rewriting project gates. Task-relevant local Skills were inspected as audit inputs, not invoked implementation workflows; no Skills changed or created. None mandates multi-agent execution. No unrelated installed Skill inspection was warranted.

Precise future corrections:

* `.agents/skills/flutter-architecture-guard/SKILL.md` §3: replace “Trace each changed behavior across relevant interfaces/use cases/repositories/serialization/persistence/transport/UI” with “Trace the actual affected call/data flow and relevant contracts; do not add missing layers to match this list.” §1: make the 5–10-line map reusable once per task, not repeated by each stage.
* `.agents/skills/flutter-feature-implementer/SKILL.md` §3: replace “3–8 expected touched files” with “the smallest expected touched-file set; no minimum file count.” Keep approved-task and visual gates.
* `.agents/skills/codex-efficient-workflow/SKILL.md` §3: replace model switching and mandatory `/status` observation with “Use available model/usage controls only when relevant and supported; do not interrupt ordinary work to optimize model selection.” §7: make handoff optional when another session needs it; retain concise verification output.
* `.agents/skills/flutter-ui-fidelity/SKILL.md` opening: load supplemental official skills only for a concrete need, not automatically. Keep runtime screenshot, RTL and unavailable-evidence requirements. No blanket repository scans were required by these local skills.

**Approval boundary:** ARCHITECTURE §3 says “Presentation invokes use cases, not Isar or Supabase directly” and mandates application/domain layering; its conventions say Cubits map use-case results. Proposed amendment: “Presentation dispatches to a focused application/session boundary or SDK-free domain contract; introduce a use case only for distinct reusable business logic or orchestration. Widgets never call SDK/storage directly.” §2 already rejects blanket wrappers. AuthCoordinator satisfies the current application boundary; deleting it or moving its policy to Cubit is not authorized by this audit.

**Feature plan boundary:** SL-02 plan explicitly prescribes one coordinator, gateway and lifecycle contracts; SL-01 plan explicitly gives ShellCubit selected destination ownership. Changing these contracts/owners needs an approved plan delta before implementation. Proposed SL-01 delta: router owns active location; shell may retain last primary destination for safe global fallback and locale override. Proposed SL-02 delta: one authoritative session snapshot/notification, distinct presentation feedback, dedicated callback ingestion; retain serialized lifecycle ordering and SDK isolation.

**Delivery boundary:** Constitution Principle II requires full ordered artifacts/analysis for every new feature. Compact maintenance planning is compatible when it reuses approved scope/contracts; bypassing steps for new features requires Product Owner amendment. No amendment is necessary merely to let Codex author both planning and implementation. PROJECT_STATE's Antigravity/stale implementation text needs an approved state reconciliation separately; do not change T035/T036 or claim convergence here.

**Security contract gap:** ARCHITECTURE §7 calls for protecting session secrets with platform secure storage; bootstrap currently delegates to SharedPreferences session and PKCE storage with a memory fallback. This is an implementation/verification gap, not optional ceremony. Review platform protection and SDK storage integration under the approved security contract; do not silently amend it to permit weaker storage.

No Constitution, architecture, feature plan, database, product or design artifact was edited. Proposed contract changes remain subject to Product Owner approval before production refactoring.
