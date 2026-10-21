import 'package:dailypulse/features/onboarding/views/welcome_screen.dart';
import 'package:flutter/material.dart';
import 'package:signals_flutter/signals_flutter.dart';

import 'package:dailypulse/core/theme/app_theme.dart';
import 'package:dailypulse/core/constant/strings/onboarding_strings.dart';
import '../../../core/widgets/navigation/fade_page_route.dart';
import '../viewmodels/splash_signal.dart';
import 'widgets/splash_phase_content.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        splashSignal.startSplashSequence(_navigateToWelcome);
      }
    });
  }

  @override
  void dispose() {
    splashSignal.dispose();
    super.dispose();
  }

  void _navigateToWelcome() {
    Navigator.of(context).pushReplacement(
      FadePageRoute(
        page: const WelcomeScreen(),
        duration: const Duration(milliseconds: 600),
      ),
    );
  }

  Color _getSkipButtonColor(SplashPhase phase, SplashColors splashColors) {
    switch (phase) {
      case SplashPhase.brandLogo:
        return splashColors.brandLogoColor.withValues(alpha: 0.5);
      case SplashPhase.progressLoading:
        return splashColors.progressLoadingText.withValues(alpha: 0.5);
      case SplashPhase.fetchingData:
        return splashColors.fetchingDataText.withValues(alpha: 0.5);
      case SplashPhase.quote:
        return splashColors.quoteText.withValues(alpha: 0.5);
    }
  }

  Color _getPhaseBackgroundColor(SplashPhase phase, SplashColors splashColors) {
    switch (phase) {
      case SplashPhase.brandLogo:
        return splashColors.brandLogoBg;
      case SplashPhase.progressLoading:
        return splashColors.progressLoadingBg;
      case SplashPhase.fetchingData:
        return splashColors.fetchingDataBg;
      case SplashPhase.quote:
        return splashColors.quoteBg;
    }
  }

  @override
  Widget build(BuildContext context) {
    return SignalBuilder(
      builder: (context) {
        final currentPhase = splashSignal.currentPhase.value;
        final progressValue = splashSignal.progressValue.value;
        final splashColors = context.splash;

        return Scaffold(
          backgroundColor: _getPhaseBackgroundColor(currentPhase, splashColors),
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
                    onContinue: _navigateToWelcome,
                  ),
                ),
              ),

              Positioned(
                top: 16,
                right: 16,
                child: SafeArea(
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 400),
                    child: TextButton(
                      key: ValueKey(currentPhase),
                      onPressed: () {
                        splashSignal.skipSplash(_navigateToWelcome);
                      },
                      style: TextButton.styleFrom(
                        foregroundColor: _getSkipButtonColor(
                          currentPhase,
                          splashColors,
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            OnboardingStrings.splashSkip,
                            style: context.textTheme.labelMedium,
                          ),
                          const SizedBox(width: 4),
                          const Icon(Icons.chevron_right_rounded, size: 18),
                        ],
                      ),
                    ),
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
