# 08 — Compact handoff for a new Codex session

Use `$codex-efficient-workflow`.
Do not make edits. Produce <=350 words of verified handoff notes based on this session's actual files and tool results, not assumptions.

Use this structure:
- Project / branch and exact task ID
- What is actually implemented (no vague completion claims)
- Changed files and any uncommitted files (from real Git status)
- Spec / task / reference PNG paths used
- Commands/tests that ran and exact outcomes
- Runtime screenshots and remaining UI differences (if UI)
- Real blockers, open approvals and CodeRabbit status
- **One** exact next action and minimal files the next session should read

Do not dump entire chat transcripts or source files. Save the handoff only if the repo has an approved handoff location; otherwise return copyable text without creating a second project-state system.
