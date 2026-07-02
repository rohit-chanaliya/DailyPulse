import 'package:flutter/material.dart';
import 'light_theme.dart';
import 'dark_theme.dart';

export 'colors/app_colors.dart';
export 'typography/app_typography.dart';
export 'extensions/mood_colors.dart';
export 'extensions/status_colors.dart';
export 'extensions/card_colors.dart';
export 'extensions/app_gradients.dart';
export 'extensions/splash_colors.dart';
export 'context_extensions.dart';

class AppTheme {
  static ThemeData get lightTheme => lightThemeData;
  static ThemeData get darkTheme => darkThemeData;

  // Backward compatibility static color references
  @Deprecated('Use context.colors.primary instead')
  static const Color primaryBlue = Color(0xFF5C49E1);
  @Deprecated('Use context.colors.secondary instead')
  static const Color accentPink = Color(0xFFFF4D8D);
  @Deprecated('Use context.colors.surface instead')
  static const Color backgroundLight = Color(0xFFF7F8FA);
  @Deprecated('Use context.cards.journalCard instead')
  static const Color cardBackground = Colors.white;
}

// Map the variables to avoid renaming them across the main entry
ThemeData get lightThemeData => lightTheme;
ThemeData get darkThemeData => darkTheme;
