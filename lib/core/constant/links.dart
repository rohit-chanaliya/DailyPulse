/// External links used by the app.
///
/// Hosted on Firebase Hosting (see `hosting/` and the rewrites in
/// `firebase.json`). Google Play requires both to be reachable without the app.
abstract final class AppLinks {
  /// Privacy policy shown in Settings and on the sign-up screen.
  static const privacyPolicy = 'https://dailyplus-mobile-app.web.app/privacy';

  /// Terms shown on the sign-up screen.
  static const termsOfService = 'https://dailyplus-mobile-app.web.app/terms';

  /// Support contact, also listed in the privacy policy.
  static const supportEmail = 'chandrarohit91@gmail.com';

  /// `mailto:` link to [supportEmail] with a prefilled [subject].
  static String supportMailto(String subject) =>
      'mailto:$supportEmail?subject=${Uri.encodeComponent(subject)}';

  /// Page where users can request account deletion without the app.
  static const accountDeletion =
      'https://dailyplus-mobile-app.web.app/delete-account';
}
