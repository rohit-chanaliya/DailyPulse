import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:dailypulse/core/constant/strings/home_strings.dart';
import 'package:dailypulse/core/theme/context_extensions.dart';
import 'package:dailypulse/features/mood/presentation/models/home_assets.dart';
import 'home_asset_icon.dart';

class HomeArticleCard extends StatelessWidget {
  const HomeArticleCard({super.key});

  @override
  Widget build(BuildContext context) {
    final home = context.home;
    return Container(
      width: 230,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: home.surface,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: home.headerSurface.withValues(alpha: 0.05),
            blurRadius: 16,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SvgPicture.asset(HomeAssets.articleHead, width: 64, height: 64),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              color: home.headerSurface,
              borderRadius: BorderRadius.circular(100),
            ),
            child: Text(
              HomeStrings.articleTag.toUpperCase(),
              style: context.textTheme.labelSmall?.copyWith(
                color: home.accent,
                fontSize: 10,
                fontWeight: FontWeight.w800,
                letterSpacing: 1,
              ),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            HomeStrings.articleTitle,
            style: context.textTheme.titleMedium?.copyWith(
              color: home.textPrimary,
              fontSize: 16,
              fontWeight: FontWeight.w700,
              height: 1.25,
            ),
          ),
          const SizedBox(height: 16),
          const Row(
            children: [
              _ArticleStat(
                icon: HomeAssets.articleHeart,
                value: HomeStrings.articleLikes,
              ),
              SizedBox(width: 20),
              _ArticleStat(
                icon: HomeAssets.eye,
                value: HomeStrings.articleViews,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _ArticleStat extends StatelessWidget {
  const _ArticleStat({required this.icon, required this.value});

  final String icon;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        HomeAssetIcon(icon, size: 16),
        const SizedBox(width: 4),
        Text(
          value.toUpperCase(),
          style: context.textTheme.labelSmall?.copyWith(
            color: context.home.textSecondary,
            fontSize: 10,
            fontWeight: FontWeight.w800,
            letterSpacing: 1,
          ),
        ),
      ],
    );
  }
}
