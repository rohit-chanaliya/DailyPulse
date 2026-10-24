// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format width=80

// **************************************************************************
// Generator: inject.dart
// https://pub.dev/packages/inject_annotation
// **************************************************************************

// ignore_for_file: type=lint, type=warning
// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'package:cloud_firestore/cloud_firestore.dart' as _i15;
import 'package:connectivity_plus/connectivity_plus.dart' as _i13;
import 'package:firebase_auth/firebase_auth.dart' as _i14;
import 'package:inject_annotation/inject_annotation.dart' as _i12;

import '../../features/auth/presentation/signals/auth_signal.dart' as _i4;
import '../../features/insights/presentation/signals/insights_signal.dart'
    as _i9;
import '../../features/mood/data/remote/firestore_service.dart' as _i5;
import '../../features/mood/data/repositories/mood_repository.dart' as _i7;
import '../../features/mood/data/services/sync_service.dart' as _i6;
import '../../features/mood/presentation/signals/mood_signal.dart' as _i8;
import '../../features/onboarding/viewmodels/splash_signal.dart' as _i10;
import '../../features/settings/presentation/signals/theme_signal.dart' as _i11;
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
    final firebaseAuth$Provider = _FirebaseAuth$Provider(firebaseModule);
    _authSignal$Provider = _AuthSignal$Provider(firebaseAuth$Provider);
    final connectivity$Provider = _Connectivity$Provider(infrastructureModule);
    final firebaseFirestore$Provider = _FirebaseFirestore$Provider(
      firebaseModule,
    );
    _firestoreService$Provider = _FirestoreService$Provider(
      firebaseFirestore$Provider,
    );
    _syncService$Provider = _SyncService$Provider(
      _firestoreService$Provider,
      connectivity$Provider,
      firebaseAuth$Provider,
    );
    _moodRepository$Provider = _MoodRepository$Provider(
      _syncService$Provider,
      _firestoreService$Provider,
    );
    _moodSignal$Provider = _MoodSignal$Provider(_moodRepository$Provider);
    _insightsSignal$Provider = _InsightsSignal$Provider(_moodSignal$Provider);
    _splashSignal$Provider = _SplashSignal$Provider();
    _themeSignal$Provider = _ThemeSignal$Provider();
  }

  late final _AuthSignal$Provider _authSignal$Provider;

  late final _FirestoreService$Provider _firestoreService$Provider;

  late final _SyncService$Provider _syncService$Provider;

  late final _MoodRepository$Provider _moodRepository$Provider;

  late final _MoodSignal$Provider _moodSignal$Provider;

  late final _InsightsSignal$Provider _insightsSignal$Provider;

  late final _SplashSignal$Provider _splashSignal$Provider;

  late final _ThemeSignal$Provider _themeSignal$Provider;

  @override
  _i4.AuthSignal get authSignal => _authSignal$Provider.get();

  @override
  _i5.FirestoreService get firestoreService => _firestoreService$Provider.get();

  @override
  _i6.SyncService get syncService => _syncService$Provider.get();

  @override
  _i7.MoodRepository get moodRepository => _moodRepository$Provider.get();

  @override
  _i8.MoodSignal get moodSignal => _moodSignal$Provider.get();

  @override
  _i9.InsightsSignal get insightsSignal => _insightsSignal$Provider.get();

  @override
  _i10.SplashSignal get splashSignal => _splashSignal$Provider.get();

  @override
  _i11.ThemeSignal get themeSignal => _themeSignal$Provider.get();
}

class _AuthSignal$Provider implements _i12.Provider<_i4.AuthSignal> {
  _AuthSignal$Provider(this._firebaseAuth$Provider);

  final _FirebaseAuth$Provider _firebaseAuth$Provider;

  late final _i4.AuthSignal _singleton = _create();

  _i4.AuthSignal _create() => _i4.AuthSignal(_firebaseAuth$Provider.get());

  @override
  _i4.AuthSignal get() => _singleton;
}

class _Connectivity$Provider implements _i12.Provider<_i13.Connectivity> {
  _Connectivity$Provider(this._module);

  final _i3.InfrastructureModule _module;

  late final _i13.Connectivity _singleton = _create();

  _i13.Connectivity _create() => _module.provideConnectivity();

  @override
  _i13.Connectivity get() => _singleton;
}

class _FirebaseAuth$Provider implements _i12.Provider<_i14.FirebaseAuth> {
  _FirebaseAuth$Provider(this._module);

  final _i2.FirebaseModule _module;

  late final _i14.FirebaseAuth _singleton = _create();

  _i14.FirebaseAuth _create() => _module.provideAuth();

  @override
  _i14.FirebaseAuth get() => _singleton;
}

class _FirebaseFirestore$Provider
    implements _i12.Provider<_i15.FirebaseFirestore> {
  _FirebaseFirestore$Provider(this._module);

  final _i2.FirebaseModule _module;

  late final _i15.FirebaseFirestore _singleton = _create();

  _i15.FirebaseFirestore _create() => _module.provideFirestore();

  @override
  _i15.FirebaseFirestore get() => _singleton;
}

class _FirestoreService$Provider
    implements _i12.Provider<_i5.FirestoreService> {
  _FirestoreService$Provider(this._firebaseFirestore$Provider);

  final _FirebaseFirestore$Provider _firebaseFirestore$Provider;

  late final _i5.FirestoreService _singleton = _create();

  _i5.FirestoreService _create() =>
      _i5.FirestoreService(_firebaseFirestore$Provider.get());

  @override
  _i5.FirestoreService get() => _singleton;
}

class _InsightsSignal$Provider implements _i12.Provider<_i9.InsightsSignal> {
  _InsightsSignal$Provider(this._moodSignal$Provider);

  final _MoodSignal$Provider _moodSignal$Provider;

  late final _i9.InsightsSignal _singleton = _create();

  _i9.InsightsSignal _create() =>
      _i9.InsightsSignal(_moodSignal$Provider.get());

  @override
  _i9.InsightsSignal get() => _singleton;
}

class _MoodRepository$Provider implements _i12.Provider<_i7.MoodRepository> {
  _MoodRepository$Provider(
    this._syncService$Provider,
    this._firestoreService$Provider,
  );

  final _SyncService$Provider _syncService$Provider;

  final _FirestoreService$Provider _firestoreService$Provider;

  late final _i7.MoodRepository _singleton = _create();

  _i7.MoodRepository _create() => _i7.MoodRepository(
    _syncService$Provider.get(),
    _firestoreService$Provider.get(),
  );

  @override
  _i7.MoodRepository get() => _singleton;
}

class _MoodSignal$Provider implements _i12.Provider<_i8.MoodSignal> {
  _MoodSignal$Provider(this._moodRepository$Provider);

  final _MoodRepository$Provider _moodRepository$Provider;

  late final _i8.MoodSignal _singleton = _create();

  _i8.MoodSignal _create() => _i8.MoodSignal(_moodRepository$Provider.get());

  @override
  _i8.MoodSignal get() => _singleton;
}

class _SplashSignal$Provider implements _i12.Provider<_i10.SplashSignal> {
  _SplashSignal$Provider();

  late final _i10.SplashSignal _singleton = _create();

  _i10.SplashSignal _create() => _i10.SplashSignal();

  @override
  _i10.SplashSignal get() => _singleton;
}

class _SyncService$Provider implements _i12.Provider<_i6.SyncService> {
  _SyncService$Provider(
    this._firestoreService$Provider,
    this._connectivity$Provider,
    this._firebaseAuth$Provider,
  );

  final _FirestoreService$Provider _firestoreService$Provider;

  final _Connectivity$Provider _connectivity$Provider;

  final _FirebaseAuth$Provider _firebaseAuth$Provider;

  late final _i6.SyncService _singleton = _create();

  _i6.SyncService _create() => _i6.SyncService(
    _firestoreService$Provider.get(),
    _connectivity$Provider.get(),
    _firebaseAuth$Provider.get(),
  );

  @override
  _i6.SyncService get() => _singleton;
}

class _ThemeSignal$Provider implements _i12.Provider<_i11.ThemeSignal> {
  _ThemeSignal$Provider();

  late final _i11.ThemeSignal _singleton = _create();

  _i11.ThemeSignal _create() => _i11.ThemeSignal();

  @override
  _i11.ThemeSignal get() => _singleton;
}
