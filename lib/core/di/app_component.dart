import 'package:inject_annotation/inject_annotation.dart';

import 'package:dailypulse/features/auth/presentation/signals/auth_signal.dart';
import 'package:dailypulse/features/insights/presentation/signals/insights_signal.dart';
import 'package:dailypulse/features/mood/data/repositories/mood_repository.dart';
import 'package:dailypulse/features/mood/data/remote/firestore_service.dart';
import 'package:dailypulse/features/mood/data/services/sync_service.dart';
import 'package:dailypulse/features/mood/presentation/signals/mood_signal.dart';
import 'package:dailypulse/features/onboarding/viewmodels/splash_signal.dart';
import 'package:dailypulse/features/settings/presentation/signals/theme_signal.dart';

import 'app_component.inject.dart' as g;
import 'firebase_module.dart';
import 'infrastructure_module.dart';

/// Central application dependency injection component.
@Component([FirebaseModule, InfrastructureModule])
abstract class AppComponent {
  static const create = g.AppComponent$Component.create;

  FirestoreService get firestoreService;
  SyncService get syncService;
  MoodRepository get moodRepository;

  MoodSignal get moodSignal;
  InsightsSignal get insightsSignal;
  ThemeSignal get themeSignal;
  AuthSignal get authSignal;
  SplashSignal get splashSignal;
}
