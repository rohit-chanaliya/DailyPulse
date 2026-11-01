import 'package:flutter/material.dart';

import 'package:dailypulse/core/theme/context_extensions.dart';

/// One settings row: tinted icon box, title, optional subtitle and chevron.
class SettingsTile extends StatelessWidget {
  const SettingsTile({
    super.key,
    required this.icon,
    required this.iconBackground,
    required this.iconColor,
    required this.title,
    this.subtitle,
    this.onTap,
    this.isDestructive = false,
  });

  final IconData icon;
  final Color iconBackground;
  final Color iconColor;
  final String title;
  final String? subtitle;
  final VoidCallback? onTap;
  final bool isDestructive;

  @override
  Widget build(BuildContext context) {
    final home = context.home;
    final danger = context.status.error;
    final titleColor = isDestructive ? danger : home.textPrimary;

    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: isDestructive
                    ? danger.withValues(alpha: 0.15)
                    : iconBackground,
                borderRadius: BorderRadius.circular(14),
              ),
              child: Icon(
                icon,
                size: 24,
                color: isDestructive ? danger : iconColor,
              ),
            ),
            const SizedBox(width: 14),
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
            if (!isDestructive)
              Icon(Icons.chevron_right_rounded, color: home.textMuted),
          ],
        ),
      ),
    );
  }
}
