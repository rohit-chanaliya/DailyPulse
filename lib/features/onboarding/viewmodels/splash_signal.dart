import 'dart:async';

import 'package:signals_flutter/signals_flutter.dart';

enum SplashPhase {
  brandLogo, // Cream background with terracotta logo
  progressLoading, // Dark warm charcoal background with 0-100% counter
  fetchingData, // Sage green background with "Fetching Data"
  quote, // Terracotta orange background with Albert Camus quote
}

/// Drives the splash sequence with signals.
class SplashSignal {
  final currentPhase = signal(SplashPhase.brandLogo);
  final progressValue = signal(0.0);

  Timer? _phaseTimer;
  bool _isDisposed = false;

  void startSplashSequence(void Function() onComplete) {
    _startPhase1(onComplete);
  }

  void _startPhase1(void Function() onComplete) {
    _phaseTimer = Timer(const Duration(milliseconds: 2200), () {
      if (_isDisposed) return;
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
      if (_isDisposed) {
        timer.cancel();
        return;
      }
      step++;
      final nextProgress = (step / totalSteps) * 100;
      if (nextProgress >= 100) {
        progressValue.value = 100;
        timer.cancel();
        Future.delayed(const Duration(milliseconds: 300), () {
          if (_isDisposed) return;
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
      if (_isDisposed) return;
      currentPhase.value = SplashPhase.quote;
      _startPhase4(onComplete);
    });
  }

  void _startPhase4(void Function() onComplete) {
    _phaseTimer = Timer(const Duration(milliseconds: 4500), () {
      if (_isDisposed) return;
      onComplete();
    });
  }

  void skipSplash(void Function() onComplete) {
    _phaseTimer?.cancel();
    onComplete();
  }

  void dispose() {
    _isDisposed = true;
    _phaseTimer?.cancel();
  }
}

final splashSignal = SplashSignal();
