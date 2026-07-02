import 'dart:async';
import 'package:flutter/material.dart';

enum SplashPhase {
  brandLogo,       // Cream background with terracotta logo
  progressLoading, // Dark warm charcoal background with 0-100% counter
  fetchingData,    // Sage green background with "Fetching Data"
  quote,           // Terracotta orange background with Albert Camus quote
}

class SplashProvider extends ChangeNotifier {
  SplashPhase _currentPhase = SplashPhase.brandLogo;
  double _progressValue = 0.0;
  bool _isDisposed = false;
  Timer? _phaseTimer;

  SplashPhase get currentPhase => _currentPhase;
  double get progressValue => _progressValue;

  void startSplashSequence(VoidCallback onComplete) {
    _startPhase1(onComplete);
  }

  void _startPhase1(VoidCallback onComplete) {
    _phaseTimer = Timer(const Duration(milliseconds: 2200), () {
      if (_isDisposed) return;
      _currentPhase = SplashPhase.progressLoading;
      notifyListeners();
      _startPhase2(onComplete);
    });
  }

  void _startPhase2(VoidCallback onComplete) {
    const duration = Duration(milliseconds: 1800);
    const interval = Duration(milliseconds: 30);
    final totalSteps = duration.inMilliseconds ~/ interval.inMilliseconds;
    int step = 0;

    _phaseTimer = Timer.periodic(interval, (timer) {
      if (_isDisposed) {
        timer.cancel();
        return;
      }
      step++;
      _progressValue = (step / totalSteps) * 100;
      if (_progressValue >= 100) {
        _progressValue = 100;
        timer.cancel();
        notifyListeners();

        // Subtle pause at 100% before transition
        Future.delayed(const Duration(milliseconds: 300), () {
          if (_isDisposed) return;
          _currentPhase = SplashPhase.fetchingData;
          notifyListeners();
          _startPhase3(onComplete);
        });
      } else {
        notifyListeners();
      }
    });
  }

  void _startPhase3(VoidCallback onComplete) {
    _phaseTimer = Timer(const Duration(milliseconds: 3200), () {
      if (_isDisposed) return;
      _currentPhase = SplashPhase.quote;
      notifyListeners();
      _startPhase4(onComplete);
    });
  }

  void _startPhase4(VoidCallback onComplete) {
    _phaseTimer = Timer(const Duration(milliseconds: 4500), () {
      if (_isDisposed) return;
      onComplete();
    });
  }

  void skipSplash(VoidCallback onComplete) {
    _phaseTimer?.cancel();
    onComplete();
  }

  @override
  void dispose() {
    _isDisposed = true;
    _phaseTimer?.cancel();
    super.dispose();
  }
}
