// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format width=80

// **************************************************************************
// Generator: inject.dart
// https://pub.dev/packages/inject_annotation
// **************************************************************************

// ignore_for_file: type=lint, type=warning
// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'package:cloud_firestore/cloud_firestore.dart' as _i27;
import 'package:connectivity_plus/connectivity_plus.dart' as _i25;
import 'package:firebase_auth/firebase_auth.dart' as _i26;
import 'package:hive_ce/src/box/box.dart' as _i23;
import 'package:inject_annotation/inject_annotation.dart' as _i21;

import '../../features/auth/repository/auth_error_mapper.dart' as _i22;
import '../../features/auth/repository/auth_repository.dart' as _i5;
import '../../features/auth/viewmodels/auth_signal.dart' as _i11;
import '../../features/insights/viewmodels/insights_signal.dart' as _i15;
import '../../features/mood/datasource/firestore_service.dart' as _i7;
import '../../features/mood/datasource/hive_service.dart' as _i6;
import '../../features/mood/models/mood_entry.dart' as _i24;
import '../../features/mood/repository/mood_repository.dart' as _i10;
import '../../features/mood/services/sync_service.dart' as _i9;
import '../../features/mood/viewmodels/mood_signal.dart' as _i14;
import '../../features/onboarding/repository/onboarding_repository.dart'
    as _i18;
import '../../features/onboarding/viewmodels/onboarding_signal.dart' as _i19;
import '../../features/onboarding/viewmodels/splash_signal.dart' as _i20;
import '../../features/settings/repository/feedback_repository.dart' as _i8;
import '../../features/settings/viewmodels/feedback_signal.dart' as _i13;
import '../../features/settings/viewmodels/notification_settings_signal.dart'
    as _i17;
import '../services/app_preferences.dart' as _i4;
import '../services/deep_link_service.dart' as _i12;
import '../services/notification_service.dart' as _i16;
import 'app_component.dart' as _i1;
import 'firebase_module.dart' as _i2;
import 'infrastructure_module.dart' as _i3;

class AppComponent$Component implements _i1.AppComponent {
  factory AppComponent$Component.create({
    _i2.FirebaseModule? firebaseModule,
    _i3.InfrastructureModule? infrastructureModule,
  }) => AppComponent$Component._(
    firebaseModule ?? _i2.FirebaseModule(),
    infrastructureModule ?? _i3.InfrastructureModule(),
  );

  AppComponent$Component._(
    _i2.FirebaseModule firebaseModule,
    _i3.InfrastructureModule infrastructureModule,
  ) {
    final boxOfDynamic$Provider = _BoxOfDynamic$Provider(infrastructureModule);
    _appPreferences$Provider = _AppPreferences$Provider(boxOfDynamic$Provider);
    final authErrorMapper$Provider = _AuthErrorMapper$Provider();
    final firebaseAuth$Provider = _FirebaseAuth$Provider(firebaseModule);
    final firebaseFirestore$Provider = _FirebaseFirestore$Provider(
      firebaseModule,
    );
    _authRepository$Provider = _AuthRepository$Provider(
      firebaseAuth$Provider,
      authErrorMapper$Provider,
      firebaseFirestore$Provider,
    );
    final boxOfMoodEntry$Provider = _BoxOfMoodEntry$Provider(
      infrastructureModule,
    );
    _hiveService$Provider = _HiveService$Provider(boxOfMoodEntry$Provider);
    _firestoreService$Provider = _FirestoreService$Provider(
      firebaseFirestore$Provider,
    );
    final connectivity$Provider = _Connectivity$Provider(infrastructureModule);
    _feedbackRepository$Provider = _FeedbackRepository$Provider(
      _appPreferences$Provider,
      _firestoreService$Provider,
    );
    _syncService$Provider = _SyncService$Provider(
      _hiveService$Provider,
      _firestoreService$Provider,
      connectivity$Provider,
      firebaseAuth$Provider,
      _feedbackRepository$Provider,
    );
    _moodRepository$Provider = _MoodRepository$Provider(
      _hiveService$Provider,
      _syncService$Provider,
      _firestoreService$Provider,
    );
    _authSignal$Provider = _AuthSignal$Provider(
      _authRepository$Provider,
      _syncService$Provider,
      _moodRepository$Provider,
      _appPreferences$Provider,
    );
    _deepLinkService$Provider = _DeepLinkService$Provider(_authSignal$Provider);
    _feedbackSignal$Provider = _FeedbackSignal$Provider(
      _feedbackRepository$Provider,
      _authSignal$Provider,
    );
    _moodSignal$Provider = _MoodSignal$Provider(
      _moodRepository$Provider,
      _authSignal$Provider,
    );
    _insightsSignal$Provider = _InsightsSignal$Provider(_moodSignal$Provider);
    _notificationService$Provider = _NotificationService$Provider(
      _appPreferences$Provider,
    );
    _notificationSettingsSignal$Provider = _NotificationSettingsSignal$Provider(
      _appPreferences$Provider,
      _notificationService$Provider,
    );
    _onboardingRepository$Provider = _OnboardingRepository$Provider(
      _appPreferences$Provider,
    );
    _onboardingSignal$Provider = _OnboardingSignal$Provider(
      _onboardingRepository$Provider,
    );
    _splashSignal$Provider = _SplashSignal$Provider(
      firebaseAuth$Provider,
      _onboardingRepository$Provider,
    );
  }

  late final _AppPreferences$Provider _appPreferences$Provider;

  late final _AuthRepository$Provider _authRepository$Provider;

  late final _HiveService$Provider _hiveService$Provider;

  late final _FirestoreService$Provider _firestoreService$Provider;

  late final _FeedbackRepository$Provider _feedbackRepository$Provider;

  late final _SyncService$Provider _syncService$Provider;

  late final _MoodRepository$Provider _moodRepository$Provider;

  late final _AuthSignal$Provider _authSignal$Provider;

  late final _DeepLinkService$Provider _deepLinkService$Provider;

  late final _FeedbackSignal$Provider _feedbackSignal$Provider;

  late final _MoodSignal$Provider _moodSignal$Provider;

  late final _InsightsSignal$Provider _insightsSignal$Provider;

  late final _NotificationService$Provider _notificationService$Provider;

  late final _NotificationSettingsSignal$Provider
  _notificationSettingsSignal$Provider;

  late final _OnboardingRepository$Provider _onboardingRepository$Provider;

  late final _OnboardingSignal$Provider _onboardingSignal$Provider;

  late final _SplashSignal$Provider _splashSignal$Provider;

  @override
  _i4.AppPreferences get appPreferences => _appPreferences$Provider.get();

  @override
  _i5.AuthRepository get authRepository => _authRepository$Provider.get();

  @override
  _i6.HiveService get hiveService => _hiveService$Provider.get();

  @override
  _i7.FirestoreService get firestoreService => _firestoreService$Provider.get();

  @override
  _i8.FeedbackRepository get feedbackRepository =>
      _feedbackRepository$Provider.get();

  @override
  _i9.SyncService get syncService => _syncService$Provider.get();

  @override
  _i10.MoodRepository get moodRepository => _moodRepository$Provider.get();

  @override
  _i11.AuthSignal get authSignal => _authSignal$Provider.get();

  @override
  _i12.DeepLinkService get deepLinkService => _deepLinkService$Provider.get();

  @override
  _i13.FeedbackSignal get feedbackSignal => _feedbackSignal$Provider.get();

  @override
  _i14.MoodSignal get moodSignal => _moodSignal$Provider.get();

  @override
  _i15.InsightsSignal get insightsSignal => _insightsSignal$Provider.get();

  @override
  _i16.NotificationService get notificationService =>
      _notificationService$Provider.get();

  @override
  _i17.NotificationSettingsSignal get notificationSettingsSignal =>
      _notificationSettingsSignal$Provider.get();

  @override
  _i18.OnboardingRepository get onboardingRepository =>
      _onboardingRepository$Provider.get();

  @override
  _i19.OnboardingSignal get onboardingSignal =>
      _onboardingSignal$Provider.get();

  @override
  _i20.SplashSignal get splashSignal => _splashSignal$Provider.get();
}

class _AppPreferences$Provider implements _i21.Provider<_i4.AppPreferences> {
  _AppPreferences$Provider(this._boxOfDynamic$Provider);

  final _BoxOfDynamic$Provider _boxOfDynamic$Provider;

  late final _i4.AppPreferences _singleton = _create();

  _i4.AppPreferences _create() =>
      _i4.AppPreferences(_boxOfDynamic$Provider.get());

  @override
  _i4.AppPreferences get() => _singleton;
}

class _AuthErrorMapper$Provider implements _i21.Provider<_i22.AuthErrorMapper> {
  _AuthErrorMapper$Provider();

  late final _i22.AuthErrorMapper _singleton = _create();

  _i22.AuthErrorMapper _create() => _i22.AuthErrorMapper();

  @override
  _i22.AuthErrorMapper get() => _singleton;
}

class _AuthRepository$Provider implements _i21.Provider<_i5.AuthRepository> {
  _AuthRepository$Provider(
    this._firebaseAuth$Provider,
    this._authErrorMapper$Provider,
    this._firebaseFirestore$Provider,
  );

  final _FirebaseAuth$Provider _firebaseAuth$Provider;

  final _AuthErrorMapper$Provider _authErrorMapper$Provider;

  final _FirebaseFirestore$Provider _firebaseFirestore$Provider;

  late final _i5.AuthRepository _singleton = _create();

  _i5.AuthRepository _create() => _i5.AuthRepository(
    _firebaseAuth$Provider.get(),
    _authErrorMapper$Provider.get(),
    _firebaseFirestore$Provider.get(),
  );

  @override
  _i5.AuthRepository get() => _singleton;
}

class _AuthSignal$Provider implements _i21.Provider<_i11.AuthSignal> {
  _AuthSignal$Provider(
    this._authRepository$Provider,
    this._syncService$Provider,
    this._moodRepository$Provider,
    this._appPreferences$Provider,
  );

  final _AuthRepository$Provider _authRepository$Provider;

  final _SyncService$Provider _syncService$Provider;

  final _MoodRepository$Provider _moodRepository$Provider;

  final _AppPreferences$Provider _appPreferences$Provider;

  late final _i11.AuthSignal _singleton = _create();

  _i11.AuthSignal _create() => _i11.AuthSignal(
    _authRepository$Provider.get(),
    _syncService$Provider.get(),
    _moodRepository$Provider.get(),
    _appPreferences$Provider.get(),
  );

  @override
  _i11.AuthSignal get() => _singleton;
}

class _BoxOfDynamic$Provider implements _i21.Provider<_i23.Box<dynamic>> {
  _BoxOfDynamic$Provider(this._module);

  final _i3.InfrastructureModule _module;

  late final _i23.Box<dynamic> _singleton = _create();

  _i23.Box<dynamic> _create() => _module.providePreferencesBox();

  @override
  _i23.Box<dynamic> get() => _singleton;
}

class _BoxOfMoodEntry$Provider
    implements _i21.Provider<_i23.Box<_i24.MoodEntry>> {
  _BoxOfMoodEntry$Provider(this._module);

  final _i3.InfrastructureModule _module;

  late final _i23.Box<_i24.MoodEntry> _singleton = _create();

  _i23.Box<_i24.MoodEntry> _create() => _module.provideMoodBox();

  @override
  _i23.Box<_i24.MoodEntry> get() => _singleton;
}

class _Connectivity$Provider implements _i21.Provider<_i25.Connectivity> {
  _Connectivity$Provider(this._module);

  final _i3.InfrastructureModule _module;

  late final _i25.Connectivity _singleton = _create();

  _i25.Connectivity _create() => _module.provideConnectivity();

  @override
  _i25.Connectivity get() => _singleton;
}

class _DeepLinkService$Provider implements _i21.Provider<_i12.DeepLinkService> {
  _DeepLinkService$Provider(this._authSignal$Provider);

  final _AuthSignal$Provider _authSignal$Provider;

  late final _i12.DeepLinkService _singleton = _create();

  _i12.DeepLinkService _create() =>
      _i12.DeepLinkService(_authSignal$Provider.get());

  @override
  _i12.DeepLinkService get() => _singleton;
}

class _FeedbackRepository$Provider
    implements _i21.Provider<_i8.FeedbackRepository> {
  _FeedbackRepository$Provider(
    this._appPreferences$Provider,
    this._firestoreService$Provider,
  );

  final _AppPreferences$Provider _appPreferences$Provider;

  final _FirestoreService$Provider _firestoreService$Provider;

  late final _i8.FeedbackRepository _singleton = _create();

  _i8.FeedbackRepository _create() => _i8.FeedbackRepository(
    _appPreferences$Provider.get(),
    _firestoreService$Provider.get(),
  );

  @override
  _i8.FeedbackRepository get() => _singleton;
}

class _FeedbackSignal$Provider implements _i21.Provider<_i13.FeedbackSignal> {
  _FeedbackSignal$Provider(
    this._feedbackRepository$Provider,
    this._authSignal$Provider,
  );

  final _FeedbackRepository$Provider _feedbackRepository$Provider;

  final _AuthSignal$Provider _authSignal$Provider;

  late final _i13.FeedbackSignal _singleton = _create();

  _i13.FeedbackSignal _create() => _i13.FeedbackSignal(
    _feedbackRepository$Provider.get(),
    _authSignal$Provider.get(),
  );

  @override
  _i13.FeedbackSignal get() => _singleton;
}

class _FirebaseAuth$Provider implements _i21.Provider<_i26.FirebaseAuth> {
  _FirebaseAuth$Provider(this._module);

  final _i2.FirebaseModule _module;

  late final _i26.FirebaseAuth _singleton = _create();

  _i26.FirebaseAuth _create() => _module.provideAuth();

  @override
  _i26.FirebaseAuth get() => _singleton;
}

class _FirebaseFirestore$Provider
    implements _i21.Provider<_i27.FirebaseFirestore> {
  _FirebaseFirestore$Provider(this._module);

  final _i2.FirebaseModule _module;

  late final _i27.FirebaseFirestore _singleton = _create();

  _i27.FirebaseFirestore _create() => _module.provideFirestore();

  @override
  _i27.FirebaseFirestore get() => _singleton;
}

class _FirestoreService$Provider
    implements _i21.Provider<_i7.FirestoreService> {
  _FirestoreService$Provider(this._firebaseFirestore$Provider);

  final _FirebaseFirestore$Provider _firebaseFirestore$Provider;

  late final _i7.FirestoreService _singleton = _create();

  _i7.FirestoreService _create() =>
      _i7.FirestoreService(_firebaseFirestore$Provider.get());

  @override
  _i7.FirestoreService get() => _singleton;
}

class _HiveService$Provider implements _i21.Provider<_i6.HiveService> {
  _HiveService$Provider(this._boxOfMoodEntry$Provider);

  final _BoxOfMoodEntry$Provider _boxOfMoodEntry$Provider;

  late final _i6.HiveService _singleton = _create();

  _i6.HiveService _create() => _i6.HiveService(_boxOfMoodEntry$Provider.get());

  @override
  _i6.HiveService get() => _singleton;
}

class _InsightsSignal$Provider implements _i21.Provider<_i15.InsightsSignal> {
  _InsightsSignal$Provider(this._moodSignal$Provider);

  final _MoodSignal$Provider _moodSignal$Provider;

  late final _i15.InsightsSignal _singleton = _create();

  _i15.InsightsSignal _create() =>
      _i15.InsightsSignal(_moodSignal$Provider.get());

  @override
  _i15.InsightsSignal get() => _singleton;
}

class _MoodRepository$Provider implements _i21.Provider<_i10.MoodRepository> {
  _MoodRepository$Provider(
    this._hiveService$Provider,
    this._syncService$Provider,
    this._firestoreService$Provider,
  );

  final _HiveService$Provider _hiveService$Provider;

  final _SyncService$Provider _syncService$Provider;

  final _FirestoreService$Provider _firestoreService$Provider;

  late final _i10.MoodRepository _singleton = _create();

  _i10.MoodRepository _create() => _i10.MoodRepository(
    _hiveService$Provider.get(),
    _syncService$Provider.get(),
    _firestoreService$Provider.get(),
  );

  @override
  _i10.MoodRepository get() => _singleton;
}

class _MoodSignal$Provider implements _i21.Provider<_i14.MoodSignal> {
  _MoodSignal$Provider(
    this._moodRepository$Provider,
    this._authSignal$Provider,
  );

  final _MoodRepository$Provider _moodRepository$Provider;

  final _AuthSignal$Provider _authSignal$Provider;

  late final _i14.MoodSignal _singleton = _create();

  _i14.MoodSignal _create() => _i14.MoodSignal(
    _moodRepository$Provider.get(),
    _authSignal$Provider.get(),
  );

  @override
  _i14.MoodSignal get() => _singleton;
}

class _NotificationService$Provider
    implements _i21.Provider<_i16.NotificationService> {
  _NotificationService$Provider(this._appPreferences$Provider);

  final _AppPreferences$Provider _appPreferences$Provider;

  late final _i16.NotificationService _singleton = _create();

  _i16.NotificationService _create() =>
      _i16.NotificationService(_appPreferences$Provider.get());

  @override
  _i16.NotificationService get() => _singleton;
}

class _NotificationSettingsSignal$Provider
    implements _i21.Provider<_i17.NotificationSettingsSignal> {
  _NotificationSettingsSignal$Provider(
    this._appPreferences$Provider,
    this._notificationService$Provider,
  );

  final _AppPreferences$Provider _appPreferences$Provider;

  final _NotificationService$Provider _notificationService$Provider;

  late final _i17.NotificationSettingsSignal _singleton = _create();

  _i17.NotificationSettingsSignal _create() => _i17.NotificationSettingsSignal(
    _appPreferences$Provider.get(),
    _notificationService$Provider.get(),
  );

  @override
  _i17.NotificationSettingsSignal get() => _singleton;
}

class _OnboardingRepository$Provider
    implements _i21.Provider<_i18.OnboardingRepository> {
  _OnboardingRepository$Provider(this._appPreferences$Provider);

  final _AppPreferences$Provider _appPreferences$Provider;

  late final _i18.OnboardingRepository _singleton = _create();

  _i18.OnboardingRepository _create() =>
      _i18.OnboardingRepository(_appPreferences$Provider.get());

  @override
  _i18.OnboardingRepository get() => _singleton;
}

class _OnboardingSignal$Provider
    implements _i21.Provider<_i19.OnboardingSignal> {
  _OnboardingSignal$Provider(this._onboardingRepository$Provider);

  final _OnboardingRepository$Provider _onboardingRepository$Provider;

  late final _i19.OnboardingSignal _singleton = _create();

  _i19.OnboardingSignal _create() =>
      _i19.OnboardingSignal(_onboardingRepository$Provider.get());

  @override
  _i19.OnboardingSignal get() => _singleton;
}

class _SplashSignal$Provider implements _i21.Provider<_i20.SplashSignal> {
  _SplashSignal$Provider(
    this._firebaseAuth$Provider,
    this._onboardingRepository$Provider,
  );

  final _FirebaseAuth$Provider _firebaseAuth$Provider;

  final _OnboardingRepository$Provider _onboardingRepository$Provider;

  late final _i20.SplashSignal _singleton = _create();

  _i20.SplashSignal _create() => _i20.SplashSignal(
    _firebaseAuth$Provider.get(),
    _onboardingRepository$Provider.get(),
  );

  @override
  _i20.SplashSignal get() => _singleton;
}

class _SyncService$Provider implements _i21.Provider<_i9.SyncService> {
  _SyncService$Provider(
    this._hiveService$Provider,
    this._firestoreService$Provider,
    this._connectivity$Provider,
    this._firebaseAuth$Provider,
    this._feedbackRepository$Provider,
  );

  final _HiveService$Provider _hiveService$Provider;

  final _FirestoreService$Provider _firestoreService$Provider;

  final _Connectivity$Provider _connectivity$Provider;

  final _FirebaseAuth$Provider _firebaseAuth$Provider;

  final _FeedbackRepository$Provider _feedbackRepository$Provider;

  late final _i9.SyncService _singleton = _create();

  _i9.SyncService _create() => _i9.SyncService(
    _hiveService$Provider.get(),
    _firestoreService$Provider.get(),
    _connectivity$Provider.get(),
    _firebaseAuth$Provider.get(),
    _feedbackRepository$Provider.get(),
  );

  @override
  _i9.SyncService get() => _singleton;
}
