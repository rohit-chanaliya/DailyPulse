import 'package:flutter/material.dart';

import 'package:dailypulse/core/theme/context_extensions.dart';

/// One settings row: icon box, title, optional subtitle, value and trailing.
class SettingsTile extends StatelessWidget {
  const SettingsTile({
    super.key,
    required this.icon,
    required this.title,
    this.subtitle,
    this.value,
    this.trailing,
    this.onTap,
    this.isDestructive = false,
  });

  final IconData icon;
  final String title;
  final String? subtitle;

  /// Short current value shown before the trailing widget.
  final String? value;

  /// Replaces the default chevron (e.g. a [Switch]).
  final Widget? trailing;
  final VoidCallback? onTap;
  final bool isDestructive;

  @override
  Widget build(BuildContext context) {
    final home = context.home;
    final titleColor = isDestructive ? home.orange : home.textPrimary;

    return Material(
      color: isDestructive ? home.orangeDark : home.surface,
      borderRadius: BorderRadius.circular(24),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: isDestructive ? home.orange : home.headerSurface,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  icon,
                  size: 24,
                  color: isDestructive ? home.orangeDark : home.onMedia,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: context.textTheme.titleLarge?.copyWith(
                        color: titleColor,
                      ),
                    ),
                    if (subtitle != null)
                      Text(
                        subtitle!,
                        style: context.textTheme.bodySmall?.copyWith(
                          color: home.textMuted,
                        ),
                      ),
                  ],
                ),
              ),
              if (value != null) ...[
                const SizedBox(width: 8),
                Text(
                  value!,
                  style: context.textTheme.labelMedium?.copyWith(
                    color: home.textSecondary,
                  ),
                ),
              ],
              const SizedBox(width: 8),
              trailing ??
                  Icon(
                    Icons.chevron_right_rounded,
                    color: isDestructive ? home.orange : home.textMuted,
                  ),
            ],
          ),
        ),
      ),
    );
  }
}
