/// Centralized user-facing strings for the delete-account screen.
abstract final class DeleteAccountStrings {
  static const String title = 'Delete Account';

  static const String intro = 'Deleting your account permanently removes:';

  static const String bulletAccount = 'Your DailyPulse sign-in account';
  static const String bulletEntries = 'Every mood entry you logged';
  static const String bulletNotes = 'Every journal title and note';
  static const String bulletDevice = 'The local copy stored on this device';

  static const String irreversibleNote =
      'This action is permanent. We cannot restore your account or your mood '
      'history afterwards.';

  static const String emailLabel = 'Signed in as';
  static const String passwordLabel = 'Current password';
  static const String passwordHint = 'Enter your password to confirm...';
  static const String passwordHelp =
      'Needed only if you signed in a while ago. Google accounts confirm with '
      'the account picker instead.';
  static const String passwordRequiredError = 'Enter your password to continue';

  static const String deleteButton = 'Delete my account permanently';
  static const String deleteFailed =
      'Could not delete your account. Please try again.';
  static const String cancelButton = 'Keep my account';
  static const String webFallback =
      'Can\'t delete from the app? Use the web page';

  static const String deletedMessage =
      'Your account and all of its data have been deleted.';
}
