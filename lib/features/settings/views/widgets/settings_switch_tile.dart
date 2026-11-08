import 'package:flutter/material.dart';

import 'package:dailypulse/core/theme/context_extensions.dart';
import 'package:dailypulse/features/settings/views/widgets/settings_switch.dart';

/// Card row with a title, optional description and a trailing switch.
class SettingsSwitchTile extends StatelessWidget {
  const SettingsSwitchTile({
    super.key,
    required this.title,
    required this.value,
    required this.onChanged,
    this.description,
  });

  final String title;
  final String? description;
  final bool value;
  final ValueChanged<bool>? onChanged;

  @override
  Widget build(BuildContext context) {
    final home = context.home;

    return Material(
      color: home.surface,
      borderRadius: BorderRadius.circular(24),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onChanged == null ? null : () => onChanged!(!value),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            spacing: 12,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  spacing: 4,
                  children: [
                    Text(
                      title,
                      style: context.textTheme.titleLarge?.copyWith(
                        color: home.textPrimary,
                      ),
                    ),
                    if (description != null)
                      Text(
                        description!,
                        style: context.textTheme.bodySmall?.copyWith(
                          color: home.textSecondary,
                        ),
                      ),
                  ],
                ),
              ),
              SettingsSwitch(value: value, onChanged: onChanged),
            ],
          ),
        ),
      ),
    );
  }
}
