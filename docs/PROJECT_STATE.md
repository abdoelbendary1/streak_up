# StreakUp Project State

Current Phase: Feature Development  
Active Feature: SL-02 — Account Access and Session Isolation  
Feature Stage: Implementation In Progress; verification outstanding
Implementation Agent: Antigravity  
Design Stage: SL-02 PNG designs approved; SL-01 approved and verified  
Design Gate: SATISFIED for SL-02  
Implementation Allowed: YES — SL-02 implementation is underway; this is not a completion or convergence signal.
Previous Feature: SL-01 — Completed / Converged  
Next Gate: Complete or formally disposition T035 platform verification, then complete T036 acceptance reconciliation.

## Approved design references

The Product Owner approved these exact paths, registered in [DESIGN_MANIFEST.md](design/DESIGN_MANIFEST.md):

- `docs/design/identity/VID-001-visual-identity.png` — visual identity.
- `docs/design/identity/LOGO.png` — primary logo.
- `docs/design/identity/APP Icon.png` — app icon.
- `docs/design/references/REF-001-today.png` — Today and primary shell reference.
- `docs/design/references/REF-002-habits.png` — Habits main screen.
- `docs/design/references/REF-003-challenges.png` — Challenges main screen.
- `docs/design/references/REF-004-friends.png` — Friends main screen.
- `docs/design/screens/001-bilingual-shell-feedback/SL01-UI-001-sync-failed-review-en.png` — failed sync banner and Review entry.
- `docs/design/screens/001-bilingual-shell-feedback/SL01-UI-002-offline-en.png` — offline banner and locally saved action status.
- `docs/design/screens/001-bilingual-shell-feedback/SL01-UI-003-large-text-en.png` — large-text shell layout.
- `docs/design/screens/001-bilingual-shell-feedback/SL01-UI-004-sync-issue-compact-en.png` — compact sync issue banner and Review entry.
- `docs/design/screens/001-bilingual-shell-feedback/SL01-UI-005-today-rtl-ar.png` — Arabic RTL shell.
- `docs/design/screens/002-account-access-session-isolation/SL02-UI-001-sign-in.png` — Sign In.
- `docs/design/screens/002-account-access-session-isolation/SL02-UI-002-registration.png` — Registration.
- `docs/design/screens/002-account-access-session-isolation/SL02-UI-003-email-verification.png` — Email Verification.
- `docs/design/screens/002-account-access-session-isolation/SL02-UI-004-password-recovery.png` — Password Recovery.
- `docs/design/screens/002-account-access-session-isolation/SL02-UI-004B-password-recovery-email-sent.png` — Password Recovery Email Sent.
- `docs/design/screens/002-account-access-session-isolation/SL02-UI-005-session-restoring.png` — Session Restoring.
- `docs/design/screens/002-account-access-session-isolation/SL02-UI-006-session-expired.png` — Session Expired / Reauthentication.
- `docs/design/screens/002-account-access-session-isolation/SL02-UI-007-sign-out-unsynced-warning.png` — Sign Out with Unsynced Work Warning.
- `docs/design/screens/002-account-access-session-isolation/SL02-UI-008-switch-account-unsynced-warning.png` — Switch Account with Unsynced Work Warning.
- `docs/design/screens/004-habit-create/SL04-UI-001-create-habit.png` — Create Habit visual reference for later SL-04 planning only.

`docs/design/screens/001-bilingual-shell-feedback/today-en.png` and `docs/design/references/REF-001-streakup-master.png` are byte-identical aliases of `REF-001-today.png`.

## SL-01 convergence and SL-02 design gate

The [SL-01 specification](../specs/001-bilingual-shell-feedback/spec.md), [technical plan](../specs/001-bilingual-shell-feedback/plan.md), [research](../specs/001-bilingual-shell-feedback/research.md), [presentation model](../specs/001-bilingual-shell-feedback/data-model.md), [presentation contract](../specs/001-bilingual-shell-feedback/contracts/presentation.md), [verification quickstart](../specs/001-bilingual-shell-feedback/quickstart.md), and [49-task breakdown](../specs/001-bilingual-shell-feedback/tasks.md) (`T001`–`T049`) are complete and converged. Implementation, generated routes/DI/localizations (`go_router_builder`, `injectable_generator`, `flutter gen-l10n`), responsive/adaptive constraint-driven layout (`<360` compact, `360–599` standard, `>=600` centered wide max-width `560px`), English/Arabic RTL parity (`0–9` Western Arabic numerals, unmirrored brand wordmark), connection/action status separation (`Online`/`Offline`/`Reconnecting`/`Syncing`/`SyncFailed` vs. `Pending`/`Synced`/`Failed`), shared feedback and accessibility (`>=48x48` primary targets, live regions, reduced-motion fallbacks), privacy-safe `AppLogger`/`RedactedBlocObserver`, CodeRabbit review disposition, and `flutter analyze` / `flutter test` (`24/24` passing) are verified. Recorded platform verification gaps (macOS/iOS hardware VoiceOver/dynamic-island scrubbing and physical Android TalkBack gesture scrubbing on a Windows 10 host) are documented for hardware verification without blocking SL-01 shell convergence. **SL-01 COMPLETE / CONVERGED: YES.** Further SL-01 feature expansion is closed. [SL-02 specification](../specs/002-account-access-session-isolation/spec.md) is clarified. All nine required SL-02 PNG states are present and explicitly approved by the Product Owner; their exact paths and scoped variants are registered in [DESIGN_MANIFEST.md](design/DESIGN_MANIFEST.md). The [SL-02 technical plan](../specs/002-account-access-session-isolation/plan.md) and task breakdown are in place; implementation is authorized and underway, with T001–T034 recorded complete. T035 platform verification remains open and T036 acceptance reconciliation remains unchecked pending T035; the SL-02 handoff and convergence are not complete. No dedicated Data Contract is required because SL-02 adds no application-owned persistent product data. The Product Owner approved account-scoped retention of unsynced work across sign-out, account switch, and confirmed session expiry; voluntary transitions require an explicit warning, and work resumes only after the same account identity is confirmed. Email-and-password registration/sign-in, email recovery, and email verification before first shell entry are approved. SL-02 implementation has not started; implementation is now allowed.

## Data-layer state

The Supabase project exists according to the Product Owner. The repository has completed only `SL-01` presentation/shell foundations: no production Supabase schema or migration, Isar collection, DTO, domain entity, mapper, sync table, or RLS policy is implemented yet. [DATABASE.md](DATABASE.md) is an approved foundation, not a production schema. No product data-layer files were created in `SL-01`.

For each future persistence feature, its technical plan must define one aligned **Data Contract** covering domain entity; application-facing types where needed; Isar model; Supabase PostgreSQL schema; remote DTO/row; layer mappers; IDs; enum/value mappings; nullability; defaults; timestamps; revision/conflict metadata; tombstones/deletion; indexes; RLS/authorization; migration; and sync/outbox behavior where applicable. Alignment does not mean one class across layers. Domain models remain free of Isar and Supabase concerns. SL-01 creates no product data entity.

## Authority and gates

The [roadmap](ROADMAP.md) and [feature registry](FEATURE_REGISTRY.md) remain the approved delivery order. For behavior: PRD → active spec → approved clarifications. For technical work: constitution → architecture → database foundation → active feature plan. For visuals: feature-specific approved PNG → closest approved reference PNG → [DESIGN_SYSTEM.md](design/DESIGN_SYSTEM.md) → [BRAND_IDENTITY.md](design/identity/BRAND_IDENTITY.md) → UI/UX foundation. Only APPROVED manifest images may guide implementation. Approved PNGs govern styling; report any product-behavior contradiction rather than implementing it.
