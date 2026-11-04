import 'dart:async';

import 'package:flutter/material.dart';
import 'package:inject_annotation/inject_annotation.dart';
import 'package:signals_flutter/signals_flutter.dart';

import 'package:dailypulse/core/services/app_preferences.dart';

/// App-wide theme selection backed by a signal and persisted locally.
@singleton
class ThemeSignal {
  @inject
  ThemeSignal(this._preferences) {
    mode.value = _preferences.themeMode;
  }

  final AppPreferences _preferences;

  final mode = signal<ThemeMode>(ThemeMode.system);

  ThemeMode get themeMode => mode.value;
  bool get isDarkMode => mode.value == ThemeMode.dark;
  bool get isLightMode => mode.value == ThemeMode.light;
  bool get isSystemMode => mode.value == ThemeMode.system;

  void setThemeMode(ThemeMode value) {
    if (mode.value == value) return;
    mode.value = value;
    // Fire-and-forget: the write is local and must not block the UI switch.
    unawaited(_preferences.setThemeMode(value));
  }

  void toggleTheme(BuildContext context) {
    if (mode.value == ThemeMode.system) {
      final brightness = MediaQuery.platformBrightnessOf(context);
      setThemeMode(
        brightness == Brightness.dark ? ThemeMode.light : ThemeMode.dark,
      );
    } else {
      setThemeMode(
        mode.value == ThemeMode.light ? ThemeMode.dark : ThemeMode.light,
      );
    }
  }

  void setLightTheme() => setThemeMode(ThemeMode.light);
  void setDarkTheme() => setThemeMode(ThemeMode.dark);
  void setSystemTheme() => setThemeMode(ThemeMode.system);
}
