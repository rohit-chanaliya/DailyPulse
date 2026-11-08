import 'package:flutter/material.dart';
import 'dark_theme.dart';

export 'colors/app_colors.dart';
export 'typography/app_typography.dart';
export 'extensions/mood_colors.dart';
export 'extensions/status_colors.dart';
export 'extensions/card_colors.dart';
export 'extensions/app_gradients.dart';
export 'extensions/splash_colors.dart';
export 'extensions/onboarding_colors.dart';
export 'extensions/button_colors.dart';
export 'context_extensions.dart';

class AppTheme {
  static ThemeData get darkTheme => darkThemeData;
}

// Map the variables to avoid renaming them across the main entry
ThemeData get darkThemeData => darkTheme;
