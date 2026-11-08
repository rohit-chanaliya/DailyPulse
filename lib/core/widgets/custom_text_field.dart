import 'package:flutter/material.dart';
import 'package:dailypulse/core/theme/context_extensions.dart';

/// A shared, highly customizable Text Form Field with high readability,
/// comfortable touch target, clean borders, and mindful theme colors.
class CustomTextField extends StatelessWidget {
  final TextEditingController controller;
  final String? label;
  final String? hintText;
  final IconData? prefixIcon;
  final Widget? suffixIcon;
  final bool obscureText;
  final TextInputType? keyboardType;
  final String? Function(String?)? validator;

  const CustomTextField({
    super.key,
    required this.controller,
    this.label,
    this.hintText,
    this.prefixIcon,
    this.suffixIcon,
    this.obscureText = false,
    this.keyboardType,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    final home = context.home;
    final buttons = context.buttons;
    final onboarding = context.onboarding;
    final status = context.status;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (label != null) ...[
          Text(
            label!,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: home.textSecondary,
              letterSpacing: 0.1,
            ),
          ),
          const SizedBox(height: 8),
        ],
        TextFormField(
          controller: controller,
          obscureText: obscureText,
          keyboardType: keyboardType,
          validator: validator,
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w500,
            color: home.textPrimary,
          ),
          decoration: InputDecoration(
            hintText: hintText,
            hintStyle: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w400,
              color: home.textMuted,
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 16,
            ),
            filled: true,
            fillColor: buttons.surfaceBackground,
            prefixIcon: prefixIcon != null
                ? Padding(
                    padding: const EdgeInsets.only(left: 14, right: 10),
                    child: Icon(
                      prefixIcon,
                      size: 20,
                      color: home.textSecondary,
                    ),
                  )
                : null,
            prefixIconConstraints: prefixIcon != null
                ? const BoxConstraints(minWidth: 44, minHeight: 24)
                : null,
            suffixIcon: suffixIcon,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide(
                color: buttons.surfaceBorder,
                width: 1.2,
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide(
                color: buttons.surfaceBorder,
                width: 1.2,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide(
                color: onboarding.welcomeHighlight,
                width: 1.8,
              ),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide(
                color: status.error,
                width: 1.2,
              ),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide(
                color: status.error,
                width: 1.8,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

