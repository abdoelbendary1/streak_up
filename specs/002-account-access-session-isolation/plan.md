# Implementation plan: SL-02 — Account access and session isolation

**Branch:** reimplement/sl01-sl02 | **Amendment:** 2026-10-01
**Spec:** [spec.md](spec.md) | **Current code:** [auth guide](../../docs/features/auth/IMPLEMENTATION_GUIDE.md)

## Scope and data flow

Preserve PRD FR-001/BR-020/PERM-001, the approved email/password, verification and recovery flows, valid-session admission, serialized transitions, stale-event rejection and A → sign out → B isolation. No dedicated Switch Account feature, product database or SL-03 implementation. Lean delivery uses spec.md/plan.md; consistency checking happens in planning and tasks.md/review are optional.

Screen → AuthCubit → AuthSession → AuthRepository → AuthRepositoryImpl → SupabaseAuthDataSource → SDK. Cubit owns loading/errors; session owns authoritative lifecycle/recovery/cleanup. Callback handler validates input; OS subscription lives in bootstrap. Repository contract/models are SDK-free; implementation maps events/evidence/failures; source contains SDK operations and persistence barriers; storage owns secure auth persistence. Bootstrap wires constructor dependencies. GoRouter observes session truth without invoking auth from redirects.

## Files and state ownership

features/auth/presentation/cubit, screens, widgets and sheets; application/auth_session.dart and auth_callback_handler.dart; domain/models/auth_models.dart and domain/repositories/auth_repository.dart; data/datasources/supabase_auth_data_source.dart, data/repositories/auth_repository_impl.dart and data/storage/secure_auth_storage.dart. Form text, focus and password visibility stay local. Cleanup revokes access before clearing outgoing presentation; device reachability survives. No pass-through use cases, duplicate gateway, base repository, generic service or SDK driver.

## Data/database impact

SDK auth session and PKCE only, through secure storage; remove legacy plaintext auth values without touching unrelated preferences. No Isar collections, custom account store, schema, migration or sync/outbox. Future local work must retain original-account ownership and reopen only after same-account verification, using DATABASE.md contracts.

## Approved UI references

Exact files under docs/design/screens/002-account-access-session-isolation/:
- SL02-UI-001-sign-in.png
- SL02-UI-002-registration.png
- SL02-UI-003-email-verification.png
- SL02-UI-004-password-recovery.png
- SL02-UI-004B-password-recovery-email-sent.png
- SL02-UI-005-session-restoring.png
- SL02-UI-006-session-expired.png
- SL02-UI-007-sign-out-unsynced-warning.png

The manifest registers these approved references and supporting SL-01 RTL/design tokens. UI-008 remains retired historical material. Implement functional UI reasonably close to approved references; final polish is a later Product Owner pass, without a mandatory screenshot matrix.

## Auth and connection state

| Account state                                | Protected UI | Meaning                                                                              |
| -------------------------------------------- | ------------ | ------------------------------------------------------------------------------------ |
| restoring                                    | Hidden       | Startup/session refresh or transition unresolved; no previous-account frame.         |
| signedOut                                    | Hidden       | No established authenticated account; show access.                                   |
| verificationRequired                         | Hidden       | Unverified account; await confirmed verification.                                    |
| authenticated(accountId, evidence)           | Eligible     | Established, verified identity; activate only that account scope.                    |
| reauthenticationRequired(previousAccountId?) | Hidden       | Confirmed invalidation; retain original-account work and require new authentication. |

Network Offline and backend-unreachable are separate conditions. A previously established account may retain eligible cached personal access offline under its own boundary, without claiming current remote authorization or permitting fresh remote actions. First-time access cannot be granted offline. Only definitive auth invalidation enters reauthenticationRequired; refresh/transport failure alone does not. SL-01 connection and Pending/Synced/Failed states remain orthogonal. Local account transition success is not remote product-data acknowledgment.

Serialize SDK events and command results. Each account transition advances an epoch; reject late callbacks whose account or epoch no longer matches. Deduplicate equivalent events, and dispose subscriptions with their owner. A stale SDK event must not undo a newer explicit sign-out or subsequent sign-in as another account.

## Verification and recovery links

Registration submits email/password, then shows verificationRequired. A verification link returns via a platform deep-link boundary to Supabase SDK handling. Resolve current session and server-confirmed verified status before shell entry; opening a link or checking a local flag never passes the gate. Invalid/expired links or offline verification leave a safe retry state. Already-verified returning accounts follow sign-in/restore.

Recovery initiation sends an email request and always presents the approved generic email-sent result, including unknown emails. The reset link returns through the same allowlisted callback boundary into an isolated password-reset step backed by valid SDK recovery context. Invalid/expired context returns to safe retry. Passwords remain in memory only for submission, never in routes, feedback, logs, or analytics. After reset, resolve session and verified identity through the normal guard; the link itself does not authorize the shell.

Configure environment-specific redirect origins and Android/iOS app-link or URL handlers in Supabase Auth and platform settings. Use exact allowlists; never hardcode a production URL or parse tokens into application route/query state. Verify the resolved SDK's callback, event, email confirmation, recovery, and secure session-storage behavior during implementation.

## Typed routing and transitions

Extend existing generated typed go_router routes with top-level access, verification, recovery, restoring, and reauthentication destinations. Retain the current four-destination shell and global routes. Router refresh/redirect observes account state. Startup must show a neutral restoring route rather than unconditional /today. All shell/global routes require authenticated verified identity. Access routes redirect an already eligible account to a safe shell destination. Define a state/route redirect table and terminal routes to avoid loops.

Handle incoming auth callbacks once through a dedicated app/deep-link entry boundary, retaining origin validation and SDK PKCE handling. Redirect decisions derive deterministically from the authoritative session snapshot; they do not launch asynchronous callback ingestion. Keep saved-destination updates and consumption explicit outside redirect evaluation, with one owner and safe same-account restoration. Replace existing ingestion when introducing this boundary; do not duplicate SDK/OS handlers. Cover delayed/duplicate/invalid callbacks, cold/warm recovery and prior-account back history before adoption.

Store at most one internal sanitized protected destination after signed-out redirect. Reject external URLs, auth callbacks, credentials, account-specific query data, and stale destinations. After authentication, revalidate it under the active account; otherwise open Today. On sign-out, subsequent sign-in as another account, or confirmed invalidation, block protected rendering first, clear prior route history and saved destination, then show access or the new account. Back navigation must not reveal a prior account. Client routing never replaces server authorization.

Before SL-03 supplies an actual account-owned inventory, voluntary sign-out uses a conservative unknown-work warning. Future integration may query that inventory before transition. If pending, show approved warning and require explicit confirmation; cancel preserves the session. An unknown/failed inspection must not be called “no pending work”; show the same conservative retention warning before voluntary exit. After confirmation, close the old scope before binding another. If remote sign-out fails, hide old protected content until true SDK session state is resolved and preserve work. Confirmed expiry hides protected UI immediately, preserves work, and requires reauthentication without a voluntary warning. Reopen retained work only after canonical same-account identity is confirmed.

## Account isolation contract for SL-03

Every account-scoped operation carries a canonical AccountId and active epoch. For A → signed out/B: stop or invalidate A subscriptions/in-flight callbacks; reset A shell selection, status/feedback, destination cache, and other presentation state; close or lock A's future local store; then create a fresh B scope. No B widget, Cubit, repository, or queue may reuse A state. Apply async results only when both ID and epoch still match.

A's retained work stays keyed/stored under A and is neither deleted nor mounted for B. Future SL-03 stores use separate per-account paths and check authenticated identity before opening a store or submitting its queue. They must never infer work ownership from the UI account and may resume A only after authenticated A returns. SL-02 defines a narrow pending/none/unknown work-presence boundary; SL-03 supplies durable storage, outbox, and sync mechanics. The current repository has no product pending work to inspect; tests use owned fakes to exercise warning and isolation.

## UI and security

Use approved SL02-UI-001–008 and 004B PNGs for their scoped screens, plus approved SL-01 shell, Arabic RTL, and large-text references. The 390×844 canvas is a comparison reference, not a fixed layout. Verify under 360 logical px, at/above 600 logical px, large text, Arabic RTL, keyboard insets, short heights, safe areas, focus order, semantics, and announcements. SL02-UI-007 approves its warning sheet, not the background Profile feature content.

Map typed auth failures to localized, actionable, non-enumerating messages. Never put passwords, email addresses, tokens, recovery links, raw SDK errors, exception strings, or session payloads in AppLogger, BlocObserver, feedback, routes, or analytics. Log fixed event names and allowlisted safe metadata only; inspect SDK/platform debug logging. Clear password fields at terminal transitions. Do not create a custom credential cache.


## Implementation steps, tests and risks

Move files/imports; split SDK operations from result mapping; preserve persistence timing and lifecycle logic; remove global status/error ownership; regenerate DI/routes; run focused auth/session/SDK/callback/recovery/routing/cleanup/UI tests, then full suite/analyzer/diff checks; write actual implementation guides and reconcile state. Keep behavior assertions, adapting fixture construction only. Known release evidence still includes live Supabase configuration and real device callback/secure-storage checks; automated SDK fixtures do not imply those passed. CodeRabbit is removed from delivery. No unrelated migrations or iOS verification on Windows.

The critical risks are early SDK echoes, callback purpose/foreign identity, recovery credential persistence, cleanup failures and late A events after B admission. Preserve explicit storage barriers and identity comparison before admission. Check spec/plan/test agreement while planning; deeper artifacts are warranted only when future persistence/authorization contracts actually exist.
