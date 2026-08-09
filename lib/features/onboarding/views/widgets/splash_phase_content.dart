import 'package:flutter/material.dart';
import '../../viewmodels/splash_viewmodel.dart';
import 'brand_logo_phase.dart';
import 'fetching_data_phase.dart';
import 'progress_loading_phase.dart';
import 'quote_phase.dart';

class SplashPhaseContent extends StatelessWidget {
  final SplashPhase phase;
  final double progressValue;
  final VoidCallback onContinue;

  const SplashPhaseContent({
    super.key,
    required this.phase,
    required this.progressValue,
    required this.onContinue,
  });

  @override
  Widget build(BuildContext context) {
    switch (phase) {
      case SplashPhase.brandLogo:
        return const BrandLogoPhase();
      case SplashPhase.progressLoading:
        return ProgressLoadingPhase(progressValue: progressValue);
      case SplashPhase.fetchingData:
        return const FetchingDataPhase();
      case SplashPhase.quote:
        return QuotePhase(onContinue: onContinue);
    }
  }
}
