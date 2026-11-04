import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:dailypulse/core/constant/strings/settings_strings.dart';
import 'package:dailypulse/core/theme/context_extensions.dart';

/// Account summary: initial avatar, name, email and two info chips.
class UserProfileCard extends StatelessWidget {
  const UserProfileCard({
    super.key,
    this.displayName,
    this.email,
    this.memberSince,
    this.entryCount = 0,
  });

  final String? displayName;
  final String? email;
  final DateTime? memberSince;
  final int entryCount;

  @override
  Widget build(BuildContext context) {
    final home = context.home;
    final name = (displayName?.trim().isNotEmpty ?? false)
        ? displayName!.trim()
        : SettingsStrings.defaultName;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: home.headerSurface,
        borderRadius: BorderRadius.circular(32),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 72,
                height: 72,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: home.accent,
                ),
                child: Text(
                  name[0].toUpperCase(),
                  style: context.textTheme.displaySmall?.copyWith(
                    color: home.onMedia,
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: context.textTheme.headlineLarge?.copyWith(
                        color: home.onMedia,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      email ?? SettingsStrings.noEmail,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: context.textTheme.bodyMedium?.copyWith(
                        color: home.onMedia.withValues(alpha: 0.7),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              if (memberSince != null)
                _InfoChip(
                  icon: Icons.calendar_today_outlined,
                  label:
                      '${SettingsStrings.memberSincePrefix}'
                      '${DateFormat('MMM y').format(memberSince!)}',
                  background: home.greenDark,
                  foreground: home.green,
                ),
              _InfoChip(
                icon: Icons.edit_note_rounded,
                label: '$entryCount${SettingsStrings.entriesSuffix}',
                background: home.yellowDark,
                foreground: home.yellow,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _InfoChip extends StatelessWidget {
  const _InfoChip({
    required this.icon,
    required this.label,
    required this.background,
    required this.foreground,
  });

  final IconData icon;
  final String label;
  final Color background;
  final Color foreground;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: foreground),
          const SizedBox(width: 6),
          Text(
            label,
            style: context.textTheme.labelMedium?.copyWith(color: foreground),
          ),
        ],
      ),
    );
  }
}
