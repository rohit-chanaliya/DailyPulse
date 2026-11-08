import 'package:flutter/material.dart';

import 'package:dailypulse/core/theme/context_extensions.dart';

/// Full-width stadium button with a label, trailing icon and loading state.
class AccentPillButton extends StatelessWidget {
  const AccentPillButton({
    super.key,
    required this.label,
    required this.icon,
    required this.onPressed,
    this.isLoading = false,
  });

  final String label;
  final IconData icon;

  /// `null` disables the button.
  final VoidCallback? onPressed;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    final home = context.home;

    return SizedBox(
      height: 64,
      child: ElevatedButton(
        onPressed: isLoading ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: home.accent,
          foregroundColor: home.onMedia,
          disabledBackgroundColor: home.accent.withValues(alpha: 0.4),
          elevation: 0,
          shape: const StadiumBorder(),
        ),
        child: isLoading
            ? SizedBox(
                width: 24,
                height: 24,
                child: CircularProgressIndicator(
                  strokeWidth: 2.5,
                  color: home.onMedia,
                ),
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                spacing: 12,
                children: [
                  Text(
                    label,
                    style: context.textTheme.headlineSmall?.copyWith(
                      color: home.onMedia,
                    ),
                  ),
                  Icon(icon, color: home.onMedia, size: 24),
                ],
              ),
      ),
    );
  }
}
