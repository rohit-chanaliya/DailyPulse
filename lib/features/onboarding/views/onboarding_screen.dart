import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:signals_flutter/signals_flutter.dart';

import 'package:dailypulse/core/di/injection.dart';
import 'package:dailypulse/core/router/app_routes.dart';
import 'package:dailypulse/core/theme/app_theme.dart';
import '../viewmodels/onboarding_signal.dart';
import 'widgets/onboarding_bottom_card.dart';
import 'widgets/onboarding_page_indicator.dart';
import 'widgets/onboarding_page_view.dart';
import 'widgets/onboarding_skip_button.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  late final OnboardingSignal _signal = appComponent.onboardingSignal;

  @override
  void initState() {
    super.initState();
    _signal.reset();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _onNext() {
    if (_signal.isLastPage.value) {
      _completeOnboarding();
    } else {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
      );
    }
  }

  Future<void> _completeOnboarding() async {
    await _signal.complete();
    if (mounted) {
      context.go(AppRoutes.signIn);
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.onboarding;

    return SignalBuilder(
      builder: (context) {
        final index = _signal.currentIndex.value;
        final page = _signal.currentPage.value;

        return Scaffold(
          backgroundColor: colors.pageBg(index),
          body: Stack(
            children: [
              AnimatedContainer(
                duration: const Duration(milliseconds: 400),
                color: colors.pageBg(index),
              ),
              Column(
                children: [
                  Expanded(
                    child: OnboardingPageView(
                      pages: OnboardingSignal.pages,
                      controller: _pageController,
                      onPageChanged: _signal.onPageChanged,
                    ),
                  ),
                ],
              ),
              SafeArea(
                child: Align(
                  alignment: Alignment.topCenter,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 16),
                    child: OnboardingPageIndicator(
                      count: OnboardingSignal.pages.length,
                      currentIndex: index,
                    ),
                  ),
                ),
              ),
              Positioned(
                top: 0,
                right: 0,
                child: SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 4, right: 12),
                    child: OnboardingSkipButton(onPressed: _completeOnboarding),
                  ),
                ),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: OnboardingBottomCard(
                  step: page.step,
                  titlePart1: page.titlePart1,
                  highlightedTitle: page.highlightedTitle,
                  titlePart2: page.titlePart2,
                  highlightColor: colors.pageHighlight(index),
                  badgeColor: colors.pageBadge(index),
                  onNext: _onNext,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
