import 'package:flutter/material.dart';

import 'package:dailypulse/core/theme/context_extensions.dart';
import 'package:dailypulse/core/theme/typography/app_typography.dart';

/// Rectangular tab button with a clean elevation shadow.
class AppTabButton extends StatelessWidget {
  final String text;
  final bool isSelected;
  final VoidCallback onPressed;

  const AppTabButton({
    super.key,
    required this.text,
    required this.isSelected,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    final buttons = context.buttons;

    final textColor = isSelected
        ? buttons.tabSelectedForeground
        : buttons.tabUnselectedForeground;

    return Semantics(
      button: true,
      selected: isSelected,
      label: text,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: onPressed,
        child: SizedBox(
          height: 48,
          child: Center(
            child: Container(
              height: 44,
              padding: const EdgeInsets.symmetric(horizontal: 24),
              decoration: isSelected
                  ? BoxDecoration(
                      color: buttons.surfaceBackground,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: context.cards.shadow,
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    )
                  : null,
              child: Center(
                child: Text(
                  text,
                  style: AppTypography.textSmBold.copyWith(
                    color: textColor,
                    fontWeight: isSelected ? FontWeight.w800 : FontWeight.w500,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
