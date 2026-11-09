import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';
import 'package:logger/logger.dart';

/// Sends uncaught errors to Firebase Crashlytics in release builds only.
///
/// Reports carry no user id or email, and no mood data.
abstract final class CrashReporting {
  /// Call once after `Firebase.initializeApp`.
  static Future<void> init() async {
    final crashlytics = FirebaseCrashlytics.instance;
    await crashlytics.setCrashlyticsCollectionEnabled(kReleaseMode);
    if (!kReleaseMode) return;

    FlutterError.onError = crashlytics.recordFlutterFatalError;
    PlatformDispatcher.instance.onError = (error, stack) {
      unawaited(crashlytics.recordError(error, stack, fatal: true));
      return true;
    };
  }
}

/// Logger output that records `appLogger.e(...)` calls as non-fatal errors.
///
/// Offline and timeout failures are expected for an offline-first app, so they
/// are skipped to keep the dashboard useful.
class CrashlyticsLogOutput extends LogOutput {
  static const _ignoredFirebaseCodes = {
    'unavailable',
    'network-request-failed',
    'deadline-exceeded',
    'cancelled',
  };

  @override
  void output(OutputEvent event) {
    final origin = event.origin;
    if (event.level != Level.error || origin.error == null) return;

    final error = origin.error!;
    if (error is TimeoutException) return;
    if (error is FirebaseException &&
        _ignoredFirebaseCodes.contains(error.code)) {
      return;
    }

    try {
      unawaited(
        FirebaseCrashlytics.instance.recordError(
          error,
          origin.stackTrace,
          reason: origin.message.toString(),
        ),
      );
    } catch (_) {
      // Crash reporting must never throw from the logger.
    }
  }
}
