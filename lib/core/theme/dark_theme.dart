import 'package:flutter/material.dart';
import 'colors/app_colors.dart';
import 'typography/app_typography.dart';
import 'extensions/mood_colors.dart';
import 'extensions/status_colors.dart';
import 'extensions/card_colors.dart';
import 'extensions/app_gradients.dart';
import 'extensions/splash_colors.dart';

final ThemeData darkTheme = ThemeData(
  useMaterial3: true,
  brightness: Brightness.dark,
  scaffoldBackgroundColor: AppColors.backgroundDark,
  colorScheme: ColorScheme.fromSeed(
    seedColor: AppColors.primaryBlue,
    primary: AppColors.primaryBlue,
    secondary: AppColors.accentPink,
    brightness: Brightness.dark,
    surface: AppColors.surfaceDark,
  ),
  textTheme: AppTypography.textTheme,
  appBarTheme: const AppBarTheme(
    backgroundColor: AppColors.transparent,
    elevation: 0,
    centerTitle: true,
    titleTextStyle: TextStyle(
      fontSize: 20,
      fontWeight: FontWeight.w600,
      color: AppColors.white,
    ),
    iconTheme: IconThemeData(color: AppColors.white),
  ),
  navigationBarTheme: const NavigationBarThemeData(
    backgroundColor: AppColors.surfaceDark,
    elevation: 0,
    indicatorColor: AppColors.transparent,
    labelTextStyle: WidgetStatePropertyAll(
      TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w500,
      ),
    ),
  ),
  cardTheme: const CardThemeData(
    color: AppColors.cardDark,
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
    fillColor: AppColors.cardDark,
    hintStyle: AppTypography.textMdMedium.copyWith(color: AppColors.grey500),
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
      frustrated: const Color(0xFFEF9A9A),
      terrible: const Color(0xFFFFB74D),
      anxious: const Color(0xFFFFF176),
      neutral: const Color(0xFF81C784),
      happy: const Color(0xFFBA68C8),
      excited: const Color(0xFFE57373),
    ),
    StatusColors(
      success: AppColors.green40,
      warning: AppColors.orange30,
      error: AppColors.red,
      info: AppColors.primaryBlue,
    ),
    CardColors(
      journalCard: AppColors.cardDark,
      statsCard: AppColors.surfaceDark,
      premiumCard: AppColors.purple90,
      shadow: const Color(0x1F000000),
    ),
    AppGradients(
      primaryGradient: const LinearGradient(
        colors: [AppColors.primaryBlue, AppColors.purple60],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
      premiumGradient: const LinearGradient(
        colors: [AppColors.accentPink, AppColors.orange60],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
      cardGradient: const LinearGradient(
        colors: [AppColors.cardDark, AppColors.surfaceDark],
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
      ),
    ),
    SplashColors(
      brandLogoBg: AppColors.splashDarkBg,
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
