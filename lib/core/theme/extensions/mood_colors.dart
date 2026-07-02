import 'package:flutter/material.dart';

class MoodColors extends ThemeExtension<MoodColors> {
  final Color frustrated;
  final Color terrible;
  final Color anxious;
  final Color neutral;
  final Color happy;
  final Color excited;

  MoodColors({
    required this.frustrated,
    required this.terrible,
    required this.anxious,
    required this.neutral,
    required this.happy,
    required this.excited,
  });

  List<Color> get values => [
        frustrated,
        terrible,
        anxious,
        neutral,
        happy,
        excited,
      ];

  @override
  MoodColors copyWith({
    Color? frustrated,
    Color? terrible,
    Color? anxious,
    Color? neutral,
    Color? happy,
    Color? excited,
  }) {
    return MoodColors(
      frustrated: frustrated ?? this.frustrated,
      terrible: terrible ?? this.terrible,
      anxious: anxious ?? this.anxious,
      neutral: neutral ?? this.neutral,
      happy: happy ?? this.happy,
      excited: excited ?? this.excited,
    );
  }

  @override
  MoodColors lerp(ThemeExtension<MoodColors>? other, double t) {
    if (other is! MoodColors) return this;
    return MoodColors(
      frustrated: Color.lerp(frustrated, other.frustrated, t)!,
      terrible: Color.lerp(terrible, other.terrible, t)!,
      anxious: Color.lerp(anxious, other.anxious, t)!,
      neutral: Color.lerp(neutral, other.neutral, t)!,
      happy: Color.lerp(happy, other.happy, t)!,
      excited: Color.lerp(excited, other.excited, t)!,
    );
  }
}
