import 'package:flutter/material.dart';
import '../../viewmodels/splash_signal.dart';
import 'brand_logo_phase.dart';
import 'fetching_data_phase.dart';
import 'progress_loading_phase.dart';

class SplashPhaseContent extends StatelessWidget {
  final SplashPhase phase;
  final double progressValue;

  const SplashPhaseContent({
    super.key,
    required this.phase,
    required this.progressValue,
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
    }
  }
}
