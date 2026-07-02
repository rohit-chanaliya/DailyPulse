import 'dart:async';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'splash_viewmodel.g.dart';

enum SplashPhase {
  brandLogo,       // Cream background with terracotta logo
  progressLoading, // Dark warm charcoal background with 0-100% counter
  fetchingData,    // Sage green background with "Fetching Data"
  quote,           // Terracotta orange background with Albert Camus quote
}

class SplashState {
  final SplashPhase currentPhase;
  final double progressValue;

  SplashState({
    required this.currentPhase,
    required this.progressValue,
  });

  SplashState copyWith({
    SplashPhase? currentPhase,
    double? progressValue,
  }) {
    return SplashState(
      currentPhase: currentPhase ?? this.currentPhase,
      progressValue: progressValue ?? this.progressValue,
    );
  }
}

@riverpod
class SplashViewModel extends _$SplashViewModel {
  Timer? _phaseTimer;
  bool _isDisposed = false;

  @override
  SplashState build() {
    ref.onDispose(() {
      _isDisposed = true;
      _phaseTimer?.cancel();
    });
    return SplashState(
      currentPhase: SplashPhase.brandLogo,
      progressValue: 0.0,
    );
  }

  void startSplashSequence(void Function() onComplete) {
    _startPhase1(onComplete);
  }

  void _startPhase1(void Function() onComplete) {
    _phaseTimer = Timer(const Duration(milliseconds: 2200), () {
      if (_isDisposed) return;
      state = state.copyWith(currentPhase: SplashPhase.progressLoading);
      _startPhase2(onComplete);
    });
  }

  void _startPhase2(void Function() onComplete) {
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
      final nextProgress = (step / totalSteps) * 100;
      if (nextProgress >= 100) {
        state = state.copyWith(progressValue: 100);
        timer.cancel();

        // Subtle pause at 100% before transition
        Future.delayed(const Duration(milliseconds: 300), () {
          if (_isDisposed) return;
          state = state.copyWith(currentPhase: SplashPhase.fetchingData);
          _startPhase3(onComplete);
        });
      } else {
        state = state.copyWith(progressValue: nextProgress);
      }
    });
  }

  void _startPhase3(void Function() onComplete) {
    _phaseTimer = Timer(const Duration(milliseconds: 3200), () {
      if (_isDisposed) return;
      state = state.copyWith(currentPhase: SplashPhase.quote);
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
}
