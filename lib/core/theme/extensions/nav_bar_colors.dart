import 'package:flutter/material.dart';

import '../colors/app_colors.dart';

/// Colors of the floating bottom navigation bar.
class NavBarColors extends ThemeExtension<NavBarColors> {
  const NavBarColors({
    required this.surface,
    required this.selectedBackground,
    required this.selectedIcon,
    required this.unselectedIcon,
    required this.addButton,
    required this.onAddButton,
    required this.shadow,
  });

  final Color surface;
  final Color selectedBackground;
  final Color selectedIcon;
  final Color unselectedIcon;
  final Color addButton;
  final Color onAddButton;
  final Color shadow;

  /// The bar is a dark brown pill in both themes, so one palette serves both.
  static const NavBarColors brown = NavBarColors(
    surface: AppColors.brown80,
    selectedBackground: AppColors.brown90,
    selectedIcon: AppColors.white,
    unselectedIcon: Color(0xFFA06A4C),
    addButton: AppColors.green50,
    onAddButton: AppColors.white,
    shadow: Color(0x66000000),
  );

  @override
  NavBarColors copyWith({
    Color? surface,
    Color? selectedBackground,
    Color? selectedIcon,
    Color? unselectedIcon,
    Color? addButton,
    Color? onAddButton,
    Color? shadow,
  }) {
    return NavBarColors(
      surface: surface ?? this.surface,
      selectedBackground: selectedBackground ?? this.selectedBackground,
      selectedIcon: selectedIcon ?? this.selectedIcon,
      unselectedIcon: unselectedIcon ?? this.unselectedIcon,
      addButton: addButton ?? this.addButton,
      onAddButton: onAddButton ?? this.onAddButton,
      shadow: shadow ?? this.shadow,
    );
  }

  @override
  NavBarColors lerp(ThemeExtension<NavBarColors>? other, double t) {
    if (other is! NavBarColors) return this;
    return NavBarColors(
      surface: Color.lerp(surface, other.surface, t)!,
      selectedBackground: Color.lerp(
        selectedBackground,
        other.selectedBackground,
        t,
      )!,
      selectedIcon: Color.lerp(selectedIcon, other.selectedIcon, t)!,
      unselectedIcon: Color.lerp(unselectedIcon, other.unselectedIcon, t)!,
      addButton: Color.lerp(addButton, other.addButton, t)!,
      onAddButton: Color.lerp(onAddButton, other.onAddButton, t)!,
      shadow: Color.lerp(shadow, other.shadow, t)!,
    );
  }
}
