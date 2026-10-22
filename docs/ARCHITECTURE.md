# StreakUp Architecture

| Field | Value |
| --- | --- |
| Status | **Approved architecture direction and Flutter coding conventions; remaining items in §11** |
| Date | 2026-10-01 (foundation amendment; original direction 2026-09-28) |
| Scope | Android and iOS v1 architecture; no feature implementation authorized by this document |
| Product authority | [PRD v1.0](PRD.md) |
| Governance | [StreakUp Constitution](../.specify/memory/constitution.md) v2.0.0 |

This document records the approved technology direction and proposes its remaining technical boundaries. It does not resolve PRD open questions or change product behavior. Feature specifications must still follow the constitution's ordered delivery process and cite applicable requirement IDs. SL-01/SL-02 are implemented; current ownership and verification are recorded in PROJECT_STATE.md and their implementation guides. Product persistence and SL-03 remain future work.

## 1. Drivers and invariants

- Android and iOS; English and Arabic with RTL for every P0 flow (`CON-001`, `CON-003`, `NFR-001`, `NFR-010`, `NFR-011`).
- Habit creation/editing/lifecycle, check-ins, reminders, and appropriate profile edits commit locally before network work (`FR-020`, `BR-022`). A locally accepted check-in survives restart and retries until acknowledged or explicitly resolved (`NFR-004`).
- Social actions can be queued offline but cannot be presented as effective for another user until accepted by the server (`FR-021`, `BR-023`, `UX-010`).
- Private by default, explicit sharing, and authorization at every server read/write boundary (`BR-001`, `PERM-003`, `PERM-009`, `NFR-008`).
- A scheduled occurrence contributes at most one completion and one challenge point. Restores affect personal streaks only (`BR-003`, `BR-007`, `FR-014`).
- The UI distinguishes local **Pending**, server **Synced**, and actionable **Failed** states (`FR-022`, `NFR-003`, `NFR-012`).

## 2. Architecture decisions

The technology choices marked **Approved** below are directions, not installed dependencies. Other rows remain proposals. Package versions and release infrastructure details are unpinned until implementation planning.

| Area | Recommended option and fit | Important alternatives / trade-off | Approval or product dependency |
| --- | --- | --- | --- |
| Flutter structure | Feature-first organization with only justified internal layers. Presentation dispatches through Bloc/Cubit to a focused application/session boundary or SDK-free domain contract; adapters isolate external access. UI has no business or direct data-access logic. | A single layer tree blurs feature ownership; extra abstractions without a concrete boundary add ceremony. | **Approved amendment 2026-09-30**; exact folders are a feature-plan detail. |
| Engineering principles | Apply SOLID project-wide, especially single responsibility, dependency inversion, interface segregation, and separation of concerns. Add an abstraction only when it protects a real boundary or test seam. | Blanket interfaces and one-class-per-operation wrappers create unnecessary indirection. | **Approved**. |
| State management | Bloc/Cubit owns presentation state and derives views from authoritative session/domain/local-data state without independently synchronizing copies. Offline product views observe Isar-backed snapshots. A global `BlocObserver` records lifecycle, transitions/changes, and errors through redacted logging. | Other state-management frameworks are outside the approved stack and require explicit approval. | **Approved**. [BlocObserver API](https://pub.dev/documentation/flutter_bloc/latest/flutter_bloc/BlocObserver-class.html) |
| Dependency injection | Explicit `get_it` registrations wire dependencies in the composition/bootstrap layer; dependencies still enter classes through constructors. | The current dependency graph is small enough for readable handwritten registration; service lookups throughout features obscure dependencies. | **Approved**; no direct `GetIt` access in widgets, entities, use cases, or other business logic. [GetIt](https://pub.dev/packages/get_it) |
| Navigation | `go_router` with type-safe generated routes, auth redirects, and deep-link handling for notification destinations. Avoid raw route-name strings where generated route types exist. Route guards are UX only; server checks authorization. | Raw Navigator is sufficient for a tiny app; `auto_route` adds another router. | **Approved**. [go_router type-safe routes](https://pub.dev/documentation/go_router/latest/topics/Type-safe%20routes-topic.html) |
| Models and generation | Prefer immutable models/states; use Freezed where useful for Bloc states, unions/sealed results, and immutable models; use `json_serializable` for applicable JSON. Use enums/sealed types for finite states; reproduce generated files with `build_runner`. | Handwritten immutable types can be clearer for simple cases; pervasive generation adds build cost. | **Approved**; never hand-edit generated files. [Freezed](https://pub.dev/packages/freezed), [json_serializable](https://pub.dev/packages/json_serializable) |
| Client networking | Use the Supabase Flutter SDK for Auth, PostgreSQL/Data API/RPC, and Realtime. Use centrally configured Dio for custom HTTP, suitable Edge Function HTTP endpoints, and future external APIs. Data adapters receive configured clients. | Forcing SDK traffic through Dio adds an unsupported coupling; feature-created clients cause inconsistent security and error behavior. | **Approved**; exact sync API contract remains `T-02`. [Supabase Flutter](https://supabase.com/docs/guides/getting-started/quickstarts/flutter), [Dio](https://pub.dev/packages/dio) |
| Backend and data | Supabase PostgreSQL is authoritative. Use RLS, least-privilege grants, constraints, version-controlled migrations, and narrow RPC/database functions; use Edge Functions for trusted server workflows when suitable. Realtime can prompt refreshes only. | A custom backend could centralize all workflows but adds deployment and maintenance; direct table mutations alone are insufficient for transactional scoring/transfers. | **Approved platform**; region depends on `OQ-008`; RPC/Edge boundary remains technical approval. [Supabase RLS](https://supabase.com/docs/guides/database/postgres/row-level-security), [migrations](https://supabase.com/docs/guides/local-development/declarative-database-schemas) |
| Authentication | Supabase Auth for registration, sign-in, password recovery, and identity. Database policies and trusted functions authorize product data using the authenticated user, not client-supplied owner IDs. | External OIDC or custom auth adds identity integration and operational burden. | **Approved**; market/privacy review `OQ-008`. [Supabase Flutter](https://supabase.com/docs/guides/getting-started/quickstarts/flutter) |
| Local database | Isar is the local source of truth for offline-capable data, durable outbox, sync metadata, and recovery records. Feature-driven collections and indexes are managed by versioned application migrations. | A relational local store offers stronger declarative constraints but is outside the approved stack. | **Approved**; package distribution and at-rest protection need validation. [Isar transactions](https://isar.dev/transactions.html), [data migration](https://isar.dev/recipes/data_migration.html) |
| Offline sync | Transactional Isar outbox plus incremental, permission-filtered Supabase pull/reconciliation with a server-issued cursor. Each server command returns an outcome and canonical changes. | Whole-database replication or generic last-write-wins cannot express StreakUp's permissions and domain conflicts safely. | **Approved principle**; exact command/change-feed contract remains technical approval and depends on product rules. |
| Connectivity | Global reachability distinguishes unknown, Online, Offline and Reconnecting/checking where needed. Auth lifecycle and synchronization are separate owners. | Interface availability alone cannot prove backend reachability. No sync state or action map belongs to connectivity/Shell. | **Approved amendment 2026-10-01**; real adapter/probe policy belongs in its implementation plan. |
| Conflict policy | Idempotent, server-validated domain commands; preserve rejected local intent for recovery. Never silently overwrite check-ins or habit edits. | Last-write-wins by timestamp is simple but can erase offline changes; CRDTs are unnecessary for these constrained operations. | **Approved offline principle**; user-facing edit resolution is `OQ-009`, protocol is `T-02`. |
| Streak calculation | Pure calculation over accepted, versioned occurrence and restore facts; local results are provisional until sync. This supports deterministic replay. | Mutable streak counters are faster to display but can drift after late sync; store projections only as rebuildable caches. | Proposed feature-plan detail; deadline and time zone rules require `OQ-004`. |
| Challenge scoring | Supabase-owned score ledger derived from valid ordinary check-ins; one point maximum per eligible occurrence. This protects fairness across devices. | Client-authored scores or direct leaderboard writes are simpler but cannot be trusted; periodic full recounts can supplement, not replace, transaction checks. | **Approved authority**; final feature rules need `OQ-003`, `OQ-004`, `OQ-005`, and late-finalization rule. |
| Notifications | Local scheduled habit reminders; Supabase-stored social event records with a trusted notification workflow and push provider chosen later. In-app state is authoritative. | Pure push cannot remind reliably offline; polling alone delays social notice. | **T-04**: push provider and delivery workflow. |
| In-app user feedback | A centralized `AppNotification`/`UserFeedback` presentation abstraction produces temporary localized success, information, warning and recoverable-error notifications through shared UI components. | Feature-owned inline errors and retries remain local; share notification presentation only where useful. | **Approved**; product notification center scope still follows the PRD. |
| Localization | Flutter `gen_l10n`/ARB with English and Arabic, locale-aware dates/numbers, and direction-aware layout from the start. | Hand-maintained maps or third-party localization frameworks are possible but add avoidable translation drift. | Proposed implementation detail. [Flutter localization](https://docs.flutter.dev/ui/internationalization) |
| Error handling | Typed failures and persisted recovery records from repository to UI. This makes Pending/Failed and safe retry explicit. | Generic exceptions/toasts require less mapping but hide durable conflicts and recovery. | Required recovery principle; exact errors belong in feature plans. |
| Testing | Pure-domain, Isar, Supabase integration, sync fault, UI, and device tests targeted to PRD invariants. | An end-to-end-only suite misses deterministic edge cases and is slower to diagnose; unit-only coverage misses transaction and device failures. | Constitution-required verification; details belong in feature plans. |
| Logging and telemetry | An `AppLogger` abstraction accepts structured, allowlisted metadata from app lifecycle, `BlocObserver`, Dio, sync/outbox, Supabase outcomes, migrations, and unexpected exceptions. Development is detailed, staging diagnostic, and production minimal/redacted. | Direct `print` calls or broad analytics SDK defaults can leak private content and obscure failure paths. | **Logging convention approved**; provider/retention remains `T-05` and `OQ-008`. |
| Environments | Isolated development, staging, and production Supabase projects, push credentials, and analytics configuration. This prevents test traffic and identities crossing production boundaries. | One shared environment costs less initially but weakens release verification and isolation. | **T-05**; region depends on `OQ-008`. |
| Security/privacy | RLS and grants on exposed data, narrow privileged functions, TLS, protected local storage, redacted telemetry, and minimal push payloads. Do not assume Isar provides database-level encryption. | Client-only guards cannot enforce current permissions; field-level encryption may protect selected local values but complicates queries and key recovery. | **T-01/T-02**; legal input `OQ-008`, `OQ-010`. |

## 3. Runtime boundaries

```text
Flutter UI
    ↓
Bloc / Cubit
    ↓
Focused application/session boundary or SDK-free domain contract
    ↓
Justified data-access boundary → adapters
    ↓
Isar local database (offline-capable source of truth)
    ↓
Durable Outbox / Sync Engine
    ↓
Supabase SDK → Auth + PostgreSQL/RLS + RPC + Realtime (refresh hint)
Configured Dio → suitable Edge Function HTTP/custom HTTP/external API
    ↓
Reconciliation back into Isar
    ↓
Bloc / Cubit observes updated local state → Flutter UI
```

The diagram describes offline product-data flow, including the optional custom HTTP branch; it is not a mandatory class chain for every feature. The app is divided by feature (account, habits, check-ins/streaks/restores, friends, challenges, notifications, profile) with shared infrastructure for Isar, Supabase, Dio, sync, localization, and observability. Preserve inward dependencies at real boundaries: domain rules and application contracts stay independent of concrete infrastructure; adapters implement required contracts. Introduce coordinators, use cases, repositories and interfaces only for distinct orchestration, business rules, security/lifecycle protection, SDK isolation or meaningful testability. The bootstrap layer alone wires all concrete dependencies. Domain rules are pure and have no Flutter, Isar, Supabase, Dio, or platform dependency. Presentation dispatches to a focused application/session boundary or SDK-free domain contract. Introduce a use case only for distinct reusable business logic or orchestration. Widgets never call SDK/storage directly. Repositories expose Isar-backed local snapshots and sync status. Domain functions use explicit inputs such as schedule version, occurrence identity, effective time zone/deadline, and accepted event history. They never read the device clock internally.

Supabase Auth supplies identity. Supabase PostgreSQL, its RLS/constraints/functions, and narrowly scoped Edge Functions own access control, canonical command validation, cross-user transactions, challenge scores, and final results. The mobile app computes immediate **provisional** personal projections from locally persisted actions, then reconciles canonical results into Isar. Supabase never trusts a client-supplied streak or score. This split is required by `NFR-005`, `PERM-002`, `PERM-005`, and `BR-007`.

### Project-wide Flutter coding conventions

**Approved engineering amendment — 2026-09-30:** Adopt feature-first organization, single state ownership, selective architecture and incremental refactoring. Simplify through small, independently reviewable and reversible, behavior-preserving changes with regression tests; preserve security, lifecycle and data boundaries. See [engineering guidelines](engineering/PRAGMATIC_FLUTTER_GUIDELINES.md) and [stage playbook](engineering/CODEX_STAGE_PLAYBOOK.md). These directions do not claim existing code has been refactored or verified.

- Follow pragmatic Clean Architecture and SOLID. Each class should have a focused responsibility; depend on narrow contracts rather than concrete infrastructure; keep feature interfaces small. Pure domain functions/services own business decisions, including occurrence eligibility, streak calculation, restore rules and local prevalidation of server-owned challenge rules. Add use cases or coordinators for distinct reusable logic or orchestration, not pass-through calls. Organize code by feature with only useful internal layers. Do not create interfaces or wrappers that add no meaningful boundary, substitution, or test seam.
- Widgets and screens compose and render UI and dispatch user intent through Bloc/Cubit. They do not calculate domain results, call repositories/data sources directly, run networking, or access Isar. Repeated UI patterns become reusable components. Small ephemeral visual/form state may stay local when it does not duplicate durable or shared presentation state.
- Each feature Bloc/Cubit owns presentation state and derives views from applicable application/domain results or authoritative snapshots, including Isar-backed streams and Pending/Synced/Failed. It does not independently duplicate state owned by another component. It contains no SQL, database query, HTTP call, Supabase SDK operation, or platform integration detail. Presentation effects may request centralized user feedback; business/domain layers never display UI notifications.
- A single global `BlocObserver` records Bloc/Cubit creation, closure, changes and errors through `AppLogger`. Log safe state/event types and allowlisted diagnostics, never a raw state/event dump that may contain user data. Production output is minimal and redacted.
- Use explicit `get_it` registrations in app/bootstrap/injection.dart. Classes receive dependencies through constructors; there is no generated DI module or mutable configuration bridge. Do not call `GetIt` from widgets, domain entities, use cases, or other business logic. Bootstrap owns registration, environment selection, scopes, and lifecycle. Tests can construct fakes directly. No second state-management or service-locator framework is approved.
- Use `go_router` with type-safe generated route definitions. Route types carry parameters and destinations where supported; avoid raw route-name strings when generated route types are available. Signed-out/signed-in redirects and deep links preserve a safe destination. Notification links resolve identifiers through use cases/repositories and show an unavailable state when access has changed. Client route guards cannot bypass server permissions.
- Prefer immutable models and Bloc/Cubit states. Use Freezed where its generated equality/copying/unions reduce real complexity; simple immutable types may remain handwritten. Use `json_serializable` for JSON models where applicable, and enums or sealed types instead of magic strings/integers for finite states. Generated route, model and serialization files are never edited manually; generation with `build_runner` must be reproducible from committed sources and locked dependencies.
- Long-lived account/sync services have explicit lifecycle on sign-in, sign-out and subsequent sign-in as another account. V1 has one active account per device and no dedicated Switch Account feature (Product Owner decision 2026-09-30). Sign-out retains original-account work after pending/unknown-work confirmation; reject delayed events from a prior account and resume work only under confirmed same-account identity.

### Current app foundation ownership

app/ owns startup/composition, configuration, typed routing and theme. main.dart initializes Flutter and calls app/bootstrap/app_bootstrap.dart. injection.dart explicitly wires GetIt dependencies; app/config/supabase_config.dart owns deployment values and validation. Cold callbacks are acquired before lazy AuthSession resolution. AuthStartup owns subscription, callback handling, restoration ordering and disposal; AndroidAuthCallbackChannel only transports platform callbacks.

core/logging/app_logger.dart owns allowlisting/redaction with an optional emission sink and no retained test buffer. app_bloc_observer.dart records safe lifecycle/change/error types. features/shell/presentation/models/shell_destination.dart owns bottom-navigation labels/icons, without raw paths or spec codes. Typed routes directly construct presentation entry points; there is no FeatureRouteHosts registry. Shell-owned FeaturePlaceholder and ProfilePlaceholder provide current unfinished-feature presentation and the sign-out warning.

There is one canonical token source per category: AppColors, AppSpacing, AppRadii and AppTypography; AppTheme composes ThemeData. app/streak_up_app.dart composes providers, MaterialApp.router, theme and localization with required auth startup/Cubit/router dependencies. Destinations own scrolling. AppRouter retains synchronous AuthSession redirects and the account-transition stack replacement to prevent prior-account navigation from surviving rebind.

## 4. Data and full offline-first behavior

### Local model

Isar is the local source of truth for every offline-capable product view. Model collections and indexes around feature queries and invariants, rather than mirroring remote PostgreSQL tables. Candidate feature areas are owned habits and versioned schedules, occurrence/check-in facts, provisional restore state, local profile/reminder settings, durable outbox operations, sync metadata, tombstones, and conflict/recovery records. These are conceptual areas, **not a production schema**. Index stable local/remote identifiers, occurrence lookup keys, outbox readiness/order, and recovery status as needed by measured queries. Isar watchers feed repository streams, which feed Bloc/Cubit; UI never reads Isar directly. [Isar schema](https://isar.dev/schema.html), [watchers](https://pub.dev/packages/isar)

Use a separate named Isar instance and storage path per authenticated account as the proposed isolation strategy. Opening a different account closes/locks the previous account's store and never mixes its outbox or projections. Keep only the minimum social metadata needed to queue a known action. Do not durably cache other users' shared habit details; retrieve and reauthorize those when online so stale offline permissions cannot expose them after revocation. Historical challenge results visible to a user are obtained through authorized Supabase reads. SL-02 defines original-account retention across sign-out and subsequent sign-in; account-deletion retention remains a separate product decision (§11).

Track an application data version and run ordered, tested local data migrations at startup before opening normal repositories. Isar can adapt some structural schema changes automatically, but changes to stored meanings, indexes, identifiers, and outbox payloads need explicit versioned application migrations. A migration must preserve pending operations and recovery records, fail safely with a recoverable copy, and be tested from every supported prior app version. [Isar data migration guidance](https://isar.dev/recipes/data_migration.html)

Durable outbox records include a stable command ID, account/aggregate identity, command type and version, payload/reference, base server revision, causal order, retry state, and last outcome. Sync metadata includes the server cursor, last successful pull/push, and per-command acknowledgment. Tombstones represent local deletion intent and accepted remote deletion/revocation until reconciliation is complete; they prevent a later resnapshot from resurrecting deleted data. Conflict/recovery records retain both local intent and the relevant canonical server revision until resolved. Exact collection fields and indexes belong in later feature plans.

Each scheduled occurrence has a stable identity tied to the habit, schedule version, and intended period. Its exact period/deadline definition is **product input `OQ-004`**. Check-in records and schedule history are append-only for calculation purposes; future habit edits create an effective-dated version and cannot mutate earlier occurrence meaning (`BR-011`). Isar indexes and application validation detect local duplicates; PostgreSQL constraints and trusted command handling enforce authoritative uniqueness independently.

### Local write path

1. Validate what can be validated from the locally known schedule and account state. If a rule depends on current server state, label the result provisional.
2. In one Isar write transaction, persist the action, update the local projection, enqueue a command with a stable client-generated ID and base server revision, and set **Pending**. Return immediate feedback without waiting for Supabase (`FR-005`, `FR-020`, `NFR-006`).
3. Keep the command across app restarts, process death, and connection changes. Connectivity is a hint to retry, not proof that Supabase is reachable.
4. On server acceptance, reconcile canonical data into Isar and atomically record the acknowledgment/cursor and **Synced** state. On transient failure, retain **Pending** with bounded backoff and jitter. On permanent rejection/conflict, retain the original intent in Isar and mark **Failed** with a reason and recovery action. Bloc/Cubit emits the resulting local state.

Personal habit operations and reminders use this path offline. Social commands may also be queued, but the UI describes them as pending and does not update another user's effective state before server acknowledgment (`BR-023`). Fresh registration, sign-in, password recovery, and first-time access to another user's data require connectivity. A previously authenticated account can continue local personal work while offline; upload waits for a valid token. The approved v1 policy is sign-out followed by sign-in as another account, without a dedicated switch action; preserve original-account work and the sign-out confirmation boundary.

### Sync protocol and reconciliation

- The sync engine sends pending Isar outbox operations to Supabase when connectivity is available. Actual API reachability and a valid Supabase Auth session are required; a connectivity signal alone is insufficient. Preserve per-entity causal order while allowing independent entities to progress. Acknowledge each command separately.
- Use an account-scoped stable idempotency key. Process each atomic domain command in a PostgreSQL transaction with an idempotency receipt and constraints; a retry returns the recorded outcome. An invoker RPC may use narrow table grants and RLS for commands it can safely authorize. For command-only canonical tables, deny direct client mutation and use an authenticated Edge Function that invokes a private trusted database function. Edge orchestration cannot replace the database transaction. A database uniqueness constraint prevents duplicate completion for an occurrence (`BR-003`). The exact split is `T-02`.
- Pull incremental, permission-filtered canonical changes from Supabase using a server-issued cursor through an RLS-safe read/RPC contract. This feed must include authorized tombstones and revocations without disclosing private content. Expired cursors lead to a bounded resnapshot that preserves unacknowledged Isar outbox entries.
- Apply a canonical batch, tombstones, and new cursor in one Isar transaction. Bloc/Cubit then observes the changed repository stream. A notification or Supabase Realtime event can prompt a pull but cannot itself mutate business state. Sync on launch/resume/connectivity and while active, subject to OS background limits; correctness cannot depend on Realtime or background execution.
- Use UTC instants for transport and record the applicable civil time zone and schedule version needed to interpret each occurrence. Neither client timestamp nor arrival order alone decides eligibility. Final acceptance of late offline check-ins needs `OQ-004` and a product rule for post-deadline submission (§11).
- Reconcile server corrections visibly. A pending local check-in remains in history if rejected, with its reason and recovery path; the app must not quietly erase it (`BR-022`, `FR-022`).

### Connectivity separate from synchronization

Global reachability contains only online, offline and reconnecting/checking signals when genuinely needed. Device interface availability does not prove backend reachability. Auth/session rejection belongs to AuthSession, not a connectivity state. Syncing and syncFailed belong to future synchronization infrastructure, not NetworkState.

Shell displays a reachability projection and owns no map of action synchronization. Features or future SL-03 own Pending/Synced/Failed and durable retry/recovery, supplying values to simple badges. Repositories/SyncEngine will decide requests and retries when implemented. SL-01/SL-02 do not simulate this infrastructure. Network availability alone must not turn a safely persisted local action into failure or acknowledged remote success.

## 5. Conflict resolution matrix

| Situation | Proposed technical handling | Product decision still needed |
| --- | --- | --- |
| Duplicate/retried check-in | Stable occurrence and command IDs; server returns the first accepted outcome. One completion maximum. | Exact occurrence/deadline rule `OQ-004`. |
| Same habit edited offline on two devices | Detect revision conflict; preserve both versions and original local intent. Do not auto-merge schedule, visibility, or deletion. | **`OQ-009`:** user-facing choice and allowed merge behavior. |
| Habit edit versus later check-in | Keep historical schedule versions; validate the check-in against the applicable version, then reconcile. | Effective-time/deadline rules `OQ-004`; ambiguous backdated edits must be specified. |
| Offline social action after friend removal, challenge change, or permission change | Server rechecks current permission/state and rejects stale command; client shows Failed and recovery. | Rejoin rule `OQ-005`; friend discovery `OQ-006` where relevant. |
| Restore use/gift racing on multiple devices | Server serializes balance/request changes in one transaction, rejects overspend, returns canonical balances. | Gift cap and rate limits `OQ-001`, `OQ-002`; month boundary tied to `OQ-004`. |
| Offline check-in uploaded after challenge closes | Retain local action; server evaluates a specified acceptance window and records canonical score/final result. | **Product input:** late-arrival cutoff and whether a finalized ranking can change; linked to `OQ-004`. |
| Concurrent deletion, archive, or account deletion | Server uses explicit tombstones and authorization; device keeps rejected unsynced intent available for resolution. | Deletion/retention `OQ-010` and unsynced-data handling on sign-out/deletion. |

No device-clock-based last-write-wins policy is proposed. Conflict copy, retry, or explicit discard must be visible and auditable; discard is a user action only after clear explanation.

## 6. Streak, restore, and challenge scoring boundaries

### Personal streaks

Represent scheduled occurrences and their accepted completion/miss state as facts. A pure, versioned calculation function derives current and longest streak from ordered facts, pause intervals, applicable schedule versions, and explicit restore events. A pause suspends **personal** requirements but does not alter active challenge obligations (`BR-012`). Longest streak and historical completions remain after a miss (`BR-004`). Recalculation is possible after sync without modifying the original facts.

Restores are explicit ledger operations. The server enforces three calendar-month personal grants, no rollover, and atomic usage/transfers (`BR-005`–`BR-009`). The client may show provisional local availability, but cannot make a cross-user gift effective before server acceptance. Month time-zone semantics, eligibility window after a miss, and gift cap require product specification; this proposal does not choose them. Restore events can affect only the personal streak projection and never the challenge score ledger (`BR-007`).

### Challenge scoring

The Supabase PostgreSQL score ledger is built only from accepted ordinary check-ins linked to an eligible participant, challenge, and scheduled occurrence. Enforce a unique contribution key per participant/challenge/occurrence; completed = 1, missed = 0; ties remain ties (`FR-013`, `FR-014`, `BR-017`). Lock dates and scoring rules after start (`BR-013`). Leaving/removal stops future points and win eligibility while preserving historical participation and leaving personal habits unchanged (`FR-015`). A trusted database/Edge workflow closes the challenge at its end date and preserves a final ranking according to the approved late-arrival rule (`FR-016`); that rule is still open.

The phone may display pending personal check-ins alongside the last synchronized leaderboard, clearly labeled. It does **not** credit a challenge point or change another participant's view until the server validates the check-in. Challenge equivalence (`OQ-003`), late upload cutoff/final-ranking policy, and rejoining (`OQ-005`) must be specified before scoring implementation.

## 7. Networking, authentication, and security/privacy

The Supabase Flutter SDK remains the integration for Supabase Auth, PostgreSQL/Data API/RPC, and Realtime; the app never opens a direct PostgreSQL connection. Do not route SDK traffic through Dio. A configured Dio client handles custom HTTP integrations, suitable Edge Function HTTP endpoints, and future external APIs. Data sources/adapters receive the appropriate configured client through constructors; feature code never instantiates Dio or Supabase clients directly. Repositories hide local and remote source details from use cases.

Central Dio configuration defines base options, timeouts, and interceptors for applicable auth/header injection, correlation/request IDs, redacted request/response diagnostics, standardized transport/error mapping, and bounded safe retry. Retries require an idempotent operation or a server-enforced idempotency key; never blindly replay a mutation. The same typed failure contract is applied around Supabase SDK outcomes at the adapter boundary, without pretending those requests traversed Dio. Neither Dio nor SDK logs may contain tokens, passwords, emails, private habit content, sensitive user/friend data, service-role keys, or raw private payloads.

Sync commands and pull responses have versioned contracts. Mutations use command IDs and structured outcomes: accepted, retryable, validation rejected, authorization rejected, or revision conflict. Trusted endpoints enforce payload limits and rate limits for abuse-prone actions. Errors use stable codes; localized user messages are produced in the app.

Supabase Auth supplies the user session. Enable Row Level Security and minimum grants on every exposed table; separately review views and functions for RLS bypass and callable privileges. Test both allowed and denied access. Server operations derive the actor from the authenticated session and check resource ownership, friendship, explicit sharing, challenge membership, and admin role against current PostgreSQL state. A session or friendship alone never authorizes a habit read. Read models/change feeds project only allowed fields. Deleting or blocking a friend revokes future server access and emits local cache invalidation (`BR-018`). Admin workflows and permissions await `OQ-007`. [Supabase RLS guidance](https://supabase.com/docs/guides/database/postgres/row-level-security)

Prefer `SECURITY INVOKER` database functions where RLS can enforce the caller's access. A privileged `SECURITY DEFINER` function, if truly needed, must live outside exposed schemas, pin its search path, minimize grants, and undergo focused authorization tests. Edge Functions that use a Supabase secret/service credential are trusted server code and must verify the caller and enforce permissions explicitly; such credentials never ship in the app. PostgreSQL constraints remain the final guard for unique check-ins, gift balance integrity, and score contribution. [Supabase function guidance](https://supabase.com/docs/guides/database/functions), [Edge Function security](https://supabase.com/docs/guides/functions/auth)

Do **not** assume Isar provides database-level encryption. The selected Isar distribution/version, its Android/iOS support, and any supported at-rest encryption mechanism require validation before lock-in; Isar's upstream encryption request does not establish built-in encryption for the released package. Until a validated design is approved, use OS app-private storage and platform file protection, protect Supabase session secrets separately with platform secure storage, exclude sensitive files from inappropriate backups, and minimize locally stored peer data. If the threat model or launch law requires application-level encryption, approve and test a supported field/database protection design and key-loss/recovery behavior before release. No keys, habit text, friend identifiers, tokens, or raw private payloads go to logs, crash reports, analytics, or push payloads. [Isar encryption discussion](https://github.com/isar/isar/discussions/176), [Isar package](https://pub.dev/packages/isar)

Account deletion must remove identifying visibility as required by `BR-021`, with actual retention and legal handling pending `OQ-008`/`OQ-010`. Supabase region, backups, key rotation, and data processing terms are environment design work gated by those decisions.

## 8. Notifications and localization

### Product notifications and reminders

Schedule local habit reminders from the local schedule and reschedule after edits, pause/resume, locale/time-zone changes, and permission changes. Reminder delivery never writes a check-in (`BR-019`). Social notices originate from accepted Supabase events; a trusted Edge Function or server-side delivery workflow writes/reads the in-app event and attempts push through an approved provider. The app fetches authoritative event state when opened, reconciles it into Isar where offline access is appropriate, and exposes it through Bloc/Cubit. Delayed or failed push does not alter progress (`FR-019`). Deduplicate event IDs; do not expose private habit text in lock-screen payloads. Nudge/restore-request controls and exact limits await `OQ-002`; required transactional-notice behavior is still marked TBD in `BR-019`.

### In-app feedback

Global feedback owns only temporary app-wide success, information, warning and recoverable-error notifications through conventional Flutter presentation. Feature Cubits/screens own inline errors and retry. No global per-action feedback maps, sourceActionKey registry, persistent feature errors, background sync aggregation or future sync state. Domain/data return typed outcomes and never display UI. Transient feedback does not create product Inbox history. Future sync awareness and recovery come from real feature/SL-03 state rather than a global notification framework.

### Localization

Use ARB translations with generated accessors and localized plural/date/number formatting. Direction comes from the active locale; use start/end padding and direction-aware icons/layout rather than hardcoded left/right. User-entered habit names remain in their original language and are rendered safely within bidirectional text. Keep stable identifiers separate from localized labels. Test every P0 route, notification copy, dynamic text size, empty/error/sync state, and navigation in Arabic RTL and English (`FR-023`, `UX-012`, `NFR-009`–`NFR-011`).

## 9. Errors, observability, and environments

Define typed failures across layers: input validation, authentication, authorization, offline/transport, transient server, permanent domain rejection, revision conflict, local-storage/migration, and unexpected defect. The repository preserves the underlying command and diagnostic code. UI text states what happened and offers valid retry/recovery; it never labels a local pending action as remotely accepted. Storage corruption/migration failures stop writes and preserve a recoverable copy rather than resetting the database. Support escalation can use a redacted action/correlation ID.

Define an architecture-level `AppLogger` abstraction with structured levels/events and an allowlist of safe metadata. It receives app lifecycle, global `BlocObserver` lifecycle/transitions/changes/errors, Dio request/response/error summaries, sync engine and outbox processing, Supabase command outcomes, database migration failures, and unexpected exceptions. Associate safe request/command correlation IDs so client and server diagnostics can be joined without user content. Development enables detailed diagnostics, staging keeps useful diagnostics, and production emits minimal, redacted events. Detailed diagnostics still obey the prohibited-data list.

Never log auth tokens, passwords, private habit content, email addresses, sensitive friend/user data, service-role keys, or raw private API payloads. Do not log entire Bloc states/events, Dio bodies, SDK responses, or exception objects without a reviewed sanitizer. Emit structured diagnostics for sync batch/cursor, queue age, retries, conflicts, migration failure, notification delivery, and score-reconciliation mismatch using safe identifiers or aggregates. Client and server clocks are observed, not trusted for rule decisions. Track the PRD KPIs (`KPI-001`–`KPI-008`) using minimum necessary events; aggregate where possible and document retention/consent after launch-market review. Alert on stuck outboxes, high rejection rates, authorization anomalies, and score mismatch. The production sink, retention, and crash/analytics vendor remain `T-05`.

Use isolated **development**, **staging**, and **production** Supabase projects plus separate push and analytics credentials/configuration. Build-time environment selection is explicit; publishable client configuration may be bundled, but Supabase secret/service credentials and push provider secrets stay in server-side secret storage. Staging mirrors schema and authorization rules and uses test accounts. PostgreSQL/RLS/function changes are version-controlled database migrations, reviewed and rehearsed in staging before promotion; do not make untracked dashboard-only production schema changes. Isar application migrations are tested from supported prior versions. Release rollout, backup/restore, and retention policies are defined before production deployment. Supabase region remains gated by `OQ-008`. [Supabase migrations](https://supabase.com/docs/guides/local-development/declarative-database-schemas)

## 10. Verification strategy

Use the Lean Feature Workflow: Understand + Specify → Design Reference (if UI exists) → Plan → Implement + Test → Finalize. Consistency checking occurs during planning. The following verification targets apply proportionately to implemented responsibilities; targeted high-risk review is optional and CodeRabbit is removed from delivery.

| Level | Required evidence |
| --- | --- |
| Pure domain tests | Table/property tests for schedules, DST/time zones, missed occurrences, pauses, longest/current streak, restore ledger, ties, leave/remove, and no restore-to-score leakage. Final cases follow approved `OQ-003`/`OQ-004` rules. |
| Local repository tests | Real Isar transactions/watchers, outbox survival after restart, indexed duplicate detection, versioned data migration from prior schema, per-account isolation, tombstone handling, at-rest/backup behavior, and resnapshot without pending-action loss. |
| Sync contract/fault tests | Duplicate/reordered command delivery, request timeout after server commit, partial batch, expired cursor, auth expiry, permission revocation, multi-device edit conflict, and late check-in handling. Assert no silent loss. |
| Architecture/tooling tests | Reproducible `build_runner` output for routes, immutable/JSON types, and DI wiring; dependency-direction checks; constructor-injected fakes; global `BlocObserver` redaction; Dio interceptor/error/retry behavior without logging private payloads. |
| Supabase integration tests | Real PostgreSQL transactions/constraints and RPC/Edge paths for duplicate check-ins, gift races, challenge-score idempotency, grants/RLS allow-and-deny matrix (`PERM-001`–`PERM-009`), private habit reads/change feeds, privileged-function review, and anonymous historical results. |
| Flutter UI tests | Bloc/Cubit observation of Isar-backed state and Pending/Synced/Failed/recovery transitions; reachability projections and temporary feedback independent of feature inline errors; destructive confirmation, safe generated-route redirects, offline home/check-in, local reminder changes, screen-reader labels, large text, English and Arabic RTL. |
| Device/end-to-end tests | Android and iOS with airplane mode, restart, intermittent network, two devices, sign-out followed by sign-in as another account, push denied/delayed, time-zone change, and staging backend. Release evidence maps tests to PRD IDs. |

Use deterministic injected clocks/time zones and fixtures. Do not infer a passing release gate from tests that were not run; report unavailable checks and remaining defects explicitly.

## 11. Decisions needed before feature specifications or implementation

### Approved technical direction

| ID | Decision | Consequence |
| --- | --- | --- |
| A-01 | Feature-first pragmatic Clean Architecture and SOLID with selective internal layers; approved amendment 2026-09-30. | UI renders and dispatches intent; pure domain logic owns business rules. Introduce coordinators, use cases, repositories and interfaces only for demonstrated responsibilities or boundaries; preserve SDK isolation and inward dependencies at those boundaries. Simplify incrementally with regression tests. |
| A-02 | Isar is the local source of truth for offline-capable data, with local-first writes, durable outbox, sync metadata, and reconciliation back into Isar. | Core habit actions return without waiting for the network; local intent survives sync failures. |
| A-03 | Supabase Auth, PostgreSQL, RLS, constraints, suitable RPC/database functions, and Edge Functions for needed trusted workflows. | Supabase owns cross-user permissions, social effects, challenge scoring, and canonical shared state. Realtime is optional and never required for correctness. |
| A-04 | `go_router` with type-safe generated routes handles Flutter navigation, auth redirects, and deep links. | Avoid raw route-name strings where generated types exist; server authorization remains authoritative. |
| A-05 | Bloc/Cubit is the sole approved presentation state framework, with a global redacted `BlocObserver`. | Blocs/Cubits own presentation state and derive views from authoritative application/domain/local-data state without duplicating its ownership; they contain no database/network implementation. |
| A-06 | Explicit `get_it` registrations wire constructor-injected dependencies only from the composition/bootstrap layer. | `GetIt` lookups do not enter widgets, domain entities, use cases, or business logic; no additional service-locator framework is approved. |
| A-07 | Prefer immutable states/models, selective Freezed, applicable `json_serializable`, finite-state enums/sealed types, and reproducible `build_runner` generation. | Generated files are never edited manually; simple types may stay handwritten. |
| A-08 | Centrally configured Dio handles custom HTTP and suitable Edge Function endpoints; Supabase Flutter SDK handles Auth, Data API/RPC, and Realtime independently. | Interceptors provide applicable headers/auth, correlation IDs, redacted diagnostics, typed errors, and safe retries; no feature-created Dio or forced SDK routing. |
| A-09 | `AppLogger` is the structured, environment-aware logging boundary. | Development/staging diagnostics and minimal redacted production events cover app, Bloc, HTTP, sync/outbox, Supabase, migrations, and unexpected errors without sensitive data. |
| A-10 | ConnectivityCubit projects reachability only; startup remains unknown until evidence exists. | AuthSession owns session health; owning features or future SL-03 own sync/retry/status. Shell owns no action registry. |
| A-11 | Central `AppNotification`/`UserFeedback` presentation abstraction and reusable UI feedback components. | Global presentation owns temporary notifications only; features own inline errors/retry and sync infrastructure owns durable status. Domain/data never display notifications. |

### Remaining technical approvals

| ID | Approval or validation needed | Why it matters |
| --- | --- | --- |
| T-01 | Select and validate the maintained Isar package/distribution and Android/iOS compatibility; approve local at-rest protection, backup, and key recovery. | Isar selection is approved, but database encryption cannot be assumed. |
| T-02 | Approve versioned sync command/change-feed contracts, cursor/resnapshot behavior, and the exact RPC versus Edge Function boundary; review any privileged function and grants/RLS model. | Makes idempotency, reconciliation, and server authority implementable and testable. Product rules in the table below affect final semantics. |
| T-04 | Approve the push provider and trusted delivery workflow, plus mobile local-notification integration. | Social notifications need a server-side delivery mechanism; reminders must work offline. |
| T-05 | Approve analytics/crash provider, project isolation, and migration/release pipeline. | Determines privacy exposure, observability, and repeatable Supabase deployments; region waits for `OQ-008`. |

### Product input required; no default behavior is assumed

| PRD item / new dependency | Needed answer and affected design |
| --- | --- |
| `OQ-004` | Exact occurrence deadline, time zone, travel/DST behavior, calendar-month boundary, and whether/how late offline check-ins can be accepted. Blocks streak and challenge validation. |
| `OQ-009` | User-visible resolution for competing offline edits, including schedule/visibility/deletion cases. Blocks conflict UX. |
| `OQ-003` | Equivalent-habit rule for challenge eligibility. Blocks challenge association/scoring. |
| **New product decision: finalization** | Cutoff for late-arriving offline challenge progress and whether a finalized ranking can be amended. Must align with `OQ-004` and `FR-016`. |
| `OQ-001`, `OQ-002` | Gift receiving cap and restore-request/nudge limits. Blocks anti-abuse policy. |
| `OQ-005`, `OQ-006`, `OQ-007` | Rejoin behavior, friend identifiers/discovery, and admin report workflow. Blocks relevant social/moderation specs. |
| **New product decision: local account data** | Sign-out and subsequent-sign-in retention is resolved by SL-02: original-account-only work, sign-out warning, no dedicated switch and same-account-only resumption. Account-deletion retention and protection details still require SL-22/security decisions. Must satisfy `BR-022` and privacy expectations. |
| `OQ-008`, `OQ-010` | Launch jurisdictions/legal needs and deletion/telemetry/backup retention. Blocks production provider/region and privacy policy. |

The PRD header calls v1.0 an approved baseline, while its downstream handoff metadata still says “Draft — Ready for Product Review.” Product Owner should reconcile that document-status mismatch; this proposal treats the header and explicit product authority statement as controlling until corrected.

## 12. Foundation organization and UI policy (approved 2026-10-01)

Organize aggressively, abstract conservatively. Global systems own only genuinely global state. Do not model future infrastructure inside presentation code before that infrastructure exists. Feature-first modules use actual responsibilities: presentation/cubit, screens, widgets, sheets, dialogs; application; domain/models/repositories; data/datasources/repositories/storage. Create only populated, useful folders. Extra organization is welcome; unnecessary classes and pass-through abstractions are not.

Auth flow: Screen → AuthCubit → AuthSession → AuthRepository → AuthRepositoryImpl → SupabaseAuthDataSource → Supabase SDK. Screens dispatch raw intent. Cubit owns normalization, presentation validation, typed input errors, loading, safe feedback and completion; session independently enforces admission/lifecycle invariants, serialization, stale events, recovery and cleanup ordering. UI callbacks do not decide command outcomes. Cubit state contains only a read-only session projection updated by AuthSession; routing observes AuthSession directly. Repository is an SDK-free contract; implementation maps SDK results; data source executes SDK operations and owns awaited persistence/health barriers; SecureAuthStorage implements the secure session/PKCE hooks and queued storage health; AuthCallbackHandler validates input without owning a session. Shell uses presentation/cubit/screens/widgets only; GoRouter owns location. See implementation guides for current files and limits.

UI uses screens with meaningful sections and small widgets, values/callbacks, local temporary visual state and one clear scrolling owner. Prefer standard Flutter layout, constraints and theme/design tokens; avoid deep Cubit lookups, giant screens, a one-widget-per-file rule and speculative generic components. Keep useful shared wordmark/buttons/fields/state views where real reuse exists. Implement functional UI reasonably close to approved PNGs; verify states, interactions, obvious overflow, structural RTL, keyboard/insets, compact constraints and accessibility. Pixel-perfect polish is a later Product Owner pass; exhaustive screenshot comparison is not an implementation gate.

The focused app/bootstrap/app_bootstrap.dart composition root acquires the cold callback before resolving the lazy session. AuthStartup owns callback-before-restoration ordering and subscription cleanup; app/streak_up_app.dart composes Flutter providers/theme/locale/router, while main.dart is only the entry point. Shell chrome provides a bounded viewport; each destination owns scrolling and keyboard inset handling.

SDK auth events are secondary reconciliation for refresh, invalidation and external changes, not an independent admission authority. Account/callback generations make stale work explicit. Callback replay history is capped at 32 payload-free outcomes/pending exchanges; pending entries are never evicted. Supabase Flutter 2.17.2 persists through an unawaited listener and catches hook errors, so session-admitting operations retain a data-source-owned explicit SDK-format write plus health drain. Email-only operations use health checks without session writes. Recovery and foreign callbacks keep persistence suspended until an explicit safe reset/exit.
