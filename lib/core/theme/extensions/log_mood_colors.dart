import 'package:flutter/material.dart';

/// Immersive palette of the mood-logging screen, one entry per mood level
/// (frustrated … excited). The screen is mood-tinted by design, so the same
/// palette is registered for both light and dark themes.
class LogMoodColors extends ThemeExtension<LogMoodColors> {
  const LogMoodColors({
    required this.backgrounds,
    required this.faces,
    required this.inactive,
    required this.onMood,
    required this.activeStop,
    required this.buttonSurface,
    required this.onButton,
  });

  final List<Color> backgrounds;
  final List<Color> faces;
  final List<Color> inactive;
  final Color onMood;
  final Color activeStop;
  final Color buttonSurface;
  final Color onButton;

  static const LogMoodColors immersive = LogMoodColors(
    backgrounds: [
      Color(0xFF4A1616),
      Color(0xFF1B1650),
      Color(0xFF552B1A),
      Color(0xFF3A2D28),
      Color(0xFF5A4A1E),
      Color(0xFF343D27),
    ],
    faces: [
      Color(0xFFC95555),
      Color(0xFF8A7FD6),
      Color(0xFFD56B4B),
      Color(0xFF8C6F60),
      Color(0xFFD9AE4F),
      Color(0xFF7F9160),
    ],
    inactive: [
      Color(0xFF8A2E2E),
      Color(0xFF3F31A8),
      Color(0xFF8F3F26),
      Color(0xFF5C4439),
      Color(0xFF8F7424),
      Color(0xFF566A3E),
    ],
    onMood: Color(0xFFE6E3EA),
    activeStop: Color(0xFFDEDEDE),
    buttonSurface: Color(0xFFD4D4D4),
    onButton: Color(0xFF1E1E1E),
  );

  @override
  LogMoodColors copyWith({
    List<Color>? backgrounds,
    List<Color>? faces,
    List<Color>? inactive,
    Color? onMood,
    Color? activeStop,
    Color? buttonSurface,
    Color? onButton,
  }) {
    return LogMoodColors(
      backgrounds: backgrounds ?? this.backgrounds,
      faces: faces ?? this.faces,
      inactive: inactive ?? this.inactive,
      onMood: onMood ?? this.onMood,
      activeStop: activeStop ?? this.activeStop,
      buttonSurface: buttonSurface ?? this.buttonSurface,
      onButton: onButton ?? this.onButton,
    );
  }

  @override
  LogMoodColors lerp(ThemeExtension<LogMoodColors>? other, double t) {
    if (other is! LogMoodColors) return this;
    List<Color> mix(List<Color> a, List<Color> b) => [
      for (var i = 0; i < a.length; i++) Color.lerp(a[i], b[i], t)!,
    ];
    return LogMoodColors(
      backgrounds: mix(backgrounds, other.backgrounds),
      faces: mix(faces, other.faces),
      inactive: mix(inactive, other.inactive),
      onMood: Color.lerp(onMood, other.onMood, t)!,
      activeStop: Color.lerp(activeStop, other.activeStop, t)!,
      buttonSurface: Color.lerp(buttonSurface, other.buttonSurface, t)!,
      onButton: Color.lerp(onButton, other.onButton, t)!,
    );
  }
}
