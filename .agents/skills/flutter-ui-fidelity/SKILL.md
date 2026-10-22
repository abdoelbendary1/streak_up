---
name: flutter-ui-fidelity
description: Implement or correct exactly one Flutter UI state against an approved PNG using a real emulator screenshot, responsive constraints, and a bounded difference/fix loop. Use for PNG-to-Flutter tasks and visual mismatch reports.
---

# Flutter UI fidelity

**Activation:** UI screen implementation from approved image, screenshot mismatch, layout fidelity gate. Load supplemental installed instructions only for a concrete task requirement; do not automatically load responsive-layout, widget-test or layout-fix skills. Discovery is optional; no installation is required by this skill.

1. Locate the actual approved reference PNG, the exact route/state, design system and closest existing widget implementation. Verify approval in the repository; if absent, report **approval unverified**, do not invent design values.
2. Record a short visual contract: viewport, safe areas, typography/fonts, colors/tokens, component boundaries, navigation/state, intended interactions, RTL and responsive behavior. Identify 3–6 high-impact visual targets, not an exhaustive pixel transcription.
3. Implement with native Flutter widgets and existing components/tokens. Keep ephemeral form controllers, focus and visibility state local where appropriate; keep authoritative shared state and business rules with their owner. Avoid screenshots as UI backgrounds, fixed screen-sized containers, `FittedBox` hiding overflow or a new UI framework.
4. Run `flutter analyze`, focused widget tests and the app on a device/emulator. Broaden regression checks for shared, security-critical or substantial changes. Reproduce target state using existing safe demo/test data. Use available diagnostics that directly help the task; do not invoke additional tools merely because they are installed.
5. Capture the actual route screenshot, e.g. via `scripts/capture-android.ps1` in this pack or `adb shell screencap -p /sdcard/...` + `adb pull`. Record screen size/DPR, font scaling, locale, theme, safe-area/chrome treatment and test state. The PNG reference and runtime shot must have equivalent content areas before comparison.
6. Supply BOTH images to Codex. Make a prioritized discrepancy list covering geometry, spacing, typography, color, icons, shape and state. Correct the top 3–5 meaningful mismatches and capture again. Limit to **two correction rounds** per task unless the user requests more; list remaining differences honestly.
7. Smoke-test a smaller and larger available viewport, at least one large text scale, and Arabic/RTL if feature has Arabic support. Do not silently change an approved layout to compensate for missing assets or fonts.
8. Preserve proof: reference path, actual screenshot path, corrected items, unresolved discrepancies, analyzer/tests results and human approval status. If runtime screenshot capture/comparison is unavailable, mark visual verification **BLOCKED**, never PASS. Golden snapshots can guard regressions, but baseline updates need review and a stable renderer.

## Required result format

- `REFERENCE`: exact PNG path, screen ID and expected state
- `ACTUAL`: screenshot path, device/viewport, font scale/locale
- `FIXED`: up to five meaningful differences
- `VALIDATION`: commands/tests and result
- `OPEN`: deviations or **BLOCKED** reasons, explicit human approval pending
