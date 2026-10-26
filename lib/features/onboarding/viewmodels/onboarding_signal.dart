import 'package:inject_annotation/inject_annotation.dart';
import 'package:signals_flutter/signals_flutter.dart';

import 'package:dailypulse/core/constant/strings/onboarding_strings.dart';
import '../models/onboarding_page.dart';
import '../repository/onboarding_repository.dart';

/// State for the onboarding carousel and its completion.
@singleton
class OnboardingSignal {
  @inject
  OnboardingSignal(this._repository);

  final OnboardingRepository _repository;

  static const pages = [
    OnboardingPage(
      step: 1,
      image: 'assets/svg/welcome_2.svg',
      titlePart1: OnboardingStrings.onboardingPage1TitlePart1,
      highlightedTitle: OnboardingStrings.onboardingPage1Highlight,
      titlePart2: OnboardingStrings.onboardingPage1TitlePart2,
    ),
    OnboardingPage(
      step: 2,
      image: 'assets/svg/welcome_3.svg',
      titlePart1: OnboardingStrings.onboardingPage2TitlePart1,
      highlightedTitle: OnboardingStrings.onboardingPage2Highlight,
      titlePart2: OnboardingStrings.onboardingPage2TitlePart2,
    ),
    OnboardingPage(
      step: 3,
      image: 'assets/svg/welcome_4.svg',
      titlePart1: OnboardingStrings.onboardingPage3TitlePart1,
      highlightedTitle: OnboardingStrings.onboardingPage3Highlight,
      titlePart2: OnboardingStrings.onboardingPage3TitlePart2,
    ),
    OnboardingPage(
      step: 4,
      image: 'assets/svg/welcome_5.svg',
      titlePart1: OnboardingStrings.onboardingPage4TitlePart1,
      highlightedTitle: OnboardingStrings.onboardingPage4Highlight,
      titlePart2: OnboardingStrings.onboardingPage4TitlePart2,
    ),
  ];

  final currentIndex = signal(0);
  late final currentPage = computed(() => pages[currentIndex.value]);
  late final isLastPage = computed(
    () => currentIndex.value == pages.length - 1,
  );

  bool get hasSeenOnboarding => _repository.hasSeenOnboarding;

  void onPageChanged(int index) => currentIndex.value = index;

  /// Back to the first page; the signal outlives the screen.
  void reset() => currentIndex.value = 0;

  Future<void> complete() => _repository.markSeen();
}
