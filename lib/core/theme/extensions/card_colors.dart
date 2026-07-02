import 'package:flutter/material.dart';

class CardColors extends ThemeExtension<CardColors> {
  final Color journalCard;
  final Color statsCard;
  final Color premiumCard;
  final Color shadow;

  CardColors({
    required this.journalCard,
    required this.statsCard,
    required this.premiumCard,
    required this.shadow,
  });

  @override
  CardColors copyWith({
    Color? journalCard,
    Color? statsCard,
    Color? premiumCard,
    Color? shadow,
  }) {
    return CardColors(
      journalCard: journalCard ?? this.journalCard,
      statsCard: statsCard ?? this.statsCard,
      premiumCard: premiumCard ?? this.premiumCard,
      shadow: shadow ?? this.shadow,
    );
  }

  @override
  CardColors lerp(ThemeExtension<CardColors>? other, double t) {
    if (other is! CardColors) return this;
    return CardColors(
      journalCard: Color.lerp(journalCard, other.journalCard, t)!,
      statsCard: Color.lerp(statsCard, other.statsCard, t)!,
      premiumCard: Color.lerp(premiumCard, other.premiumCard, t)!,
      shadow: Color.lerp(shadow, other.shadow, t)!,
    );
  }
}
