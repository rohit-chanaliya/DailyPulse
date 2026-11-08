import 'package:flutter/material.dart';
import 'package:dailypulse/core/theme/context_extensions.dart';

/// A shared, highly customizable Text Form Field with high readability,
/// comfortable touch target, clean borders, and mindful theme colors.
class CustomTextField extends StatefulWidget {
  final TextEditingController controller;
  final String? label;
  final String? hintText;
  final IconData? prefixIcon;
  final Widget? suffixIcon;
  final bool obscureText;
  final bool isPassword;
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
    this.isPassword = false,
    this.keyboardType,
    this.validator,
  });

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  late bool _obscured;

  @override
  void initState() {
    super.initState();
    _obscured = widget.isPassword || widget.obscureText;
  }

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
        if (widget.label != null) ...[
          Text(
            widget.label!,
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w600,
              color: home.textSecondary,
              letterSpacing: 0.1,
            ),
          ),
          const SizedBox(height: 10),
        ],
        ValueListenableBuilder<TextEditingValue>(
          valueListenable: widget.controller,
          builder: (context, value, _) {
            final Widget? effectiveSuffix;
            if (widget.isPassword) {
              if (value.text.isNotEmpty) {
                effectiveSuffix = IconButton(
                  icon: Icon(
                    _obscured
                        ? Icons.visibility_outlined
                        : Icons.visibility_off_outlined,
                    size: 22,
                    color: home.textMuted,
                  ),
                  onPressed: () => setState(() => _obscured = !_obscured),
                );
              } else {
                effectiveSuffix = null;
              }
            } else {
              effectiveSuffix = widget.suffixIcon;
            }

            final isObscuredNow =
                widget.isPassword ? _obscured : widget.obscureText;

            return TextFormField(
              controller: widget.controller,
              obscureText: isObscuredNow,
              obscuringCharacter: '●',
              keyboardType: widget.keyboardType,
              validator: widget.validator,
              style: TextStyle(
                fontSize: isObscuredNow ? 18 : 17,
                fontWeight: FontWeight.w600,
                letterSpacing: isObscuredNow ? 3.0 : 0.2,
                color: home.textPrimary,
              ),
              decoration: InputDecoration(
                hintText: widget.hintText,
                hintStyle: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                  letterSpacing: 0.1,
                  color: home.textMuted,
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 18,
                ),
                filled: true,
                fillColor: buttons.surfaceBackground,
                prefixIcon: widget.prefixIcon != null
                    ? Padding(
                        padding: const EdgeInsets.only(left: 14, right: 10),
                        child: Icon(
                          widget.prefixIcon,
                          size: 20,
                          color: home.textSecondary,
                        ),
                      )
                    : null,
                prefixIconConstraints: widget.prefixIcon != null
                    ? const BoxConstraints(minWidth: 44, minHeight: 24)
                    : null,
                suffixIcon: effectiveSuffix,
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
            );
          },
        ),
      ],
    );
  }
}

