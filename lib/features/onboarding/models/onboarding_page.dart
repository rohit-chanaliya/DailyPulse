/// Static content of a single onboarding page (colors come from the theme).
class OnboardingPage {
  const OnboardingPage({
    required this.step,
    required this.image,
    required this.titlePart1,
    required this.highlightedTitle,
    required this.titlePart2,
  });

  /// 1-based step number shown in the badge.
  final int step;
  final String image;
  final String titlePart1;
  final String highlightedTitle;
  final String titlePart2;
}
