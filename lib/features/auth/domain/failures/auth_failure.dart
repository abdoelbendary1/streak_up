/// Typed domain failures for authentication operations.
enum AuthFailure {
  invalidEmail,
  rateLimited,
  emailAlreadyInUse,
  verificationStillPending,
  invalidCredentials,
  weakPassword,
  network,
  storage,
  sessionMissing,
  rejected,
  unexpected,
  invalidSession,
}
