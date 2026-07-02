import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/theme_extension.dart';
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

  Color _getSkipButtonColor(SplashPhase phase, AppThemeExtension customTheme) {
    switch (phase) {
      case SplashPhase.brandLogo:
        return customTheme.splashBrandLogoColor.withValues(alpha: 0.5);
      case SplashPhase.progressLoading:
        return customTheme.splashProgressLoadingText.withValues(alpha: 0.5);
      case SplashPhase.fetchingData:
        return customTheme.splashFetchingDataText.withValues(alpha: 0.5);
      case SplashPhase.quote:
        return customTheme.splashQuoteText.withValues(alpha: 0.5);
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
    final customTheme = Theme.of(context).extension<AppThemeExtension>()!;

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
                    ref.read(splashViewModelProvider.notifier).skipSplash(_navigateToAuth);
                  },
                  style: TextButton.styleFrom(
                    foregroundColor: _getSkipButtonColor(currentPhase, customTheme),
                  ),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'Skip',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 0.2,
                        ),
                      ),
                      SizedBox(width: 4),
                      Icon(Icons.chevron_right_rounded, size: 18),
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
