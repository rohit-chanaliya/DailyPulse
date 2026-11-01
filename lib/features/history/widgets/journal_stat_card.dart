import 'package:flutter/material.dart';

import 'package:dailypulse/core/theme/context_extensions.dart';

/// Small stat tile: tinted icon box, a bold value and a caption.
class JournalStatCard extends StatelessWidget {
  const JournalStatCard({
    super.key,
    required this.icon,
    required this.iconBackground,
    required this.iconColor,
    required this.value,
    required this.caption,
  });

  final Widget icon;
  final Color iconBackground;
  final Color iconColor;
  final String value;
  final String caption;

  @override
  Widget build(BuildContext context) {
    final home = context.home;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: home.surface,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: iconBackground,
              borderRadius: BorderRadius.circular(14),
            ),
            child: IconTheme(
              data: IconThemeData(color: iconColor, size: 24),
              child: icon,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  value,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: context.textTheme.headlineMedium?.copyWith(
                    color: home.textPrimary,
                  ),
                ),
                Text(
                  caption,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: context.textTheme.bodySmall?.copyWith(
                    color: home.textSecondary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
