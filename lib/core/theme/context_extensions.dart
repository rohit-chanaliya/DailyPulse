import 'package:flutter/material.dart';
import 'extensions/mood_colors.dart';
import 'extensions/status_colors.dart';
import 'extensions/card_colors.dart';
import 'extensions/app_gradients.dart';
import 'extensions/splash_colors.dart';
import 'extensions/onboarding_colors.dart';
import 'extensions/home_colors.dart';
import 'extensions/log_mood_colors.dart';
import 'extensions/nav_bar_colors.dart';

extension ThemeContextExtensions on BuildContext {
  ThemeData get theme => Theme.of(this);
  ColorScheme get colors => theme.colorScheme;
  TextTheme get textTheme => theme.textTheme;

  MoodColors get mood => theme.extension<MoodColors>()!;
  StatusColors get status => theme.extension<StatusColors>()!;
  CardColors get cards => theme.extension<CardColors>()!;
  AppGradients get gradients => theme.extension<AppGradients>()!;
  SplashColors get splash => theme.extension<SplashColors>()!;
  OnboardingColors get onboarding => theme.extension<OnboardingColors>()!;
  HomeColors get home => theme.extension<HomeColors>()!;
  LogMoodColors get logMood => theme.extension<LogMoodColors>()!;
  NavBarColors get navBar => theme.extension<NavBarColors>()!;
}
