import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../models/onboarding_page.dart';

class OnboardingPageView extends StatelessWidget {
  const OnboardingPageView({
    super.key,
    required this.pages,
    required this.controller,
    required this.onPageChanged,
  });

  final List<OnboardingPage> pages;
  final PageController controller;
  final ValueChanged<int> onPageChanged;

  @override
  Widget build(BuildContext context) {
    return PageView.builder(
      controller: controller,
      onPageChanged: onPageChanged,
      itemCount: pages.length,
      itemBuilder: (context, index) {
        return Padding(
          // Leave room for the bottom card.
          padding: const EdgeInsets.only(bottom: 240),
          child: SvgPicture.asset(pages[index].image, fit: BoxFit.fill),
        );
      },
    );
  }
}
