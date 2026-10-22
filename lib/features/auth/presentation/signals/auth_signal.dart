import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:signals_flutter/signals_flutter.dart';

import 'package:dailypulse/core/utils/app_logger.dart';

enum AuthStatus { initial, authenticated, unauthenticated, loading }

/// Authentication state backed by signals instead of ChangeNotifier.
class AuthSignal {
  AuthSignal({FirebaseAuth? auth}) : _auth = auth ?? FirebaseAuth.instance {
    _authSubscription = _auth.authStateChanges().listen(
      _onAuthStateChanged,
      onError: (Object error, StackTrace stackTrace) {
        errorMessage.value = 'Failed to listen for auth changes';
        appLogger.e('Auth stream error', error: error, stackTrace: stackTrace);
      },
    );
  }

  final FirebaseAuth _auth;
  late final StreamSubscription<User?> _authSubscription;

  final status = signal<AuthStatus>(AuthStatus.initial);
  final user = signal<User?>(null);
  final errorMessage = signal<String?>(null);

  bool get isAuthenticated => status.value == AuthStatus.authenticated;

  void _onAuthStateChanged(User? value) {
    if (value == null) {
      user.value = null;
      status.value = AuthStatus.unauthenticated;
      return;
    }
    user.value = value;
    status.value = AuthStatus.authenticated;
    appLogger.i(
      'Auth state changed: ${status.value.name}, User: ${value.email}',
    );
  }

  Future<bool> signUp({
    required String email,
    required String password,
    required String name,
  }) async {
    try {
      status.value = AuthStatus.loading;
      errorMessage.value = null;

      final credential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      await credential.user?.updateDisplayName(name);
      await credential.user?.reload();
      user.value = _auth.currentUser;

      appLogger.i('User signed up successfully: ${user.value?.email}');
      return true;
    } on FirebaseAuthException catch (e) {
      status.value = AuthStatus.unauthenticated;
      errorMessage.value = _getErrorMessage(e.code);
      appLogger.w('Sign up failed: ${e.code}');
      return false;
    } catch (e, stackTrace) {
      status.value = AuthStatus.unauthenticated;
      errorMessage.value = 'An unexpected error occurred';
      appLogger.e(
        'Unexpected error during sign up',
        error: e,
        stackTrace: stackTrace,
      );
      return false;
    }
  }

  Future<bool> signIn({required String email, required String password}) async {
    try {
      status.value = AuthStatus.loading;
      errorMessage.value = null;

      await _auth.signInWithEmailAndPassword(email: email, password: password);

      appLogger.i('User signed in successfully: $email');
      return true;
    } on FirebaseAuthException catch (e) {
      status.value = AuthStatus.unauthenticated;
      errorMessage.value = _getErrorMessage(e.code);
      appLogger.w('Sign in failed: ${e.code}');
      return false;
    } catch (e, stackTrace) {
      status.value = AuthStatus.unauthenticated;
      errorMessage.value = 'An unexpected error occurred';
      appLogger.e(
        'Unexpected error during sign in',
        error: e,
        stackTrace: stackTrace,
      );
      return false;
    }
  }

  Future<void> signOut() async {
    appLogger.i('User signed out: ${user.value?.email}');
    await _auth.signOut();
  }

  void clearError() {
    errorMessage.value = null;
  }

  Future<void> handleSignIn({
    required String email,
    required String password,
    required Function(String) onError,
  }) async {
    final success = await signIn(email: email, password: password);
    final message = errorMessage.value;
    if (!success && message != null) {
      onError(message);
    }
  }

  Future<void> handleSignUp({
    required String email,
    required String password,
    required String name,
    required Function() onSuccess,
    required Function(String) onError,
  }) async {
    final success = await signUp(email: email, password: password, name: name);
    if (success) {
      onSuccess();
    } else if (errorMessage.value != null) {
      onError(errorMessage.value!);
    }
  }

  String _getErrorMessage(String code) {
    switch (code) {
      case 'weak-password':
        return 'Password is too weak';
      case 'email-already-in-use':
        return 'Email is already registered';
      case 'invalid-email':
        return 'Invalid email address';
      case 'user-not-found':
        return 'No user found with this email';
      case 'wrong-password':
        return 'Incorrect password';
      case 'invalid-credential':
        return 'Invalid email or password';
      default:
        return 'Authentication failed. Please try again';
    }
  }

  void dispose() {
    _authSubscription.cancel();
  }
}

final authSignal = AuthSignal();
