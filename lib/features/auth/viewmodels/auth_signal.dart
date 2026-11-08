import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:inject_annotation/inject_annotation.dart';
import 'package:signals_flutter/signals_flutter.dart';

import 'package:dailypulse/core/constant/strings/auth_strings.dart';
import 'package:dailypulse/core/services/app_preferences.dart';
import 'package:dailypulse/core/utils/app_logger.dart';
import 'package:dailypulse/core/utils/result.dart';
import 'package:dailypulse/features/auth/models/user_profile.dart';
import 'package:dailypulse/features/auth/repository/auth_repository.dart';
import 'package:dailypulse/features/mood/repository/mood_repository.dart';
import 'package:dailypulse/features/mood/services/sync_service.dart';

enum AuthStatus { initial, authenticated, unauthenticated, loading }

/// Reactive auth state. All SDK work lives in [AuthRepository]; this class only
/// maps outcomes to signals and coordinates sync/account cleanup.
@singleton
class AuthSignal {
  @inject
  AuthSignal(
    this._repository,
    this._syncService,
    this._moodRepository,
    this._preferences,
  ) {
    _authSubscription = _repository.userChanges.listen(
      _onAuthStateChanged,
      onError: (Object error, StackTrace stackTrace) {
        errorMessage.value = AuthStrings.authStreamError;
        appLogger.e('Auth stream error', error: error, stackTrace: stackTrace);
      },
    );
  }

  final AuthRepository _repository;
  final SyncService _syncService;
  final MoodRepository _moodRepository;
  final AppPreferences _preferences;
  late final StreamSubscription<User?> _authSubscription;

  final status = signal<AuthStatus>(AuthStatus.initial);
  final user = signal<User?>(null);
  final profile = signal<UserProfile?>(null);
  final profileImagePath = signal<String?>(null);
  final isUpdatingProfile = signal<bool>(false);
  final errorMessage = signal<String?>(null);

  Stream<User?> get userChanges => _repository.userChanges;
  User? get currentUser => _repository.currentUser;

  /// Whether the signed-in user authenticated through Google.
  bool get isGoogleUser {
    final current = user.value;
    if (current == null) return false;
    return current.providerData.any((info) => info.providerId == 'google.com');
  }

  /// Google users are always considered verified.
  bool get isEmailVerified =>
      user.value?.emailVerified == true || isGoogleUser;

  bool get isAuthenticated => status.value == AuthStatus.authenticated;

  void _onAuthStateChanged(User? value) {
    if (value == null) {
      user.value = null;
      profile.value = null;
      profileImagePath.value = null;
      status.value = AuthStatus.unauthenticated;
      _syncService.stopBackgroundSync();
      return;
    }
    user.value = value;
    profileImagePath.value = _preferences.getProfileImagePath(value.uid);
    status.value = AuthStatus.authenticated;
    unawaited(loadProfile());

    // Unverified email/password accounts keep a session so they can resend the
    // link, but must not sync or touch Firestore until verified.
    final isVerified =
        value.emailVerified ||
        value.providerData.any((info) => info.providerId == 'google.com');
    if (!isVerified) {
      _syncService.stopBackgroundSync();
      return;
    }

    // Nothing else starts sync, so this listener is the single entry point:
    // it covers cold starts with a restored session and every sign-in.
    _syncService.startBackgroundSync();
    unawaited(_syncService.syncPendingEntries());
  }

  Future<bool> signUp({
    required String email,
    required String password,
    required String name,
    String? firstName,
    String? lastName,
    String? gender,
  }) async {
    status.value = AuthStatus.loading;
    errorMessage.value = null;
    final result = await _repository.signUp(
      email: email,
      password: password,
      name: name,
      firstName: firstName,
      lastName: lastName,
      gender: gender,
    );
    return switch (result) {
      Ok() => true,
      Err(:final message) => _fail(message),
    };
  }

  Future<bool> signIn({
    required String email,
    required String password,
  }) async {
    status.value = AuthStatus.loading;
    errorMessage.value = null;
    final result = await _repository.signIn(
      email: email,
      password: password,
    );
    return switch (result) {
      Ok() => true,
      Err(:final message) => _keepUnverifiedSession(message),
    };
  }

  /// A kept unverified session can resend its link, so it stays signed in.
  bool _keepUnverifiedSession(String? message) {
    if (_repository.currentUser != null) {
      status.value = AuthStatus.authenticated;
      errorMessage.value = message;
      return false;
    }
    return _fail(message);
  }

  Future<void> signOut() async {
    appLogger.i('User signed out');
    await _repository.signOut();
  }

  Future<bool> signInWithGoogle() async {
    status.value = AuthStatus.loading;
    errorMessage.value = null;
    final result = await _repository.signInWithGoogle();
    return switch (result) {
      Ok() => true,
      // A cancelled picker returns an error with no message: stay silent.
      Err(:final message) => _fail(message),
    };
  }

  Future<bool> sendPasswordReset(String email) async {
    status.value = AuthStatus.loading;
    errorMessage.value = null;
    final result = await _repository.sendPasswordReset(email);
    return switch (result) {
      Ok() => _succeed(AuthStatus.unauthenticated),
      Err(:final message) => _fail(message),
    };
  }

  /// Emails a reset link to the signed-in user without touching [status].
  Future<Result<void>> sendPasswordResetToCurrentUser() async {
    final email = user.value?.email;
    if (email == null) return const Err(AuthStrings.noSignedInUser);
    return _repository.sendPasswordReset(email);
  }

  void clearError() {
    errorMessage.value = null;
  }

  /// Resends the verification link to the signed-in, unverified user.
  Future<bool> resendVerificationEmail() async {
    final result = await _repository.resendVerificationEmail();
    return switch (result) {
      Ok() => true,
      Err(:final message) => _fail(message, state: status.value),
    };
  }

  /// Reloads the user and reports whether the email is now verified.
  Future<bool> checkEmailVerified() async {
    final result = await _repository.checkEmailVerified();
    switch (result) {
      case Ok(:final value):
        user.value = _repository.currentUser;
        return value;
      case Err(:final message):
        errorMessage.value = message;
        return false;
    }
  }

  /// Apply an email verification action code received via deep link.
  Future<bool> applyVerificationCode(String oobCode) async {
    return _applyActionCode(_repository.applyVerificationCode(oobCode));
  }

  /// Restore a previous email address from a `recoverEmail` action link.
  Future<bool> applyRecoveryCode(String oobCode) async {
    return _applyActionCode(_repository.applyRecoveryCode(oobCode));
  }

  Future<bool> _applyActionCode(Future<Result<void>> action) async {
    final result = await action;
    switch (result) {
      case Ok():
        user.value = _repository.currentUser;
        return true;
      case Err(:final message):
        errorMessage.value = message;
        return false;
    }
  }

  /// Validate a password reset code and return the account email.
  Future<String?> verifyPasswordResetCode(String oobCode) async {
    final result = await _repository.verifyPasswordResetCode(oobCode);
    return switch (result) {
      Ok(:final value) => value,
      Err(:final message) => _failureValue(message),
    };
  }

  /// Complete a password reset with a new password.
  Future<bool> confirmPasswordReset({
    required String oobCode,
    required String newPassword,
  }) async {
    final result = await _repository.confirmPasswordReset(
      oobCode: oobCode,
      newPassword: newPassword,
    );
    return switch (result) {
      Ok() => true,
      Err(:final message) => _fail(message),
    };
  }

  /// Permanently deletes the signed-in account and every data trace of it.
  ///
  /// The remote/local wipe runs while the user is still signed in, because the
  /// security rules only allow owners to delete their own documents.
  Future<bool> deleteAccount({String? password}) async {
    final current = _repository.currentUser;
    if (current == null) {
      errorMessage.value = AuthStrings.deleteAccountNoUser;
      return false;
    }

    final dataDeleted = await _moodRepository.deleteAccountData(current.uid);
    if (!dataDeleted) {
      errorMessage.value = AuthStrings.deleteAccountDataFailed;
      return false;
    }

    final result = await _repository.deleteAccount(password: password);
    return switch (result) {
      Ok() => true,
      Err(:final message) => _fail(message),
    };
  }

  bool _fail(String? message, {AuthStatus state = AuthStatus.unauthenticated}) {
    status.value = state;
    errorMessage.value = message;
    return false;
  }

  bool _succeed(AuthStatus state) {
    status.value = state;
    errorMessage.value = null;
    return true;
  }

  String? _failureValue(String? message) {
    errorMessage.value = message;
    return null;
  }

  /// Loads the profile for the currently signed-in user.
  Future<UserProfile?> loadProfile() async {
    final current = user.value;
    if (current == null) {
      profile.value = null;
      return null;
    }
    final result = await _repository.getUserProfile(current.uid);
    if (result case Ok(:final value)) {
      profile.value = value;
      return value;
    }
    return null;
  }

  /// Updates profile details in Firestore and syncs the display name in Auth.
  Future<Result<UserProfile>> updateProfile({
    required String firstName,
    required String lastName,
    required String gender,
    DateTime? dateOfBirth,
    String location = '',
    String avatarId = '',
  }) async {
    final current = user.value;
    if (current == null) {
      return const Err(AuthStrings.noSignedInUser);
    }
    isUpdatingProfile.value = true;
    errorMessage.value = null;
    try {
      final result = await _repository.updateUserProfile(
        userId: current.uid,
        firstName: firstName,
        lastName: lastName,
        gender: gender,
        dateOfBirth: dateOfBirth,
        location: location,
        avatarId: avatarId,
      );
      if (result case Ok(:final value)) {
        profile.value = value;
        user.value = _repository.currentUser;
      } else if (result case Err(:final message)) {
        errorMessage.value = message;
      }
      return result;
    } finally {
      isUpdatingProfile.value = false;
    }
  }

  /// Sets or updates the local profile avatar image path for the user.
  Future<void> updateProfileImage(String? path) async {
    final current = user.value;
    if (current == null) return;
    profileImagePath.value = path;
    await _preferences.setProfileImagePath(current.uid, path);
  }

  void dispose() {
    _authSubscription.cancel();
  }
}
