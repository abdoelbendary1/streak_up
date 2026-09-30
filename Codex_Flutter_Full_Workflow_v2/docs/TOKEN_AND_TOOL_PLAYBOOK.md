# Codex allowance + quality playbook

There is **no universal numeric rule** that prevents hitting a limit. Your available models, quotas and tool economics may change; check `/status` in your account, compare the *same task types* and keep your own usage log.

**For small fixes**: smallest reliable available model; direct file + one test; avoid broad repo search and full-scope audit.
**For UI features**: a capable coding model for one state + normal tests; runtime visual check is mandatory, but bound correction rounds and capture comparable screenshots.
**For auth, offline sync, security, migrations**: use stronger reasoning, inspect verified contracts and tests; do not cut essential checks to save allowance.

Good task prompt: goal + real file paths + acceptance criteria + non-goals + test evidence expected. Bad task prompt: 'make the whole app professional, modern and perfect.'

Read docs only as needed. E.g. UI slice -> current screen spec, approved reference, design tokens, nearest analogous widget and test. Auth/sync slice -> precise product rule, relevant architecture/database contract and adjacent implementation. Spec Kit planning should be reused, not repeated on every small iteration.

Keep MCP selection purposeful: Dart MCP for Flutter; optional Supabase MCP restricted to an appropriate **nonproduction read-only** project for schema inspection; Playwright MCP for website browser verification. An MCP tool is not an unlimited free external coding agent.

Save a compact verified handoff before a fresh session instead of copying full transcripts. Use focused logs: `flutter analyze`, specific test file(s), exact crash trace, no massive indiscriminate output. An unexpected failure may need deeper examination—do not cap investigation so tightly that correctness suffers.
