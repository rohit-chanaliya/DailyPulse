import 'package:flutter/material.dart';

import 'package:dailypulse/core/theme/context_extensions.dart';

/// Large screen title with a subtitle and a round action button.
class ScreenHeader extends StatelessWidget {
  const ScreenHeader({
    super.key,
    required this.title,
    required this.subtitle,
    this.actionIcon,
    this.actionTooltip,
    this.onActionPressed,
    this.actionLoading = false,
  });

  final String title;
  final String subtitle;
  final IconData? actionIcon;
  final String? actionTooltip;
  final VoidCallback? onActionPressed;
  final bool actionLoading;

  @override
  Widget build(BuildContext context) {
    final home = context.home;

    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: context.textTheme.displaySmall?.copyWith(
                  color: home.textPrimary,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                subtitle,
                style: context.textTheme.bodyLarge?.copyWith(
                  color: home.textSecondary,
                ),
              ),
            ],
          ),
        ),
        if (actionIcon != null) ...[
          const SizedBox(width: 16),
          IconButton(
            tooltip: actionTooltip,
            onPressed: actionLoading ? null : onActionPressed,
            style: IconButton.styleFrom(
              backgroundColor: home.headerSurface,
              fixedSize: const Size(64, 64),
              shape: const CircleBorder(),
            ),
            icon: actionLoading
                ? SizedBox.square(
                    dimension: 24,
                    child: CircularProgressIndicator(
                      strokeWidth: 2.5,
                      color: home.onMedia,
                    ),
                  )
                : Icon(actionIcon, color: home.onMedia, size: 26),
          ),
        ],
      ],
    );
  }
}
