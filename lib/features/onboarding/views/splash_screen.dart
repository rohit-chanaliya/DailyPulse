import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:signals_flutter/signals_flutter.dart';

import 'package:dailypulse/core/di/injection.dart';
import 'package:dailypulse/core/theme/app_theme.dart';
import '../viewmodels/splash_signal.dart';
import 'splash_phase_colors.dart';
import 'widgets/splash_phase_content.dart';
import 'widgets/splash_skip_button.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  late final SplashSignal _signal = appComponent.splashSignal;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        _signal.startSplashSequence(_navigateNext);
      }
    });
  }

  @override
  void dispose() {
    _signal.cancel();
    super.dispose();
  }

  void _navigateNext() {
    if (!mounted) return;
    context.go(_signal.nextLocation);
  }

  @override
  Widget build(BuildContext context) {
    return SignalBuilder(
      builder: (context) {
        final currentPhase = _signal.currentPhase.value;
        final progressValue = _signal.progressValue.value;

        return Scaffold(
          backgroundColor: context.splash.backgroundFor(currentPhase),
          body: Stack(
            children: [
              Positioned.fill(
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 800),
                  switchInCurve: Curves.easeInOut,
                  switchOutCurve: Curves.easeInOut,
                  child: SplashPhaseContent(
                    phase: currentPhase,
                    progressValue: progressValue,
                    onContinue: _navigateNext,
                  ),
                ),
              ),
              Positioned(
                top: 16,
                right: 16,
                child: SafeArea(
                  child: SplashSkipButton(
                    phase: currentPhase,
                    onPressed: () => _signal.skipSplash(_navigateNext),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
