# PR quality gate (not an automatic approval)

- [ ] Task's Spec Kit acceptance criteria confirmed against actual existing approved files
- [ ] `git diff --check`; no accidental secrets, generated junk, unrelated edits or giant formatting sweep
- [ ] Repo architecture, DI/router/state-management and error UI conventions preserved
- [ ] Relevant analyzer/linters and focused tests have evidence; regression paths covered
- [ ] If offline/auth: account privacy, retries/outbox/conflicts/idempotency/sign-out verified
- [ ] If UI: approved PNG vs actual runtime screenshot reviewed at equivalent viewport; adaptive checks performed
- [ ] CodeRabbit review actually run on PR; applicable findings resolved or documented
- [ ] Human visual/behavior approval complete where required
- [ ] Feature status/docs updated only per existing repo governance, without inventing another tracker
