# Auth implementation guide

Current implementation on `reimplement/sl01-sl02`, following the 2026-10-05 presentation, domain semantics and Supabase data-boundary passes. Requirements remain in the [feature specification](../../../specs/002-account-access-session-isolation/spec.md), [plan](../../../specs/002-account-access-session-isolation/plan.md) and [PRD](../../PRD.md). Verification is recorded in [project state](../../PROJECT_STATE.md). Historical lifecycle/file maps do not describe the current implementation.

## Current file map

Paths below are under `lib/features/auth/`.

| Area | Files / responsibility |
| --- | --- |
| Screens | `presentation/screens/`: sign-in, registration, recovery, recovery sent, reset, verification, session expired and restoring |
| Forms | `presentation/widgets/`: four forms own controllers, password visibility and submit actions |
| Shared UI | `auth_page_scaffold.dart`, `auth_page_header.dart`, `auth_text_field.dart`, `auth_buttons.dart`, `auth_illustrations.dart` |
| Messages | `auth_messages.dart` localizes failures/field errors; `auth_notification_listener.dart` listens for new failures |
| Confirmation | `presentation/sheets/sign_out_warning_sheet.dart` returns a boolean |
| Feature state | `presentation/cubit/auth_cubit.dart`, `auth_state.dart` |
| Input rules | `presentation/validation/auth_input_validator.dart` |
| Domain | `domain/entities/auth_session.dart`, `domain/events/auth_event.dart`, `domain/failures/auth_failure.dart`, `domain/repositories/auth_repository.dart`, `domain/use_cases/` |
| Data | `data/repositories/supabase_auth_repository.dart`, `data/storage/secure_auth_storage.dart` |

Adjacent composition lives in app bootstrap, `app/streak_up_app.dart`, routing and generated Injectable DI. No separate AuthSession application layer remains.

## Ownership and command flow

Screens own page structure/navigation. Forms call AuthCubit with raw input. Cubit normalizes/validates input, owns loading, field errors, failures and status, calls use cases and consumes results with fold. Controllers/password visibility stay local. No UI event framework or form controller layer is needed.

The current command path is Cubit -> UseCase -> AuthRepository -> SupabaseAuthRepository -> Supabase SDK. The repository receives SupabaseClient, SecureAuthStorage and AppLogger through constructor injection. Each command directly calls the SDK and returns Either<AuthFailure, T>. No DataSource or generic operation executor remains. Private _toAuthSession and _mapFailure keep SDK conversion local. Current-session reads immediately map SDK evidence; events map SDK lifecycle events and errors to domain events and preserve recovery marker writes.

Removed data/datasources/supabase_auth_data_source.dart and data/extensions/supabase_auth_extensions.dart and their empty folders. Replaced auth_repository_impl.dart with supabase_auth_repository.dart. SecureAuthStorage remains responsible for protected persistence and SDK storage hooks. SDK types stay in data and legitimate bootstrap/generated DI/network infrastructure, never domain or presentation.

SDK persistence is drained before success and after errors; latched storage failures take precedence over SDK failures. Initial health failures skip SDK operations. Direct calls preserve recovery non-enumeration for user_not_found/email_not_found, identity guards around password updates, redacted sign-in logging, persistence order, recovery completion and local sign-out cleanup.

Sign-in/registration use router-observed status changes. Recovery/reset forms await existing Future<bool> commands and navigate on success while mounted. Reset finishes signed out. Recovery/verification emails remain because resend and verification UI use them. AuthState has no info messages, compatibility aliases, submission enum, completion marker or revision counter. Cubit has no manual UI clearing methods; command transitions clear their own outgoing state.

## Notifications and validation

StreakUpApp installs one AuthNotificationListener inside MaterialApp's builder above router content. It localizes new failures and calls AppNotifier.error; it does not navigate or access Supabase. Commands clear previous failures so repeated attempts need no counters.

Forms display validation beside fields. Resend handlers await success, check mounted and call AppNotifier.info. Loading belongs to buttons; confirmation belongs to sheets. Transient notifications use AppNotifier/Toastification.

## Shared widgets and theme

AuthPageScaffold owns artwork, safe areas, one scroll view and bounded content. Scaffold handles keyboard resizing without a second inset. AuthPageHeader has real reused layout variations. AuthTextField forwards interactions/errors and uses AppTheme decoration; its 17px input adjustment is deliberate. AuthPrimaryButton adds loading/disabled behavior. AuthSecondaryPillButton is a reused wrapping prompt/action recipe; visual styles belong to AppTheme. Dividers/artwork have real reuse. No AuthTypography exists.

Verification keeps badge/actions in the same file. Session expired keeps illustration/protection note in the same file. Recovery Sent selects loading only inside Send Again. Restoring is static wordmark/progress/title/subtitle UI.

## Sign-out confirmation and transitions

Use `final confirmed = await SignOutWarningSheet.show(context);`, return when `!confirmed || !context.mounted`, then call `context.read<AuthCubit>().signOut()`. The sheet returns true/false and has no Cubit or action callbacks. Private handle/artwork remain in the same file.

Cubit captures prior state, enters signingOut/loading and ignores SDK events while awaiting the command because SDK signedOut precedes completed network/storage work. On Left, current SDK-backed evidence is read through GetCurrentSessionUseCase: surviving evidence retains prior stable auth/recovery/verification status with failure/loading false; absent evidence gives reauthenticationRequired, cleared session and failure. Right gives signedOut, cleared session/failure/outgoing presentation state and loading false. This structural simplification leaves those transitions unchanged.

## Restore transitions

Every settled restore leaves restoring/loading. Right(null) gives signedOut/no session/no failure/true. Valid verified/unverified evidence gives authenticated/verificationRequired respectively; known recovery remains recoveryRequired. InvalidSession Left or invalid token evidence on Right gives reauthenticationRequired/no session/invalidSession/false. Network failure with local evidence retains it and selects verified/unverified status while preserving known recovery or confirmed reauthentication restriction; failure remains and return is false. Expired evidence cannot grant protected access. Network failure without local evidence and other failures give signedOut/no session/failure/false. All settled branches set isSubmitting false.

## Session identifier and token validity

AuthSession.userId comes from SDK Session.user.id. No id alias, AuthUser or AuthRegistration remains. Registration returns Either<AuthFailure, AuthSession?> and no-session registration clears previous evidence. The entity barrel exports only AuthSession. Failures/events remain in their domain folders.

Private _toAuthSession maps user identity/email, parses emailConfirmedAt and retains UTC expiry only when the access token is nonempty and expiry is known. No token enters domain. accessTokenValid computes now + thirty seconds < expiresAt whenever read, preserving the installed SDK margin. Missing expiry returns false; equality/hash use stable evidence.

Retryable refresh failures retain SDK evidence and can leave the same entity in AuthState. Dynamic validity avoids a stale true boolean. Protected-access and router decisions read current validity. Elapsed time alone does not emit state, refresh GoRouter or rebuild an existing screen; no timer/polling mechanism was introduced. Restore refreshes expired SDK evidence; checkVerification refreshes explicitly. Identifier/validity semantics remain unchanged by the data-boundary simplification.

## Design and verification

Preserve approved SL02-UI-001 through SL02-UI-007 references (including SL02-UI-004B) in [DESIGN_MANIFEST.md](../../design/DESIGN_MANIFEST.md), brand colors, spacing, RTL and safe areas. No visual redesign occurred.

Run dart format lib, normal generation when DI changes, and flutter analyze --no-pub lib. The current task excludes test execution/migration. Stale tests must be migrated separately; do not restore obsolete production APIs for them. Exact results are recorded in project state. Live Supabase/device, storage and release behavior were not reverified by this structural pass.
