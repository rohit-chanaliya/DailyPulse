import 'package:flutter/material.dart';
import '../theme/colors.dart';
import '../theme/typography.dart';

enum AppButtonVariant {
  primary,
  outlinedPrimary,
  secondary,
  outlinedSecondary,
  inline,
}

enum AppButtonSize {
  large,
  medium,
  small,
  xs,
}

/// 1. AppButton - The primary workhorse button of the application.
/// Supports 5 styles (primary, outlinedPrimary, secondary, outlinedSecondary, inline),
/// 4 sizes (large, medium, small, xs), optional suffix icons, and loading states.
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
    final isDark = Theme.of(context).brightness == Brightness.dark;

    // --- Sizing Dimensions ---
    double height;
    double fontSize;
    double paddingHorizontal;
    double borderRadius;

    switch (size) {
      case AppButtonSize.large:
        height = 54;
        fontSize = 16;
        paddingHorizontal = 24;
        borderRadius = 27;
        break;
      case AppButtonSize.medium:
        height = 46;
        fontSize = 14;
        paddingHorizontal = 20;
        borderRadius = 23;
        break;
      case AppButtonSize.small:
        height = 38;
        fontSize = 12;
        paddingHorizontal = 16;
        borderRadius = 19;
        break;
      case AppButtonSize.xs:
        height = 30;
        fontSize = 10;
        paddingHorizontal = 12;
        borderRadius = 15;
        break;
    }

    // --- Styling Properties ---
    Color bgColor = Colors.transparent;
    Color textColor = Colors.transparent;
    BorderSide borderSide = BorderSide.none;

    switch (variant) {
      case AppButtonVariant.primary:
        bgColor = const Color(0xFF402B20); // Dark brown
        textColor = Colors.white;
        break;
      case AppButtonVariant.outlinedPrimary:
        bgColor = Colors.transparent;
        textColor = isDark ? Colors.white : const Color(0xFF402B20);
        borderSide = BorderSide(
          color: isDark ? Colors.white.withValues(alpha: 0.3) : const Color(0xFF402B20),
          width: 1.2,
        );
        break;
      case AppButtonVariant.secondary:
        bgColor = isDark ? const Color(0xFF2C221D) : const Color(0xFFF5EFEB); // Light beige/brown
        textColor = isDark ? Colors.white : const Color(0xFF402B20);
        break;
      case AppButtonVariant.outlinedSecondary:
        bgColor = Colors.transparent;
        textColor = isDark ? Colors.grey.shade400 : const Color(0xFF5A4535);
        borderSide = BorderSide(
          color: isDark ? const Color(0xFF38302B) : const Color(0xFFEAE2DA),
          width: 1.2,
        );
        break;
      case AppButtonVariant.inline:
        bgColor = Colors.transparent;
        textColor = isDark ? Colors.white : const Color(0xFF402B20);
        break;
    }

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

/// 2. AppDatePickerButton - Small selection pill for date pickers/filter headers.
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
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final bgColor = isSelected
        ? const Color(0xFF402B20)
        : (isDark ? const Color(0xFF2C221D) : const Color(0xFFF5EFEB));
    final textColor = isSelected
        ? Colors.white
        : (isDark ? Colors.grey.shade400 : const Color(0xFF5A4535));

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

/// 3. AppCheckboxButton - Rounded option card with a status dot.
/// Selected: Green background with filled check.
/// Unselected: White background with thin border and empty circle.
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
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final bgColor = isChecked
        ? AppColors.splashGreenBg
        : (isDark ? const Color(0xFF231E1B) : Colors.white);
        
    final border = isChecked
        ? Border.all(color: AppColors.splashGreenBg, width: 1.5)
        : Border.all(
            color: isDark ? const Color(0xFF38302B) : const Color(0xFFEAE2DA),
            width: 1.2,
          );

    final textColor = isChecked
        ? Colors.white
        : (isDark ? Colors.white : const Color(0xFF402B20));

    return GestureDetector(
      onTap: () => onChanged(!isChecked),
      child: Container(
        height: 54,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(27),
          border: border,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: isDark ? 0.2 : 0.03),
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
                    ? Colors.white.withValues(alpha: 0.2)
                    : Colors.transparent,
                border: Border.all(
                  color: isChecked
                      ? Colors.white
                      : (isDark ? Colors.grey.shade600 : const Color(0xFF5A4535)),
                  width: 1.5,
                ),
              ),
              child: isChecked
                  ? const Icon(Icons.check, color: Colors.white, size: 14)
                  : null,
            ),
          ],
        ),
      ),
    );
  }
}

/// 4. AppTabButton - Rectangular tab button with clean elevation shadow.
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
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final cardBg = isDark ? const Color(0xFF231E1B) : Colors.white;
    final textColor = isSelected
        ? (isDark ? Colors.white : const Color(0xFF402B20))
        : (isDark ? Colors.grey.shade500 : Colors.grey.shade400);

    return GestureDetector(
      onTap: onPressed,
      child: Container(
        height: 44,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
        decoration: isSelected
            ? BoxDecoration(
                color: cardBg,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: isDark ? 0.35 : 0.05),
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
    );
  }
}

enum AppIconButtonSize {
  xl,
  large,
  medium,
  small,
  xs,
}

/// 5. AppIconButton - Circular FAB style button.
/// XL (64px) to XS (32px) in orange with a white icon.
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
    double diameter;
    double iconSize;

    switch (size) {
      case AppIconButtonSize.xl:
        diameter = 64;
        iconSize = 28;
        break;
      case AppIconButtonSize.large:
        diameter = 56;
        iconSize = 24;
        break;
      case AppIconButtonSize.medium:
        diameter = 48;
        iconSize = 20;
        break;
      case AppIconButtonSize.small:
        diameter = 40;
        iconSize = 18;
        break;
      case AppIconButtonSize.xs:
        diameter = 32;
        iconSize = 14;
        break;
    }

    return SizedBox(
      width: diameter,
      height: diameter,
      child: IconButton(
        onPressed: onPressed,
        style: IconButton.styleFrom(
          backgroundColor: AppColors.orange40, // Empathy Orange 40
          foregroundColor: Colors.white,
          shape: const CircleBorder(),
          padding: EdgeInsets.zero,
        ),
        icon: Icon(icon, size: iconSize, color: Colors.white),
      ),
    );
  }
}

/// 6. AppToggleButton - Custom toggle switch button.
class AppToggleButton extends StatelessWidget {
  final bool value;
  final ValueChanged<bool> onChanged;

  const AppToggleButton({
    super.key,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return GestureDetector(
      onTap: () => onChanged(!value),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: 48,
        height: 28,
        padding: const EdgeInsets.all(3),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(14),
          color: value
              ? AppColors.splashGreenBg
              : (isDark ? const Color(0xFF38302B) : const Color(0xFFEAE2DA)),
        ),
        child: AnimatedAlign(
          duration: const Duration(milliseconds: 200),
          alignment: value ? Alignment.centerRight : Alignment.centerLeft,
          child: Container(
            width: 22,
            height: 22,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 4,
                  offset: Offset(0, 2),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// 7. AppPillButton - Small chip widget featuring a left-aligned icon.
/// Selected: Green outline and soft green background.
/// Unselected: Grey outline and white background.
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
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final bgColor = isSelected
        ? (isDark ? const Color(0xFF2A3620) : AppColors.green10)
        : (isDark ? const Color(0xFF1E1916) : Colors.white);
        
    final border = isSelected
        ? Border.all(color: AppColors.green50, width: 1.2)
        : Border.all(
            color: isDark ? const Color(0xFF38302B) : const Color(0xFFEAE2DA),
            width: 1.2,
          );

    final textColor = isSelected
        ? (isDark ? AppColors.green30 : AppColors.green70)
        : (isDark ? Colors.grey.shade400 : const Color(0xFF5A4535));

    return GestureDetector(
      onTap: onPressed,
      child: Container(
        height: 34,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(17),
          border: border,
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
