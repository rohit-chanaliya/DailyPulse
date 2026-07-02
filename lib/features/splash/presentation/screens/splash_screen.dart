import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../core/theme/colors.dart';
import '../../../../shared/navigation/fade_page_route.dart';
import '../../../auth/widgets/auth_wrapper.dart';
import '../providers/splash_provider.dart';
import '../widgets/brand_logo_phase.dart';
import '../widgets/fetching_data_phase.dart';
import '../widgets/progress_loading_phase.dart';
import '../widgets/quote_phase.dart';

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
        context.read<SplashProvider>().startSplashSequence(() {
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

  Color _getSkipButtonColor(SplashPhase phase) {
    switch (phase) {
      case SplashPhase.brandLogo:
        return AppColors.splashCreamBrand.withValues(alpha: 0.5);
      case SplashPhase.progressLoading:
      case SplashPhase.fetchingData:
      case SplashPhase.quote:
        return Colors.white.withValues(alpha: 0.5);
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
    final splashProvider = context.watch<SplashProvider>();
    final currentPhase = splashProvider.currentPhase;
    final progressValue = splashProvider.progressValue;

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
                    context.read<SplashProvider>().skipSplash(_navigateToAuth);
                  },
                  style: TextButton.styleFrom(
                    foregroundColor: _getSkipButtonColor(currentPhase),
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
