import 'package:flutter/material.dart';

/// Semantic colors for the shared button widgets.
///
/// Both themes are declared explicitly so the buttons never branch on
/// [Theme.brightness].
class ButtonColors extends ThemeExtension<ButtonColors> {
  const ButtonColors({
    required this.primaryBackground,
    required this.primaryForeground,
    required this.secondaryBackground,
    required this.secondaryForeground,
    required this.outlinePrimary,
    required this.outlineMuted,
    required this.mutedForeground,
    required this.surfaceBackground,
    required this.surfaceBorder,
    required this.selectionBackground,
    required this.onSelection,
    required this.toggleThumb,
    required this.accentBackground,
    required this.onAccent,
    required this.pillBackground,
    required this.pillSelectedBackground,
    required this.pillSelectedBorder,
    required this.pillSelectedForeground,
    required this.tabSelectedForeground,
    required this.tabUnselectedForeground,
  });

  final Color primaryBackground;
  final Color primaryForeground;
  final Color secondaryBackground;
  final Color secondaryForeground;
  final Color outlinePrimary;
  final Color outlineMuted;
  final Color mutedForeground;
  final Color surfaceBackground;
  final Color surfaceBorder;
  final Color selectionBackground;
  final Color onSelection;
  final Color toggleThumb;
  final Color accentBackground;
  final Color onAccent;
  final Color pillBackground;
  final Color pillSelectedBackground;
  final Color pillSelectedBorder;
  final Color pillSelectedForeground;
  final Color tabSelectedForeground;
  final Color tabUnselectedForeground;

  /// Soft brown surfaces used across the auth and home flows.
  static const ButtonColors light = ButtonColors(
    primaryBackground: Color(0xFF402B20),
    primaryForeground: Colors.white,
    secondaryBackground: Color(0xFFF5EFEB),
    secondaryForeground: Color(0xFF402B20),
    outlinePrimary: Color(0xFF402B20),
    outlineMuted: Color(0xFFEAE2DA),
    mutedForeground: Color(0xFF5A4535),
    surfaceBackground: Colors.white,
    surfaceBorder: Color(0xFFEAE2DA),
    selectionBackground: Color(0xFF98AF86),
    onSelection: Color(0xFF1F160F),
    toggleThumb: Colors.white,
    accentBackground: Color(0xFFFE814B),
    onAccent: Colors.white,
    pillBackground: Colors.white,
    pillSelectedBackground: Color(0xFFF2F5EB),
    pillSelectedBorder: Color(0xFF9BB068),
    pillSelectedForeground: Color(0xFF5A6B38),
    tabSelectedForeground: Color(0xFF402B20),
    tabUnselectedForeground: Color(0xFF6B6B6B),
  );

  static const ButtonColors dark = ButtonColors(
    primaryBackground: Color(0xFF402B20),
    primaryForeground: Colors.white,
    secondaryBackground: Color(0xFF2C221D),
    secondaryForeground: Colors.white,
    outlinePrimary: Color(0x4DFFFFFF),
    outlineMuted: Color(0xFF38302B),
    mutedForeground: Color(0xFFBDBDBD),
    surfaceBackground: Color(0xFF231E1B),
    surfaceBorder: Color(0xFF38302B),
    selectionBackground: Color(0xFF98AF86),
    onSelection: Color(0xFF1F160F),
    toggleThumb: Colors.white,
    accentBackground: Color(0xFFFE814B),
    onAccent: Colors.white,
    pillBackground: Color(0xFF1E1916),
    pillSelectedBackground: Color(0xFF2A3620),
    pillSelectedBorder: Color(0xFF9BB068),
    pillSelectedForeground: Color(0xFFCFD9B5),
    tabSelectedForeground: Colors.white,
    tabUnselectedForeground: Color(0xFF9E9E9E),
  );

  @override
  ButtonColors copyWith({
    Color? primaryBackground,
    Color? primaryForeground,
    Color? secondaryBackground,
    Color? secondaryForeground,
    Color? outlinePrimary,
    Color? outlineMuted,
    Color? mutedForeground,
    Color? surfaceBackground,
    Color? surfaceBorder,
    Color? selectionBackground,
    Color? onSelection,
    Color? toggleThumb,
    Color? accentBackground,
    Color? onAccent,
    Color? pillBackground,
    Color? pillSelectedBackground,
    Color? pillSelectedBorder,
    Color? pillSelectedForeground,
    Color? tabSelectedForeground,
    Color? tabUnselectedForeground,
  }) {
    return ButtonColors(
      primaryBackground: primaryBackground ?? this.primaryBackground,
      primaryForeground: primaryForeground ?? this.primaryForeground,
      secondaryBackground: secondaryBackground ?? this.secondaryBackground,
      secondaryForeground: secondaryForeground ?? this.secondaryForeground,
      outlinePrimary: outlinePrimary ?? this.outlinePrimary,
      outlineMuted: outlineMuted ?? this.outlineMuted,
      mutedForeground: mutedForeground ?? this.mutedForeground,
      surfaceBackground: surfaceBackground ?? this.surfaceBackground,
      surfaceBorder: surfaceBorder ?? this.surfaceBorder,
      selectionBackground: selectionBackground ?? this.selectionBackground,
      onSelection: onSelection ?? this.onSelection,
      toggleThumb: toggleThumb ?? this.toggleThumb,
      accentBackground: accentBackground ?? this.accentBackground,
      onAccent: onAccent ?? this.onAccent,
      pillBackground: pillBackground ?? this.pillBackground,
      pillSelectedBackground:
          pillSelectedBackground ?? this.pillSelectedBackground,
      pillSelectedBorder: pillSelectedBorder ?? this.pillSelectedBorder,
      pillSelectedForeground:
          pillSelectedForeground ?? this.pillSelectedForeground,
      tabSelectedForeground:
          tabSelectedForeground ?? this.tabSelectedForeground,
      tabUnselectedForeground:
          tabUnselectedForeground ?? this.tabUnselectedForeground,
    );
  }

  @override
  ButtonColors lerp(ThemeExtension<ButtonColors>? other, double t) {
    if (other is! ButtonColors) return this;
    Color lerpColor(Color a, Color b) => Color.lerp(a, b, t)!;
    return ButtonColors(
      primaryBackground: lerpColor(primaryBackground, other.primaryBackground),
      primaryForeground: lerpColor(primaryForeground, other.primaryForeground),
      secondaryBackground: lerpColor(
        secondaryBackground,
        other.secondaryBackground,
      ),
      secondaryForeground: lerpColor(
        secondaryForeground,
        other.secondaryForeground,
      ),
      outlinePrimary: lerpColor(outlinePrimary, other.outlinePrimary),
      outlineMuted: lerpColor(outlineMuted, other.outlineMuted),
      mutedForeground: lerpColor(mutedForeground, other.mutedForeground),
      surfaceBackground: lerpColor(surfaceBackground, other.surfaceBackground),
      surfaceBorder: lerpColor(surfaceBorder, other.surfaceBorder),
      selectionBackground: lerpColor(
        selectionBackground,
        other.selectionBackground,
      ),
      onSelection: lerpColor(onSelection, other.onSelection),
      toggleThumb: lerpColor(toggleThumb, other.toggleThumb),
      accentBackground: lerpColor(accentBackground, other.accentBackground),
      onAccent: lerpColor(onAccent, other.onAccent),
      pillBackground: lerpColor(pillBackground, other.pillBackground),
      pillSelectedBackground: lerpColor(
        pillSelectedBackground,
        other.pillSelectedBackground,
      ),
      pillSelectedBorder: lerpColor(
        pillSelectedBorder,
        other.pillSelectedBorder,
      ),
      pillSelectedForeground: lerpColor(
        pillSelectedForeground,
        other.pillSelectedForeground,
      ),
      tabSelectedForeground: lerpColor(
        tabSelectedForeground,
        other.tabSelectedForeground,
      ),
      tabUnselectedForeground: lerpColor(
        tabUnselectedForeground,
        other.tabUnselectedForeground,
      ),
    );
  }
}
