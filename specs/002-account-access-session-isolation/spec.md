# Feature Specification: SL-02 — Account Access and Session Isolation

**Feature Branch**: 002-account-access-session-isolation (specification directory; no branch change required)
**Created**: 2026-09-29
**Status**: Clarified — Ready for PNG Design
**Input**: Specify only SL-02 account access, session transitions, and account isolation. No implementation, technical plan, tasks, schema, or PNG design is authorized.

## Scope and authority

SL-02 lets a person register and sign in with email and password, initiate password recovery by email, restore an existing authenticated session, and sign out. Email verification is required before first entry to the signed-in shell. It controls entry into the completed SL-01 signed-in shell and prevents a previous account's local or visible data from crossing into another account. Supabase Auth is the approved identity provider. The Supabase project exists; production product schemas, Isar models, outbox, and sync cursor do not.

**PRD and governance anchors:** FR-001, BR-020, BR-022, NFR-001, NFR-002, NFR-007–NFR-011, PERM-001, FLOW-001, P0-F001, and the Constitution's privacy, traceability, and recoverability principles. The approved architecture and database foundation establish account-scoped local data and server-side authorization. English/Arabic RTL behavior uses the SL-01 shell and UI/UX foundation.

This specification does not define habit, streak, reminder, challenge, friend, Inbox history, or Profile feature behavior. General offline synchronization, durable outbox, conflict resolution, and product-data persistence belong to SL-03 and later slices. Account deletion belongs to SL-22. Product-data permissions remain server-enforced; entering a client route never grants authorization.

## User scenarios and acceptance

### User Story 1 — Gain account access (Priority: P1)

A new or returning user can reach the signed-in shell through the approved account-access flow. A user who cannot sign in can initiate password recovery without exposing another account.

**Independent test:** Exercise registration, sign-in, recovery initiation, failed credentials, and safe shell entry with controlled account outcomes.

1. **SL02-AS-01** Given signed-out state and a reachable auth service, when a new user registers with email and password, then the app explains the email-verification step and does not open the signed-in shell until the email is verified and an authenticated session is established.
2. **SL02-AS-02** Given signed-out state, when a user signs in with valid email and password and the account meets the approved email-verification requirement, then the user enters the SL-01 shell for that account.
3. **SL02-AS-03** Given failed authentication or incomplete input, when the attempt returns, then the user receives localized, actionable feedback and no previous-account data, secret, or protected destination appears.
4. **SL02-AS-04** Given a user needs access help, when password recovery is initiated by email, then the app reports a safe outcome without disclosing whether another person's account exists.
5. **SL02-AS-05** Given the device or auth service is unreachable, when registration, sign-in, or recovery is attempted, then the app explains that the request cannot complete now and does not claim the user is signed in.

### User Story 2 — Restore and protect the active session (Priority: P1)

On launch or return, the app determines which account, if any, can enter the existing signed-in shell. A temporary network failure is not treated as proof of session invalidation.

**Independent test:** Supply controlled restoring, authenticated, offline, backend-unreachable, and confirmed-invalid states; inspect rendered content and navigation.

1. **SL02-AS-06** Given a stored session is being restored, when the app starts, then a neutral restoring state appears and no account's protected content is shown until the account boundary is established.
2. **SL02-AS-07** Given a restored valid authenticated session, when restoration completes, then the SL-01 shell opens for that account and only its eligible local data can be presented.
3. **SL02-AS-08** Given no authenticated session, when a protected route or saved destination is opened, then the user reaches account access; after authentication, only a still-valid, authorized destination may open, otherwise a safe default opens.
4. **SL02-AS-09** Given a previously authenticated account with permitted cached personal data, when the device is offline or the backend is unreachable without confirmed session invalidation, then the app does not automatically mark the user signed out; locally available personal access follows the approved account boundary, while remote actions remain unavailable or pending under their owning features.
5. **SL02-AS-10** Given a protected route is open, when session invalidation is confirmed, then protected content and stale account UI cease to be visible before reauthentication is requested.

### User Story 3 — Sign out or use another account safely (Priority: P1)

A person can leave the current account and sign in to another account on the same device. Account A's local data and queued work never appear or execute under Account B.

**Independent test:** Move from Account A to signed-out and Account B states using distinct local fixtures, including pending-work fixtures; verify no cross-account view or action.

1. **SL02-AS-11** Given Account A has unsynced local work, when the user requests sign-out, then the app warns that work remains only on this device under Account A and will resume only after Account A signs in again; the user may explicitly proceed, after which the signed-out state replaces Account A's protected UI.
2. **SL02-AS-12** Given Account A has locally stored data, when Account B becomes active, then no Account A cached content, local action, status, queue, or previous navigation context is visible in Account B's session.
3. **SL02-AS-13** Given Account B is active, when any account-scoped local or remote operation is attempted, then it is scoped to Account B; Account A's pending work cannot be submitted using Account B's identity.
4. **SL02-AS-14** Given Account A has unsynced local work, when the user switches to Account B, then the app gives the same explicit warning before allowing the switch, retains the work locally under Account A only, and never displays or synchronizes it under Account B. When Account A signs in again, its retained work becomes available to resume and synchronize under Account A's identity.
5. **SL02-AS-15** Given a sign-out or account transition is in progress, when it succeeds or fails, then the app shows only the resulting account's eligible UI or a safe account-access state, without briefly rendering previous-account content.

### User Story 4 — Recover from an invalid session (Priority: P1)

The app distinguishes a confirmed expired or invalid session from ordinary Offline status and guides reauthentication without losing the account boundary.

**Independent test:** Feed confirmed invalidation separately from transport and backend failures, including on a protected route and with pending local work.

1. **SL02-AS-16** Given a confirmed expired or invalid session, when the state is reported, then the app requests reauthentication, removes stale protected UI, and does not label the issue merely Offline.
2. **SL02-AS-17** Given only a device-offline or backend-unreachable signal, when no invalidation is confirmed, then the app does not infer sign-out or discard the locally cached account boundary.
3. **SL02-AS-18** Given Account A's session expires while unsynced work exists, when invalidation is confirmed, then the app preserves Account A's local work, hides protected UI, and requires reauthentication. Only after the same Account A identity is confirmed does its work become available to resume and synchronize.
4. **SL02-AS-19** Given reauthentication succeeds for a different account, when its session opens, then the previous account's UI, local data, and pending work remain inaccessible to the new account.

## Functional requirements

- **SL02-FR-001**: Provide email-and-password registration and sign-in, and password-recovery initiation by email (FR-001); these new requests require a reachable auth service.
- **SL02-FR-002**: Require email verification before a newly registered account first enters the SL-01 signed-in shell; shell entry also requires an established authenticated account. Route access alone is not product authorization (BR-020, NFR-007).
- **SL02-FR-003**: Represent signed out, restoring, authenticated, and confirmed expired/invalid session as distinct account states.
- **SL02-FR-004**: Represent device Offline and backend unreachable as separate connection conditions; neither alone changes the account state to signed out or invalid (NFR-002).
- **SL02-FR-005**: Permit a previously authenticated account's eligible cached personal access while offline under its own account boundary; do not promise fresh login or first-time remote access offline.
- **SL02-FR-006**: Remove protected and previous-account UI when sign-out, account switch, or confirmed invalidation changes the active account.
- **SL02-FR-007**: Prevent Account A's cached/local data, pending work, and navigation state from being presented or executed as Account B; require account identity at every account-scoped boundary.
- **SL02-FR-008**: Preserve Account A's unsynced local work under Account A only across sign-out, account switch, and confirmed session expiry (BR-022). Before voluntary sign-out or account switch, show an explicit consequence warning and allow the user to proceed. Account B cannot view, change, or synchronize Account A's work. Account A's work becomes available to resume and synchronize only after Account A signs in or reauthenticates and the same account identity is confirmed. Session expiry preserves the work, hides protected UI, and requires reauthentication without deleting local intent.
- **SL02-FR-009**: Keep session secrets and credentials out of UI feedback, URLs, logs, analytics, and other account-visible surfaces; failed attempts must not disclose another user's private information (FR-001, NFR-007).
- **SL02-FR-010**: Restore an existing session before showing protected content; handle unavailable auth verification without falsely declaring the session valid or invalid.
- **SL02-FR-011**: Resolve saved/protected destinations against current authentication and authorization after transitions; use a safe default or unavailable state if the destination is no longer eligible.
- **SL02-FR-012**: Localize all SL-02 states and actions in English and Arabic with RTL, large text, safe-area, keyboard, and accessibility support (NFR-009–NFR-011).
- **SL02-FR-013**: Provide comprehensible, non-secret feedback for pending, failed, and completed account transitions; do not present local account-boundary success as remote product-data synchronization.

## Session and privacy boundaries

| Concept | Required meaning |
| --- | --- |
| Signed out | No active authenticated account may display protected content. |
| Restoring session | Account state is being resolved; no stale protected content is shown. |
| Authenticated | An established account identity may enter the shell; server authorization still governs product data. |
| Locally cached authenticated state | Previously established account context for eligible offline personal access; not proof of current backend reachability or permission for fresh remote requests. |
| Session expired/invalid | A confirmed auth rejection or invalidation requiring reauthentication, distinct from transport failure. |
| Device Offline | Device network availability is absent; it does not itself revoke a session. |
| Backend unreachable | Service cannot be reached or verified; it does not itself prove session invalidation. |

Account isolation applies to displayed data, in-memory presentation state, local persistence when later added, pending work, and route history. Supabase Auth identifies the account; no client-supplied account ID grants access. No production product table, Isar collection, custom credential store, or sync engine is specified here.

## Clarifications

### Session 2026-09-29

1. **Unsynced account work:** The Product Owner approved local retention under the original account only. Voluntary sign-out or account switch is allowed after an explicit warning that pending work remains on this device and can resume only when that same account signs in again. Another account cannot see, modify, or sync it. Confirmed session expiry preserves the work, hides protected UI, and requires reauthentication; work resumes only after the same account identity is confirmed. SL-03 owns the later sync mechanics.
2. **Account access method:** The Product Owner approved email-and-password registration and sign-in, password recovery by email, and email verification before first signed-in shell entry. Other account-access methods are outside SL-02 unless separately approved.

## Dependencies and exclusions

SL-01 supplies the signed-in shell, localized navigation, and shared feedback/status patterns. SL-02 supplies the account/session boundary that SL-03 and later account-scoped local persistence must obey. SL-03 owns the general sync engine, durable queue, and conflict mechanics. SL-11 owns Profile content and persisted language choice. SL-22 owns account deletion. This spec does not define their product flows or storage contracts.

## Success criteria

- **SL02-SC-001**: All SL02-AS-01–19 pass in English and Arabic RTL on Android and iOS, or unavailable platform verification is explicitly recorded.
- **SL02-SC-002**: Account A content or pending work is never observable or executable in Account B or signed-out state in the defined transition tests; zero known cross-account disclosure defects.
- **SL02-SC-003**: Every confirmed invalidation removes stale protected UI; Offline and backend-unreachable cases never automatically become Signed Out in the defined state tests.
- **SL02-SC-004**: Sign-out, account switch, and confirmed session-expiry tests each verify retained work, the required warning or reauthentication state, and same-account-only resumption.

## PNG screens and states needed after clarification

Sign In, Registration and Email Verification, Password Recovery by Email initiation/result, Session Restoring, Signed Out, and Session Expired/Reauthentication Required need feature design. Sign-out and account-switch warning/confirmation states with unsynced work also need design. Reuse approved SL-01 shell/status visuals where applicable; no new PNG is approved by this specification.