import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:dailypulse/core/theme/app_theme.dart';
import 'package:dailypulse/core/constant/strings/onboarding_strings.dart';
import 'package:dailypulse/features/auth/screens/sign_in_screen.dart';
import 'package:dailypulse/core/widgets/navigation/fade_page_route.dart';
import 'widgets/onboarding_bottom_card.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentIndex = 0;

  void _onNext(int pageCount) {
    if (_currentIndex < pageCount - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
      );
    } else {
      Navigator.of(
        context,
      ).pushReplacement(FadePageRoute(page: const SignInScreen()));
    }
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.onboarding;

    final List<_OnboardingData> pages = [
      _OnboardingData(
        image: 'assets/svg/welcome_2.svg',
        bgColor: colors.page1Bg,
        badgeColor: colors.page1Badge,
        step: 1,
        titlePart1: OnboardingStrings.onboardingPage1TitlePart1,
        highlightedTitle: OnboardingStrings.onboardingPage1Highlight,
        titlePart2: OnboardingStrings.onboardingPage1TitlePart2,
        highlightColor: colors.page1Highlight,
      ),
      _OnboardingData(
        image: 'assets/svg/welcome_3.svg',
        bgColor: colors.page2Bg,
        badgeColor: colors.page2Badge,
        step: 2,
        titlePart1: OnboardingStrings.onboardingPage2TitlePart1,
        highlightedTitle: OnboardingStrings.onboardingPage2Highlight,
        titlePart2: OnboardingStrings.onboardingPage2TitlePart2,
        highlightColor: colors.page2Highlight,
      ),
      _OnboardingData(
        image: 'assets/svg/welcome_4.svg',
        bgColor: colors.page3Bg,
        badgeColor: colors.page3Badge,
        step: 3,
        titlePart1: OnboardingStrings.onboardingPage3TitlePart1,
        highlightedTitle: OnboardingStrings.onboardingPage3Highlight,
        titlePart2: OnboardingStrings.onboardingPage3TitlePart2,
        highlightColor: colors.page3Highlight,
      ),
      _OnboardingData(
        image: 'assets/svg/welcome_5.svg',
        bgColor: colors.page4Bg,
        badgeColor: colors.page4Badge,
        step: 4,
        titlePart1: OnboardingStrings.onboardingPage4TitlePart1,
        highlightedTitle: OnboardingStrings.onboardingPage4Highlight,
        titlePart2: OnboardingStrings.onboardingPage4TitlePart2,
        highlightColor: colors.page4Highlight,
      ),
    ];

    final currentPageData = pages[_currentIndex];

    return Scaffold(
      backgroundColor: currentPageData.bgColor,
      body: Stack(
        children: [
          // Background Color Transition
          AnimatedContainer(
            duration: const Duration(milliseconds: 400),
            color: currentPageData.bgColor,
          ),

          Column(
            children: [
              Expanded(
                child: PageView.builder(
                  controller: _pageController,
                  onPageChanged: (index) {
                    setState(() {
                      _currentIndex = index;
                    });
                  },
                  itemCount: pages.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.only(
                        bottom: 240.0,
                      ), // give space for the bottom card
                      child: SvgPicture.asset(
                        pages[index].image,
                        fit: BoxFit.fill,
                      ),
                    );
                  },
                ),
              ),
            ],
          ),

          SafeArea(
            child: Align(
              alignment: Alignment.topCenter,
              child: Padding(
                padding: const EdgeInsets.only(top: 16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(pages.length, (index) {
                    return AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      margin: const EdgeInsets.symmetric(horizontal: 4),
                      height: 8,
                      width: 8,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: _currentIndex == index
                            ? colors.indicatorActive
                            : colors.indicatorInactive,
                      ),
                    );
                  }),
                ),
              ),
            ),
          ),

          // Bottom Card Overlay
          Align(
            alignment: Alignment.bottomCenter,
            child: OnboardingBottomCard(
              step: currentPageData.step,
              titlePart1: currentPageData.titlePart1,
              highlightedTitle: currentPageData.highlightedTitle,
              titlePart2: currentPageData.titlePart2,
              highlightColor: currentPageData.highlightColor,
              badgeColor: currentPageData.badgeColor,
              onNext: () => _onNext(pages.length),
            ),
          ),
        ],
      ),
    );
  }
}

class _OnboardingData {
  final String image;
  final Color bgColor;
  final Color badgeColor;
  final int step;
  final String titlePart1;
  final String highlightedTitle;
  final String titlePart2;
  final Color highlightColor;

  _OnboardingData({
    required this.image,
    required this.bgColor,
    required this.badgeColor,
    required this.step,
    required this.titlePart1,
    required this.highlightedTitle,
    required this.titlePart2,
    required this.highlightColor,
  });
}
