import 'dart:async';

import 'package:app_links/app_links.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:dailypulse/core/constant/strings/auth_strings.dart';
import 'package:dailypulse/core/di/injection.dart';
import 'package:dailypulse/core/router/app_routes.dart';
import 'package:dailypulse/core/utils/app_logger.dart';
import 'package:dailypulse/core/utils/snackbar_utils.dart';

/// Handles incoming Firebase email verification links.
///
/// Supported links:
/// - `https://dailyplus-mobile-app.web.app/app-verify?mode=verifyEmail&oobCode=...`
/// - `dailypulse://verify?mode=verifyEmail&oobCode=...` (custom-scheme fallback)
class DeepLinkService {
  DeepLinkService._();

  static const _authHost = 'dailyplus-mobile-app.firebaseapp.com';
  static const _authPath = '/__/auth/action';
  static const _appLinkHost = 'dailyplus-mobile-app.web.app';
  static const _appLinkPath = '/app-verify';
  static const _scheme = 'dailypulse';
  static const _schemeHost = 'verify';

  static final _appLinks = AppLinks();
  static StreamSubscription<Uri>? _subscription;
  static GlobalKey<NavigatorState>? _navigatorKey;
  static Uri? _pendingUri;
  static Uri? _lastHandledUri;
  static bool _isFlushing = false;

  /// Initialise the listener.
  ///
  /// Call once from `main` after the router and navigator key exist. Links
  /// received before the first frame are queued until a route is available.
  static Future<void> init(GlobalKey<NavigatorState> navigatorKey) async {
    _navigatorKey = navigatorKey;

    try {
      final initialUri = await _appLinks.getInitialLink();
      if (initialUri != null) {
        _pendingUri = initialUri;
        _scheduleFlush();
      }
    } catch (e) {
      appLogger.w('No initial deep link: $e');
    }

    _subscription = _appLinks.uriLinkStream.listen(
      (uri) => unawaited(_handleLink(uri)),
      onError: (Object error) {
        appLogger.e('Deep link stream error', error: error);
      },
    );
  }

  static void _scheduleFlush() {
    if (_isFlushing) return;
    _isFlushing = true;
    unawaited(_flushPending());
  }

  static Future<void> _flushPending() async {
    await WidgetsBinding.instance.endOfFrame;
    _isFlushing = false;
    final uri = _pendingUri;
    _pendingUri = null;
    if (uri != null) {
      await _handleLink(uri);
    }
  }

  static Future<void> _handleLink(Uri uri) async {
    final isAuthActionLink =
        uri.scheme == 'https' &&
        uri.host == _authHost &&
        uri.path.startsWith(_authPath);
    final isAppLink =
        uri.scheme == 'https' &&
        uri.host == _appLinkHost &&
        uri.path.startsWith(_appLinkPath);
    final isCustomScheme = uri.scheme == _scheme && uri.host == _schemeHost;

    if (!isAuthActionLink && !isAppLink && !isCustomScheme) return;

    final context = _navigatorKey?.currentContext;
    if (context == null) {
      _pendingUri = uri;
      _scheduleFlush();
      return;
    }

    // Some platforms replay the initial link on the stream as well.
    if (uri == _lastHandledUri) return;
    _lastHandledUri = uri;

    final mode = uri.queryParameters['mode'];
    final oobCode = uri.queryParameters['oobCode'];

    // Never log oobCode: it is a one-time credential.
    appLogger.i(
      'Deep link received: ${uri.scheme}://${uri.host}${uri.path} (mode=$mode)',
    );

    if (mode == 'resetPassword') {
      if (oobCode == null || oobCode.isEmpty) {
        SnackBarUtils.showError(context, AuthStrings.invalidResetLink);
        return;
      }
      context.go(AppRoutes.resetPassword, extra: oobCode);
      return;
    }

    if (mode == 'recoverEmail') {
      if (oobCode == null || oobCode.isEmpty) {
        SnackBarUtils.showError(context, AuthStrings.emailRecoveryFailed);
        return;
      }

      final recovered = await appComponent.authSignal.applyRecoveryCode(
        oobCode,
      );

      if (!context.mounted) return;

      if (recovered) {
        SnackBarUtils.showSuccess(context, AuthStrings.emailRecoveredSuccess);
        context.go(AppRoutes.signIn);
      } else {
        SnackBarUtils.showError(
          context,
          appComponent.authSignal.errorMessage.value ??
              AuthStrings.emailRecoveryFailed,
        );
      }
      return;
    }

    if (mode != 'verifyEmail') {
      return;
    }

    if (oobCode == null || oobCode.isEmpty) {
      SnackBarUtils.showError(context, AuthStrings.verificationLinkInvalid);
      return;
    }

    final verified = await appComponent.authSignal.applyVerificationCode(
      oobCode,
    );

    if (!context.mounted) return;

    if (verified) {
      SnackBarUtils.showSuccess(context, AuthStrings.emailVerifiedSuccess);
      context.go(AppRoutes.signIn);
    } else {
      SnackBarUtils.showError(
        context,
        appComponent.authSignal.errorMessage.value ??
            AuthStrings.emailVerificationFailed,
      );
    }
  }

  /// Tear down the listener (useful in tests).
  static void dispose() {
    _subscription?.cancel();
    _subscription = null;
    _pendingUri = null;
    _lastHandledUri = null;
  }
}
