import 'package:flutter/foundation.dart';
import 'package:logger/logger.dart';

import 'package:dailypulse/core/services/crash_reporting.dart';

/// Global logger instance for the application.
///
/// Debug builds log everything with a pretty printer. Release builds only log
/// warnings and errors in a compact format, and errors are also sent to
/// Crashlytics as non-fatal reports.
///
/// Usage:
/// - appLogger.d('Debug message');
/// - appLogger.i('Info message');
/// - appLogger.w('Warning message');
/// - appLogger.e('Error message', error: error, stackTrace: stackTrace);
final appLogger = Logger(
  printer: kReleaseMode
      ? SimplePrinter(colors: false, printTime: true)
      : PrettyPrinter(
          methodCount: 2,
          errorMethodCount: 8,
          lineLength: 120,
          colors: true,
          printEmojis: true,
          dateTimeFormat: DateTimeFormat.onlyTimeAndSinceStart,
        ),
  level: kReleaseMode ? Level.warning : Level.debug,
  output: kReleaseMode
      ? MultiOutput([ConsoleOutput(), CrashlyticsLogOutput()])
      : ConsoleOutput(),
);
