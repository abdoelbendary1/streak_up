import 'package:streak_up/core/localization/app_localizations.dart';
import 'package:streak_up/features/auth/domain/failures/auth_failure.dart';
import 'package:streak_up/features/auth/presentation/validation/auth_input_validator.dart';

extension AuthFailureLocalization on AuthFailure {
  String localizedMessage(AppLocalizations l10n) {
    return switch (this) {
      AuthFailure.invalidCredentials => l10n.authErrorInvalidCredentials,
      AuthFailure.emailAlreadyInUse => l10n.authErrorEmailAlreadyInUse,
      AuthFailure.weakPassword => l10n.authErrorWeakPassword,
      AuthFailure.rateLimited => l10n.authErrorRateLimited,
      AuthFailure.network => l10n.authErrorNetworkOrBackend,
      AuthFailure.invalidEmail => l10n.authErrorInvalidEmail,
      AuthFailure.verificationStillPending =>
        l10n.authErrorVerificationStillPending,
      AuthFailure.storage ||
      AuthFailure.sessionMissing ||
      AuthFailure.rejected ||
      AuthFailure.unexpected ||
      AuthFailure.invalidSession => l10n.authErrorUnexpected,
    };
  }
}

extension AuthInputErrorLocalization on AuthInputError {
  String localizedMessage(AppLocalizations l10n) {
    return switch (this) {
      AuthInputError.invalidEmail => l10n.authErrorInvalidEmail,
      AuthInputError.weakPassword => l10n.authErrorWeakPassword,
      AuthInputError.passwordMismatch => l10n.authErrorPasswordMismatch,
    };
  }
}
