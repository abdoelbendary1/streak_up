# Shell implementation guide

Current presentation ownership after the 2026-10-05 readability pass on `reimplement/sl01-sl02`. Requirements remain in the [feature specification](../../../specs/001-bilingual-shell-feedback/spec.md), [plan](../../../specs/001-bilingual-shell-feedback/plan.md) and [PRD](../../PRD.md). See [project state](../../PROJECT_STATE.md) for verification.

## Current file map

Paths below are under `lib/`.

| File | Responsibility |
| --- | --- |
| `features/shell/presentation/screens/app_shell.dart` | Top bar, bounded destination viewport and bottom navigation |
| `features/shell/presentation/global_route_shell.dart` | Separate title/back layout for global routes |
| `features/shell/presentation/widgets/shell_top_bar.dart` | Wordmark and accessible Inbox/Profile actions |
| `features/shell/presentation/widgets/shell_bottom_navigation.dart` | Responsive four-destination navigation |
| `features/shell/presentation/widgets/feature_placeholder.dart` | Shared static placeholder card |
| `features/shell/presentation/widgets/profile_placeholder.dart` | Temporary Profile card/sign-out action in one scroll viewport |
| `features/shell/presentation/models/shell_destination.dart` | Labels and icons for Today, Habits, Challenges and Friends |
| `features/shell/presentation/cubit/shell_cubit.dart` | Locale presentation state and account reset |
| `app/routing/app_routes.dart`, `app_router.dart` | Typed route construction, navigation and Auth protection |
| `core/presentation/app_notifier.dart` | Stateless Toastification notifications |
| `core/presentation/widgets/streak_up_wordmark.dart` | Approved logo with fixed brand orientation |
| `app/theme/` | Common typography, decoration, controls, colors, spacing and radii |

There are no shell application/domain/data layers, fake connectivity producer, shared state-view library or speculative action-sync badge/row system. GlobalRouteShell stays public in its own file because it is a different reusable layout.

## Ownership and flow

GoRouter owns location/history and derives the selected tab. AppShell only composes chrome and content; it has no coordinator or notification state. ShellCubit only owns explicit locale presentation. Account exit resets the locale override. Auth state determines protected access; the route-content guard selects only `canAccessProtected` so command loading/errors do not rebuild the guard.

Typed routes construct feature presentation directly. FeaturePlaceholder is a card with real title/description/icon and two currently used color variants. Routes wrap ordinary placeholder destinations in their scroll view. Profile owns one scroll view around both its card and sign-out action, selects only Auth loading and uses the boolean warning-sheet API. The modal never dispatches Auth commands.

## Responsive behavior and design

AppShell derives compact padding from available layout constraints, caps readable width, honors safe areas and provides an Expanded destination viewport. Shell chrome does not resize with the keyboard; destinations own their interaction/scrolling. GlobalRouteShell uses an automatically mirrored BackButtonIcon. The brand wordmark stays unmirrored.

ShellTopBar and its private circular action button remain because their structure is already readable and touch targets are explicit. Bottom navigation retains Table/IntrinsicColumnWidth: at 320px with enlarged English text, equal-width columns wrapped Challenges despite spare width in Today. Preserve compact padding, RTL, selection semantics, wrapping and minimum 48px touch targets. This real constraint justifies the implementation detail.

Approved references are REF-001 and SL01-UI-003/004/005 in [DESIGN_MANIFEST.md](../../design/DESIGN_MANIFEST.md), plus the brand logo. The 2026-10-05 pass preserves the navigation layout; it does not claim new runtime/screenshot evidence.

## Notifications and future work

Use `AppNotifier.success/info/warning/error(context, message)` with localized presentation copy. Toastification uses AppTheme's text/color roles. The root Auth listener persists across routes; no ScaffoldMessenger, SnackBar, feedback model or notification Cubit exists in production.

Connectivity remains removed until a real producer exists. SL-03 must derive sync presentation from actual durable feature state. Do not restore speculative SharedSectionStateView, ActionSyncStatus or related projections/widgets. Future feature errors and retry UI belong to the feature; validation belongs to fields and confirmation to dialogs/sheets.

## Verification

Formatting, normal generation, analyzer and diff checks are required for this task. Tests were explicitly excluded from execution and updates. Existing tests reference removed feedback/connectivity and other stale APIs; report repository-wide analyzer failures without adding production compatibility code. Production source is analyzed separately. Future runtime verification should cover compact width, Arabic RTL, large text, keyboard and accessible controls proportionately.
