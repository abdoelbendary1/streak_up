# Implementation Plan: SL-02 — Account Access and Session Isolation

**Date**: 2026-09-29 | **Spec**: [spec.md](spec.md) | **Gate**: Implementation is authorized and underway. T035 platform verification and T036 acceptance reconciliation remain open before convergence.

## Summary and authority

Integrate Supabase Auth with the completed SL-01 shell. Email/password registration and sign-in, email verification before first shell entry, email recovery, session restoration, sign-out, account switching, and confirmed invalidation follow the clarified spec. Approved [SL-02 PNGs](../../docs/design/DESIGN_MANIFEST.md) govern visuals; PRD and spec govern behavior. Retained work belongs to its original account. No product database, Isar collection, or sync engine enters SL-02.

## Technical context and constitution

| Area               | Plan                                                                                                                                                                                               |
| ------------------ | -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| Platform           | Existing Flutter app; Dart constraint ^3.11.1; Android and iOS; English LTR and Arabic RTL.                                                                                                        |
| Existing libraries | flutter_bloc, generated typed go_router, get_it/injectable, Flutter localization, shared feedback, AppLogger/RedactedBlocObserver.                                                                 |
| New library        | Add compatible supabase_flutter during implementation and lock its version. No new state-management library or Dio dependency for Auth.                                                            |
| Persistence        | Supabase SDK-managed auth session only. No application-owned account metadata, credential store, product schema, local collection, outbox, or migration. Validate SDK secure persistence behavior. |
| Scope              | SL02-FR-001–013 and SL02-AS-01–19. No habit, challenge, friend, Inbox/Profile persistence, general sync, or account deletion.                                                                      |

PRD authority, ordered delivery, recoverable local work, privacy, and focused verification are preserved. Implementation tasks T001–T034 are recorded complete; platform verification and acceptance reconciliation remain open. No constitution exception is proposed.

## Architecture and minimum contracts

Use the existing presentation → application → domain contract → data adapter direction.

- **Presentation:** Auth widgets render localized state and dispatch intent to a focused AuthCubit. Form-local editing may stay in widgets; session truth and transitions do not. Shared feedback renders typed non-secret outcomes. Widgets call neither Supabase nor GetIt.
- **Application:** One auth/session coordinator handles registration, sign-in, recovery request, restore, sign-out, invalidation, and account transition ordering. It consumes an AuthGateway, a pending-work presence contract, and an account-scope lifecycle contract. Avoid wrappers with no real boundary.
- **Domain:** Minimal immutable AccountId (canonical Supabase Auth user UUID), VerifiedAccount/session snapshot, typed auth failure/transition outcome, and AuthGateway for session lookup, auth events, email/password operations, verification refresh, recovery callback, and sign-out. No SDK types, tokens, credentials, or persistence annotations cross into domain/application. A client-provided ID or email never grants identity or authorization.
- **Data:** A Supabase Auth adapter maps SDK sessions, users, events, and failures to those contracts and owns subscriptions. Transport failure maps to indeterminate availability, never a fabricated signed-out/authenticated result. Supabase/server authorization remains authoritative for product data.
- **Composition:** Bootstrap initializes the Supabase client before resolving coordinator/router, using environment-selected URL and publishable key. Existing get_it/injectable registers constructor-injected collaborators. Never ship a service-role secret. Regenerate DI/routes from source; never edit generated files.

## Auth and connection state

| Account state                                | Protected UI | Meaning                                                                              |
| -------------------------------------------- | ------------ | ------------------------------------------------------------------------------------ |
| restoring                                    | Hidden       | Startup/session refresh or transition unresolved; no previous-account frame.         |
| signedOut                                    | Hidden       | No established authenticated account; show access.                                   |
| verificationRequired                         | Hidden       | Unverified account; await confirmed verification.                                    |
| authenticated(accountId, evidence)           | Eligible     | Established, verified identity; activate only that account scope.                    |
| reauthenticationRequired(previousAccountId?) | Hidden       | Confirmed invalidation; retain original-account work and require new authentication. |

Network Offline and backend-unreachable are separate conditions. A previously established account may retain eligible cached personal access offline under its own boundary, without claiming current remote authorization or permitting fresh remote actions. First-time access cannot be granted offline. Only definitive auth invalidation enters reauthenticationRequired; refresh/transport failure alone does not. SL-01 connection and Pending/Synced/Failed states remain orthogonal. Local account transition success is not remote product-data acknowledgment.

Serialize SDK events and command results. Each account transition advances an epoch; reject late callbacks whose account or epoch no longer matches. Deduplicate equivalent events, and dispose subscriptions with their owner. A stale SDK event must not undo a newer explicit sign-out/switch.

## Verification and recovery links

Registration submits email/password, then shows verificationRequired. A verification link returns via a platform deep-link boundary to Supabase SDK handling. Resolve current session and server-confirmed verified status before shell entry; opening a link or checking a local flag never passes the gate. Invalid/expired links or offline verification leave a safe retry state. Already-verified returning accounts follow sign-in/restore.

Recovery initiation sends an email request and always presents the approved generic email-sent result, including unknown emails. The reset link returns through the same allowlisted callback boundary into an isolated password-reset step backed by valid SDK recovery context. Invalid/expired context returns to safe retry. Passwords remain in memory only for submission, never in routes, feedback, logs, or analytics. After reset, resolve session and verified identity through the normal guard; the link itself does not authorize the shell.

Configure environment-specific redirect origins and Android/iOS app-link or URL handlers in Supabase Auth and platform settings. Use exact allowlists; never hardcode a production URL or parse tokens into application route/query state. Verify the resolved SDK's callback, event, email confirmation, recovery, and secure session-storage behavior during implementation.

## Typed routing and transitions

Extend existing generated typed go_router routes with top-level access, verification, recovery, restoring, and reauthentication destinations. Retain the current four-destination shell and global routes. Router refresh/redirect observes account state. Startup must show a neutral restoring route rather than unconditional /today. All shell/global routes require authenticated verified identity. Access routes redirect an already eligible account to a safe shell destination. Define a state/route redirect table and terminal routes to avoid loops.

Store at most one internal sanitized protected destination after signed-out redirect. Reject external URLs, auth callbacks, credentials, account-specific query data, and stale destinations. After authentication, revalidate it under the active account; otherwise open Today. On sign-out, switch, or confirmed invalidation, block protected rendering first, clear prior route history and saved destination, then show access or the new account. Back navigation must not reveal a prior account. Client routing never replaces server authorization.

For voluntary sign-out/switch, query account-owned pending-work presence before transition. If pending, show approved warning and require explicit confirmation; cancel preserves the session. An unknown/failed inspection must not be called “no pending work”; show the same conservative retention warning before voluntary exit. After confirmation, close the old scope before binding another. If remote sign-out fails, hide old protected content until true SDK session state is resolved and preserve work. Confirmed expiry hides protected UI immediately, preserves work, and requires reauthentication without a voluntary warning. Reopen retained work only after canonical same-account identity is confirmed.

## Account isolation contract for SL-03

Every account-scoped operation carries a canonical AccountId and active epoch. For A → signed out/B: stop or invalidate A subscriptions/in-flight callbacks; reset A shell selection, status/feedback, destination cache, and other presentation state; close or lock A's future local store; then create a fresh B scope. No B widget, Cubit, repository, or queue may reuse A state. Apply async results only when both ID and epoch still match.

A's retained work stays keyed/stored under A and is neither deleted nor mounted for B. Future SL-03 stores use separate per-account paths and check authenticated identity before opening a store or submitting its queue. They must never infer work ownership from the UI account and may resume A only after authenticated A returns. SL-02 defines a narrow pending/none/unknown work-presence boundary; SL-03 supplies durable storage, outbox, and sync mechanics. The current repository has no product pending work to inspect; tests use owned fakes to exercise warning and isolation.

## UI and security

Use approved SL02-UI-001–008 and 004B PNGs for their scoped screens, plus approved SL-01 shell, Arabic RTL, and large-text references. The 390×844 canvas is a comparison reference, not a fixed layout. Verify under 360 logical px, at/above 600 logical px, large text, Arabic RTL, keyboard insets, short heights, safe areas, focus order, semantics, and announcements. SL02-UI-007 approves its warning sheet, not the background Profile feature content.

Map typed auth failures to localized, actionable, non-enumerating messages. Never put passwords, email addresses, tokens, recovery links, raw SDK errors, exception strings, or session payloads in AppLogger, BlocObserver, feedback, routes, or analytics. Log fixed event names and allowlisted safe metadata only; inspect SDK/platform debug logging. Clear password fields at terminal transitions. Do not create a custom credential cache.

## Verification and implementation sequence

1. Confirm resolved Supabase Flutter/Auth SDK session persistence, events, verification/recovery APIs and configure isolated environment callback allowlists and Android/iOS handlers.
2. Add domain contracts and adapter; unit-test restore, verification, transport error versus confirmed invalidation, and late events.
3. Add coordinator/Cubit and account-scope lifecycle; test A → signed out → B → A, warning cancel/confirm, retained-work fixtures, old-epoch callbacks, and invalidation.
4. Extend typed routing/bootstrap; test startup cover, guarded routes/deep links, redirect termination, no stale frames/back-stack return, and safe post-auth fallback.
5. Build approved localized views with shared feedback; test English/Arabic RTL, compact/wide widths, text scaling, keyboard/safe area, and semantics.
6. Run focused unit/widget tests, flutter analyze/test, Android/iOS callbacks and restoration against an isolated Supabase environment, and visual comparison. Report unavailable device checks. Audit logs/routes for secrets and cross-account leaks.

**Plan checks run:** inspected SL-02 spec, project state, design manifest, Spec Kit template/constitution, relevant architecture/database/UI foundation sections, and current dependency, bootstrap, typed-route, logging, and shell entry points. No runtime tests were run because this is documentation only.

## Data Contract decision and next gate

**DATA CONTRACT REQUIRED: NO.** SL-02 introduces no application-owned persistent data needing aligned local/remote models; SDK-managed Auth persistence is infrastructure, and the account-ownership contract above governs future feature data.

**Open technical validation:** exact Supabase SDK APIs and secure persistence; environment redirect allowlists and mobile link association; cold-start callback behavior; failed remote sign-out semantics; and future SL-03 pending-work inspector/store integration. These are technical checks, not reopened product decisions. Implementation is authorized and underway. Next gate: complete or formally disposition T035, then complete T036 acceptance reconciliation before proposing SL-02 convergence.
