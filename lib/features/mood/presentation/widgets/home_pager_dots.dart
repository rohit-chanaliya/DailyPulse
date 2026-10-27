import 'package:flutter/material.dart';

import 'package:dailypulse/core/theme/context_extensions.dart';

class HomePagerDots extends StatelessWidget {
  const HomePagerDots({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(5, (index) {
        return Container(
          width: 8,
          height: 8,
          margin: const EdgeInsets.symmetric(horizontal: 4),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: index == 0
                ? context.home.accent
                : context.home.headerSurface,
          ),
        );
      }),
    );
  }
}
