# Codex stage playbook

The Product Owner approved the Lean Feature Workflow on 2026-10-01. Codex owns both planning and implementation; product decisions and design approval remain with the Product Owner. Apply the [Constitution](../../.specify/memory/constitution.md) and [engineering guidelines](PRAGMATIC_FLUTTER_GUIDELINES.md). CodeRabbit is removed from future work. Targeted review may help high-risk changes but is not a mandatory stage.

## Default workflow

1. **Understand + Specify.** Read the task-specific PRD/spec/code/test slice. Write one concise spec.md: purpose, user flows, business rules, acceptance criteria, important edge cases and genuine unresolved product decisions. Reuse existing approvals by reference. Clarification is not a separate stage; ask only when a real product decision blocks implementation.
2. **Design Reference, if UI exists.** Obtain an approved design/PNG before UI implementation and cite exact paths. Understand hierarchy, sections, states, interactions, visual language and RTL implications. Codex does not perform design exploration. Implement functional UI reasonably close to the reference; final polish is a later Product Owner pass.
3. **Plan.** Write one concise plan.md: data flow, state ownership, architecture boundaries, folders/files, data/database impact, ordered implementation steps, tests and relevant risks. Check consistency here. Tasks may live inside the plan; separate tasks.md only when useful. No separate Spec Kit analysis stage is required.
4. **Implement + Test.** Prioritize correct logic, all required states, maintainable code, organization, automated tests and functional UI. Check that screens have no feature submission workflow, state owners/dependencies are explicit, presentation validation is not duplicated, controls/layout have no unjustified custom mechanism, no hidden fake rebuild exists, and files support manual maintenance. Use focused tests during work. Preserve behavior coverage when changing construction; remove only tests of deliberately removed internal ownership.
5. **Finalize.** Run analyzer, relevant automated tests and git diff --check; use a lightweight runtime check where it resolves a real uncertainty. Write/update IMPLEMENTATION_GUIDE.md and feature/project state. Report exact results and actual unavailable release/platform evidence. Pixel-perfect comparison and exhaustive screenshot matrices are not gates.

## Spec Kit and proportional depth

Spec Kit stays as a requirements/planning tool. Default new artifacts are spec.md and plan.md plus approved design references for UI. Add a data contract, research, contracts, task breakdown or other deeper artifacts only for concrete risk: persistence, sync, ownership, RLS/authorization, cross-user operations, challenge scoring or destructive privacy operations. Do not repeat PRD/architecture text. Existing artifacts remain useful references; do not regenerate them for each implementation slice. Bounded approved fixes/refactors reuse existing specs and record a concise plan delta.

## Bounded execution

Start with branch/status and direct implementation/tests. Search and read relevant sections before expanding context. Do not reread historical specs or generated files without a concrete question. Reuse established facts within the task; no repeated handoff or tracking file is required. Batch independent reads; sequence dependent edits and checks. Use no agents unless explicitly authorized. Keep reversible changes on the requested existing branch; do not create another worktree when the task says to use the existing repository.

Format touched Dart files and regenerate only through normal generators. Broaden tests for shared/auth/security changes. Do not run unrelated remote integration, migrations, iOS verification on Windows or dependency upgrades. For documentation-only work check consistency, links and diff scope. If a diagnostic fails, change hypothesis and continue authorized work. Do not claim tests, deployment or platform checks passed without evidence. Final reports follow the requested format.
