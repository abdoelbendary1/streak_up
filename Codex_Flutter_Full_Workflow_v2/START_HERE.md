# Codex full-development workflow pack — Flutter first, Next.js later

**Release:** 2026-09-30 | **Audience:** Existing Flutter projects using Spec Kit and approved PNG designs. Tested here for package structure/scripts; your actual repository and Codex account have NOT been accessed.

## What is in this ZIP?

- **4 original project-local Codex skills** in `.agents/skills/`: `flutter-ui-fidelity`, `flutter-architecture-guard`, `flutter-feature-implementer`, `codex-efficient-workflow`.
- **9 ready-to-adapt prompts** in `prompts/`, including a read-only rescue audit, a task slicer, scoped implementation, visual correction, offline sync, CodeRabbit review, session handoff and a future-web prompt.
- `AGENTS_APPEND.md`: compact repository instructions; merge or opt into backed-up append. **Never replace** your existing `AGENTS.md` or Spec Kit files.
- `scripts/install-local.ps1` for SAFE project-local installation; `scripts/install-official.ps1` for the independently maintained Flutter plugin/official skills; `scripts/capture-android.ps1` for repeatable screenshot capture; `scripts/compare_screenshots.py` for *optional* image overlays, not automatic visual approval; `scripts/check-pack.py` for validation.
- Templates and checklists for UI evidence, PR quality gate and session handoff.

Official Flutter and Dart skills are **not copied into this ZIP** because they update independently. Install them through the official Flutter Codex plugin (preferred) OR the official standalone skill installer. The installer script provides both options. This pack does not bundle an MCP server executable, API keys, Supabase credentials or copied proprietary assets.

## 1. Back up your repo and create a branch

```powershell
cd 'F:\Abdelrahman\Flutter\StreakUp\streak_up'  # adjust to actual project
# If git status shows changes, commit/stash them deliberately BEFORE proceeding.
git status --short
git switch -c chore/codex-workflow
```

**Do not execute** `git reset --hard` or delete anything to prepare the installation. An existing dirty working tree must be reviewed, not silently discarded.

## 2. Install the 4 custom skills (does NOT overwrite existing skills)

Unzip this pack anywhere, then from **the unpacked pack directory** run:

```powershell
powershell -ExecutionPolicy Bypass -File .\scripts\install-local.ps1 -ProjectRoot 'F:\Abdelrahman\Flutter\StreakUp\streak_up'
```

The installer **skips names already installed**, reports conflicts and leaves your root `AGENTS.md` unchanged unless `-AppendAgentRules` is explicitly supplied. Review `AGENTS_APPEND.md`, then either paste it into your existing file or run:

```powershell
powershell -ExecutionPolicy Bypass -File .\scripts\install-local.ps1 -ProjectRoot 'F:\Abdelrahman\Flutter\StreakUp\streak_up' -AppendAgentRules
```

The opt-in append backs up the old `AGENTS.md` first. The installer will never replace a conflicting skill. Skills install under `<project>/.agents/skills/` alongside your existing Spec Kit Codex skills.

## 3. Install the OFFICIAL Flutter tools (separate from this ZIP)

Check that `codex`, `dart`, `flutter` and an Android emulator/device are available. Run ONE of the following from PowerShell after reviewing what the script does:

```powershell
# PREFERRED: official Flutter Codex plugin with its bundled skills/MCP settings
powershell -ExecutionPolicy Bypass -File .\scripts\install-official.ps1 -Method Plugin

# ALTERNATIVE: standalone official Flutter + Dart skills; you must verify Dart MCP separately
powershell -ExecutionPolicy Bypass -File .\scripts\install-official.ps1 -Method Standalone -ProjectRoot 'F:\Abdelrahman\Flutter\StreakUp\streak_up'
```

The script asks for your confirmation before remote installation. **Do not run both modes by default.** After the plugin route, check `codex plugin list` and `codex mcp list`; add Dart MCP manually only if it wasn't installed. If your Codex release does not support `plugin`, use Standalone.

Current upstream instructions: https://docs.flutter.dev/ai/get-started .

## 4. Start with a READ-ONLY audit, not immediate rewriting

1. Review `AGENTS_APPEND.md` and fill in any project-specific differences; repo is source of truth, not the example technologies in these files.
2. Open Codex from the repo root. Optionally inspect `/status` before and after each slice.
3. Paste `prompts/01-rescue-audit.md`; fill its `[PLACEHOLDERS]` with real file references. Keep this first pass strictly read-only.
4. Examine its findings and decide whether the fix is UI-only, business logic or an architectural change.
5. Use `prompts/02-slice-approved-feature.md`, then `prompts/03-implement-one-slice.md` for exactly **one** approved slice.
6. For UI, run the app on a matching emulator/device and capture with `scripts/capture-android.ps1`; attach reference + actual PNGs to Codex, then use `prompts/04-fix-visual-mismatch.md`.
7. Run `flutter analyze` + relevant tests; inspect diff and screenshots; use `prompts/07-pr-review.md` and CodeRabbit as a separate gate. Never claim a CodeRabbit review took place without its actual output.

## 5. Screenshots on Windows

From unpacked pack directory (device already started; `adb devices` must show exactly one device, or specify its serial):

```powershell
powershell -ExecutionPolicy Bypass -File .\scripts\capture-android.ps1 -OutputPath '.\artifacts\current.png'
# Optional: if more than one device is connected, also pass -Device 'emulator-5554'
```

Or run the installed Dart/Flutter MCP's runtime inspection/screenshot tools when those capabilities are available in your version. Screenshots must capture the correct route, locale, theme and UI state. The **approved reference screenshot must already exist** in your project; this ZIP does not fabricate it.

Optional side-by-side visual aid (requires Python and Pillow, and equivalent/cropped content areas):

```powershell
python -m pip install Pillow
python .\scripts\compare_screenshots.py --reference PATH_TO_APPROVED_PNG --actual .\artifacts\current.png --output-dir .\artifacts\comparison
```

The overlay and raw difference images are **diagnostics only**. Do not use a pixel-difference percentage as an automatic accept/reject quality threshold.

## 6. Next.js later

When working on a **separate website repository**, refer to `prompts/09-nextjs-design-and-code.md` and install upstream Vercel skills there. Playwright MCP is useful for browser-level verification. Keep web-only tools out of your Flutter sessions.

## Security and non-goals

- Do not paste secrets into Codex prompts, commit `.env` files or expose production Supabase write credentials to MCPs.
- No prompt or skill guarantees lower usage; actual allowance depends on model, reasoning, tool calls and account. Measure usage with `/status`.
- No automated screenshot system can grant design approval on your behalf. Human sign-off remains required.
- No scripts automatically change remote databases, run destructive Git commands, or mutate your original source tree except the explicit project-local installer.

## Sources for installation conventions

- Official Flutter AI + Codex setup: https://docs.flutter.dev/ai/get-started
- Flutter's official tools/MCP: https://docs.flutter.dev/ai/tools
- Flutter-maintained skills: https://github.com/flutter/agent-plugins
- Dart-maintained skills: https://github.com/dart-lang/skills
- Spec Kit Codex integration: https://github.com/github/spec-kit/blob/main/docs/reference/integrations.md
- OpenAI guidance for targeted skills/context: https://developers.openai.com/blog/rethinking-skills-and-prompts-for-gpt-6-astra
- Skill structure: https://developers.openai.com/api/docs/guides/tools-skills
