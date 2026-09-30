# SL-01 Implementation and Verification Quickstart

This is a future execution guide for [plan.md](plan.md). Planning created no Flutter code or package changes.

1. Use the completed `tasks.md` with SL01-FR/AS links and exact approved PNG paths. The user directed a lightweight readiness check instead of a full Spec Kit analyze; that check passed and is recorded in `docs/PROJECT_STATE.md`.
2. Verify the installed Flutter/Dart SDK and resolve compatible versions of approved packages. Record locked dependencies and reproducible generated files. Add only SL-01 routing, localization, DI, logger/observer, theme, shell, status, and feedback foundations.
3. Supply controlled states through test or explicitly development-only fixtures. Do not connect to Supabase, create Isar data, simulate production synchronization, or claim an authenticated session.
4. Run code generation, static analysis, widget/unit tests, English/Arabic locale and RTL checks, large-text and semantics checks. Confirm each test result rather than assuming a command passed.
5. Render the approved shell variants using 390 × 844 as the visual reference canvas only. Compare with the manifest's Today, four root screens, Arabic RTL, offline, large-text, and sync-issue PNGs; correct meaningful visual differences. Do not treat reference dimensions as fixed layout values or globally scale the UI.

   | Viewport | Verify |
   | --- | --- |
   | Compact, about 320–359 logical pixels wide | Four destination labels/icons and global actions remain usable; no overflow or clipping. |
   | Standard, about 390 logical pixels wide | Visual comparison with the approved canvas; content and status remain readable. |
   | Larger phone, about 430 logical pixels wide | Content expands naturally without stretched controls or lost hierarchy. |
   | Wide, 600 logical pixels or more | Content is centered within a readable maximum width; the same four-destination shell remains usable. |

   At each width, check English LTR and Arabic RTL, long strings and system text scaling, safe areas, keyboard insets, short-height scrolling, and orientation changes. Record any overflow, clipping, hidden action, or navigation failure.
6. Verify Android and iOS behavior where build/device access exists. After tests and visual comparison, run CodeRabbit review and resolve or explicitly disposition findings before SL-01 convergence. Record unavailable checks and their impact.

Follow the current `docs/PROJECT_STATE.md` gate: SL-01 implementation is authorized for Antigravity only. A full Spec Kit analyze was not run; do not report it as complete. Do not start SL-02 as part of SL-01.

