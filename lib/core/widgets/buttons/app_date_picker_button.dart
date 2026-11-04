import 'package:flutter/material.dart';

import 'package:dailypulse/core/theme/context_extensions.dart';
import 'package:dailypulse/core/theme/typography/app_typography.dart';

/// Small selection pill for date pickers and filter headers.
class AppDatePickerButton extends StatelessWidget {
  final String text;
  final bool isSelected;
  final VoidCallback onPressed;

  const AppDatePickerButton({
    super.key,
    required this.text,
    required this.isSelected,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    final buttons = context.buttons;

    final bgColor = isSelected
        ? buttons.primaryBackground
        : buttons.secondaryBackground;
    final textColor = isSelected
        ? buttons.primaryForeground
        : buttons.mutedForeground;

    return SizedBox(
      height: 36,
      child: FilledButton(
        onPressed: onPressed,
        style: FilledButton.styleFrom(
          backgroundColor: bgColor,
          foregroundColor: textColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 16),
          elevation: 0,
        ),
        child: Text(
          text,
          style: AppTypography.textSmSemiBold.copyWith(color: textColor),
        ),
      ),
    );
  }
}
