import 'package:flutter/material.dart';

/// Semantic colors used by the Freud-inspired home dashboard.
class HomeColors extends ThemeExtension<HomeColors> {
  const HomeColors({
    required this.background,
    required this.surface,
    required this.headerSurface,
    required this.searchSurface,
    required this.textPrimary,
    required this.textSecondary,
    required this.textMuted,
    required this.accent,
    required this.green,
    required this.greenDark,
    required this.greenLight,
    required this.greenPale,
    required this.orange,
    required this.orangeDark,
    required this.orangeLight,
    required this.orangePale,
    required this.purple,
    required this.purpleDark,
    required this.purpleLight,
    required this.purplePale,
    required this.yellow,
    required this.yellowDark,
    required this.onMedia,
  });

  final Color background;
  final Color surface;
  final Color headerSurface;
  final Color searchSurface;
  final Color textPrimary;
  final Color textSecondary;
  final Color textMuted;
  final Color accent;
  final Color green;
  final Color greenDark;
  final Color greenLight;
  final Color greenPale;
  final Color orange;
  final Color orangeDark;
  final Color orangeLight;
  final Color orangePale;
  final Color purple;
  final Color purpleDark;
  final Color purpleLight;
  final Color purplePale;
  final Color yellow;
  final Color yellowDark;
  final Color onMedia;

  @override
  HomeColors copyWith({
    Color? background,
    Color? surface,
    Color? headerSurface,
    Color? searchSurface,
    Color? textPrimary,
    Color? textSecondary,
    Color? textMuted,
    Color? accent,
    Color? green,
    Color? greenDark,
    Color? greenLight,
    Color? greenPale,
    Color? orange,
    Color? orangeDark,
    Color? orangeLight,
    Color? orangePale,
    Color? purple,
    Color? purpleDark,
    Color? purpleLight,
    Color? purplePale,
    Color? yellow,
    Color? yellowDark,
    Color? onMedia,
  }) {
    return HomeColors(
      background: background ?? this.background,
      surface: surface ?? this.surface,
      headerSurface: headerSurface ?? this.headerSurface,
      searchSurface: searchSurface ?? this.searchSurface,
      textPrimary: textPrimary ?? this.textPrimary,
      textSecondary: textSecondary ?? this.textSecondary,
      textMuted: textMuted ?? this.textMuted,
      accent: accent ?? this.accent,
      green: green ?? this.green,
      greenDark: greenDark ?? this.greenDark,
      greenLight: greenLight ?? this.greenLight,
      greenPale: greenPale ?? this.greenPale,
      orange: orange ?? this.orange,
      orangeDark: orangeDark ?? this.orangeDark,
      orangeLight: orangeLight ?? this.orangeLight,
      orangePale: orangePale ?? this.orangePale,
      purple: purple ?? this.purple,
      purpleDark: purpleDark ?? this.purpleDark,
      purpleLight: purpleLight ?? this.purpleLight,
      purplePale: purplePale ?? this.purplePale,
      yellow: yellow ?? this.yellow,
      yellowDark: yellowDark ?? this.yellowDark,
      onMedia: onMedia ?? this.onMedia,
    );
  }

  @override
  HomeColors lerp(ThemeExtension<HomeColors>? other, double t) {
    if (other is! HomeColors) return this;
    Color lerpColor(Color a, Color b) => Color.lerp(a, b, t)!;
    return HomeColors(
      background: lerpColor(background, other.background),
      surface: lerpColor(surface, other.surface),
      headerSurface: lerpColor(headerSurface, other.headerSurface),
      searchSurface: lerpColor(searchSurface, other.searchSurface),
      textPrimary: lerpColor(textPrimary, other.textPrimary),
      textSecondary: lerpColor(textSecondary, other.textSecondary),
      textMuted: lerpColor(textMuted, other.textMuted),
      accent: lerpColor(accent, other.accent),
      green: lerpColor(green, other.green),
      greenDark: lerpColor(greenDark, other.greenDark),
      greenLight: lerpColor(greenLight, other.greenLight),
      greenPale: lerpColor(greenPale, other.greenPale),
      orange: lerpColor(orange, other.orange),
      orangeDark: lerpColor(orangeDark, other.orangeDark),
      orangeLight: lerpColor(orangeLight, other.orangeLight),
      orangePale: lerpColor(orangePale, other.orangePale),
      purple: lerpColor(purple, other.purple),
      purpleDark: lerpColor(purpleDark, other.purpleDark),
      purpleLight: lerpColor(purpleLight, other.purpleLight),
      purplePale: lerpColor(purplePale, other.purplePale),
      yellow: lerpColor(yellow, other.yellow),
      yellowDark: lerpColor(yellowDark, other.yellowDark),
      onMedia: lerpColor(onMedia, other.onMedia),
    );
  }
}
