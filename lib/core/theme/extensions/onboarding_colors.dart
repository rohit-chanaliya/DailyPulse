import 'package:flutter/material.dart';

class OnboardingColors extends ThemeExtension<OnboardingColors> {
  final Color welcomeBg;
  final Color welcomeHighlight;
  final Color welcomeText;
  final Color welcomeSubtitle;

  final Color page1Bg;
  final Color page1Badge;
  final Color page1Highlight;

  final Color page2Bg;
  final Color page2Badge;
  final Color page2Highlight;

  final Color page3Bg;
  final Color page3Badge;
  final Color page3Highlight;

  final Color page4Bg;
  final Color page4Badge;
  final Color page4Highlight;

  final Color bottomCardBg;
  final Color bottomCardText;
  final Color bottomCardButtonBg;
  final Color bottomCardButtonIcon;
  final Color bottomCardBadgeText;

  final Color indicatorActive;
  final Color indicatorInactive;

  OnboardingColors({
    required this.welcomeBg,
    required this.welcomeHighlight,
    required this.welcomeText,
    required this.welcomeSubtitle,
    required this.page1Bg,
    required this.page1Badge,
    required this.page1Highlight,
    required this.page2Bg,
    required this.page2Badge,
    required this.page2Highlight,
    required this.page3Bg,
    required this.page3Badge,
    required this.page3Highlight,
    required this.page4Bg,
    required this.page4Badge,
    required this.page4Highlight,
    required this.bottomCardBg,
    required this.bottomCardText,
    required this.bottomCardButtonBg,
    required this.bottomCardButtonIcon,
    required this.bottomCardBadgeText,
    required this.indicatorActive,
    required this.indicatorInactive,
  });

  @override
  OnboardingColors copyWith({
    Color? welcomeBg,
    Color? welcomeHighlight,
    Color? welcomeText,
    Color? welcomeSubtitle,
    Color? page1Bg,
    Color? page1Badge,
    Color? page1Highlight,
    Color? page2Bg,
    Color? page2Badge,
    Color? page2Highlight,
    Color? page3Bg,
    Color? page3Badge,
    Color? page3Highlight,
    Color? page4Bg,
    Color? page4Badge,
    Color? page4Highlight,
    Color? bottomCardBg,
    Color? bottomCardText,
    Color? bottomCardButtonBg,
    Color? bottomCardButtonIcon,
    Color? bottomCardBadgeText,
    Color? indicatorActive,
    Color? indicatorInactive,
  }) {
    return OnboardingColors(
      welcomeBg: welcomeBg ?? this.welcomeBg,
      welcomeHighlight: welcomeHighlight ?? this.welcomeHighlight,
      welcomeText: welcomeText ?? this.welcomeText,
      welcomeSubtitle: welcomeSubtitle ?? this.welcomeSubtitle,
      page1Bg: page1Bg ?? this.page1Bg,
      page1Badge: page1Badge ?? this.page1Badge,
      page1Highlight: page1Highlight ?? this.page1Highlight,
      page2Bg: page2Bg ?? this.page2Bg,
      page2Badge: page2Badge ?? this.page2Badge,
      page2Highlight: page2Highlight ?? this.page2Highlight,
      page3Bg: page3Bg ?? this.page3Bg,
      page3Badge: page3Badge ?? this.page3Badge,
      page3Highlight: page3Highlight ?? this.page3Highlight,
      page4Bg: page4Bg ?? this.page4Bg,
      page4Badge: page4Badge ?? this.page4Badge,
      page4Highlight: page4Highlight ?? this.page4Highlight,
      bottomCardBg: bottomCardBg ?? this.bottomCardBg,
      bottomCardText: bottomCardText ?? this.bottomCardText,
      bottomCardButtonBg: bottomCardButtonBg ?? this.bottomCardButtonBg,
      bottomCardButtonIcon: bottomCardButtonIcon ?? this.bottomCardButtonIcon,
      bottomCardBadgeText: bottomCardBadgeText ?? this.bottomCardBadgeText,
      indicatorActive: indicatorActive ?? this.indicatorActive,
      indicatorInactive: indicatorInactive ?? this.indicatorInactive,
    );
  }

  @override
  OnboardingColors lerp(ThemeExtension<OnboardingColors>? other, double t) {
    if (other is! OnboardingColors) return this;
    return OnboardingColors(
      welcomeBg: Color.lerp(welcomeBg, other.welcomeBg, t)!,
      welcomeHighlight: Color.lerp(welcomeHighlight, other.welcomeHighlight, t)!,
      welcomeText: Color.lerp(welcomeText, other.welcomeText, t)!,
      welcomeSubtitle: Color.lerp(welcomeSubtitle, other.welcomeSubtitle, t)!,
      page1Bg: Color.lerp(page1Bg, other.page1Bg, t)!,
      page1Badge: Color.lerp(page1Badge, other.page1Badge, t)!,
      page1Highlight: Color.lerp(page1Highlight, other.page1Highlight, t)!,
      page2Bg: Color.lerp(page2Bg, other.page2Bg, t)!,
      page2Badge: Color.lerp(page2Badge, other.page2Badge, t)!,
      page2Highlight: Color.lerp(page2Highlight, other.page2Highlight, t)!,
      page3Bg: Color.lerp(page3Bg, other.page3Bg, t)!,
      page3Badge: Color.lerp(page3Badge, other.page3Badge, t)!,
      page3Highlight: Color.lerp(page3Highlight, other.page3Highlight, t)!,
      page4Bg: Color.lerp(page4Bg, other.page4Bg, t)!,
      page4Badge: Color.lerp(page4Badge, other.page4Badge, t)!,
      page4Highlight: Color.lerp(page4Highlight, other.page4Highlight, t)!,
      bottomCardBg: Color.lerp(bottomCardBg, other.bottomCardBg, t)!,
      bottomCardText: Color.lerp(bottomCardText, other.bottomCardText, t)!,
      bottomCardButtonBg: Color.lerp(bottomCardButtonBg, other.bottomCardButtonBg, t)!,
      bottomCardButtonIcon: Color.lerp(bottomCardButtonIcon, other.bottomCardButtonIcon, t)!,
      bottomCardBadgeText: Color.lerp(bottomCardBadgeText, other.bottomCardBadgeText, t)!,
      indicatorActive: Color.lerp(indicatorActive, other.indicatorActive, t)!,
      indicatorInactive: Color.lerp(indicatorInactive, other.indicatorInactive, t)!,
    );
  }
}
