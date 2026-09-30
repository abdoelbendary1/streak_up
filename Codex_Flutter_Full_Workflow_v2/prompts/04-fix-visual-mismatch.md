# 04 — Screenshot-to-approved-PNG correction

Use `$flutter-ui-fidelity` and installed official layout/test skills as needed.
SCREEN / STATE: [SCREEN_ID + EXACT APP STATE]
REFERENCE PNG: [PATH] (attach actual approved image to Codex)
ACTUAL SCREENSHOT: [PATH] (attach actual emulator screenshot to Codex)
DEVICE / VIEWPORT / DPI: [DETAILS]
LOCALE / TEXT SCALE / THEME: [DETAILS]
SCREEN CODE SCOPE: [FILES]

**Both images must be available in this session.** If either is missing, ask for it or capture the app screenshot using the verified local device; do not imagine or describe unseen pixels.

Compare the equivalent APP CONTENT area; account for safe areas, system bars, fonts and state. List at most five highest-impact discrepancies (geometry, spacing, typography, icons, color, states). Correct them using existing design tokens/reusable widgets, avoiding entire-screen hardcoding or unrelated behavioral changes. Run the actual screen again, capture a second screenshot, and repeat at most once if the second image still shows major differences. Check smaller/larger widths and Arabic/RTL where supported.

End with reference and before/after paths, fixed discrepancies, remaining deviations, exact tests/results and explicit human design-approval status. Do NOT invent a numerical 'match percentage'.
