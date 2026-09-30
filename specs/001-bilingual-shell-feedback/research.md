# SL-01 Planning Research and Decisions

**Sources:** [SL-01 spec](spec.md), [architecture](../../docs/ARCHITECTURE.md), [database foundation](../../docs/DATABASE.md), [UI/UX foundation](../../docs/UI_UX_FOUNDATION.md), and [approved design manifest](../../docs/design/DESIGN_MANIFEST.md).

## Repository findings

The repository contains a starter `lib/main.dart`, a starter widget test, Flutter and Cupertino Icons dependencies, and no product data layer. The Supabase project exists according to the Product Owner, but no production schema, migration, Isar collection, DTO, mapper, or sync service is present. The approved architecture chooses Bloc/Cubit, generated typed `go_router` routes, `get_it` + `injectable`, `gen_l10n`/ARB, Material 3, `AppLogger`, and a redacted global `BlocObserver`; these packages and infrastructure are not installed yet.

## Decisions for SL-01

| Decision | Reason and boundary |
| --- | --- |
| Shell host exposes four typed destinations, with global routes outside the bottom bar | Matches UXF-02 and SL01-FR-001–004. Later features supply actual content; auth redirect belongs to SL-02. |
| Presentation contracts consume typed connection and action states | Prevents raw string/boolean confusion, especially local success versus remote acknowledgment. Reachability and sync execution belong to SL-03. |
| Central feedback coordinator and shared widgets | Keeps message severity, optional action, localization, announcement, and persistence semantics consistent without creating Inbox history. |
| `gen_l10n` ARB and direction-aware composition | Supports equivalent English/Arabic meaning and RTL without manual list reversal. Profile later supplies a locale override; SL-01 does not persist it. |
| Semantic theme tokens first; visual validation for unspecified metrics | Colors and spacing rhythm are approved. Exact font, radii, elevation, and screenshot pixel measurements are not. |
| Development/test fixtures stay outside production status sources | Lets AS-01–AS-17 be verified while SL-02/SL-03 and destination features remain unimplemented; avoids pretending backend state exists. |

## Validation deferred to implementation

Choose compatible package versions and verify route/DI generation against the installed Flutter/Dart SDK before writing tasks that pin them. Validate font coverage, contrast, 48 logical-pixel primary targets, Arabic line height, large text, and 390 × 844 visual fidelity on actual rendered UI. Do not treat an interface connection as backend reachability or use screenshot copy to promise sync acceptance.

No external product decision is required to create SL-01 tasks. The remaining checks are implementation and verification work within the approved scope.
