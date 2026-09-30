# 06 — Fast but responsible verification gate

Use `$codex-efficient-workflow` and relevant official Dart/Flutter testing skills.
CHANGED TASK ID: [ID]
EXPECTED CHANGED PATHS: [PATHS]
KNOWN BASELINE FAILURES (IF ANY): [SPECIFICS]

Inspect the current diff and select minimal adequate checks: format only changed Dart files, `flutter analyze`, focused tests for changed behavior and security/ownership paths when affected. Add or repair missing focused tests where necessary; run relevant integration tests when affected by cross-screen behavior. Do not make existing tests pass by removing assertions.

If UI changed, confirm actual screenshot comparison against approved reference, responsive/localization smoke tests and any controlled golden fixtures. If reference, device or execution is missing, mark visual check BLOCKED, not PASS.

Report a compact gate matrix: exact commands, PASS/FAIL/BLOCKED, root cause for failures, whether each failure preexisted this change and the minimum necessary next fix. Stop after two unsuccessful debugging cycles and summarize evidence instead of guessing.
