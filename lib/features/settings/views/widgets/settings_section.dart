import 'package:flutter/material.dart';

import 'package:dailypulse/core/theme/context_extensions.dart';

/// Section title (with optional trailing icon) above a stack of [children].
class SettingsSection extends StatelessWidget {
  const SettingsSection({
    super.key,
    required this.title,
    required this.children,
    this.trailingIcon,
    this.trailingIconColor,
  });

  final String title;
  final List<Widget> children;
  final IconData? trailingIcon;
  final Color? trailingIconColor;

  @override
  Widget build(BuildContext context) {
    final home = context.home;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 8,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 4),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  title,
                  style: context.textTheme.headlineSmall?.copyWith(
                    color: home.textPrimary,
                  ),
                ),
              ),
              if (trailingIcon != null)
                Icon(
                  trailingIcon,
                  size: 24,
                  color: trailingIconColor ?? home.textMuted,
                ),
            ],
          ),
        ),
        ...children,
      ],
    );
  }
}
