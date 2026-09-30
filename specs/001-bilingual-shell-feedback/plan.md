# Implementation Plan: SL-01 — Bilingual App Shell and Shared Feedback

**Branch**: `main` (the local Spec Kit script resolved `001-bilingual-shell-feedback` as the feature identifier; no feature branch is configured) | **Date**: 2026-09-29 | **Spec**: [spec.md](spec.md)

**Input**: Clarified SL-01 specification and APPROVED entries in [DESIGN_MANIFEST.md](../../docs/design/DESIGN_MANIFEST.md). This is a technical plan only; no Flutter implementation is authorized by this file.

## Summary

Build a reusable signed-in Material 3 shell with exactly four labeled primary destinations, global Inbox/Profile actions, and a contextual Sync & Recovery entry. Supply English/Arabic RTL localization, typed shared connection/action status presentation, and centralized accessible feedback. Later slices provide authentication, destination content, network signals, durable action state, and recovery behavior. SL-01 has no product persistence or backend calls.

## Technical Context

| Item | Current state / planned choice |
| --- | --- |
| Language/version | Dart constraint `^3.11.1` in `pubspec.yaml`; installed Flutter SDK version to verify when implementation starts. |
| Primary dependencies | Currently Flutter and Cupertino Icons only. Plan to add approved `flutter_bloc`, `go_router` with generated typed routes, `get_it` + `injectable`, `gen_l10n`/ARB, and generation tooling at implementation. Resolve compatible versions in the tasks; no package is claimed installed now. |
| Storage | None for SL-01. No Isar collections, Supabase schema, DTOs, sync cursor, or outbox. |
| Testing | Flutter widget/unit tests plus localization, route, semantics, and visual checks; Android/iOS device checks when implemented. |
| Target platform | Android and iOS mobile; English LTR and Arabic RTL. |
| Project type | Existing Flutter starter app (`lib/main.dart`, `test/widget_test.dart`). |
| Performance | Keep shell navigation and local presentation responsive without network dependency; no invented numeric latency target. |
| Constraints | No business logic or service lookup in widgets; no presentation networking; no hard-coded user-facing strings; no product notification history; no false remote success. |

## Constitution Check

| Principle | Planning result |
| --- | --- |
| PRD authority and traceability | Scope maps to `FR-022`, `FR-023`, `NFR-001`, `NFR-003`, `NFR-008`–`NFR-012`, `UX-003`, `UX-010`–`UX-014`, and SL01-FR-001–017. Destination content remains with owning slices. |
| Ordered delivery | Spec and clarification exist; PNG gate is approved. This plan was drafted before tasks and implementation. The user later directed a lightweight readiness check instead of full Spec Kit analyze; current implementation authorization is recorded in `docs/PROJECT_STATE.md`. |
| Correctness and recoverable data | The plan distinguishes local success, Pending, Synced, and Failed; it performs no data writes or sync execution. Persistent failure remains visible through its source/recovery entry. |
| Privacy and least privilege | Global status and feedback expose only safe summary text and counts, never private habit or friend details. No client route is treated as server authorization. |
| Verifiable outcomes | Tests and visual checks map to AS-01–AS-17; CodeRabbit review follows implementation and verification. |

**Gate result:** Pass for technical planning. Recheck after design of the presentation contracts. No constitution exception or product change is proposed.

## Architecture and component decisions

1. **Composition:** `main.dart` delegates to a bootstrap/composition layer. `get_it` + `injectable` registers constructor-injected services there. Widgets and application logic receive dependencies through constructors or providers, never direct `GetIt` calls. A global `BlocObserver` reports allowlisted lifecycle/change/error metadata through `AppLogger`; raw states, private content, auth values, and payloads are excluded. Provider and retention choice remains outside SL-01.
2. **Routing:** Define generated typed `go_router` routes for the four shell destinations and global Inbox, Profile, and Sync & Recovery entries. Preserve branch selection and a predictable return from global routes. Route availability is a presentation contract; SL-02 later owns signed-in redirects and account state, and the server retains authorization. Route destinations accept later feature content. Labeled destination surfaces may be supplied by tests or an explicitly development-only fixture, not represented as implemented product features.
3. **Presentation state:** A small shell Cubit owns selected destination and presentation-only locale override input where needed. Typed `NetworkState`/connection-view and `ActionSyncStatus` values come from injected streams or controlled test fixtures. SL-01 only maps them to visible text, icons, announcements, and recovery affordances. SL-03 later supplies reachability and sync signals; a device interface does not prove Online. Auth/session action-required remains distinct from Offline and is supplied later by SL-02.
4. **Feedback:** A central presentation coordinator accepts a localized message key/arguments, semantic severity, optional valid action, and transient/persistent intent. Shared widgets render snackbar, inline, or banner form. Background repetition is coalesced; closing a transient message cannot clear persistent action-level failure. This does not create Inbox events or durable feedback storage.
5. **Theme and widgets:** Build a Material 3 StreakUp theme from the approved palette and semantic roles in [DESIGN_SYSTEM.md](../../docs/design/DESIGN_SYSTEM.md): background, surface, primary/secondary text, border, primary action, success, warning, error, pending, and information. Use approved 4/8 spacing rhythm and typography roles. Rounded/pill/circular shapes, pastel icon containers, and restrained depth follow the PNGs. Exact radii, font family, weights, shadows, and screen dimensions are implementation choices subject to visual verification; do not declare them approved tokens. Reuse shell top bar, bottom navigation, status badge, attention/offline banner, feedback host, and accessibility primitives where the current references show the same treatment.
6. **Localization:** Use `gen_l10n` with English and Arabic ARB files. Device English maps to English; device Arabic maps to Arabic; any unsupported device locale falls back to English. Accept a later Profile-supplied explicit locale without storing it in SL-01. Keep all labels/feedback in ARB, locale-aware dates/times, and approved 0–9 numeral glyphs. Let Flutter directionality drive layout; mirror directional controls and traversal, not logos or non-directional symbols.

### Responsive and adaptive layout

Build the shell from available constraints and content size: compact below 360 logical pixels, standard 360–599, and wide at 600 or more. At wide widths, center content within a readable maximum width while preserving the four-destination navigation; do not add tablet panes or new destinations. The approved 390 × 844 canvas guides visual comparison only. Do not hardcode its dimensions, derive pixel tokens from it, or globally scale the interface.

Allow system text scaling, long English/Arabic strings, and short-height or rotated viewports to grow or scroll without clipped actions. Respect safe areas and keyboard view insets, including future destination forms. Keep all four navigation destinations usable at compact widths with icon and readable label where practical. Use direction-aware layout for RTL. Validate these constraints with widget and device checks; no portrait-only assumption or height breakpoint is required.

The focused presentation types and handoff rules are in [data-model.md](data-model.md) and [contracts/presentation.md](contracts/presentation.md). [research.md](research.md) records implementation decisions and open validation. No production data contract is needed for a feature with no persisted product data.

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

## Project Structure

### Documentation (this feature)

```text
specs/001-bilingual-shell-feedback/
├── spec.md
├── plan.md
├── research.md
├── data-model.md
├── quickstart.md
└── contracts/presentation.md
```

`tasks.md` belongs to the next Spec Kit step and is not created by this plan.

### Proposed source layout (no files created in this step)

```text
lib/
├── main.dart
├── app/
│   ├── bootstrap/        # composition, logger, observer, DI setup
│   ├── routing/          # generated typed route sources and shell wiring
│   └── theme/            # approved colors, type roles, shared shapes
├── core/
│   ├── localization/     # ARB and generated localizations
│   └── presentation/     # status/feedback contracts and shared widgets
└── features/
    └── shell/presentation/ # shell Cubit, top bar, bottom nav, host
test/
└── shell/                # navigation, locale, RTL, status, feedback, semantics
```

The source tree groups only boundaries needed by SL-01. The later feature slices plug into route/content contracts without prebuilding their screens, repositories, or data models.

## Verification and convergence plan

| Evidence | Requirements / scenarios |
| --- | --- |
| Widget route tests: four branches, selected state, Inbox/Profile/Review entry and return | SL01-FR-001–004; AS-01–03, AS-10, AS-14 |
| Locale tests: device en/ar, unsupported fallback en, supplied override, date/time and 0–9 numerals | SL01-FR-005–008; AS-04–07 |
| RTL, narrow width, large text, touch target and semantics checks | SL01-FR-006–008, 015; AS-06, AS-15 |
| Controlled Online/Offline/Reconnecting/Syncing/SyncFailed and auth-action-required fixtures | SL01-FR-009–010; AS-08, AS-11 |
| Pending/Synced/Failed, local save versus remote acknowledgment, persistent recovery | SL01-FR-011–012, 014; AS-09–10, AS-14 |
| Feedback severity/action/coalescing, loading versus empty versus inline error, global privacy | SL01-FR-013–017; AS-12–17 |

After implementation, use the 390 × 844 reference canvas and compare compact, standard, and wide widths, short heights, orientation changes, and large text with all mapped approved PNGs in English and Arabic RTL. Check top bar, bottom navigation, colors, typography hierarchy, spacing, cards, banners, action labels, and focus order; correct differences before convergence. Device verification covers Android and iOS. Run CodeRabbit review after tests and visual verification for architecture boundaries, widget responsibility, Bloc/Cubit, routes, localization, accessibility, privacy logging, duplication, speculative abstractions, and test coverage; resolve or explicitly disposition findings before feature convergence. Do not configure or run CodeRabbit during planning.

## Research, risks, and readiness

Package versions and code-generation compatibility are implementation-time checks, not assumed facts. Visual token values not explicitly approved require comparison against PNGs. The compact sync banner's example copy can sound like guaranteed automatic recovery; implementation must use state-accurate localized copy and distinguish Failed from Pending. No unresolved product or design decision blocks creating tasks for this scoped plan.

**READY FOR TASKS: YES.** Tasks cite requirement/acceptance IDs and exact approved PNG paths. The user later directed a lightweight readiness check instead of full Spec Kit analyze; see `docs/PROJECT_STATE.md` for the current implementation gate.


