import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:dailypulse/core/constant/strings/profile_strings.dart';
import 'package:dailypulse/core/constant/strings/settings_strings.dart';
import 'package:dailypulse/core/theme/context_extensions.dart';
import 'package:dailypulse/features/settings/views/widgets/curved_banner.dart';
import 'package:dailypulse/features/settings/views/widgets/profile_avatar.dart';

/// Curved banner with title, avatar, quick actions, name, email and join date.
class SettingsHeader extends StatelessWidget {
  const SettingsHeader({
    super.key,
    required this.onAvatarTap,
    required this.onEditProfile,
    required this.onMoodInsights,
    this.displayName,
    this.email,
    this.memberSince,
    this.imagePath,
    this.avatarId,
    this.photoUrl,
  });

  final String? displayName;
  final String? email;
  final DateTime? memberSince;
  final String? imagePath;
  final String? avatarId;
  final String? photoUrl;
  final VoidCallback onAvatarTap;
  final VoidCallback onEditProfile;
  final VoidCallback onMoodInsights;

  @override
  Widget build(BuildContext context) {
    final home = context.home;
    final top = MediaQuery.paddingOf(context).top;
    final name = (displayName?.trim().isNotEmpty ?? false)
        ? displayName!.trim()
        : SettingsStrings.defaultName;

    return Column(
      children: [
        SizedBox(
          height: top + 218,
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              Positioned.fill(
                child: CurvedBanner(color: home.greenDark, bottom: top + 158),
              ),
              Positioned(
                top: top + 16,
                left: 16,
                right: 16,
                child: SizedBox(
                  height: 48,
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      SettingsStrings.title,
                      style: context.textTheme.headlineMedium?.copyWith(
                        color: home.onMedia,
                      ),
                    ),
                  ),
                ),
              ),
              Positioned(
                top: top + 104,
                left: 35,
                child: _HeaderAction(
                  icon: Icons.sentiment_satisfied_alt_rounded,
                  color: home.green,
                  tooltip: SettingsStrings.moodInsights,
                  onTap: onMoodInsights,
                ),
              ),
              Positioned(
                top: top + 104,
                right: 35,
                child: _HeaderAction(
                  icon: Icons.edit_outlined,
                  color: home.orange,
                  tooltip: ProfileStrings.editProfile,
                  onTap: onEditProfile,
                ),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: GestureDetector(
                  onTap: onAvatarTap,
                  child: ProfileAvatar(
                    size: 128,
                    borderWidth: 4,
                    name: name,
                    imagePath: imagePath,
                    avatarId: avatarId,
                    photoUrl: photoUrl,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            spacing: 8,
            children: [
              Text(
                name,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: context.textTheme.headlineLarge?.copyWith(
                  color: home.textPrimary,
                ),
              ),
              Text(
                email ?? SettingsStrings.noEmail,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: context.textTheme.titleMedium?.copyWith(
                  color: home.textSecondary,
                ),
              ),
              if (memberSince != null)
                Text(
                  '${SettingsStrings.memberSincePrefix}'
                  '${DateFormat('MMM yyyy').format(memberSince!)}',
                  style: context.textTheme.titleMedium?.copyWith(
                    color: home.textMuted,
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }
}

class _HeaderAction extends StatelessWidget {
  const _HeaderAction({
    required this.icon,
    required this.color,
    required this.tooltip,
    required this.onTap,
  });

  final IconData icon;
  final Color color;
  final String tooltip;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: tooltip,
      child: Material(
        color: color,
        shape: const CircleBorder(),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onTap,
          child: SizedBox(
            width: 64,
            height: 64,
            child: Icon(icon, size: 24, color: context.home.onMedia),
          ),
        ),
      ),
    );
  }
}
