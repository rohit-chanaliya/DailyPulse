import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:dailypulse/core/theme/app_theme.dart';
import '../../../../shared/navigation/fade_page_route.dart';
import 'package:dailypulse/features/auth/widgets/auth_wrapper.dart';
import '../viewmodels/splash_viewmodel.dart';
import 'widgets/brand_logo_phase.dart';
import 'widgets/fetching_data_phase.dart';
import 'widgets/progress_loading_phase.dart';
import 'widgets/quote_phase.dart';

class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        ref.read(splashViewModelProvider.notifier).startSplashSequence(() {
          _navigateToAuth();
        });
      }
    });
  }

  void _navigateToAuth() {
    Navigator.of(context).pushReplacement(
      FadePageRoute(
        page: const AuthWrapper(),
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

  Widget _buildPhaseContent(SplashPhase phase, double progressValue) {
    switch (phase) {
      case SplashPhase.brandLogo:
        return const BrandLogoPhase();
      case SplashPhase.progressLoading:
        return ProgressLoadingPhase(progressValue: progressValue);
      case SplashPhase.fetchingData:
        return const FetchingDataPhase();
      case SplashPhase.quote:
        return QuotePhase(onContinue: _navigateToAuth);
    }
  }

  @override
  Widget build(BuildContext context) {
    final splashState = ref.watch(splashViewModelProvider);
    final currentPhase = splashState.currentPhase;
    final progressValue = splashState.progressValue;
    final splashColors = context.splash;
    

    return Scaffold(
      body: Stack(
        children: [
          // Content layer with animated transitions between phases
          Positioned.fill(
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 800),
              switchInCurve: Curves.easeInOut,
              switchOutCurve: Curves.easeInOut,
              child: _buildPhaseContent(currentPhase, progressValue),
            ),
          ),

          // Global skip button overlay
          Positioned(
            top: 16,
            right: 16,
            child: SafeArea(
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 400),
                child: TextButton(
                  key: ValueKey(currentPhase),
                  onPressed: () {
                    ref
                        .read(splashViewModelProvider.notifier)
                        .skipSplash(_navigateToAuth);
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
                        'Skip',
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
  }
}
