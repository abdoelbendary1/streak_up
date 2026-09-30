# Feature Specification: SL-01 — Bilingual App Shell and Shared Feedback

**Feature Branch**: main (no feature-branch hook configured)

**Created**: 2026-09-28

**Status**: Clarified — Design Gate Approved; Ready for Technical Planning

**Input**: Specify only the approved SL-01 bilingual app shell, primary/global navigation, English/Arabic RTL behavior, shared network/sync and user-feedback states, accessibility, and reusable shell/status behavior.

## Clarifications

### Session 2026-09-28

- Q: Should SL-01 show English or Arabic when the device locale is neither supported language? → A: Default to English when the device locale is neither English nor Arabic.

## Scope and PRD alignment

SL-01 supplies the signed-in navigation and shared presentation language that later feature slices use. It covers the Today, Habits, Challenges, and Friends destinations; global Inbox and Profile actions; an entry to Sync & Recovery when attention is needed; localized, accessible shell and status/feedback patterns. It defines what users must perceive when later features supply connection, action, or error states.

SL-01 does **not** specify the content or workflows inside those destinations. Account access belongs to SL-02; durable writes, sync execution, conflict choices, and recovery processing belong to SL-03; habit, social, challenge, Inbox, and Profile content belong to their registered slices. No product database, notification event history, locale-preference persistence, or final brand palette/font is defined here. A global navigation destination is an entry point, not authorization to implement its feature.

**Primary PRD anchors:** FR-023, FR-022; NFR-001, NFR-003, NFR-009–NFR-012; UX-003, UX-011–UX-014; P0-F013. The approved UX foundation supplies UXF-01–UXF-05 and UXF-07. The shell also respects private-data boundaries from NFR-008 and PERM-009.

## User Scenarios & Testing *(mandatory)*

### User Story 1 — Move among the main areas (Priority: P1)

A signed-in user can recognize the four primary areas and move to one with a single selection. Inbox and Profile remain reachable as global actions without being added as fifth and sixth primary destinations.

**Why this priority**: The shell is the entry point to every later P0 flow and must remain understandable in either language.

**Independent Test**: With destination content represented by labeled test surfaces, select each primary destination and each global action; verify the selected area and destination are clear without implementing that destination's feature.

**Acceptance Scenarios**:

1. **AS-01** Given the signed-in shell, when the user selects Today, Habits, Challenges, or Friends, then the selected destination is visibly and accessibly identified and its corresponding area opens.
2. **AS-02** Given any primary destination, when the user selects Inbox or Profile, then the corresponding global destination opens and the user has a predictable way back to the previous context.
3. **AS-03** Given a return from a global or detail destination, when the shell is shown again, then the primary selection reflects the area the user returned to.

### User Story 2 — Use the shell in English or Arabic (Priority: P1)

A user can understand the same navigation, status, and feedback meaning in English and Arabic. Arabic presentation follows right-to-left reading order while preserving the meaning of directional and non-directional elements.

**Why this priority**: Both languages and functional RTL parity are required for every P0 surface.

**Independent Test**: Review the shell and every shared status/feedback state with English and Arabic test content, long labels, large text, and mixed-script names without requiring any habit or social feature.

**Acceptance Scenarios**:

1. **AS-04** Given no explicit language selection, when the app opens, then the shell uses the corresponding language for an English or Arabic device locale and defaults to English when the device locale is neither English nor Arabic.
2. **AS-05** Given an explicit English or Arabic selection supplied by Profile, when the active language changes, then the shell and shared feedback use that language without changing the meaning or available actions.
3. **AS-06** Given Arabic is active, when navigation or feedback appears, then reading order, alignment, back affordance, and directional symbols follow RTL; non-directional symbols keep their meaning.
4. **AS-07** Given a date, time, or count appears in shared UI, when the language changes, then date/time formatting follows the locale and numeral glyphs use the approved 0–9 default.

### User Story 3 — Understand connection and action status (Priority: P1)

A user can tell whether the app is Online, Offline, Reconnecting, Syncing, or SyncFailed and can distinguish an action saved locally from one confirmed remotely.

**Why this priority**: Clear status prevents a locally accepted action or queued social change from being mistaken for server confirmation.

**Independent Test**: Present each shared state and Pending/Synced/Failed action state from controlled scenarios; verify wording, visual distinction, accessible announcement, and recovery entry without running actual synchronization.

**Acceptance Scenarios**:

1. **AS-08** Given the app reports one of Online, Offline, Reconnecting, Syncing, or SyncFailed, when the shell displays status, then the user receives a distinct text/accessibility explanation and the shell does not infer reachability solely from a device network interface.
2. **AS-09** Given an offline-capable action is saved locally but not acknowledged remotely, when shared feedback appears, then it identifies local success and Pending synchronization separately; it does not say the action is Synced.
3. **AS-10** Given remote acknowledgment has been reconciled, when the action status is shown, then it may be labeled Synced. Given the action is Failed, then the affected action remains identifiable and a valid retry or recovery entry is visible.
4. **AS-11** Given an auth/session problem rather than a transport problem, when action-required feedback appears, then it is not mislabeled as simple Offline and directs the user toward the account recovery path owned by SL-02.

### User Story 4 — Receive useful shared feedback accessibly (Priority: P2)

A user receives consistent success, information, warning, recoverable error, offline, sync, or action-required feedback. Repeated background updates do not interrupt the main task.

**Why this priority**: Shared feedback must remain helpful across later features without burying the daily action or creating contradictory messages.

**Independent Test**: Feed the shell repeated success, failure, and network-state scenarios and review the shared presentation in both languages with assistive technology and large text.

**Acceptance Scenarios**:

1. **AS-12** Given a user-visible outcome, when feedback is appropriate, then its message, severity, and any valid action are consistent across shell surfaces and distinguishable without color.
2. **AS-13** Given several repetitive background sync updates, when feedback is presented, then they are grouped or suppressed rather than producing a separate transient message for every operation.
3. **AS-14** Given a persistent failure requiring action, when a transient message is dismissed, then the affected item or shared recovery entry continues to expose the failure and next valid action.
4. **AS-15** Given a screen reader or enlarged text is in use, when navigation or status changes, then controls remain labeled, focus order follows the visual reading order, and important state changes are announced without hiding the main action.
5. **AS-16** Given shared content is loading, when the shell displays its state, then it is not labeled empty. Given it is truly empty and a next action is known, then the shared empty state explains that action; an inline error remains distinguishable from both.
6. **AS-17** Given a global status indicator or transient feedback, when sensitive habit or friend details exist elsewhere in the app, then the global surface does not reveal them and the transient message is not presented as a persistent Inbox event.

### Edge Cases

- A network interface exists but the backend is unreachable: the shell must not call that state Online.
- Network reachability returns while pending actions remain: Reconnecting/Syncing and pending work must be distinguishable until remote acknowledgment.
- One action is Failed while others remain Pending: the shared summary cannot imply that all actions succeeded or failed.
- A user dismisses a global banner while an individual action still requires recovery: the action-level failure remains discoverable.
- Arabic text expands, the device uses large text, or the screen is narrow: primary/global actions and critical feedback remain readable and reachable.
- Mixed English/Arabic user text appears inside a shared message: surrounding punctuation and numbers remain understandable.
- A later feature has not yet supplied a destination's content or a live status source: SL-01 defines the entry and presentation contract only; its spec does not invent placeholder product behavior or synthetic success.

## Requirements *(mandatory)*

### Functional Requirements

- **SL01-FR-001**: The signed-in shell MUST expose exactly four labeled primary destinations: Today, Habits, Challenges, and Friends.
- **SL01-FR-002**: Selecting a primary destination MUST open its corresponding area and clearly identify it as selected visually and to assistive technology.
- **SL01-FR-003**: Inbox and Profile MUST be available as global actions from the main shell, with a predictable return to the user's prior context.
- **SL01-FR-004**: The shell MUST expose a stable Sync & Recovery entry when pending work or a failure needs user awareness or action, without obstructing the primary task.
- **SL01-FR-005**: The shell MUST follow an English or Arabic device locale initially, default to English when the device locale is neither English nor Arabic, and MUST display an explicit English or Arabic choice supplied later by Profile. SL-01 MUST NOT define how Profile stores that choice.
- **SL01-FR-006**: All SL-01 labels, explanations, actions, and shared feedback MUST be available in English and Arabic with equivalent meaning.
- **SL01-FR-007**: Arabic presentation MUST support RTL navigation order, reading order, alignment, back affordance, and directional symbols; elements whose meaning is not directional MUST retain their orientation.
- **SL01-FR-008**: Shared date/time presentation MUST be locale-aware, and shared numeric presentation MUST use 0–9 numeral glyphs as the current approved default.
- **SL01-FR-009**: The shell MUST provide distinct user-facing explanations for Online, Offline, Reconnecting, Syncing, and SyncFailed when those states are reported; a network interface alone MUST NOT be presented as proof of backend reachability.
- **SL01-FR-010**: An auth/session issue reported to the shell MUST be communicated as an action-required account issue rather than merely Offline; account recovery behavior remains SL-02 scope.
- **SL01-FR-011**: Shared action-status patterns MUST distinguish Pending, Synced, and Failed where ambiguity would mislead the user, and MUST distinguish local save from remote acknowledgment.
- **SL01-FR-012**: Failed action feedback MUST keep the affected action discoverable and present a valid retry or recovery entry; SL-01 MUST NOT define retry, conflict resolution, or sync execution.
- **SL01-FR-013**: Shared feedback MUST support success, information, warning, recoverable error, offline, sync-status, and action-required messages in a consistent presentation.
- **SL01-FR-014**: Repeated background sync events MUST be grouped or suppressed; a persistent banner MUST be reserved for awareness or action that remains important. Dismissing transient feedback MUST NOT hide an unresolved failure.
- **SL01-FR-015**: Shared navigation, status, and feedback MUST have meaningful labels, accessible focus order and state announcements, usable touch targets and large-text layouts, reduced-motion alternatives, and a non-color-only distinction for important states.
- **SL01-FR-016**: Reusable shell/status/feedback patterns MUST accommodate loading, empty, offline, and inline error contexts. An empty state MUST explain the next valid action when one is known; loading MUST NOT be mistaken for empty, and Pending MUST NOT be mistaken for remote confirmation.
- **SL01-FR-017**: Global indicators and feedback MUST avoid disclosing private habit content or sensitive user/friend details. Transient user feedback MUST remain distinct from persistent product Inbox events.

### PRD traceability

| SL-01 requirements | PRD and approved-foundation source | Boundary carried into later slices |
| --- | --- | --- |
| SL01-FR-001–004 | FR-022; UX-003, UX-014; UXF-02, UXF-04 | Destination content: SL-02, SL-04 onward, SL-11, SL-21; recovery processing: SL-03. |
| SL01-FR-005–008 | FR-023; NFR-010, NFR-011; UX-012; UXF-07 | Profile language selection/persistence: SL-11. |
| SL01-FR-009–012 | FR-022; NFR-003, NFR-012; UX-003, UX-014; UXF-04 | Reachability and sync sources/retries: SL-03; account/session handling: SL-02. |
| SL01-FR-013–014 | FR-022; UX-003, UX-014; UXF-01, UXF-04 | Feature outcomes originate in their owning slices; product event history: SL-21. |
| SL01-FR-015–016 | NFR-001, NFR-009–NFR-011; UX-011–UX-013; UXF-03 | Approved PNG references and the Design System govern visual styling; the approved SL-01 variants are registered in the Design Manifest. |
| SL01-FR-017 | NFR-008; PERM-009; UXF-04 | Authorization and private data handling remain with owning product slices. |

### Acceptance coverage

| SL-01 requirement | Acceptance scenario(s) |
| --- | --- |
| SL01-FR-001–003 | AS-01–AS-03 |
| SL01-FR-004 | AS-10, AS-14 |
| SL01-FR-005–006 | AS-04, AS-05 |
| SL01-FR-007–008 | AS-06, AS-07, AS-15 |
| SL01-FR-009–010 | AS-08, AS-11 |
| SL01-FR-011–012 | AS-09, AS-10, AS-14 |
| SL01-FR-013–014 | AS-12–AS-14 |
| SL01-FR-015 | AS-06, AS-08, AS-12, AS-15 |
| SL01-FR-016 | AS-16 |
| SL01-FR-017 | AS-17 |

## Success Criteria *(mandatory)*

### Measurable Outcomes

- **SC-001**: In the signed-in shell acceptance review, all four primary destinations and both global actions are reachable in one selection and have an unambiguous selected/destination label in English and Arabic on Android and iOS.
- **SC-002**: Every scripted Online, Offline, Reconnecting, Syncing, SyncFailed, Pending, Synced, and Failed scenario has a distinct text or spoken explanation; no scripted local-only action is described as remotely Synced.
- **SC-003**: In every scripted persistent-failure scenario, the affected action or recovery entry remains discoverable after transient feedback is dismissed.
- **SC-004**: The bilingual accessibility review finds zero critical shell controls or status messages that are clipped, unlabeled, reachable only by color, or blocked by large text/RTL layout in the agreed device test matrix.
- **SC-005**: All reviewers in the agreed bilingual comprehension review can explain without prompting the difference between an offline local save, a pending remote action, a synchronized action, and an action requiring recovery; any misunderstanding is corrected and reviewed again before SL-01 is accepted.
- **SC-006**: In repeated-background-event scenarios, the main task remains available and no individual sync operation produces its own redundant transient message.

## Assumptions

- SL-01 is the signed-in shell defined by UXF-02. Actual authentication and signed-out screens are specified in SL-02.
- Other slices supply destination content, action outcomes, connection/sync signals, and recovery actions. SL-01 specifies their common presentation and navigation affordances, not their rules.
- Device locale is the starting language. Profile's explicit language control and preference persistence are specified in SL-11; SL-01 responds to the active language supplied to it.
- No new product data entity is created by SL-01. Its navigation and feedback states are presentation concepts.
- The approved visual identity and screen PNGs establish palette, logo, icon, and common layout direction. The exact typeface is not approved, and the approved SL-01 variants are tracked in docs/PROJECT_STATE.md. This specification does not decide visual tokens or screen layouts.


