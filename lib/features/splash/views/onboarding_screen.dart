import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:dailypulse/core/theme/colors/app_colors.dart';
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

  final List<_OnboardingData> _pages = [
    _OnboardingData(
      image: 'assets/svg/welcome_2.svg',
      bgColor: AppColors.green80,
      badgeColor: AppColors.green90,
      step: 1,
      titlePart1: 'Personalize Your Mental\n',
      highlightedTitle: 'Health State',
      titlePart2: ' With AI',
      highlightColor: AppColors.green40,
    ),
    _OnboardingData(
      image: 'assets/svg/welcome_3.svg',
      bgColor: AppColors.orange80,
      badgeColor: AppColors.orange90,
      step: 2,
      titlePart1: 'Intelligent ',
      highlightedTitle: 'Mood Tracking',
      titlePart2: '\n& Emotion Insights',
      highlightColor: AppColors.orange40,
    ),
    _OnboardingData(
      image: 'assets/svg/welcome_4.svg',
      bgColor: AppColors.yellow80,
      badgeColor: AppColors.yellow90,
      step: 3,
      titlePart1: 'Mindful ',
      highlightedTitle: 'Resources',
      titlePart2: ' That\nMakes You Happy',
      highlightColor: AppColors.yellow40,
    ),
    _OnboardingData(
      image: 'assets/svg/welcome_5.svg',
      bgColor: AppColors.purple80,
      badgeColor: AppColors.purple90,
      step: 4,
      titlePart1: 'Loving & Supportive\n',
      highlightedTitle: 'Community',
      titlePart2: '',
      highlightColor: AppColors.purple40,
    ),
  ];

  void _onNext() {
    if (_currentIndex < _pages.length - 1) {
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
    final currentPageData = _pages[_currentIndex];

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
                  itemCount: _pages.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.only(
                        bottom: 240.0,
                      ), // give space for the bottom card
                      child: SvgPicture.asset(
                        _pages[index].image,
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
                  children: List.generate(_pages.length, (index) {
                    return AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      margin: const EdgeInsets.symmetric(horizontal: 4),

                      height: 8,
                      width: 8,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: _currentIndex == index
                            ? Colors.white
                            : Colors.white.withValues(alpha: 0.4),
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
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              child: OnboardingBottomCard(
                key: ValueKey(_currentIndex),
                step: currentPageData.step,
                titlePart1: currentPageData.titlePart1,
                highlightedTitle: currentPageData.highlightedTitle,
                titlePart2: currentPageData.titlePart2,
                highlightColor: currentPageData.highlightColor,
                badgeColor: currentPageData.badgeColor,
                onNext: _onNext,
              ),
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
