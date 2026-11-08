import 'package:inject_annotation/inject_annotation.dart';

import 'package:dailypulse/core/services/app_preferences.dart';
import 'package:dailypulse/core/services/deep_link_service.dart';
import 'package:dailypulse/core/services/notification_service.dart';
import 'package:dailypulse/features/auth/repository/auth_repository.dart';
import 'package:dailypulse/features/auth/viewmodels/auth_signal.dart';
import 'package:dailypulse/features/insights/viewmodels/insights_signal.dart';
import 'package:dailypulse/features/mood/datasource/hive_service.dart';
import 'package:dailypulse/features/mood/repository/mood_repository.dart';
import 'package:dailypulse/features/mood/datasource/firestore_service.dart';
import 'package:dailypulse/features/mood/services/sync_service.dart';
import 'package:dailypulse/features/mood/viewmodels/mood_signal.dart';
import 'package:dailypulse/features/onboarding/repository/onboarding_repository.dart';
import 'package:dailypulse/features/onboarding/viewmodels/onboarding_signal.dart';
import 'package:dailypulse/features/onboarding/viewmodels/splash_signal.dart';
import 'package:dailypulse/features/settings/viewmodels/feedback_signal.dart';
import 'package:dailypulse/features/settings/viewmodels/notification_settings_signal.dart';
import 'package:dailypulse/features/settings/repository/feedback_repository.dart';

import 'app_component.inject.dart' as g;
import 'firebase_module.dart';
import 'infrastructure_module.dart';

/// Central application dependency injection component.
@Component([FirebaseModule, InfrastructureModule])
abstract class AppComponent {
  static const create = g.AppComponent$Component.create;

  HiveService get hiveService;
  AppPreferences get appPreferences;
  FirestoreService get firestoreService;
  SyncService get syncService;
  MoodRepository get moodRepository;
  OnboardingRepository get onboardingRepository;
  AuthRepository get authRepository;
  FeedbackRepository get feedbackRepository;

  MoodSignal get moodSignal;
  InsightsSignal get insightsSignal;
  NotificationSettingsSignal get notificationSettingsSignal;
  FeedbackSignal get feedbackSignal;
  AuthSignal get authSignal;
  SplashSignal get splashSignal;
  OnboardingSignal get onboardingSignal;
  DeepLinkService get deepLinkService;
  NotificationService get notificationService;
}
