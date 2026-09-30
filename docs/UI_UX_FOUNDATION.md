# StreakUp UI/UX Foundation

| Field | Value |
| --- | --- |
| Status | **Approved Foundation — UXF-01 through UXF-08 approved by Product Owner** |
| Date | 2026-09-28 |
| Phase | UI/UX Foundation |
| Product authority | [PRD v1.0](PRD.md) |
| Engineering boundaries | [ARCHITECTURE.md](ARCHITECTURE.md) and [DATABASE.md](DATABASE.md) |
| Governance | [StreakUp Constitution](../.specify/memory/constitution.md) v1.0.0 |

This document defines the approved visual and interaction foundation for Android and iOS. It is not a set of final screen designs or permission to implement Flutter UI. Feature specifications must still clarify open product rules and follow the approved design workflow: Feature Specification → Clarification → PNG UI Design → Design Approval → Technical Plan → Tasks → Implementation → Visual Verification. P0 flows, English/Arabic, RTL, privacy, and offline recovery are the design baseline (`CON-001`–`CON-004`, `NFR-002`–`NFR-012`). Stable design rules are recorded in [DESIGN_SYSTEM.md](design/DESIGN_SYSTEM.md); approved reusable PNG references and feature screen PNGs live under `docs/design/references/` and `docs/design/screens/<feature-id>/` respectively.

## 1. Product design direction

**Approved direction (UXF-01):** A calm daily workspace with restrained, encouraging progress cues and clear social context. The first visual priority is the next eligible habit action and its state; the second is personal continuity; social competition remains easy to reach without crowding the daily task. Success feedback should acknowledge the local check-in immediately, while the sync label separately states whether Supabase has accepted it (`FLOW-001`, `UX-001`–`UX-003`). Use encouraging, non-shaming copy for misses, nudges, and restore requests (`UX-007`).

Use Flutter's Material 3 component behavior as the interaction base, with StreakUp-specific color, typography, shape, and motion tokens. This offers established mobile controls while leaving room for a distinct brand. A fully custom component set would require more accessibility and platform behavior work; a wholly platform-native split could make English/Arabic parity harder to maintain. The foundation is approved; final visual choices are pending visual approval through the PNG design workflow. [Flutter Material guidance](https://docs.flutter.dev/ui/design/material)

Keep P0 content prominent. P1 statistics, detailed challenge history, richer discovery, fine-grained notification preferences, dedicated archive browsing, and onboarding do not become implied P0 screens (`P1-F001`–`P1-F008`). No public feed, public leaderboard, reward store, or AI coach appears in the information architecture (`§5.3` of the PRD).

## 2. Approved navigation model

**Approved direction (UXF-02):** A signed-in four-destination bottom navigation: **Today**, **Habits**, **Challenges**, **Friends**. A globally reachable Inbox action opens notifications; a globally reachable profile/avatar action opens Profile and account settings. This keeps the main habit and social tasks visible while avoiding a fifth persistent label in Arabic. The alternative is five destinations with Profile in the bar; that may improve Profile discovery but uses more width and needs RTL/text-scaling validation.

| Navigation layer | Destination and purpose | Entry/return behavior |
| --- | --- | --- |
| Signed-out flow | Sign in, register, password recovery | Outside the main shell; protected destinations return safely after successful authentication (`FR-001`). |
| Main shell | Today, Habits, Challenges, Friends | Each destination retains its own navigation history where practical. Android back and iOS back gestures return predictably; no permission can be gained through a route. |
| Global actions | Inbox, Profile, Sync & Recovery when an action needs attention | Available from a stable app-header location; badges never reveal private content. |
| Detail flows | Habit detail/edit, challenge detail/leaderboard/create, friend requests/shared progress, restore flows | Open from their owning destination; return to the originating context. Notification links resolve current access before showing content. |

`go_router` is the approved routing technology. Route names, transition animations, and exact deep-link paths are implementation details. A route guard guides the signed-in experience; Supabase remains authoritative for access (`PERM-001`–`PERM-009`). When a link refers to deleted or no-longer-permitted content, show a safe unavailable state without confirming whether a private habit exists. Offline personal destinations load Isar data. Social destinations may show only locally available, permitted metadata and a clear stale/unavailable state; they must not imply a remote action has completed (`FR-020`–`FR-022`).

## 3. Information architecture

| Area | Main content/actions | Source and privacy boundary | PRD links |
| --- | --- | --- | --- |
| Today | Due occurrences, Pending/Completed/Missed, quick check-in, personal streak context, relevant reminder/challenge summary | Owned Isar state first. Challenge score remains last confirmed Supabase result. | `FR-004`–`FR-006`, `FLOW-001` |
| Habits | Owned habit list, create/edit, schedule, visibility, reminders, pause/resume/archive/deletion controls, history | Owned Isar state; private by default. | `FR-002`, `FR-003`, `FR-009`, `BR-001`, `BR-011` |
| Challenges | Own invitations, participating challenges, details, participant progress, leaderboard, creation and lifecycle actions | Supabase-confirmed shared state; pending actions labeled locally. | `FR-012`–`FR-016`, `FLOW-002`, `FLOW-005` |
| Friends | Requests, relationships, permitted shared progress, nudges, restore requests/gifts | Only explicitly shared progress; private habits are undiscoverable. | `FR-008`, `FR-010`, `FR-011`, `FR-017` |
| Inbox | Approved social/product events and their destinations | In-app records from accepted events; push receipt is never the source of truth. | `FR-019`, `BR-019` |
| Profile & settings | Basic profile/progress, account actions, language proposal, sync/recovery entry | Owned state; account/session boundaries remain visible. | `FR-018`, `FR-022`, `FR-023` |

Information order within each area follows task frequency and consequence. Today never mixes a private habit into a friend's view. The challenge leaderboard does not expose underlying private habit details. A personal Streak Restore is visually and verbally separate from challenge points (`BR-007`, `PERM-009`).

## 4. Core screen map

This is a route/template inventory for design planning, not a final screen count or layout specification.

| Screen or template | P0 responsibility | Key states to represent |
| --- | --- | --- |
| Sign in / Register / Password recovery | Account access (`FR-001`) | Validation, loading, failed auth, safe return destination. |
| Today | Due habits and immediate check-in (`FR-004`, `FR-005`) | No habits, no habits due, all due complete, missed, offline, local pending, failed sync. |
| Habits list | Reach all owned habits and creation (`FR-002`, `FR-003`) | Active, paused, empty; archive/deletion controls without implying P1 dedicated archive browsing. |
| Create/Edit Habit | Name, optional details, schedule, reminder, visibility, optional target (`FR-002`) | Private default, validation, offline save, pending visibility change, future-only edit warning. |
| Habit detail/history | Current/longest streak, completion history, lifecycle and Restore entry (`FR-003`, `FR-006`, `FR-007`) | Pending/Completed/Missed; paused; restore available/unavailable; locally provisional result. |
| Restore use / request / gift decision | Explicit personal restore use and friend transfer (`FR-007`, `FR-008`) | Balance and consequence, pending request, accept/decline, failed transfer, no challenge point added. |
| Challenges list / invitations | Find own challenges and act on invitations (`FR-012`, `FR-013`) | No challenges, invited, pending action, active, completed. |
| Challenge create/configure | Name, duration/dates, goal, association, friend invites (`FR-012`) | Validation, pre-start only edits/cancel, rules awaiting `OQ-003`. |
| Challenge detail / leaderboard | Progress, valid scores, ties, participant state (`FR-013`–`FR-016`) | Synced ranking, pending personal check-in, left/removed, closed, unavailable offline. |
| Friends / requests / permitted progress | Add/respond/remove; view explicitly shared information (`FR-010`, `FR-011`) | No friends, pending request, removed friend, no shared progress; private habits absent. |
| Inbox | Friend/challenge/restore/nudge events (`FR-019`) | Empty, unread, stale/offline, unavailable destination. |
| Profile / settings | Profile summary, account, relevant notification/language entry (`FR-018`, `FR-023`) | Local profile edit pending/failed; sign-out with unsynced data requires product rule. |
| Sync & Recovery | Explain Pending/Synced/Failed and offer retry/recovery (`FR-022`) | Queue progressing, persistent failure, conflict, no data loss, safe navigation back to affected item. |

Reporting/admin screens and richer P1 experiences depend on the relevant PRD clarification and release priority (`OQ-007`, `P1-F001`–`P1-F008`). This map does not grant scope to a new admin console.

## 5. Design system foundation

### Tokens, typography, spacing, color, motion

| Foundation | Approved foundation rule | What remains open |
| --- | --- | --- |
| Tokens | Define semantic tokens for surface, text, primary action, borders, focus, status, visibility, spacing, radius, and elevation. Components use roles, not one-off values. | Final brand palette, illustration style, and icon set are pending visual approval (`UXF-03`). |
| Typography | A compact hierarchy: page title, section title, body, supporting text, action/label, numeric emphasis. Use fonts with complete English and Arabic coverage; test Arabic line height and weight rather than assuming Latin metrics transfer. Support device text scaling and mixed-script user names. | Exact font family/weights and any change to the approved 0–9 numeral default are pending visual approval (`UXF-03`, `UXF-07`). [Flutter typography](https://docs.flutter.dev/ui/design/text/typography) |
| Spacing | Use a 4-unit base with an 8-unit rhythm for common padding/gaps; starting steps 4, 8, 12, 16, 24, 32. Respect safe areas, keyboard insets, and expanded text. | Exact densities and screen-specific dimensions are pending visual approval (`UXF-03`). |
| Color | Choose a limited brand primary, neutral surfaces/text, and separate semantic roles for completion, pending, failed, missed, private, shared, and challenge score. Pending/offline are informational; Failed demands attention; missed is neutral and non-shaming. Pair every color with text/icon/shape. | Final colors and light/dark theme scope are pending visual approval (`UXF-03`). |
| Motion | Brief local check-in feedback may reinforce completion; sync acknowledgment is a separate subtle transition. Avoid motion as the only signal, respect reduced-motion settings, and prevent distracting competitive effects. | Exact timing/animation language is pending visual approval (`UXF-03`). |

Material 3 is the approved component foundation, not a mandate to adopt its default color palette. A final color set should be checked against contrast targets before approval. Use at least a 48 logical-pixel target for primary touch controls as a design default and validate platform guidance; Flutter's [accessibility testing guidance](https://docs.flutter.dev/ui/accessibility/accessibility-testing) includes target-size checks. Use WCAG 2.2 AA contrast as a design reference: 4.5:1 for normal text and 3:1 for large text, subject to launch-market legal review (`OQ-008`). [WCAG 2.2](https://www.w3.org/TR/WCAG22/)

### Reusable components and variants

Design component **families and states**, not final feature screens, before Flutter implementation:

- App shell: labeled bottom navigation, global Inbox/Profile actions, page header, safe-area layout.
- Habit row/card: due state, check-in action, current streak, reminder, private/shared badge, local sync badge. Do not overload one card with every metric.
- Status: occurrence Pending/Completed/Missed; sync Pending/Synced/Failed; offline banner; retry/recovery entry. The two kinds of “Pending” need different labels/context.
- Progress: personal streak summary, longest-streak label, Restore allowance/usage, challenge score row, tie label. Personal and challenge symbols must stay distinct.
- Social: friend request, shared-progress summary, challenge invitation, nudge/restore-request item, participant state.
- Forms: labeled field, helper/error text, schedule selector, visibility selector, reminder control, validation summary, primary/secondary/destructive buttons.
- Feedback: loading placeholder, empty-state panel, inline error, persistent failed-action panel, confirmation dialog/sheet, success message.

Each family needs relevant interaction, disabled, loading, offline, Pending, Failed, English, Arabic/RTL, large-text, and screen-reader variants. Component names here describe design assets, not Flutter classes or database records.

## 6. Forms and confirmations

- Put field labels outside editable values; mark required versus optional information. Show validation near the field and in an accessible summary when a long form fails. Preserve entered values after recoverable errors (`UX-004`).
- Habit creation starts **Private** and makes Shared an explicit choice with a concise explanation of who may see progress (`BR-001`, `UX-008`). A future-facing edit explains that history remains unchanged (`BR-011`). Saving an offline-capable personal edit completes locally and shows Pending sync without blocking on the network (`FR-020`, `UX-010`).
- Challenge creation and invitations show locked rules and dates before submission; exact equivalent-habit guidance waits for `OQ-003`. Offline social submission is labeled queued, not sent to friends (`BR-023`).
- Use explicit confirmation for permanent habit deletion, account deletion, leaving a challenge, removing a participant, and pre-start challenge cancellation. Explain the concrete consequence and label the destructive action; do not rely on color (`UX-005`, `UX-009`, `FLOW-005`). Account-deletion copy waits for legal/retention decisions (`OQ-008`, `OQ-010`).
- Streak Restore use must show that one limited personal restore is consumed and that no challenge point changes (`UX-006`, `BR-007`). Accepting a Restore gift requires **consequence-first confirmation**: state that one Restore will be deducted from the giver's own available allowance, then ask for explicit confirmation (`UXF-06`, `PERM-007`).
- When a privacy reduction or friend removal is queued offline, clearly state that the change is **saved locally** and will take effect for other users **only after successful sync**. Show a visible Pending state and recovery if sync fails; do not claim remote access has already ended (`UXF-08`, `BR-023`). Exact localized copy is reviewed with the affected feature design.

## 7. Loading, empty, error, offline, and sync states

| State | User-facing behavior | Required distinction |
| --- | --- | --- |
| Opening local data | Show a brief skeleton or labeled progress while Isar opens; then render cached personal content. | Do not show an empty state before local loading has finished. |
| Refreshing remote data | Keep existing local content usable and show a quiet refresh indicator. | A remote refresh must not block core habit actions (`NFR-006`). |
| No habits / no habits due / all due complete | Three separate empty states with the next valid action or explanation. | Do not imply the day is complete when no habit is scheduled (`UX-013`). |
| Empty social area | Explain no requests/challenges/friends where known; show an approved next action. | Offline lack of fresh social data is not proof that no remote items exist. |
| Offline | Keep local Today/Habits actions active; show a non-alarmist connection indicator and accessible explanation. Social views distinguish cached metadata from current server state. | Offline is a condition, not an error or a failed check-in. |
| Local action Pending sync | Show local success plus a labeled Pending badge at the affected item. A detail entry explains that remote confirmation is outstanding. | Personal progress can be provisional; social actions are not effective for others (`UX-003`, `UX-010`). |
| Synced | Show a restrained confirmation or accessible status in detail/history. | “Synced” means Supabase acknowledged and Isar reconciled the result. |
| Failed / conflict | Keep the local action visible, say what needs attention, and offer retry or a route to Sync & Recovery. Explain a server correction without silently removing the user's intent. | Never replace a check-in with a generic error toast or erase it (`FR-022`, `NFR-012`). |

Sync status belongs near the affected action and in a consolidated recovery destination. A global status indicator is useful when several operations are pending or failed, but it must not cover the main check-in control. Challenge scores and leaderboards use **server-confirmed** results; a pending personal check-in appears as pending beside, not inside, the point total (`BR-007`, `FLOW-002`). A failed push notification never changes underlying progress (`FR-019`).

## 8. Streak, challenge, and privacy visual language

**Personal streak:** Show current and longest streak with clear labels and a history context. A missed occurrence is legible without punitive graphics. A Restore reconnects personal streak continuity only after an explicit action; the design distinguishes provisional local use from canonical allowance. Do not draw the exact occurrence calendar/deadline model until `OQ-004` is resolved (`FR-006`, `FR-007`, `FLOW-003`).

**Challenge score:** Use a separate score treatment with “1 for accepted completed occurrence, 0 for missed” and explicit tie labels. Avoid winner visuals before challenge finalization. Leaving/removed states keep historical participation but remove win eligibility. The leaderboard never visually implies a Restore adds a point (`FR-014`–`FR-016`, `BR-007`, `BR-017`). Equivalent-habit and late-finalization rules remain product input (`OQ-003`, `OQ-004`, architecture late-finalization decision).

**Privacy:** Private and Shared are explicit words with supporting icons; neither icon nor color is the sole signal. A friend's view contains only authorized shared information and gives no hint that undiscoverable private habits exist. A challenge may show approved score/progress without revealing private habit names. An offline privacy reduction or friend removal is labeled saved locally and Pending; the user is told that the change takes effect for others only after successful sync (`UXF-08`, `BR-001`, `BR-018`, `BR-023`, `PERM-003`, `PERM-009`).

## 9. Accessibility, English/Arabic, and RTL

- Design and test every P0 flow in English and Arabic in its PNG designs, including sync, failure, confirmation, empty, and notification states (`FR-023`, `UX-012`). Never depend on English text width or a Latin-only font.
- Use direction-aware layout and start/end alignment. Mirror navigation order, back affordance, horizontal flow, and directional icons where meaning follows reading direction. Do not mirror logos, clocks, charts, or icons whose meaning is not directional. Use locale-aware date/time formatting and **0–9 numeral glyphs as the current default** in both languages. Isolate mixed-script habit names/user input to prevent punctuation and digits from reordering confusingly. [Flutter internationalization](https://docs.flutter.dev/ui/internationalization)
- Provide semantic labels and state announcements for check-in, sync, restore balance, score, privacy, and icon-only actions. Keep focus order aligned with visual reading order. Test TalkBack and VoiceOver on Android and iOS. Important states use text plus shape/icon, not color alone (`NFR-009`, `UX-011`). [Flutter accessibility](https://docs.flutter.dev/ui/accessibility)
- Allow large text and system display scaling without clipped actions or hidden consequences. Test small phones, keyboard open, long Arabic strings, and screen-reader navigation before feature implementation and at release (`NFR-009`–`NFR-011`).

- Adapt to available width and height, safe areas, keyboard insets, and orientation; keep the four shell destinations and primary actions reachable without fixing layouts to the approved reference canvas. The responsive rules and validation widths are in [DESIGN_SYSTEM.md](design/DESIGN_SYSTEM.md).

**Approved (UXF-07):** Follow the device locale initially. Profile offers an explicit English/Arabic selection; an explicit selection overrides the device locale until the user changes it. Use locale-aware date/time formatting and 0–9 numeral glyphs as the current default. Bilingual PNG design review must validate mixed-script dates, times, numbers, and accessibility; it may propose a later change without silently changing this decision.

## 10. PNG design gates before implementation

For every feature containing user-facing UI, follow Feature Specification → Clarification → PNG UI Design → Design Approval → Technical Plan → Tasks → Implementation → Visual Verification. A required screen MUST NOT be implemented until its PNG design has been explicitly approved by the Product Owner. Plans and tasks MUST cite the exact approved PNG file paths. Store approved reusable visual reference PNGs in `docs/design/references/` and feature-specific screen PNGs in `docs/design/screens/<feature-id>/`. Use those PNGs together with [DESIGN_SYSTEM.md](design/DESIGN_SYSTEM.md).

| Gate | Required PNG design scope | Reason |
| --- | --- | --- |
| SL-01 foundation gate, before any P0 UI implementation | English LTR and Arabic RTL shell; global Inbox/Profile actions; Sync & Recovery entry; shared connection/action states and feedback; normal and large text; offline and failed-sync states. | Validates navigation, local-first status meaning, bilingual layout and shared presentation rules. |
| Habit/streak feature gate | Habits list; Habit detail/history; Restore use and request/gift decision states; pause/archive/deletion confirmation. | Prevents streak, restore, and destructive UX from being improvised during implementation. |
| Social/challenge feature gate | Challenges list/invitations; Create Challenge; Challenge detail/leaderboard including ties, pending check-in, left/removed; Friends/requests/permitted progress; Inbox. | Tests score-versus-streak distinction and authorization-sensitive views. Exact screen scope awaits `OQ-003`–`OQ-006`. |
| Account/profile feature gate | Sign in/register/password recovery; Profile/settings; account deletion and sign-out with pending data. | Tests session, localization choice, and retention-sensitive warnings. Exact deletion/pending-data copy awaits product decisions. |

P1-only screens are designed only if their scope is scheduled and specified. Each PNG design must identify its PRD IDs, feature ID, language/direction, data freshness, sync state, privacy state, and primary/secondary actions in an accompanying description or naming convention. Approval is a design input to the technical plan and tasks; it does not bypass the constitution's implementation gates. Future screens must not independently redesign approved navigation, typography hierarchy, colors, buttons, cards, spacing language, icons, status indicators, or feedback unless the Product Owner explicitly approves a design-system change.

## 11. Approved foundation decisions and remaining design inputs

| ID | Approved decision | Remaining design input |
| --- | --- | --- |
| UXF-01 | Calm, encouraging Material 3-based direction with restrained success/competition cues. | Final visual execution in approved PNG designs. |
| UXF-02 | Four bottom destinations: Today, Habits, Challenges, Friends; Inbox and Profile as global actions. | Validate shell at Arabic RTL and large text in PNG designs. |
| UXF-03 | Semantic tokens, 4/8-unit spacing rhythm, bilingual type scale, status/visibility color roles, and reduced-motion variants. | Final palette/font/icon choices are pending visual approval. |
| UXF-04 | Local success feedback separate from Pending/Synced/Failed sync labels; dedicated Sync & Recovery entry. | Specify feature-specific recovery copy. |
| UXF-05 | Separate visual language for personal streaks/Restores and canonical challenge scores; private/shared words plus icons. | Validate feature states in approved PNG designs. |
| UXF-06 | Consequence-first confirmation before accepting a Restore gift, stating the giver loses one available Restore. | Final localized copy and balance presentation in the Restore feature design. |
| UXF-07 | Device locale initially; explicit English/Arabic selection in Profile; locale-aware date/time; 0–9 numeral glyphs by default. | Validate bilingual date/time/numeral layouts in approved PNG designs. |
| UXF-08 | Offline privacy reduction/friend removal is saved locally; it affects other users only after successful sync. | Final localized warning, Pending/Failed, and recovery states in affected designs. |

Open PRD rules still block exact designs for occurrence deadlines (`OQ-004`), equivalent challenge habits (`OQ-003`), restore limits (`OQ-001`, `OQ-002`), challenge rejoin (`OQ-005`), friend identifiers (`OQ-006`), reporting (`OQ-007`), offline edit conflicts (`OQ-009`), and account deletion/retention (`OQ-008`, `OQ-010`). The architecture also leaves late challenge finalization and unsynced data on sign-out open. The affected final screens wait for those decisions; this foundation does not supply them by assumption.
