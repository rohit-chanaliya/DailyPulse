import 'package:flutter/material.dart';

class AppGradients extends ThemeExtension<AppGradients> {
  final LinearGradient primaryGradient;
  final LinearGradient premiumGradient;
  final LinearGradient cardGradient;

  AppGradients({
    required this.primaryGradient,
    required this.premiumGradient,
    required this.cardGradient,
  });

  @override
  AppGradients copyWith({
    LinearGradient? primaryGradient,
    LinearGradient? premiumGradient,
    LinearGradient? cardGradient,
  }) {
    return AppGradients(
      primaryGradient: primaryGradient ?? this.primaryGradient,
      premiumGradient: premiumGradient ?? this.premiumGradient,
      cardGradient: cardGradient ?? this.cardGradient,
    );
  }

  @override
  AppGradients lerp(ThemeExtension<AppGradients>? other, double t) {
    if (other is! AppGradients) return this;
    return AppGradients(
      primaryGradient: LinearGradient.lerp(primaryGradient, other.primaryGradient, t)!,
      premiumGradient: LinearGradient.lerp(premiumGradient, other.premiumGradient, t)!,
      cardGradient: LinearGradient.lerp(cardGradient, other.cardGradient, t)!,
    );
  }
}
