import 'package:flutter/material.dart';

import 'package:dailypulse/core/constant/strings/settings_strings.dart';
import 'package:dailypulse/core/theme/context_extensions.dart';

/// Light / Dark / System choice as a segmented pill.
class ThemeSelector extends StatelessWidget {
  const ThemeSelector({
    super.key,
    required this.isLightMode,
    required this.isDarkMode,
    required this.isSystemMode,
    required this.onLightMode,
    required this.onDarkMode,
    required this.onSystemMode,
  });

  final bool isLightMode;
  final bool isDarkMode;
  final bool isSystemMode;
  final VoidCallback onLightMode;
  final VoidCallback onDarkMode;
  final VoidCallback onSystemMode;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: context.home.searchSurface.withValues(alpha: 0.35),
        borderRadius: BorderRadius.circular(28),
      ),
      child: Row(
        children: [
          _ThemePill(
            icon: Icons.light_mode_outlined,
            label: SettingsStrings.themeLight,
            selected: isLightMode,
            onTap: onLightMode,
          ),
          _ThemePill(
            icon: Icons.dark_mode_outlined,
            label: SettingsStrings.themeDark,
            selected: isDarkMode,
            onTap: onDarkMode,
          ),
          _ThemePill(
            icon: Icons.brightness_auto_outlined,
            label: SettingsStrings.themeSystem,
            selected: isSystemMode,
            onTap: onSystemMode,
          ),
        ],
      ),
    );
  }
}

class _ThemePill extends StatelessWidget {
  const _ThemePill({
    required this.icon,
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final home = context.home;
    final color = selected ? home.onMedia : home.textPrimary;

    return Expanded(
      child: Semantics(
        button: true,
        selected: selected,
        label: label,
        child: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: onTap,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            height: 48,
            decoration: BoxDecoration(
              color: selected ? home.accent : Colors.transparent,
              borderRadius: BorderRadius.circular(24),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(icon, size: 20, color: color),
                const SizedBox(width: 6),
                Text(
                  label,
                  style: context.textTheme.labelLarge?.copyWith(color: color),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
