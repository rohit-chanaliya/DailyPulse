import 'package:flutter/material.dart';
import '../../app/theme/colors.dart';
import '../../app/theme/typography.dart';

/// A shared, highly customizable Text Form Field that represents the
/// Figma "Input Field Master" component. It supports optional labels,
/// prefix icons (with custom circular borders), and suffix icons.
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
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        // Render label if provided (Figma option)
        if (label != null) ...[
          Text(
            label!,
            style: AppTypography.labelXs.copyWith(
              color: isDark ? Colors.grey.shade400 : const Color(0xFF5A4535),
            ),
          ),
          const SizedBox(height: 6),
        ],
        TextFormField(
          controller: controller,
          obscureText: obscureText,
          keyboardType: keyboardType,
          validator: validator,
          style: AppTypography.paragraphSm.copyWith(
            color: isDark ? Colors.white : const Color(0xFF402B20),
          ),
          decoration: InputDecoration(
            hintText: hintText,
            hintStyle: AppTypography.paragraphSm.copyWith(
              color: isDark ? Colors.grey.shade600 : Colors.grey.shade400,
            ),
            contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
            filled: true,
            fillColor: isDark ? const Color(0xFF231E1B) : Colors.white,
            
            // Render circular-bordered Prefix Icon only if provided (Figma option)
            prefixIcon: prefixIcon != null
                ? Padding(
                    padding: const EdgeInsets.only(left: 12, right: 8),
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: isDark ? const Color(0xFF38302B) : const Color(0xFFEAE2DA),
                          width: 1,
                        ),
                      ),
                      child: Icon(
                        prefixIcon,
                        size: 16,
                        color: isDark ? Colors.grey.shade400 : const Color(0xFF5A4535),
                      ),
                    ),
                  )
                : null,
            prefixIconConstraints: prefixIcon != null
                ? const BoxConstraints(
                    minWidth: 40,
                    minHeight: 40,
                  )
                : null,
            
            // Render Suffix Icon only if provided (Figma option)
            suffixIcon: suffixIcon,
            
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(30),
              borderSide: BorderSide(
                color: isDark ? const Color(0xFF38302B) : const Color(0xFFDCD2C9),
                width: 1.2,
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(30),
              borderSide: BorderSide(
                color: isDark ? const Color(0xFF38302B) : const Color(0xFFDCD2C9),
                width: 1.2,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(30),
              borderSide: const BorderSide(
                color: AppColors.splashGreenBg,
                width: 1.5,
              ),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(30),
              borderSide: const BorderSide(color: Colors.red, width: 1.2),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(30),
              borderSide: const BorderSide(color: Colors.red, width: 1.5),
            ),
          ),
        ),
      ],
    );
  }
}
