import 'package:flutter/material.dart';

class SplashColors extends ThemeExtension<SplashColors> {
  final Color brandLogoBg;
  final Color progressLoadingBg;
  final Color progressLoadingOverlay;
  final Color fetchingDataBg;
  final Color quoteBg;

  final Color brandLogoColor;
  final Color progressLoadingText;
  final Color fetchingDataText;
  final Color quoteText;

  SplashColors({
    required this.brandLogoBg,
    required this.progressLoadingBg,
    required this.progressLoadingOverlay,
    required this.fetchingDataBg,
    required this.quoteBg,
    required this.brandLogoColor,
    required this.progressLoadingText,
    required this.fetchingDataText,
    required this.quoteText,
  });

  @override
  SplashColors copyWith({
    Color? brandLogoBg,
    Color? progressLoadingBg,
    Color? progressLoadingOverlay,
    Color? fetchingDataBg,
    Color? quoteBg,
    Color? brandLogoColor,
    Color? progressLoadingText,
    Color? fetchingDataText,
    Color? quoteText,
  }) {
    return SplashColors(
      brandLogoBg: brandLogoBg ?? this.brandLogoBg,
      progressLoadingBg: progressLoadingBg ?? this.progressLoadingBg,
      progressLoadingOverlay: progressLoadingOverlay ?? this.progressLoadingOverlay,
      fetchingDataBg: fetchingDataBg ?? this.fetchingDataBg,
      quoteBg: quoteBg ?? this.quoteBg,
      brandLogoColor: brandLogoColor ?? this.brandLogoColor,
      progressLoadingText: progressLoadingText ?? this.progressLoadingText,
      fetchingDataText: fetchingDataText ?? this.fetchingDataText,
      quoteText: quoteText ?? this.quoteText,
    );
  }

  @override
  SplashColors lerp(ThemeExtension<SplashColors>? other, double t) {
    if (other is! SplashColors) return this;
    return SplashColors(
      brandLogoBg: Color.lerp(brandLogoBg, other.brandLogoBg, t)!,
      progressLoadingBg: Color.lerp(progressLoadingBg, other.progressLoadingBg, t)!,
      progressLoadingOverlay: Color.lerp(progressLoadingOverlay, other.progressLoadingOverlay, t)!,
      fetchingDataBg: Color.lerp(fetchingDataBg, other.fetchingDataBg, t)!,
      quoteBg: Color.lerp(quoteBg, other.quoteBg, t)!,
      brandLogoColor: Color.lerp(brandLogoColor, other.brandLogoColor, t)!,
      progressLoadingText: Color.lerp(progressLoadingText, other.progressLoadingText, t)!,
      fetchingDataText: Color.lerp(fetchingDataText, other.fetchingDataText, t)!,
      quoteText: Color.lerp(quoteText, other.quoteText, t)!,
    );
  }
}
