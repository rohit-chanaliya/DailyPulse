import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:dailypulse/core/constant/strings/profile_strings.dart';
import 'package:dailypulse/core/constant/strings/settings_strings.dart';
import 'package:dailypulse/core/theme/context_extensions.dart';
import 'package:dailypulse/core/widgets/app_top_nav.dart';
import 'package:dailypulse/features/settings/views/widgets/curved_banner.dart';
import 'package:dailypulse/features/settings/views/widgets/profile_avatar.dart';

/// Profile top section: banner, back button, avatar, name and member tag.
class ProfileHeroHeader extends StatelessWidget {
  const ProfileHeroHeader({
    super.key,
    required this.onEdit,
    this.name,
    this.memberSince,
    this.imagePath,
    this.avatarId,
    this.photoUrl,
  });

  final String? name;
  final DateTime? memberSince;
  final String? imagePath;
  final String? avatarId;
  final String? photoUrl;
  final VoidCallback onEdit;

  @override
  Widget build(BuildContext context) {
    final home = context.home;
    final top = MediaQuery.paddingOf(context).top;
    final displayName = (name?.trim().isNotEmpty ?? false)
        ? name!.trim()
        : SettingsStrings.defaultName;

    return Column(
      children: [
        SizedBox(
          height: top + 274,
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              Positioned.fill(
                child: CurvedBanner(color: home.greenDark, bottom: top + 201),
              ),
              Positioned(
                top: top + 16,
                left: 16,
                right: 16,
                child: AppTopNav(color: home.onMedia),
              ),
              Positioned(
                top: top + 158,
                left: 0,
                right: 0,
                child: Center(
                  child: SizedBox(
                    width: 96,
                    height: 116,
                    child: Stack(
                      clipBehavior: Clip.none,
                      children: [
                        ProfileAvatar(
                          size: 96,
                          borderWidth: 4,
                          name: displayName,
                          imagePath: imagePath,
                          avatarId: avatarId,
                          photoUrl: photoUrl,
                        ),
                        Positioned(
                          top: 76,
                          left: 28,
                          child: Tooltip(
                            message: ProfileStrings.editProfile,
                            child: Material(
                              color: home.headerSurface,
                              shape: const CircleBorder(),
                              clipBehavior: Clip.antiAlias,
                              child: InkWell(
                                onTap: onEdit,
                                child: SizedBox(
                                  width: 40,
                                  height: 40,
                                  child: Icon(
                                    Icons.edit_outlined,
                                    size: 22,
                                    color: home.onMedia,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            spacing: 12,
            children: [
              Text(
                displayName,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: context.textTheme.headlineLarge?.copyWith(
                  color: home.textPrimary,
                ),
              ),
              if (memberSince != null)
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
                  decoration: ShapeDecoration(
                    color: home.greenDark,
                    shape: const StadiumBorder(),
                  ),
                  child: Text(
                    '${SettingsStrings.memberSincePrefix}'
                    '${DateFormat('MMM yyyy').format(memberSince!)}'
                        .toUpperCase(),
                    style: context.textTheme.labelSmall?.copyWith(
                      color: home.green,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 1.2,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }
}
