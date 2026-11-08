import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:signals_flutter/signals_flutter.dart';

import 'package:dailypulse/core/constant/constants.dart';
import 'package:dailypulse/core/constant/strings/home_strings.dart';
import 'package:dailypulse/core/di/injection.dart';
import 'package:dailypulse/core/router/app_routes.dart';
import 'package:dailypulse/core/theme/context_extensions.dart';
import 'package:dailypulse/core/utils/mood_stats_utils.dart';
import 'package:dailypulse/features/mood/models/home_assets.dart';
import 'package:dailypulse/features/settings/views/widgets/profile_avatar.dart';
import 'home_asset_icon.dart';

/// Home top section: date, check-in bell, avatar, greeting and live badges.
class HomeHeader extends StatelessWidget {
  const HomeHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final home = context.home;

    return SignalBuilder(
      builder: (context) {
        final auth = appComponent.authSignal;
        final user = auth.user.value;
        final profile = auth.profile.value;
        final entries = appComponent.moodSignal.entries.value;
        final now = DateTime.now();
        final today = DateTime(now.year, now.month, now.day);

        final profileFirst = profile?.firstName.trim() ?? '';
        final firstName = profileFirst.isNotEmpty
            ? profileFirst
            : user?.displayName?.trim().split(' ').first;
        final greetingName = (firstName?.isNotEmpty ?? false)
            ? firstName!
            : HomeStrings.defaultUserName;
        final avatarName = profile?.fullName.isNotEmpty == true
            ? profile!.fullName
            : user?.displayName;

        final sorted = [...entries]
          ..sort((a, b) => b.timestamp.compareTo(a.timestamp));
        final latestLevel = sorted.isEmpty ? null : sorted.first.moodLevel;

        return Container(
          padding: EdgeInsets.fromLTRB(
            16,
            MediaQuery.paddingOf(context).top + 12,
            16,
            28,
          ),
          decoration: BoxDecoration(
            color: home.headerSurface,
            borderRadius: const BorderRadius.vertical(
              bottom: Radius.circular(40),
            ),
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
                        DateFormat('E, d MMM y').format(now),
                        style: context.textTheme.titleSmall?.copyWith(
                          color: home.onMedia,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                  _NotificationButton(
                    showBadge: !MoodStatsUtils.loggedDays(
                      entries,
                    ).contains(today),
                    onTap: () => context.push(AppRoutes.logMood),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  GestureDetector(
                    onTap: () => context.push(AppRoutes.profile),
                    child: Container(
                      width: 64,
                      height: 64,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: home.textSecondary),
                      ),
                      child: ProfileAvatar(
                        size: 62,
                        name: avatarName,
                        imagePath: auth.profileImagePath.value,
                        avatarId: profile?.avatarId,
                        photoUrl: user?.photoURL,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${HomeStrings.greetingPrefix}$greetingName!',
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
                        _UserBadges(
                          streak: MoodStatsUtils.currentStreak(
                            entries,
                            now: now,
                          ),
                          score: MoodStatsUtils.moodScore(entries, now: now),
                          latestLevel: latestLevel,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}

class _NotificationButton extends StatelessWidget {
  const _NotificationButton({required this.showBadge, required this.onTap});

  /// Shown while today has no mood entry yet.
  final bool showBadge;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: HomeStrings.checkInTooltip,
      child: GestureDetector(
        onTap: onTap,
        child: SizedBox(
          width: 48,
          height: 48,
          child: Stack(
            children: [
              Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: context.home.onMedia),
                ),
                child: const Center(
                  child: HomeAssetIcon(HomeAssets.notification),
                ),
              ),
              if (showBadge)
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
        ),
      ),
    );
  }
}

class _UserBadges extends StatelessWidget {
  const _UserBadges({
    required this.streak,
    required this.score,
    required this.latestLevel,
  });

  final int streak;
  final int? score;
  final int? latestLevel;

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
                streak > 0
                    ? '$streak ${HomeStrings.dayStreak}'
                    : HomeStrings.startStreak,
                style: context.textTheme.titleSmall?.copyWith(
                  color: home.green,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ),
        _Badge(
          leading: const HomeAssetIcon(HomeAssets.menu, size: 20),
          label: score == null ? HomeStrings.noValue : '$score%',
        ),
        _Badge(
          leading: Text(
            latestLevel == null ? '' : AppConstants.moodEmojis[latestLevel!],
            style: const TextStyle(fontSize: 16),
          ),
          label: latestLevel == null
              ? HomeStrings.moodNotLogged
              : AppConstants.moodLabels[latestLevel!],
        ),
      ],
    );
  }
}

class _Badge extends StatelessWidget {
  const _Badge({required this.leading, required this.label});

  final Widget leading;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        leading,
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
