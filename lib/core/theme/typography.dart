import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// The Typography System for DailyPulse based on the Urbanist font family.
class AppTypography {
  // Base Urbanist Style Helper
  static TextStyle _urbanist({
    required double fontSize,
    required FontWeight fontWeight,
    double? letterSpacing,
    double? height,
  }) {
    return GoogleFonts.urbanist(
      fontSize: fontSize,
      fontWeight: fontWeight,
      letterSpacing: letterSpacing,
      height: height,
    );
  }

  // --- DISPLAY STYLES ---
  static TextStyle get displayLgExtraBold => _urbanist(fontSize: 56, fontWeight: FontWeight.w800, letterSpacing: -1.5, height: 1.1);
  static TextStyle get displayLgBold => _urbanist(fontSize: 56, fontWeight: FontWeight.w700, letterSpacing: -1.5, height: 1.1);
  
  static TextStyle get displayMdExtraBold => _urbanist(fontSize: 40, fontWeight: FontWeight.w800, letterSpacing: -1.0, height: 1.15);
  static TextStyle get displayMdBold => _urbanist(fontSize: 40, fontWeight: FontWeight.w700, letterSpacing: -1.0, height: 1.15);

  static TextStyle get displaySmExtraBold => _urbanist(fontSize: 32, fontWeight: FontWeight.w800, letterSpacing: -0.5, height: 1.2);
  static TextStyle get displaySmBold => _urbanist(fontSize: 32, fontWeight: FontWeight.w700, letterSpacing: -0.5, height: 1.2);

  // --- HEADING STYLES ---
  static TextStyle get heading2xlBold => _urbanist(fontSize: 24, fontWeight: FontWeight.w700, height: 1.25);
  static TextStyle get heading2xlSemiBold => _urbanist(fontSize: 24, fontWeight: FontWeight.w600, height: 1.25);
  static TextStyle get heading2xlMedium => _urbanist(fontSize: 24, fontWeight: FontWeight.w500, height: 1.25);

  static TextStyle get headingXlBold => _urbanist(fontSize: 20, fontWeight: FontWeight.w700, height: 1.3);
  static TextStyle get headingXlSemiBold => _urbanist(fontSize: 20, fontWeight: FontWeight.w600, height: 1.3);
  static TextStyle get headingXlMedium => _urbanist(fontSize: 20, fontWeight: FontWeight.w500, height: 1.3);

  static TextStyle get headingLgBold => _urbanist(fontSize: 18, fontWeight: FontWeight.w700, height: 1.35);
  static TextStyle get headingLgSemiBold => _urbanist(fontSize: 18, fontWeight: FontWeight.w600, height: 1.35);
  static TextStyle get headingLgMedium => _urbanist(fontSize: 18, fontWeight: FontWeight.w500, height: 1.35);

  static TextStyle get headingMdBold => _urbanist(fontSize: 16, fontWeight: FontWeight.w700, height: 1.4);
  static TextStyle get headingMdSemiBold => _urbanist(fontSize: 16, fontWeight: FontWeight.w600, height: 1.4);
  static TextStyle get headingMdMedium => _urbanist(fontSize: 16, fontWeight: FontWeight.w500, height: 1.4);

  static TextStyle get headingSmBold => _urbanist(fontSize: 14, fontWeight: FontWeight.w700, height: 1.4);
  static TextStyle get headingSmSemiBold => _urbanist(fontSize: 14, fontWeight: FontWeight.w600, height: 1.4);
  static TextStyle get headingSmMedium => _urbanist(fontSize: 14, fontWeight: FontWeight.w500, height: 1.4);

  static TextStyle get headingXsBold => _urbanist(fontSize: 12, fontWeight: FontWeight.w700, height: 1.4);
  static TextStyle get headingXsSemiBold => _urbanist(fontSize: 12, fontWeight: FontWeight.w600, height: 1.4);
  static TextStyle get headingXsMedium => _urbanist(fontSize: 12, fontWeight: FontWeight.w500, height: 1.4);

  // --- TEXT STYLES ---
  static TextStyle get text2xlBold => _urbanist(fontSize: 24, fontWeight: FontWeight.w700);
  static TextStyle get text2xlSemiBold => _urbanist(fontSize: 24, fontWeight: FontWeight.w600);
  static TextStyle get text2xlMedium => _urbanist(fontSize: 24, fontWeight: FontWeight.w500);

  static TextStyle get textXlBold => _urbanist(fontSize: 20, fontWeight: FontWeight.w700);
  static TextStyle get textXlSemiBold => _urbanist(fontSize: 20, fontWeight: FontWeight.w600);
  static TextStyle get textXlMedium => _urbanist(fontSize: 20, fontWeight: FontWeight.w500);

  static TextStyle get textLgBold => _urbanist(fontSize: 18, fontWeight: FontWeight.w700);
  static TextStyle get textLgSemiBold => _urbanist(fontSize: 18, fontWeight: FontWeight.w600);
  static TextStyle get textLgMedium => _urbanist(fontSize: 18, fontWeight: FontWeight.w500);

  static TextStyle get textMdBold => _urbanist(fontSize: 16, fontWeight: FontWeight.w700);
  static TextStyle get textMdSemiBold => _urbanist(fontSize: 16, fontWeight: FontWeight.w600);
  static TextStyle get textMdMedium => _urbanist(fontSize: 16, fontWeight: FontWeight.w500);

  static TextStyle get textSmBold => _urbanist(fontSize: 14, fontWeight: FontWeight.w700);
  static TextStyle get textSmSemiBold => _urbanist(fontSize: 14, fontWeight: FontWeight.w600);
  static TextStyle get textSmMedium => _urbanist(fontSize: 14, fontWeight: FontWeight.w500);

  static TextStyle get textXsBold => _urbanist(fontSize: 12, fontWeight: FontWeight.w700);
  static TextStyle get textXsSemiBold => _urbanist(fontSize: 12, fontWeight: FontWeight.w600);
  static TextStyle get textXsMedium => _urbanist(fontSize: 12, fontWeight: FontWeight.w500);

  static TextStyle get text2xsBold => _urbanist(fontSize: 10, fontWeight: FontWeight.w700);
  static TextStyle get text2xsSemiBold => _urbanist(fontSize: 10, fontWeight: FontWeight.w600);
  static TextStyle get text2xsMedium => _urbanist(fontSize: 10, fontWeight: FontWeight.w500);

  // --- PARAGRAPH STYLES ---
  static TextStyle get paragraph2xl => _urbanist(fontSize: 24, fontWeight: FontWeight.w400, height: 1.55);
  static TextStyle get paragraphXl => _urbanist(fontSize: 20, fontWeight: FontWeight.w400, height: 1.55);
  static TextStyle get paragraphLg => _urbanist(fontSize: 18, fontWeight: FontWeight.w400, height: 1.55);
  static TextStyle get paragraphMd => _urbanist(fontSize: 16, fontWeight: FontWeight.w400, height: 1.55);
  static TextStyle get paragraphSm => _urbanist(fontSize: 14, fontWeight: FontWeight.w400, height: 1.55);
  static TextStyle get paragraphXs => _urbanist(fontSize: 12, fontWeight: FontWeight.w400, height: 1.55);

  // --- LABEL STYLES ---
  static TextStyle get label2xl => _urbanist(fontSize: 24, fontWeight: FontWeight.w600, letterSpacing: 0.5);
  static TextStyle get labelXl => _urbanist(fontSize: 20, fontWeight: FontWeight.w600, letterSpacing: 0.5);
  static TextStyle get labelLg => _urbanist(fontSize: 18, fontWeight: FontWeight.w600, letterSpacing: 0.5);
  static TextStyle get labelMd => _urbanist(fontSize: 16, fontWeight: FontWeight.w600, letterSpacing: 0.5);
  static TextStyle get labelSm => _urbanist(fontSize: 14, fontWeight: FontWeight.w600, letterSpacing: 0.5);
  static TextStyle get labelXs => _urbanist(fontSize: 12, fontWeight: FontWeight.w600, letterSpacing: 0.5);

  /// Helper to convert the typography system to a Material 3 TextTheme.
  static TextTheme get textTheme {
    return TextTheme(
      displayLarge: displayLgBold,
      displayMedium: displayMdBold,
      displaySmall: displaySmBold,
      headlineLarge: heading2xlBold,
      headlineMedium: headingXlBold,
      headlineSmall: headingLgBold,
      titleLarge: headingMdBold,
      titleMedium: headingSmBold,
      titleSmall: headingXsBold,
      bodyLarge: paragraphLg,
      bodyMedium: paragraphMd,
      bodySmall: paragraphSm,
      labelLarge: labelMd,
      labelMedium: labelSm,
      labelSmall: labelXs,
    );
  }
}
