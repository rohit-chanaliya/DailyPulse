import 'package:flutter/foundation.dart';
import 'package:logger/logger.dart';

/// Global logger instance for the application.
///
/// Debug builds log everything with a pretty printer. Release builds only log
/// warnings and errors in a compact format.
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
);
