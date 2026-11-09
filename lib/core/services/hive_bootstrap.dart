import 'dart:io';

import 'package:hive_ce_flutter/hive_flutter.dart';
import 'package:path_provider/path_provider.dart';

import 'package:dailypulse/core/services/app_preferences.dart';
import 'package:dailypulse/core/utils/app_logger.dart';
import 'package:dailypulse/features/mood/datasource/hive_service.dart';
import 'package:dailypulse/features/mood/models/mood_entry.dart';

/// Opens Hive and every box at once, before the DI graph is created.
///
/// Keeping the engine path, adapter and box names in one place means the
/// startup order can no longer drift between features.
abstract final class HiveBootstrap {
  static const String _directory = 'dailypulse';

  static Future<void> init({String? storagePath}) async {
    final String directoryPath;
    if (storagePath != null) {
      Hive.init(storagePath);
      directoryPath = storagePath;
    } else {
      await Hive.initFlutter(_directory);
      final appDir = await getApplicationDocumentsDirectory();
      directoryPath = '${appDir.path}/$_directory';
    }

    if (!Hive.isAdapterRegistered(MoodEntryAdapter().typeId)) {
      Hive.registerAdapter(MoodEntryAdapter());
    }

    await Future.wait([
      _openBox<MoodEntry>(HiveService.boxName, directoryPath),
      _openBox<dynamic>(AppPreferences.boxName, directoryPath),
    ]);

    appLogger.i('Hive initialised');
  }

  static Future<void> _openBox<T>(String name, String directoryPath) async {
    try {
      await Hive.openBox<T>(name);
    } catch (e, stackTrace) {
      appLogger.e(
        'Failed to open Hive box "$name", moving corrupt file aside',
        error: e,
        stackTrace: stackTrace,
      );
      await _quarantineBox(name, directoryPath);
      await Hive.openBox<T>(name);
    }
  }

  /// Renames a damaged `.hive` / `.lock` pair so a fresh box can open without
  /// destroying the broken bytes.
  static Future<void> _quarantineBox(String name, String directoryPath) async {
    final stamp = DateTime.now().millisecondsSinceEpoch;
    for (final suffix in const ['.hive', '.lock']) {
      try {
        final file = File('$directoryPath/${name.toLowerCase()}$suffix');
        if (await file.exists()) {
          await file.rename('${file.path}.corrupt-$stamp');
        }
      } catch (e, stackTrace) {
        appLogger.w(
          'Could not quarantine "$name$suffix"',
          error: e,
          stackTrace: stackTrace,
        );
      }
    }
  }
}
