import 'package:flutter/material.dart';
import 'colors/app_colors.dart';
import 'typography/app_typography.dart';
import 'extensions/mood_colors.dart';
import 'extensions/status_colors.dart';
import 'extensions/card_colors.dart';
import 'extensions/app_gradients.dart';
import 'extensions/splash_colors.dart';

final ThemeData lightTheme = ThemeData(
  useMaterial3: true,
  brightness: Brightness.light,
  scaffoldBackgroundColor: AppColors.backgroundLight,
  colorScheme: ColorScheme.fromSeed(
    seedColor: AppColors.primaryBlue,
    primary: AppColors.primaryBlue,
    secondary: AppColors.accentPink,
    brightness: Brightness.light,
    surface: AppColors.backgroundLight,
  ),
  textTheme: AppTypography.textTheme,
  appBarTheme: AppBarTheme(
    backgroundColor: AppColors.transparent,
    elevation: 0,
    centerTitle: true,
    titleTextStyle: AppTypography.headingXlSemiBold.copyWith(color: AppColors.textLightPrimary),
    iconTheme: const IconThemeData(color: AppColors.textLightPrimary),
  ),
  navigationBarTheme: NavigationBarThemeData(
    backgroundColor: AppColors.white,
    elevation: 0,
    indicatorColor: AppColors.transparent,
    labelTextStyle: WidgetStateProperty.all(
      AppTypography.textXsMedium,
    ),
  ),
  cardTheme: const CardThemeData(
    color: AppColors.cardLight,
    elevation: 0,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(24)),
    ),
  ),
  filledButtonTheme: FilledButtonThemeData(
    style: FilledButton.styleFrom(
      backgroundColor: AppColors.accentPink,
      foregroundColor: AppColors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(30),
      ),
      padding: const EdgeInsets.symmetric(vertical: 18),
      textStyle: AppTypography.textMdSemiBold,
    ),
  ),
  textButtonTheme: TextButtonThemeData(
    style: TextButton.styleFrom(
      foregroundColor: AppColors.accentPink,
      textStyle: AppTypography.textMdSemiBold,
    ),
  ),
  inputDecorationTheme: InputDecorationTheme(
    filled: true,
    fillColor: AppColors.white,
    hintStyle: AppTypography.textMdMedium.copyWith(color: AppColors.grey400),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(30),
      borderSide: BorderSide.none,
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(30),
      borderSide: BorderSide.none,
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(30),
      borderSide: const BorderSide(
        color: AppColors.primaryBlue,
        width: 2,
      ),
    ),
    errorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(30),
      borderSide: const BorderSide(color: AppColors.red, width: 2),
    ),
    focusedErrorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(30),
      borderSide: const BorderSide(color: AppColors.red, width: 2),
    ),
  ),
  extensions: [
    MoodColors(
      frustrated: const Color(0xFFFFB3BA),
      terrible: const Color(0xFFFFCC80),
      anxious: const Color(0xFFFFF59D),
      neutral: const Color(0xFFA5D6A7),
      happy: const Color(0xFFCE93D8),
      excited: const Color(0xFFEF9A9A),
    ),
    StatusColors(
      success: AppColors.green50,
      warning: AppColors.orange40,
      error: AppColors.red,
      info: AppColors.primaryBlue,
    ),
    CardColors(
      journalCard: AppColors.cardLight,
      statsCard: AppColors.white,
      premiumCard: AppColors.purple10,
      shadow: const Color(0x0D000000),
    ),
    AppGradients(
      primaryGradient: const LinearGradient(
        colors: [AppColors.primaryBlue, AppColors.purple40],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
      premiumGradient: const LinearGradient(
        colors: [AppColors.accentPink, AppColors.orange40],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
      cardGradient: const LinearGradient(
        colors: [AppColors.white, AppColors.gray10],
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
      ),
    ),
    SplashColors(
      brandLogoBg: AppColors.splashCreamBg,
      progressLoadingBg: AppColors.splashDarkBg,
      progressLoadingOverlay: AppColors.splashDarkOverlay,
      fetchingDataBg: AppColors.splashGreenBg,
      quoteBg: AppColors.splashOrangeBg,
      brandLogoColor: AppColors.splashCreamBrand,
      progressLoadingText: AppColors.white,
      fetchingDataText: AppColors.white,
      quoteText: AppColors.white,
    ),
  ],
);
