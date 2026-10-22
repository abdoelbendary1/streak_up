# Implementation plan: SL-01 — Bilingual shell and temporary feedback

**Branch:** reimplement/sl01-sl02 | **Amendment:** 2026-10-01
**Spec:** [spec.md](spec.md) | **Current code:** [shell guide](../../docs/features/shell/IMPLEMENTATION_GUIDE.md)

## Purpose and approved scope

Preserve the four destinations, Inbox/Profile/contextual recovery routing, bilingual locale/RTL, accessible shell chrome and shared primitives. The approved foundation amendment changes global ownership: temporary notifications only; reachability separate from sync; no shell action or inline-error registry. PRD behavior remains controlling; real persistence/sync is SL-03 and later feature work. Historical task/review records remain history.

## Data flow and ownership

GoRouter → selected destination → AppShell → top bar/content/bottom navigation. ShellCubit owns locale presentation only. FeatureRouteHosts supplies feature content. ConnectivityCubit → reachability banner; startup unknown without a real signal. Owning features supply simple Pending/Synced/Failed badge values; network changes cannot acknowledge their actions. FeedbackCoordinator → root SharedFeedbackHost → Flutter ScaffoldMessenger/SnackBar. Feature inline errors/retry remain local. AuthSession invokes bootstrap cleanup of shell locale and temporary feedback without resetting device reachability.

## Files and boundaries

features/shell/presentation/cubit/shell_cubit.dart; screens/app_shell.dart; widgets/shell_top_bar.dart and shell_bottom_navigation.dart. Shared connectivity/feedback/status widgets remain in core/presentation. Composition/routing stays in app/bootstrap and app/routing; main.dart provides dependencies and one app-wide feedback listener. No shell application/domain/data layer, fake sync engine or generic notification framework.

## Data/database impact

None. No product persistence, outbox, schema, migrations or remote work. Locale preference persistence belongs to SL-11. Preserve existing logger privacy and auth isolation.

## Design reference map

Visual authority: feature-specific approved PNG → closest approved reference PNG → Design System → Brand Identity → UI/UX Foundation. If screenshot copy implies a product-state behavior that contradicts the PRD/spec, use the product rule and record the discrepancy.

| UI area | Approved PNG path(s) | Planned reuse |
| --- | --- | --- |
| Brand/top app bar | `docs/design/identity/VID-001-visual-identity.png`; `docs/design/identity/LOGO.png`; `docs/design/identity/APP Icon.png`; `docs/design/references/REF-001-today.png` | Brand treatment, global Inbox/Profile actions, icon containers. |
| Four root branches and bottom navigation | `docs/design/references/REF-001-today.png`; `docs/design/references/REF-002-habits.png`; `docs/design/references/REF-003-challenges.png`; `docs/design/references/REF-004-friends.png` | Exactly four text-plus-icon tabs and selected pill treatment; destination content remains outside SL-01. |
| Arabic RTL shell | `docs/design/screens/001-bilingual-shell-feedback/SL01-UI-005-today-rtl-ar.png` | Mirrored action placement, reading order, navigation and chevrons; preserve logo orientation. |
| Large text | `docs/design/screens/001-bilingual-shell-feedback/SL01-UI-003-large-text-en.png` | Wrapping, card growth, reachable actions and navigation. |
| Offline and local-save status | `docs/design/screens/001-bilingual-shell-feedback/SL01-UI-002-offline-en.png` | Warm informational banner and separate “Saved offline” action status. |
| Failure/recovery and compact variant | `docs/design/screens/001-bilingual-shell-feedback/SL01-UI-001-sync-failed-review-en.png`; `docs/design/screens/001-bilingual-shell-feedback/SL01-UI-004-sync-issue-compact-en.png` | Persistent issue banner, Review entry, affected-action label; choose copy from actual state, not from the screenshot example. |
| Pending/Synced action labels | `docs/design/references/REF-001-today.png`; `docs/design/references/REF-002-habits.png`; the SL-01 variants above | Icon-plus-text status adjacent to affected action. |

The Create Habit image is approved for later SL-04; it is not an SL-01 screen to build.


## Implementation steps

Move shell presentation into cubit/screens/widgets; preserve router selection. Remove shell/global action maps, sync counts/states and feedback inline/background registries. Use temporary Flutter snackbars at the app root. Keep actual reusable badges and local error primitives. Adapt removed-internal tests to feature-owned behavior; regenerate DI/routes normally; remove obsolete files and proven-unused strings/dependencies; update guides and project state.

## Verification, risks and consistency

Analyzer, focused then full tests, git diff --check. Preserve navigation/back/selection, locale/RTL, semantic targets, compact/large-text/keyboard layout, destination edit lifetime and bounded scrolling. Verify transient replacement/expiration, account reset and independent inline retry. Only lightweight runtime checking where useful; no mandatory screenshot comparison, exhaustive matrix or CodeRabbit. The main risks are destination remounting, stale notices after account exit and accidentally acknowledging remote work from connectivity. Existing specs/designs are reused by reference; obsolete global-registry requirements are superseded by this ownership amendment.
