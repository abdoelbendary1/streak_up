# Independently maintained official skills and optional MCPs

**Do not duplicate these upstream skills inside this ZIP.** Install at runtime from their maintainers and confirm real installed names/versions.

## Preferred Flutter + Dart (Codex plugin)

```
codex plugin marketplace add flutter/agent-plugins
codex plugin add dart-flutter@dart-flutter
codex plugin list
codex mcp list
```

Official instructions: https://docs.flutter.dev/ai/get-started . If the plugin added Dart MCP, do not add it again. If plugin support is missing in your actual Codex CLI, standalone:

```
npx skills add flutter/agent-plugins --skill '*' --agent universal --yes
npx skills add dart-lang/skills --skill '*' --agent universal --yes
codex mcp list
# If NO dart MCP and your Dart SDK supports it:
codex mcp add dart -- dart mcp-server
```

Official Flutter skills of most immediate practical interest: responsive layout, widget preview, widget testing, layout fixes and integration tests. Use architecture/networking skills only when consistent with your already-approved stack. Dart testing, analysis and dependency skills are useful when the relevant task calls for them. See https://github.com/flutter/agent-plugins and https://github.com/dart-lang/skills .

## Existing Spec Kit

Codex Spec Kit skills normally live in `<repo>/.agents/skills/speckit-*/SKILL.md`, invoked using `$speckit-...` inside Codex. Reuse them. If your repo has only an Antigravity integration, inspect the current `specify` version and official migration docs before installing a second integration:
https://github.com/github/spec-kit/blob/main/docs/reference/integrations.md

## Optional tools

- Flutter Dart/Flutter MCP: supplies real SDK diagnostics, tests, symbol info and runtime introspection; see https://docs.flutter.dev/ai/tools
- Supabase MCP: use read-only project-scoped development configuration; see https://supabase.com/docs/guides/getting-started/mcp . Never connect unrestricted production writes by default.
- Next.js separate project: Vercel agent skills https://vercel.com/docs/agent-resources/skills , Playwright MCP https://github.com/microsoft/playwright-mcp .
- `dart run skills@ get` may discover **package-provided** skills installed by your project dependencies when package authors supply them: https://docs.flutter.dev/ai/tools . Review each discovered skill before adopting.

Activating every MCP simultaneously can create unnecessary tool/schema context. Only add what the project needs.
