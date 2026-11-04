import 'package:flutter/material.dart';

import 'package:dailypulse/core/constant/strings/home_strings.dart';
import 'home_article_card.dart';
import 'home_pager_dots.dart';
import 'home_section_title.dart';

class HomeArticlesSection extends StatelessWidget {
  const HomeArticlesSection({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: HomeSectionTitle(HomeStrings.articlesTitle),
        ),
        SizedBox(height: 12),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            children: [
              HomeArticleCard(),
              SizedBox(width: 8),
              HomeArticleCard(),
            ],
          ),
        ),
        SizedBox(height: 16),
        HomePagerDots(),
      ],
    );
  }
}
