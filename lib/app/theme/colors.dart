import 'package:flutter/material.dart';

/// The Color Palette for the DailyPulse application.
/// Contains both core semantic mapping and the complete design token swatches.
class AppColors {
  // --- CORE SEMANTIC THEME COLORS ---
  static const Color primaryBlue = Color(0xFF5C49E1); // Deep purple/blue primary
  static const Color accentPink = Color(0xFFFF4D8D);  // Pink accent color
  
  // Light Mode Backgrounds & Surfaces
  static const Color backgroundLight = Color(0xFFF7F8FA);
  static const Color cardLight = Colors.white;
  static const Color textLightPrimary = Colors.black87;

  // Dark Mode Backgrounds & Surfaces
  static const Color backgroundDark = Color(0xFF121212);
  static const Color cardDark = Color(0xFF2C2C2C);
  static const Color surfaceDark = Color(0xFF1E1E1E);

  // --- SPLASH & AUTH FLOW SEMANTIC COLORS ---
  static const Color splashCreamBg = Color(0xFFFAF8F5);      // Soft cream background
  static const Color splashCreamBrand = Color(0xFF8D5B4C);   // Terracotta brown logo/text

  static const Color splashDarkBg = Color(0xFF161210);       // Dark charcoal/brown background
  static const Color splashDarkOverlay = Color(0xFF2C221D);  // Lighter brown overlay circles

  static const Color splashGreenBg = Color(0xFF98AF86);      // Sage green background
  static const Color splashOrangeBg = Color(0xFFDF8353);     // Terracotta orange background


  // ==========================================
  // --- COMPLETE DESIGN TOKEN COLOR PALETTE ---
  // ==========================================

  // --- MINDFUL BROWN ---
  // Opacity variants of Brown 100 (#1F160F)
  static const Color brown100A64 = Color(0xA31F160F); // 64% Opacity
  static const Color brown100A48 = Color(0x7A1F160F); // 48% Opacity
  static const Color brown100A32 = Color(0x521F160F); // 32% Opacity
  
  static const Color brown100 = Color(0xFF1F160F);
  static const Color brown90 = Color(0xFF332419);
  static const Color brown80 = Color(0xFF4B3425);
  static const Color brown70 = Color(0xFF6D4B36);
  static const Color brown60 = Color(0xFF926247);
  static const Color brown50 = Color(0xFFAC836C);
  static const Color brown40 = Color(0xFFBDA193);
  static const Color brown30 = Color(0xFFD5C2B9);
  static const Color brown20 = Color(0xFFE8DDD9);
  static const Color brownGray10 = Color(0xFFF7F4F2); // Gray 10 under Mindful Brown

  // --- OPTIMISTIC GRAY ---
  static const Color gray100 = Color(0xFF121619);
  static const Color gray90 = Color(0xFF21262A);
  static const Color gray80 = Color(0xFF343A3F);
  static const Color gray70 = Color(0xFF4D5358);
  static const Color gray60 = Color(0xFF697077);
  static const Color gray50 = Color(0xFF878E96);
  static const Color gray40 = Color(0xFFA2A9B0);
  static const Color gray30 = Color(0xFFC1C6CD);
  static const Color gray20 = Color(0xFFDDE1E6);
  static const Color gray10 = Color(0xFFF2F5FB);

  // --- SERENITY GREEN ---
  static const Color green100 = Color(0xFF191E10);
  static const Color green90 = Color(0xFF29321A);
  static const Color green80 = Color(0xFF3D4A26);
  static const Color green70 = Color(0xFF5A6B38);
  static const Color green60 = Color(0xFF7D944D);
  static const Color green50 = Color(0xFF9BB068);
  static const Color green40 = Color(0xFFB4C48D);
  static const Color green30 = Color(0xFFCFD9B5);
  static const Color green20 = Color(0xFFE5EAD7);
  static const Color green10 = Color(0xFFF2F5EB);

  // --- EMPATHY ORANGE ---
  static const Color orange100 = Color(0xFF2E1200);
  static const Color orange90 = Color(0xFF4C1D00);
  static const Color orange80 = Color(0xFF702901);
  static const Color orange70 = Color(0xFFA23901);
  static const Color orange60 = Color(0xFFDF4B01);
  static const Color orange50 = Color(0xFFFE631B);
  static const Color orange40 = Color(0xFFFE814B);
  static const Color orange30 = Color(0xFFFEAF8F);
  static const Color orange20 = Color(0xFFFFD2C2);
  static const Color orange10 = Color(0xFFFFF0EB);

  // --- ZEN YELLOW ---
  static const Color yellow100 = Color(0xFF2E2500);
  static const Color yellow90 = Color(0xFF4D3C00);
  static const Color yellow80 = Color(0xFF705600);
  static const Color yellow70 = Color(0xFFA37A00);
  static const Color yellow60 = Color(0xFFE0A500);
  static const Color yellow50 = Color(0xFFFFCE5C);
  static const Color yellow40 = Color(0xFFFFCE5C); // Shared token code in design spec sheet
  static const Color yellow30 = Color(0xFFFFD88F);
  static const Color yellow20 = Color(0xFFFFEBC2);
  static const Color yellow10 = Color(0xFFFFF4E0);

  // --- GENTLE PURPLE ---
  static const Color purple100 = Color(0xFF0D002E);
  static const Color purple90 = Color(0xFF14004D);
  static const Color purple80 = Color(0xFF1C0070);
  static const Color purple70 = Color(0xFF2F1093);
  static const Color purple60 = Color(0xFF3D16CA);
  static const Color purple50 = Color(0xFF5530E8);
  static const Color purple40 = Color(0xFF7152FF);
  static const Color purple30 = Color(0xFFA18FFF);
  static const Color purple20 = Color(0xFFCBC2FF);
  static const Color purple10 = Color(0xFFEDE8FF);
}
