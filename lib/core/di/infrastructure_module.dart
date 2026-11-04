import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dailypulse/core/services/app_preferences.dart';
import 'package:dailypulse/features/mood/datasource/hive_service.dart';
import 'package:dailypulse/features/mood/models/mood_entry.dart';
import 'package:hive_ce/hive.dart';
import 'package:inject_annotation/inject_annotation.dart';

/// Provides platform infrastructure singletons to the dependency graph.
@module
class InfrastructureModule {
  @provides
  @singleton
  Connectivity provideConnectivity() => Connectivity();

  @provides
  @singleton
  Box<MoodEntry> provideMoodBox() => Hive.box<MoodEntry>(HiveService.boxName);

  @provides
  @singleton
  Box<dynamic> providePreferencesBox() =>
      Hive.box<dynamic>(AppPreferences.boxName);
}
