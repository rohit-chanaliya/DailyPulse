import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';

import 'package:dailypulse/core/constant/strings/home_strings.dart';
import 'package:dailypulse/core/theme/context_extensions.dart';
import 'package:dailypulse/features/mood/presentation/models/home_assets.dart';
import 'home_asset_icon.dart';

class HomeHeader extends StatelessWidget {
  const HomeHeader({super.key, required this.userName});

  final String userName;

  @override
  Widget build(BuildContext context) {
    final home = context.home;
    return Container(
      padding: EdgeInsets.fromLTRB(
        16,
        MediaQuery.paddingOf(context).top + 12,
        16,
        28,
      ),
      decoration: BoxDecoration(
        color: home.headerSurface,
        borderRadius: const BorderRadius.vertical(bottom: Radius.circular(40)),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const HomeAssetIcon(HomeAssets.calendar, size: 20),
                  const SizedBox(width: 4),
                  Text(
                    DateFormat('E, d MMM y').format(DateTime.now()),
                    style: context.textTheme.titleSmall?.copyWith(
                      color: home.onMedia,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
              const _NotificationButton(),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Container(
                width: 64,
                height: 64,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: home.textSecondary),
                ),
                child: ClipOval(
                  child: Image.asset(
                    HomeAssets.profileAvatar,
                    width: 72,
                    height: 108,
                    fit: BoxFit.cover,
                    alignment: Alignment.topCenter,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${HomeStrings.greetingPrefix}$userName!',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: context.textTheme.headlineLarge?.copyWith(
                        color: home.onMedia,
                        fontSize: 30,
                        fontWeight: FontWeight.w800,
                        height: 1.25,
                        letterSpacing: -0.6,
                      ),
                    ),
                    const SizedBox(height: 4),
                    const _UserBadges(),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Container(
            height: 48,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              color: home.searchSurface,
              borderRadius: BorderRadius.circular(32),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    HomeStrings.searchHint,
                    style: context.textTheme.bodyMedium?.copyWith(
                      color: home.onMedia,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                const HomeAssetIcon(HomeAssets.search),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _NotificationButton extends StatelessWidget {
  const _NotificationButton();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 48,
      height: 48,
      child: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: context.home.onMedia),
            ),
            child: const Center(child: HomeAssetIcon(HomeAssets.notification)),
          ),
          Positioned(
            right: 11,
            top: 9,
            child: SvgPicture.asset(
              HomeAssets.notificationBadge,
              width: 14,
              height: 14,
            ),
          ),
        ],
      ),
    );
  }
}

class _UserBadges extends StatelessWidget {
  const _UserBadges();

  @override
  Widget build(BuildContext context) {
    final home = context.home;
    return Wrap(
      spacing: 12,
      runSpacing: 4,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: home.greenDark,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const HomeAssetIcon(HomeAssets.starGreen, size: 20),
              const SizedBox(width: 4),
              Text(
                HomeStrings.proMember,
                style: context.textTheme.titleSmall?.copyWith(
                  color: context.home.green,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ),
        const _Badge(icon: HomeAssets.menu, label: HomeStrings.progress),
        const _Badge(
          icon: HomeAssets.moodHappy,
          label: HomeStrings.currentMood,
        ),
      ],
    );
  }
}

class _Badge extends StatelessWidget {
  const _Badge({required this.icon, required this.label});

  final String icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        HomeAssetIcon(icon, size: 20),
        const SizedBox(width: 4),
        Text(
          label,
          style: context.textTheme.titleSmall?.copyWith(
            color: context.home.onMedia,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }
}
