import 'package:flutter/material.dart';

import 'package:dailypulse/core/theme/context_extensions.dart';

enum AppIconButtonSize { xl, large, medium, small, xs }

/// Circular FAB-style button in the brand accent color.
class AppIconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onPressed;
  final AppIconButtonSize size;

  const AppIconButton({
    super.key,
    required this.icon,
    required this.onPressed,
    this.size = AppIconButtonSize.large,
  });

  @override
  Widget build(BuildContext context) {
    final buttons = context.buttons;

    final (diameter, iconSize) = switch (size) {
      AppIconButtonSize.xl => (64.0, 28.0),
      AppIconButtonSize.large => (56.0, 24.0),
      AppIconButtonSize.medium => (48.0, 20.0),
      AppIconButtonSize.small => (40.0, 18.0),
      AppIconButtonSize.xs => (32.0, 14.0),
    };

    return SizedBox(
      width: diameter,
      height: diameter,
      child: IconButton(
        onPressed: onPressed,
        style: IconButton.styleFrom(
          backgroundColor: buttons.accentBackground,
          foregroundColor: buttons.onAccent,
          shape: const CircleBorder(),
          padding: EdgeInsets.zero,
        ),
        icon: Icon(icon, size: iconSize, color: buttons.onAccent),
      ),
    );
  }
}
