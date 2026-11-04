import 'package:flutter/material.dart';

import 'package:dailypulse/core/theme/context_extensions.dart';
import 'package:dailypulse/core/theme/typography/app_typography.dart';

enum AppButtonVariant {
  primary,
  outlinedPrimary,
  secondary,
  outlinedSecondary,
  inline,
}

enum AppButtonSize { large, medium, small, xs }

/// The primary workhorse button of the application.
class AppButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final AppButtonVariant variant;
  final AppButtonSize size;
  final IconData? suffixIcon;
  final bool isLoading;

  const AppButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.variant = AppButtonVariant.primary,
    this.size = AppButtonSize.large,
    this.suffixIcon,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    final buttons = context.buttons;

    final (height, fontSize, paddingHorizontal, borderRadius) = switch (size) {
      AppButtonSize.large => (54.0, 16.0, 24.0, 27.0),
      AppButtonSize.medium => (46.0, 14.0, 20.0, 23.0),
      AppButtonSize.small => (38.0, 12.0, 16.0, 19.0),
      AppButtonSize.xs => (30.0, 10.0, 12.0, 15.0),
    };

    final (bgColor, textColor, borderSide) = switch (variant) {
      AppButtonVariant.primary => (
        buttons.primaryBackground,
        buttons.primaryForeground,
        BorderSide.none,
      ),
      AppButtonVariant.outlinedPrimary => (
        Colors.transparent,
        buttons.secondaryForeground,
        BorderSide(color: buttons.outlinePrimary, width: 1.2),
      ),
      AppButtonVariant.secondary => (
        buttons.secondaryBackground,
        buttons.secondaryForeground,
        BorderSide.none,
      ),
      AppButtonVariant.outlinedSecondary => (
        Colors.transparent,
        buttons.mutedForeground,
        BorderSide(color: buttons.outlineMuted, width: 1.2),
      ),
      AppButtonVariant.inline => (
        Colors.transparent,
        buttons.secondaryForeground,
        BorderSide.none,
      ),
    };

    return SizedBox(
      height: height,
      child: OutlinedButton(
        onPressed: isLoading ? null : onPressed,
        style: OutlinedButton.styleFrom(
          backgroundColor: bgColor,
          foregroundColor: textColor,
          side: borderSide,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadius),
          ),
          padding: EdgeInsets.symmetric(horizontal: paddingHorizontal),
        ),
        child: isLoading
            ? SizedBox(
                height: height * 0.4,
                width: height * 0.4,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(textColor),
                ),
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    text,
                    style: AppTypography.textMdSemiBold.copyWith(
                      fontSize: fontSize,
                      color: textColor,
                    ),
                  ),
                  if (suffixIcon != null) ...[
                    const SizedBox(width: 8),
                    Icon(suffixIcon, size: fontSize * 1.15, color: textColor),
                  ],
                ],
              ),
      ),
    );
  }
}
