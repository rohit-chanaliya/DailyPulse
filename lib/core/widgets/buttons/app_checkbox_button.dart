import 'package:flutter/material.dart';

import 'package:dailypulse/core/theme/context_extensions.dart';
import 'package:dailypulse/core/theme/typography/app_typography.dart';

/// Rounded option card with a status dot.
class AppCheckboxButton extends StatelessWidget {
  final String text;
  final bool isChecked;
  final ValueChanged<bool> onChanged;

  const AppCheckboxButton({
    super.key,
    required this.text,
    required this.isChecked,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final buttons = context.buttons;

    final bgColor = isChecked
        ? buttons.selectionBackground
        : buttons.surfaceBackground;
    final borderColor = isChecked
        ? buttons.selectionBackground
        : buttons.surfaceBorder;
    final textColor = isChecked
        ? buttons.onSelection
        : buttons.secondaryForeground;

    return Semantics(
      button: true,
      checked: isChecked,
      label: text,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () => onChanged(!isChecked),
        child: Container(
          height: 54,
          padding: const EdgeInsets.symmetric(horizontal: 20),
          decoration: BoxDecoration(
            color: bgColor,
            borderRadius: BorderRadius.circular(27),
            border: Border.all(color: borderColor, width: 1.2),
            boxShadow: [
              BoxShadow(
                color: context.cards.shadow,
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                text,
                style: AppTypography.textMdSemiBold.copyWith(color: textColor),
              ),
              Container(
                width: 22,
                height: 22,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: isChecked
                      ? buttons.onSelection.withValues(alpha: 0.2)
                      : Colors.transparent,
                  border: Border.all(
                    color: isChecked
                        ? buttons.onSelection
                        : buttons.mutedForeground,
                    width: 1.5,
                  ),
                ),
                child: isChecked
                    ? Icon(Icons.check, color: buttons.onSelection, size: 14)
                    : null,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
