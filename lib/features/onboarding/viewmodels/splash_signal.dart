import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:inject_annotation/inject_annotation.dart';
import 'package:signals_flutter/signals_flutter.dart';

import 'package:dailypulse/core/router/app_routes.dart';
import '../repository/onboarding_repository.dart';

enum SplashPhase {
  brandLogo, // Cream background with terracotta logo
  progressLoading, // Dark warm charcoal background with 0-100% counter
  fetchingData, // Sage green background with "Fetching Data"
  quote, // Terracotta orange background with Albert Camus quote
}

/// Drives the splash sequence and decides where the app lands afterwards.
@singleton
class SplashSignal {
  @inject
  SplashSignal(this._auth, this._onboardingRepository);

  final FirebaseAuth _auth;
  final OnboardingRepository _onboardingRepository;

  final currentPhase = signal(SplashPhase.brandLogo);
  final progressValue = signal(0.0);

  Timer? _phaseTimer;

  /// Where a cold start should land once the splash is done.
  ///
  /// Authenticated users skip the onboarding/auth funnel; unverified
  /// email/password users are sent to sign-in.
  String get nextLocation {
    final user = _auth.currentUser;
    if (user != null) {
      final isGoogleUser = user.providerData.any(
        (info) => info.providerId == 'google.com',
      );
      return user.emailVerified || isGoogleUser
          ? AppRoutes.home
          : AppRoutes.signIn;
    }
    return _onboardingRepository.hasSeenOnboarding
        ? AppRoutes.signIn
        : AppRoutes.welcome;
  }

  /// Restarts the sequence from the first phase.
  void startSplashSequence(void Function() onComplete) {
    cancel();
    currentPhase.value = SplashPhase.brandLogo;
    progressValue.value = 0;
    _startPhase1(onComplete);
  }

  void _startPhase1(void Function() onComplete) {
    _phaseTimer = Timer(const Duration(milliseconds: 2200), () {
      currentPhase.value = SplashPhase.progressLoading;
      _startPhase2(onComplete);
    });
  }

  void _startPhase2(void Function() onComplete) {
    const duration = Duration(milliseconds: 1800);
    const interval = Duration(milliseconds: 30);
    final totalSteps = duration.inMilliseconds ~/ interval.inMilliseconds;
    var step = 0;

    _phaseTimer = Timer.periodic(interval, (timer) {
      step++;
      final nextProgress = (step / totalSteps) * 100;
      if (nextProgress >= 100) {
        progressValue.value = 100;
        timer.cancel();
        _phaseTimer = Timer(const Duration(milliseconds: 300), () {
          currentPhase.value = SplashPhase.fetchingData;
          _startPhase3(onComplete);
        });
      } else {
        progressValue.value = nextProgress;
      }
    });
  }

  void _startPhase3(void Function() onComplete) {
    _phaseTimer = Timer(const Duration(milliseconds: 3200), () {
      currentPhase.value = SplashPhase.quote;
      _startPhase4(onComplete);
    });
  }

  void _startPhase4(void Function() onComplete) {
    _phaseTimer = Timer(const Duration(milliseconds: 4500), onComplete);
  }

  void skipSplash(void Function() onComplete) {
    cancel();
    onComplete();
  }

  /// Stops any running phase timer; safe to call before restarting.
  void cancel() {
    _phaseTimer?.cancel();
    _phaseTimer = null;
  }
}
