import 'package:flutter/material.dart';
import 'colors.dart';

class AppThemeExtension extends ThemeExtension<AppThemeExtension> {
  final Color splashBrandLogoBg;
  final Color splashProgressLoadingBg;
  final Color splashProgressLoadingOverlay;
  final Color splashFetchingDataBg;
  final Color splashQuoteBg;

  final Color splashBrandLogoColor;
  final Color splashProgressLoadingText;
  final Color splashFetchingDataText;
  final Color splashQuoteText;

  AppThemeExtension({
    required this.splashBrandLogoBg,
    required this.splashProgressLoadingBg,
    required this.splashProgressLoadingOverlay,
    required this.splashFetchingDataBg,
    required this.splashQuoteBg,
    required this.splashBrandLogoColor,
    required this.splashProgressLoadingText,
    required this.splashFetchingDataText,
    required this.splashQuoteText,
  });

  @override
  AppThemeExtension copyWith({
    Color? splashBrandLogoBg,
    Color? splashProgressLoadingBg,
    Color? splashProgressLoadingOverlay,
    Color? splashFetchingDataBg,
    Color? splashQuoteBg,
    Color? splashBrandLogoColor,
    Color? splashProgressLoadingText,
    Color? splashFetchingDataText,
    Color? splashQuoteText,
  }) {
    return AppThemeExtension(
      splashBrandLogoBg: splashBrandLogoBg ?? this.splashBrandLogoBg,
      splashProgressLoadingBg: splashProgressLoadingBg ?? this.splashProgressLoadingBg,
      splashProgressLoadingOverlay: splashProgressLoadingOverlay ?? this.splashProgressLoadingOverlay,
      splashFetchingDataBg: splashFetchingDataBg ?? this.splashFetchingDataBg,
      splashQuoteBg: splashQuoteBg ?? this.splashQuoteBg,
      splashBrandLogoColor: splashBrandLogoColor ?? this.splashBrandLogoColor,
      splashProgressLoadingText: splashProgressLoadingText ?? this.splashProgressLoadingText,
      splashFetchingDataText: splashFetchingDataText ?? this.splashFetchingDataText,
      splashQuoteText: splashQuoteText ?? this.splashQuoteText,
    );
  }

  @override
  AppThemeExtension lerp(ThemeExtension<AppThemeExtension>? other, double t) {
    if (other is! AppThemeExtension) return this;
    return AppThemeExtension(
      splashBrandLogoBg: Color.lerp(splashBrandLogoBg, other.splashBrandLogoBg, t)!,
      splashProgressLoadingBg: Color.lerp(splashProgressLoadingBg, other.splashProgressLoadingBg, t)!,
      splashProgressLoadingOverlay: Color.lerp(splashProgressLoadingOverlay, other.splashProgressLoadingOverlay, t)!,
      splashFetchingDataBg: Color.lerp(splashFetchingDataBg, other.splashFetchingDataBg, t)!,
      splashQuoteBg: Color.lerp(splashQuoteBg, other.splashQuoteBg, t)!,
      splashBrandLogoColor: Color.lerp(splashBrandLogoColor, other.splashBrandLogoColor, t)!,
      splashProgressLoadingText: Color.lerp(splashProgressLoadingText, other.splashProgressLoadingText, t)!,
      splashFetchingDataText: Color.lerp(splashFetchingDataText, other.splashFetchingDataText, t)!,
      splashQuoteText: Color.lerp(splashQuoteText, other.splashQuoteText, t)!,
    );
  }
}

final lightThemeExtension = AppThemeExtension(
  splashBrandLogoBg: AppColors.splashCreamBg,
  splashProgressLoadingBg: AppColors.splashDarkBg,
  splashProgressLoadingOverlay: AppColors.splashDarkOverlay,
  splashFetchingDataBg: AppColors.splashGreenBg,
  splashQuoteBg: AppColors.splashOrangeBg,
  splashBrandLogoColor: AppColors.splashCreamBrand,
  splashProgressLoadingText: AppColors.white,
  splashFetchingDataText: AppColors.white,
  splashQuoteText: AppColors.white,
);

final darkThemeExtension = AppThemeExtension(
  splashBrandLogoBg: AppColors.splashDarkBg,
  splashProgressLoadingBg: AppColors.splashDarkBg,
  splashProgressLoadingOverlay: AppColors.splashDarkOverlay,
  splashFetchingDataBg: AppColors.splashGreenBg,
  splashQuoteBg: AppColors.splashOrangeBg,
  splashBrandLogoColor: AppColors.splashCreamBrand,
  splashProgressLoadingText: AppColors.white,
  splashFetchingDataText: AppColors.white,
  splashQuoteText: AppColors.white,
);
