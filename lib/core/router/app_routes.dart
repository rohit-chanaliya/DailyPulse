/// Central list of route paths used across the app.
///
/// Keeping paths in one place avoids stringly-typed navigation and makes
/// deep-link handling predictable.
abstract final class AppRoutes {
  static const String splash = '/splash';
  static const String welcome = '/welcome';
  static const String onboarding = '/onboarding';

  static const String signIn = '/sign-in';
  static const String signUp = '/sign-up';
  static const String forgotPassword = '/forgot-password';

  static const String home = '/home';
  static const String history = '/history';
  static const String insights = '/insights';
  static const String settings = '/settings';

  static const String addNote = '/mood-note';

  /// Routes that may be visited without an authenticated user.
  static const Set<String> publicRoutes = {
    splash,
    welcome,
    onboarding,
    signIn,
    signUp,
    forgotPassword,
  };

  /// First-run screens that should not be shown again once completed.
  static const Set<String> onboardingRoutes = {welcome, onboarding};
}
