---
name: flutter-feature-implementer
description: Implement a single already-approved Spec Kit task in an existing Flutter repository, with focused tests and a clear completion report. Use when specification, plan and UI approvals exist and the user asks Codex to implement one bounded task.
---

# Implement exactly one approved feature slice

This skill starts **after** the repository's Spec Kit specification/clarification/design/plan gates. Do not pretend a spec or PNG is approved based only on a prompt assertion; find the actual referenced artifact and state.

1. Input contract: feature ID, exact task ID, approved spec/tasks path, acceptance criteria, existing example components/contracts, optional approved PNG/state, relevant files. If a source is missing, scope work to verified acceptance criteria and report the missing gate; never invent source content.
2. Baseline: inspect `git status`, target files and focused tests; report existing changes and never discard or overwrite another person's work. Confirm one small slice can be completed without broad speculative refactoring.
3. Create a tiny implementation plan: behavior, 3–8 expected touched files, targeted tests, acceptance checks and a stop boundary. Reuse dependency injection, existing routing, storage, state management, error/UI patterns and code generation already used in the repo.
4. Implement the smallest working vertical slice. For API/persistence changes, inspect contracts first and propose migration steps separately when necessary. Use approved mocks/fakes for local tests if the app cannot safely access development services.
5. Test happy path + material errors, permissions/account isolation and offline/conflict behavior when affected. For UI tasks invoke `flutter-ui-fidelity` and verify the actual runtime screenshot before declaring visually checked.
6. Run only relevant formatting, scoped tests and analyzer initially; broaden validation if shared code/contracts are touched. Stop and report instead of repeatedly running the full suite on a known unrelated failure.
7. Report changed paths, acceptance checks, exact tests/commands, visual evidence and remaining risks. Commit or update Spec Kit status **only if** that is already the repository's approved practice and the user has authorized it.

**Exit rule:** One slice implemented and verifiable, or clearly blocked. No adjacent feature implementation and no unbounded polish loop.
