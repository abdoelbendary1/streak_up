enum AuthInputError { invalidEmail, weakPassword, passwordMismatch }

bool hasValidAuthEmailSyntax(String email) =>
    RegExp(r'^[^\s@]+@[^\s@]+\.[^\s@]+$').hasMatch(email);

class AuthInputErrors {
  const AuthInputErrors({this.email, this.password, this.confirmation});

  final AuthInputError? email;
  final AuthInputError? password;
  final AuthInputError? confirmation;

  bool get isEmpty => email == null && password == null && confirmation == null;
}

/// Presentation validation for auth forms.
class AuthInputValidator {
  const AuthInputValidator();

  String normalizeEmail(String raw) => raw.trim();

  AuthInputErrors email(String normalized) => AuthInputErrors(
    email: hasValidAuthEmailSyntax(normalized)
        ? null
        : AuthInputError.invalidEmail,
  );

  AuthInputErrors password(String value, String confirmation) =>
      AuthInputErrors(
        password: value.length < 8 ? AuthInputError.weakPassword : null,
        confirmation: value != confirmation
            ? AuthInputError.passwordMismatch
            : null,
      );

  AuthInputErrors registration(
    String normalized,
    String value,
    String confirmation,
  ) {
    final passwords = password(value, confirmation);
    return AuthInputErrors(
      email: email(normalized).email,
      password: passwords.password,
      confirmation: passwords.confirmation,
    );
  }
}
