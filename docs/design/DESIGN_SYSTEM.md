# StreakUp Design System

## Authority and foundation

The approved [visual identity board](identity/VID-001-visual-identity.png), [standalone logo](identity/LOGO.png), and [app icon](<identity/APP Icon.png>) establish the brand language. The approved [Today](references/REF-001-today.png), [Habits](references/REF-002-habits.png), [Challenges](references/REF-003-challenges.png), and [Friends](references/REF-004-friends.png) screens establish the common signed-in shell. The approved [SL-01 variants](DESIGN_MANIFEST.md) establish its Arabic RTL, large-text, offline, and sync-issue treatments. The approved [Create Habit](screens/004-habit-create/SL04-UI-001-create-habit.png) screen supplies the current form reference. [DESIGN_MANIFEST.md](DESIGN_MANIFEST.md) records approval and scope. Only APPROVED images are authoritative visual references.

Use Material 3 as the mobile interaction and accessibility foundation on Android and iOS. Apply StreakUp's approved visual language while preserving predictable platform behavior. Product rules remain in the product and UX documents.

## Color roles

| Role | Approved color | Use |
| --- | --- | --- |
| Primary Green | `#22C55E` | Brand, primary action, active state, progress |
| Green Dark | `#16A34A` | Pressed state and stronger green emphasis |
| Navy | `#0F172A` | Primary text and headings |
| Background | `#F8FAFC` | App background |
| Surface | `#FFFFFF` | Cards and sheets |
| Border | `#E2E8F0` | Dividers and boundaries |
| Secondary Text | `#64748B` | Supporting copy and metadata |
| Orange | `#F97316` | Streak energy and pending sync |
| Blue | `#3B82F6` | Information, links, activity icons |
| Purple | `#A855F7` | Secondary accents and activity icons |
| Peach | `#FB923C` | Soft activity and wellness accents |
| Success | `#22C55E` | Completed and positive states |
| Warning | `#F59E0B` | Attention and reminders |
| Error | `#EF4444` | Errors and failed actions |
| Pending | `#F97316` | Awaiting remote acknowledgment |
| Information | `#3B82F6` | Neutral information |

Use semantic roles in component specifications. Verify contrast on actual surfaces. Do not introduce unapproved colors as permanent tokens. Accessibility must never rely on color alone.

## Typography and spacing

Use a clean, bold heading style with calm, readable body text. Preserve page title, section title, body, supporting text, action label, and numeric emphasis roles. The Today reference uses strong navy headings and quieter secondary copy. No font family is approved; do not identify one from rendered PNG text.

Follow the established 4-unit base and 8-unit common spacing rhythm from the prior design-system foundation. Starting steps are 4, 8, 12, 16, 24, and 32 logical units. The approved screens use clear gaps between the top identity/actions, page introduction, sections, and cards. Let content grow at large text sizes. Exact margins, component dimensions, and positions need implementation validation; do not derive them by measuring PNG pixels.

English LTR and Arabic RTL are first-class requirements. The approved [Arabic Today](screens/001-bilingual-shell-feedback/SL01-UI-005-today-rtl-ar.png) reference mirrors top global actions, card composition, chevrons, and bottom navigation reading order while keeping the brand mark recognizable. Use direction-aware start/end placement, localized copy and dates, and suitable Arabic line height. Keep logos and non-directional symbols in their intended orientation. The approved [large-text Today](screens/001-bilingual-shell-feedback/SL01-UI-003-large-text-en.png) reference wraps the heading and supportive copy while keeping the primary task and navigation reachable. Labels and cards must grow or wrap without clipping actions or hiding status.

## Responsive and adaptive layout

Use available constraints and content size to compose mobile layouts. Treat widths below 360 logical pixels as compact, 360–599 as standard, and 600 or more as wide. On wide screens, center content within a readable maximum width while retaining the same navigation model; this does not authorize a tablet redesign or multi-pane layout. The approved 390 × 844 reference is a visual comparison canvas, not a fixed screen size or a source of exact measurements. Do not hardcode screen dimensions or apply global scaling to match it.

Let long English/Arabic text and system text scaling wrap or grow naturally; do not disable or clamp text scaling to preserve a screenshot. Keep short-height and rotated layouts usable through scrolling where content exceeds available height, without assuming portrait orientation. Respect safe areas and keyboard insets so controls and form actions remain reachable. All four bottom destinations must remain usable at compact widths, with readable icon and label treatment where practical. Use direction-aware spacing and alignment in English LTR and Arabic RTL. Validate overflow, clipping, and reachability across these conditions during feature implementation.

## Shape, cards, and surfaces

Use rounded cards, pill treatments for selected navigation or badges, rounded buttons, and circular pastel icon containers. White surfaces sit on the pale app background with a subtle border and soft depth where grouping needs it. Gentle green tint marks encouraging or selected content in the approved screens. Keep shadows restrained. The images guide corner-radius and elevation character; exact radii, shadows, and elevations need implementation validation.

Habit cards place an activity icon in a soft tinted circular container, followed by the habit name and supporting detail, then an obvious completion control. Keep personal streak and synchronization status as separate, labeled metadata near the affected habit. A locally completed action can still read Pending remotely. Preserve room for longer Arabic names and large text.

## Reusable components

### Buttons and icon containers

Use green for the primary action, with a clear text label and visible pressed, disabled, and focus states. The Habits, Challenges, Friends, and Create Habit references show rounded green call-to-action buttons with text and a plus icon where adding is the action. Secondary actions appear as softer tinted or outlined controls. Use simple, legible icons in pastel circular containers for activities and supportive illustration. Icon meaning needs nearby text or an accessible label. Use the approved standalone logo and icon assets for their stated roles; do not reconstruct them from screenshots.

### App bar and bottom navigation

The four main references show the same root layout: brand identification at the top, global Inbox and Profile actions, a page introduction, task-specific content, and four-destination bottom navigation. The signed-in shell has exactly Today, Habits, Challenges, and Friends as primary destinations. Their meanings remain Today = Execute, Habits = Manage, Challenges = Compete, Friends = Connect. Keep Today focused on due actions, not analytics. Use text plus icon in bottom navigation and a pale green selected pill with green icon/label as shown. Respect safe areas and RTL reading order. Inbox, Profile, and Sync & Recovery are reachable global or contextual destinations, not additional primary tabs. The exact Sync & Recovery entry treatment is not yet shown in an approved PNG.

Secondary screens use a back affordance and page title instead of the root brand/app-bar composition. The Create Habit reference shows this pattern. Back direction and reading order must follow the active language; exact sizing needs implementation validation.

### Progress indicators

Pair progress bars, completion counts, and status badges with explicit text. The Today reference shows a completed-count label with a green progress bar. Personal streaks use an orange flame and labeled day count. Challenges use trophy or activity imagery, a goal/progress label, a green progress bar, participant context, and a score or rank treatment. Personal streak and challenge score must remain visually and verbally distinct. A challenge card's displayed example values are illustration, not scoring rules. Do not imply remote acceptance of a pending local action.

Challenge cards are larger groupings for goal, remaining time or completion, progress, participants, and a clearly labeled detail action. Friends rows/cards use an avatar, name, only permitted shared-progress context, and a separate contextual action. The Friends reference includes a softly tinted request summary. Neither reference authorizes exposing private information or implementing feature behavior before its own gate.

### Forms

The approved Create Habit screen establishes white grouped form cards, persistent field labels, softly bordered inputs, circular icon/category choices, a segmented schedule choice, day selectors, a switch, and text-plus-icon Private/Shared selection. A selected option uses the approved green treatment and remains distinguishable by text and selection mark. Use Material 3 field behavior with clear help text, validation, focus, and inline error placement. Preserve input meaning and action reachability under keyboard insets, RTL, and large text. The PNG shows a filled example; it does not approve validation copy, exact dimensions, schedule semantics, or save behavior.

### Feedback components

Use snackbars or equivalent brief feedback for transient outcomes, inline feedback beside an affected action, and a banner or stable recovery entry when an unresolved condition needs attention. The approved [sync issue](screens/001-bilingual-shell-feedback/SL01-UI-001-sync-failed-review-en.png) and [compact sync issue](screens/001-bilingual-shell-feedback/SL01-UI-004-sync-issue-compact-en.png) references show a rounded pale-red banner beneath the top actions, an error icon, concise explanation, and a labeled Review action with a directional chevron. The approved [offline](screens/001-bilingual-shell-feedback/SL01-UI-002-offline-en.png) reference uses a warm pale banner with an orange connection icon and explanatory copy. These banners preserve the daily task below. Pair semantic color with an icon and plain-language label. Local success and remote synchronization are separate concepts: acknowledge a successful local save while separately labeling its remote state. Group repetitive background updates; keep unresolved failures discoverable after a transient message closes. The approved PNG set does not yet show every snackbar or inline-error composition.

## Connection and action states

| State | Meaning | Presentation rule |
| --- | --- | --- |
| Online | Backend reachability is confirmed | Use a concise status when useful; device connectivity alone does not establish this state. |
| Offline | Backend is unreachable | Show an informational label; offline-capable actions can continue locally. |
| Reconnecting | Reachability is being restored | Show a distinct in-progress label; pending work may remain. |
| Syncing | Remote synchronization is in progress | Show activity without implying acknowledgment. |
| Sync Failed | Synchronization needs attention | Show a discoverable recovery entry and a valid next action. |
| Pending | Action is saved locally, awaiting remote acknowledgment | Label the affected action Pending; orange may reinforce the label. |
| Synced | Server acknowledged and local state was reconciled | Label the affected action Synced. |
| Failed | Action needs attention | Preserve its intent and provide valid retry or recovery. |

The Today and Habits references illustrate locally complete or present content while still labeled “Pending sync.” The approved offline screen labels affected completed actions “Saved offline” and separates that from the completion mark. The approved sync-failure screen keeps the failed item labeled near that item and presents a Review entry in the global banner. Do not collapse local completion, Pending, Synced, and Failed into one success state. Do not promise that a Failed action will synchronize automatically merely because a banner example mentions returning online. Identify authentication problems requiring action separately from ordinary Offline status. Reconnecting and Syncing retain the icon-plus-text semantic treatment without requiring a unique screen layout.

## Privacy and competition

Private and Shared always use text plus a supporting icon; neither color nor icon alone is sufficient. Do not expose private habit details through badges, notifications, or shared views. Personal streak uses the flame/day-count language; challenges use a trophy and goal or score context. Keep those treatments separate across cards, summaries, and feedback.

## Empty, loading, and error states

Provide specific, localized copy for no habits, no habits due, all due complete, unavailable remote content, and failed work. Use the soft illustration or icon-container language where it helps comprehension. Loading should preserve context and avoid implying completion. Offline and Reconnecting are connection states, not generic errors. Error states identify what failed and offer a valid next action when one exists. Destructive confirmations must state the consequence before the action and clearly distinguish cancel from confirm; exact composition needs an approved feature reference. Every state must remain understandable without color and at large text sizes.

## Reference and change control

For **product behavior**, use PRD → active feature specification → approved clarifications. For **technical implementation**, use constitution → architecture → database foundation → active feature technical plan. For **visual implementation**, use feature-specific approved PNG → closest approved reference PNG → this design system → brand identity → UI/UX foundation. An approved PNG controls styling if text differs only visually. If an image appears to contradict a product rule, follow the product rule and report the conflict rather than silently implementing it.

Future screens should reuse approved common components while their feature-specific compositions receive their own approval. Do not infer precise pixel measurements from PNGs. Register each newly approved design in [DESIGN_MANIFEST.md](DESIGN_MANIFEST.md) before using it for implementation. The approved SL-01 set now includes English LTR, Arabic RTL, large text, offline, and sync-issue shell references; technical planning must still preserve the full set of status meanings from the active specification.
