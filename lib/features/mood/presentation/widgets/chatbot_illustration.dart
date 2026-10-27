import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:dailypulse/features/mood/presentation/models/home_assets.dart';

class ChatbotIllustration extends StatelessWidget {
  const ChatbotIllustration({super.key});

  static const _vectors = [
    (HomeAssets.chatDecor1, 0.7454, -0.0318, 0.2005, 0.7569),
    (HomeAssets.chatDecor2, 0.7213, -0.0909, 0.1745, 0.9099),
    (HomeAssets.chatVector7, 0.5413, 0.5539, 0.2972, 0.1656),
    (HomeAssets.chatVector8, 0.5930, 0.6889, 0.3840, 0.0564),
    (HomeAssets.chatVector9, 0.5525, 0.8823, 0.3253, -0.0952),
    (HomeAssets.chatVector10, 0.5950, 0.1284, 0.0622, 0.4266),
    (HomeAssets.chatVector11, 0.6043, 0.1980, 0.1641, 0.6197),
    (HomeAssets.chatVector12, 0.6413, 0.2678, 0.3309, 0.6839),
    (HomeAssets.chatVector13, 0.7586, 0.2678, 0.2135, 0.6839),
    (HomeAssets.chatVector14, 0.6565, 0.4097, 0.2075, 0.5694),
    (HomeAssets.chatVector15, 0.8950, 0.2472, 0.0623, 0.5346),
    (HomeAssets.chatVector16, 0.6444, 0.6055, 0.1050, -0.0059),
    (HomeAssets.chatVector17, 0.6725, 0.6328, 0.1251, 0.0945),
    (HomeAssets.chatVector18, 0.6563, 0.6308, 0.1411, 0.0945),
    (HomeAssets.chatVector19, 0.7596, 0.7174, 0.1771, 0.1730),
    (HomeAssets.chatVector20, 0.6993, 0.7208, 0.2471, 0.2291),
    (HomeAssets.chatVectorCopy, 0.7155, 0.7623, 0.2465, 0.1930),
    (HomeAssets.chatVector21, 0.8420, 0.5539, -0.0035, 0.1656),
    (HomeAssets.chatVector22, 0.9117, 0.6749, 0.0652, 0.0704),
    (HomeAssets.chatVector23, 0.8712, 0.8683, 0.0065, -0.0812),
  ];

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;
        final height = constraints.maxHeight;
        return Stack(
          clipBehavior: Clip.none,
          children: [
            Positioned(
              left: 263,
              top: -18,
              child: SvgPicture.asset(
                HomeAssets.chatCircleSmall,
                width: 52,
                height: 52,
              ),
            ),
            Positioned(
              left: 207,
              top: -128,
              child: SvgPicture.asset(
                HomeAssets.chatCircleLarge,
                width: 252,
                height: 252,
              ),
            ),
            Positioned(
              left: -20,
              top: 144,
              child: SvgPicture.asset(
                HomeAssets.chatCircleBottom,
                width: 60,
                height: 60,
              ),
            ),
            for (final (asset, left, top, right, bottom) in _vectors)
              Positioned(
                left: width * left,
                top: height * top,
                width: width * (1 - left - right),
                height: height * (1 - top - bottom),
                child: SvgPicture.asset(asset, fit: BoxFit.fill),
              ),
            Positioned(
              left: 181,
              top: 14,
              child: SvgPicture.asset(
                HomeAssets.chatBubble,
                width: 53,
                height: 48,
              ),
            ),
            Positioned(
              left: 191,
              top: 30,
              child: SvgPicture.asset(
                HomeAssets.chatBubbleDots,
                width: 32,
                height: 8,
              ),
            ),
          ],
        );
      },
    );
  }
}
