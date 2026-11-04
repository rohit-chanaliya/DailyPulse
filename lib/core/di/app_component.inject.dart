// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format width=80

// **************************************************************************
// Generator: inject.dart
// https://pub.dev/packages/inject_annotation
// **************************************************************************

// ignore_for_file: type=lint, type=warning
// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'package:cloud_firestore/cloud_firestore.dart' as _i21;
import 'package:connectivity_plus/connectivity_plus.dart' as _i19;
import 'package:firebase_auth/firebase_auth.dart' as _i20;
import 'package:hive_ce/src/box/box.dart' as _i17;
import 'package:inject_annotation/inject_annotation.dart' as _i16;

import '../../features/auth/presentation/signals/auth_signal.dart' as _i9;
import '../../features/insights/presentation/signals/insights_signal.dart'
    as _i11;
import '../../features/mood/data/local/hive_service.dart' as _i5;
import '../../features/mood/data/models/mood_entry.dart' as _i18;
import '../../features/mood/data/remote/firestore_service.dart' as _i6;
import '../../features/mood/data/repositories/mood_repository.dart' as _i8;
import '../../features/mood/data/services/sync_service.dart' as _i7;
import '../../features/mood/presentation/signals/mood_signal.dart' as _i10;
import '../../features/onboarding/repository/onboarding_repository.dart'
    as _i12;
import '../../features/onboarding/viewmodels/onboarding_signal.dart' as _i13;
import '../../features/onboarding/viewmodels/splash_signal.dart' as _i14;
import '../../features/settings/presentation/signals/theme_signal.dart' as _i15;
import '../services/app_preferences.dart' as _i4;
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
    final firebaseAuth$Provider = _FirebaseAuth$Provider(firebaseModule);
    final boxOfMoodEntry$Provider = _BoxOfMoodEntry$Provider(
      infrastructureModule,
    );
    _hiveService$Provider = _HiveService$Provider(boxOfMoodEntry$Provider);
    final firebaseFirestore$Provider = _FirebaseFirestore$Provider(
      firebaseModule,
    );
    _firestoreService$Provider = _FirestoreService$Provider(
      firebaseFirestore$Provider,
    );
    final connectivity$Provider = _Connectivity$Provider(infrastructureModule);
    _syncService$Provider = _SyncService$Provider(
      _hiveService$Provider,
      _firestoreService$Provider,
      connectivity$Provider,
      firebaseAuth$Provider,
    );
    _moodRepository$Provider = _MoodRepository$Provider(
      _hiveService$Provider,
      _syncService$Provider,
      _firestoreService$Provider,
    );
    _authSignal$Provider = _AuthSignal$Provider(
      firebaseAuth$Provider,
      _syncService$Provider,
      _moodRepository$Provider,
    );
    _moodSignal$Provider = _MoodSignal$Provider(
      _moodRepository$Provider,
      _authSignal$Provider,
    );
    _insightsSignal$Provider = _InsightsSignal$Provider(_moodSignal$Provider);
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
    _themeSignal$Provider = _ThemeSignal$Provider(_appPreferences$Provider);
  }

  late final _AppPreferences$Provider _appPreferences$Provider;

  late final _HiveService$Provider _hiveService$Provider;

  late final _FirestoreService$Provider _firestoreService$Provider;

  late final _SyncService$Provider _syncService$Provider;

  late final _MoodRepository$Provider _moodRepository$Provider;

  late final _AuthSignal$Provider _authSignal$Provider;

  late final _MoodSignal$Provider _moodSignal$Provider;

  late final _InsightsSignal$Provider _insightsSignal$Provider;

  late final _OnboardingRepository$Provider _onboardingRepository$Provider;

  late final _OnboardingSignal$Provider _onboardingSignal$Provider;

  late final _SplashSignal$Provider _splashSignal$Provider;

  late final _ThemeSignal$Provider _themeSignal$Provider;

  @override
  _i4.AppPreferences get appPreferences => _appPreferences$Provider.get();

  @override
  _i5.HiveService get hiveService => _hiveService$Provider.get();

  @override
  _i6.FirestoreService get firestoreService => _firestoreService$Provider.get();

  @override
  _i7.SyncService get syncService => _syncService$Provider.get();

  @override
  _i8.MoodRepository get moodRepository => _moodRepository$Provider.get();

  @override
  _i9.AuthSignal get authSignal => _authSignal$Provider.get();

  @override
  _i10.MoodSignal get moodSignal => _moodSignal$Provider.get();

  @override
  _i11.InsightsSignal get insightsSignal => _insightsSignal$Provider.get();

  @override
  _i12.OnboardingRepository get onboardingRepository =>
      _onboardingRepository$Provider.get();

  @override
  _i13.OnboardingSignal get onboardingSignal =>
      _onboardingSignal$Provider.get();

  @override
  _i14.SplashSignal get splashSignal => _splashSignal$Provider.get();

  @override
  _i15.ThemeSignal get themeSignal => _themeSignal$Provider.get();
}

class _AppPreferences$Provider implements _i16.Provider<_i4.AppPreferences> {
  _AppPreferences$Provider(this._boxOfDynamic$Provider);

  final _BoxOfDynamic$Provider _boxOfDynamic$Provider;

  late final _i4.AppPreferences _singleton = _create();

  _i4.AppPreferences _create() =>
      _i4.AppPreferences(_boxOfDynamic$Provider.get());

  @override
  _i4.AppPreferences get() => _singleton;
}

class _AuthSignal$Provider implements _i16.Provider<_i9.AuthSignal> {
  _AuthSignal$Provider(
    this._firebaseAuth$Provider,
    this._syncService$Provider,
    this._moodRepository$Provider,
  );

  final _FirebaseAuth$Provider _firebaseAuth$Provider;

  final _SyncService$Provider _syncService$Provider;

  final _MoodRepository$Provider _moodRepository$Provider;

  late final _i9.AuthSignal _singleton = _create();

  _i9.AuthSignal _create() => _i9.AuthSignal(
    _firebaseAuth$Provider.get(),
    _syncService$Provider.get(),
    _moodRepository$Provider.get(),
  );

  @override
  _i9.AuthSignal get() => _singleton;
}

class _BoxOfDynamic$Provider implements _i16.Provider<_i17.Box<dynamic>> {
  _BoxOfDynamic$Provider(this._module);

  final _i3.InfrastructureModule _module;

  late final _i17.Box<dynamic> _singleton = _create();

  _i17.Box<dynamic> _create() => _module.providePreferencesBox();

  @override
  _i17.Box<dynamic> get() => _singleton;
}

class _BoxOfMoodEntry$Provider
    implements _i16.Provider<_i17.Box<_i18.MoodEntry>> {
  _BoxOfMoodEntry$Provider(this._module);

  final _i3.InfrastructureModule _module;

  late final _i17.Box<_i18.MoodEntry> _singleton = _create();

  _i17.Box<_i18.MoodEntry> _create() => _module.provideMoodBox();

  @override
  _i17.Box<_i18.MoodEntry> get() => _singleton;
}

class _Connectivity$Provider implements _i16.Provider<_i19.Connectivity> {
  _Connectivity$Provider(this._module);

  final _i3.InfrastructureModule _module;

  late final _i19.Connectivity _singleton = _create();

  _i19.Connectivity _create() => _module.provideConnectivity();

  @override
  _i19.Connectivity get() => _singleton;
}

class _FirebaseAuth$Provider implements _i16.Provider<_i20.FirebaseAuth> {
  _FirebaseAuth$Provider(this._module);

  final _i2.FirebaseModule _module;

  late final _i20.FirebaseAuth _singleton = _create();

  _i20.FirebaseAuth _create() => _module.provideAuth();

  @override
  _i20.FirebaseAuth get() => _singleton;
}

class _FirebaseFirestore$Provider
    implements _i16.Provider<_i21.FirebaseFirestore> {
  _FirebaseFirestore$Provider(this._module);

  final _i2.FirebaseModule _module;

  late final _i21.FirebaseFirestore _singleton = _create();

  _i21.FirebaseFirestore _create() => _module.provideFirestore();

  @override
  _i21.FirebaseFirestore get() => _singleton;
}

class _FirestoreService$Provider
    implements _i16.Provider<_i6.FirestoreService> {
  _FirestoreService$Provider(this._firebaseFirestore$Provider);

  final _FirebaseFirestore$Provider _firebaseFirestore$Provider;

  late final _i6.FirestoreService _singleton = _create();

  _i6.FirestoreService _create() =>
      _i6.FirestoreService(_firebaseFirestore$Provider.get());

  @override
  _i6.FirestoreService get() => _singleton;
}

class _HiveService$Provider implements _i16.Provider<_i5.HiveService> {
  _HiveService$Provider(this._boxOfMoodEntry$Provider);

  final _BoxOfMoodEntry$Provider _boxOfMoodEntry$Provider;

  late final _i5.HiveService _singleton = _create();

  _i5.HiveService _create() => _i5.HiveService(_boxOfMoodEntry$Provider.get());

  @override
  _i5.HiveService get() => _singleton;
}

class _InsightsSignal$Provider implements _i16.Provider<_i11.InsightsSignal> {
  _InsightsSignal$Provider(this._moodSignal$Provider);

  final _MoodSignal$Provider _moodSignal$Provider;

  late final _i11.InsightsSignal _singleton = _create();

  _i11.InsightsSignal _create() =>
      _i11.InsightsSignal(_moodSignal$Provider.get());

  @override
  _i11.InsightsSignal get() => _singleton;
}

class _MoodRepository$Provider implements _i16.Provider<_i8.MoodRepository> {
  _MoodRepository$Provider(
    this._hiveService$Provider,
    this._syncService$Provider,
    this._firestoreService$Provider,
  );

  final _HiveService$Provider _hiveService$Provider;

  final _SyncService$Provider _syncService$Provider;

  final _FirestoreService$Provider _firestoreService$Provider;

  late final _i8.MoodRepository _singleton = _create();

  _i8.MoodRepository _create() => _i8.MoodRepository(
    _hiveService$Provider.get(),
    _syncService$Provider.get(),
    _firestoreService$Provider.get(),
  );

  @override
  _i8.MoodRepository get() => _singleton;
}

class _MoodSignal$Provider implements _i16.Provider<_i10.MoodSignal> {
  _MoodSignal$Provider(
    this._moodRepository$Provider,
    this._authSignal$Provider,
  );

  final _MoodRepository$Provider _moodRepository$Provider;

  final _AuthSignal$Provider _authSignal$Provider;

  late final _i10.MoodSignal _singleton = _create();

  _i10.MoodSignal _create() => _i10.MoodSignal(
    _moodRepository$Provider.get(),
    _authSignal$Provider.get(),
  );

  @override
  _i10.MoodSignal get() => _singleton;
}

class _OnboardingRepository$Provider
    implements _i16.Provider<_i12.OnboardingRepository> {
  _OnboardingRepository$Provider(this._appPreferences$Provider);

  final _AppPreferences$Provider _appPreferences$Provider;

  late final _i12.OnboardingRepository _singleton = _create();

  _i12.OnboardingRepository _create() =>
      _i12.OnboardingRepository(_appPreferences$Provider.get());

  @override
  _i12.OnboardingRepository get() => _singleton;
}

class _OnboardingSignal$Provider
    implements _i16.Provider<_i13.OnboardingSignal> {
  _OnboardingSignal$Provider(this._onboardingRepository$Provider);

  final _OnboardingRepository$Provider _onboardingRepository$Provider;

  late final _i13.OnboardingSignal _singleton = _create();

  _i13.OnboardingSignal _create() =>
      _i13.OnboardingSignal(_onboardingRepository$Provider.get());

  @override
  _i13.OnboardingSignal get() => _singleton;
}

class _SplashSignal$Provider implements _i16.Provider<_i14.SplashSignal> {
  _SplashSignal$Provider(
    this._firebaseAuth$Provider,
    this._onboardingRepository$Provider,
  );

  final _FirebaseAuth$Provider _firebaseAuth$Provider;

  final _OnboardingRepository$Provider _onboardingRepository$Provider;

  late final _i14.SplashSignal _singleton = _create();

  _i14.SplashSignal _create() => _i14.SplashSignal(
    _firebaseAuth$Provider.get(),
    _onboardingRepository$Provider.get(),
  );

  @override
  _i14.SplashSignal get() => _singleton;
}

class _SyncService$Provider implements _i16.Provider<_i7.SyncService> {
  _SyncService$Provider(
    this._hiveService$Provider,
    this._firestoreService$Provider,
    this._connectivity$Provider,
    this._firebaseAuth$Provider,
  );

  final _HiveService$Provider _hiveService$Provider;

  final _FirestoreService$Provider _firestoreService$Provider;

  final _Connectivity$Provider _connectivity$Provider;

  final _FirebaseAuth$Provider _firebaseAuth$Provider;

  late final _i7.SyncService _singleton = _create();

  _i7.SyncService _create() => _i7.SyncService(
    _hiveService$Provider.get(),
    _firestoreService$Provider.get(),
    _connectivity$Provider.get(),
    _firebaseAuth$Provider.get(),
  );

  @override
  _i7.SyncService get() => _singleton;
}

class _ThemeSignal$Provider implements _i16.Provider<_i15.ThemeSignal> {
  _ThemeSignal$Provider(this._appPreferences$Provider);

  final _AppPreferences$Provider _appPreferences$Provider;

  late final _i15.ThemeSignal _singleton = _create();

  _i15.ThemeSignal _create() =>
      _i15.ThemeSignal(_appPreferences$Provider.get());

  @override
  _i15.ThemeSignal get() => _singleton;
}
