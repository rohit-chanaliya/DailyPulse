import 'package:flutter/material.dart';

import 'package:dailypulse/core/theme/context_extensions.dart';
import 'package:dailypulse/core/theme/typography/app_typography.dart';

/// Small chip widget with a left-aligned icon.
class AppPillButton extends StatelessWidget {
  final String text;
  final IconData icon;
  final bool isSelected;
  final VoidCallback onPressed;

  const AppPillButton({
    super.key,
    required this.text,
    required this.icon,
    required this.isSelected,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    final buttons = context.buttons;

    final bgColor = isSelected
        ? buttons.pillSelectedBackground
        : buttons.pillBackground;
    final borderColor = isSelected
        ? buttons.pillSelectedBorder
        : buttons.outlineMuted;
    final textColor = isSelected
        ? buttons.pillSelectedForeground
        : buttons.mutedForeground;

    return GestureDetector(
      onTap: onPressed,
      child: Container(
        height: 34,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(17),
          border: Border.all(color: borderColor, width: 1.2),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 14, color: textColor),
            const SizedBox(width: 6),
            Text(
              text,
              style: AppTypography.textXsBold.copyWith(color: textColor),
            ),
          ],
        ),
      ),
    );
  }
}
