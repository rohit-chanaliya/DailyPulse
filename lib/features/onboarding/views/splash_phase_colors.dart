import 'package:dailypulse/core/theme/app_theme.dart';
import 'package:flutter/material.dart';

import '../viewmodels/splash_signal.dart';

/// Maps a [SplashPhase] to its themed colors.
extension SplashPhaseColors on SplashColors {
  Color backgroundFor(SplashPhase phase) => switch (phase) {
    SplashPhase.brandLogo => brandLogoBg,
    SplashPhase.progressLoading => progressLoadingBg,
    SplashPhase.fetchingData => fetchingDataBg,
    SplashPhase.quote => quoteBg,
  };

  Color skipButtonFor(SplashPhase phase) => switch (phase) {
    SplashPhase.brandLogo => brandLogoColor,
    SplashPhase.progressLoading => progressLoadingText,
    SplashPhase.fetchingData => fetchingDataText,
    SplashPhase.quote => quoteText,
  }.withValues(alpha: 0.5);
}
