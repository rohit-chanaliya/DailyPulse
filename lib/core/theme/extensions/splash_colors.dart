import 'package:flutter/material.dart';

class SplashColors extends ThemeExtension<SplashColors> {
  final Color brandLogoBg;
  final Color progressLoadingBg;
  final Color progressLoadingOverlay;
  final Color fetchingDataBg;

  final Color brandLogoColor;
  final Color progressLoadingText;
  final Color fetchingDataText;

  SplashColors({
    required this.brandLogoBg,
    required this.progressLoadingBg,
    required this.progressLoadingOverlay,
    required this.fetchingDataBg,
    required this.brandLogoColor,
    required this.progressLoadingText,
    required this.fetchingDataText,
  });

  @override
  SplashColors copyWith({
    Color? brandLogoBg,
    Color? progressLoadingBg,
    Color? progressLoadingOverlay,
    Color? fetchingDataBg,
    Color? brandLogoColor,
    Color? progressLoadingText,
    Color? fetchingDataText,
  }) {
    return SplashColors(
      brandLogoBg: brandLogoBg ?? this.brandLogoBg,
      progressLoadingBg: progressLoadingBg ?? this.progressLoadingBg,
      progressLoadingOverlay:
          progressLoadingOverlay ?? this.progressLoadingOverlay,
      fetchingDataBg: fetchingDataBg ?? this.fetchingDataBg,
      brandLogoColor: brandLogoColor ?? this.brandLogoColor,
      progressLoadingText: progressLoadingText ?? this.progressLoadingText,
      fetchingDataText: fetchingDataText ?? this.fetchingDataText,
    );
  }

  @override
  SplashColors lerp(ThemeExtension<SplashColors>? other, double t) {
    if (other is! SplashColors) return this;
    return SplashColors(
      brandLogoBg: Color.lerp(brandLogoBg, other.brandLogoBg, t)!,
      progressLoadingBg: Color.lerp(
        progressLoadingBg,
        other.progressLoadingBg,
        t,
      )!,
      progressLoadingOverlay: Color.lerp(
        progressLoadingOverlay,
        other.progressLoadingOverlay,
        t,
      )!,
      fetchingDataBg: Color.lerp(fetchingDataBg, other.fetchingDataBg, t)!,
      brandLogoColor: Color.lerp(brandLogoColor, other.brandLogoColor, t)!,
      progressLoadingText: Color.lerp(
        progressLoadingText,
        other.progressLoadingText,
        t,
      )!,
      fetchingDataText: Color.lerp(
        fetchingDataText,
        other.fetchingDataText,
        t,
      )!,
    );
  }
}
