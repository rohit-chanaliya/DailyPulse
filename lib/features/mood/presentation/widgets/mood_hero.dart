import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:dailypulse/core/constant/strings/mood_strings.dart';
import 'package:dailypulse/core/theme/context_extensions.dart';
import 'package:dailypulse/core/utils/mood_utils.dart';
import 'package:dailypulse/features/mood/presentation/widgets/mood_face.dart';
import 'package:dailypulse/features/mood/presentation/widgets/mood_hero_background.dart';

/// Top panel: back button, level pill, "Your mood is X" and a face switcher.
class MoodHero extends StatelessWidget {
  const MoodHero({
    super.key,
    required this.level,
    required this.onOlder,
    required this.onNewer,
  });

  /// Mood level shown, or `null` when nothing has been logged.
  final int? level;

  /// Steps to an older / newer entry; `null` disables the chevron.
  final VoidCallback? onOlder;
  final VoidCallback? onNewer;

  static const double height = 400;

  @override
  Widget build(BuildContext context) {
    final home = context.home;
    final palette = context.logMood;
    final shown = level;
    final label = shown == null
        ? MoodStrings.emptyHero
        : MoodUtils.getMoodOptions()[shown].label;

    return MoodHeroBackground(
      color: home.headerSurface,
      lineColor: home.accent.withValues(alpha: 0.35),
      child: SizedBox(
        height: height + MediaQuery.paddingOf(context).top,
        child: SafeArea(
          bottom: false,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 56),
            child: Column(
              children: [
                Row(
                  children: [
                    IconButton(
                      tooltip: MoodStrings.backLabel,
                      onPressed: () => context.pop(),
                      icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 18),
                      color: home.onMedia,
                      style: IconButton.styleFrom(
                        fixedSize: const Size(52, 52),
                        side: BorderSide(color: home.onMedia),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Text(
                      MoodStrings.title,
                      style: context.textTheme.headlineMedium?.copyWith(
                        color: home.onMedia,
                      ),
                    ),
                    const Spacer(),
                    if (shown != null)
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 10,
                        ),
                        decoration: BoxDecoration(
                          color: home.accent,
                          borderRadius: BorderRadius.circular(22),
                        ),
                        child: Text(
                          '${MoodStrings.levelPrefix}${shown + 1}',
                          style: context.textTheme.labelMedium?.copyWith(
                            color: home.onMedia,
                            fontWeight: FontWeight.w800,
                            letterSpacing: 2,
                          ),
                        ),
                      ),
                  ],
                ),
                const Spacer(),
                Text(
                  MoodStrings.yourMoodIs,
                  style: context.textTheme.headlineMedium?.copyWith(
                    color: home.onMedia,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text(
                    label,
                    style: context.textTheme.displayLarge?.copyWith(
                      color: home.onMedia,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
                const Spacer(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _Chevron(
                      icon: Icons.chevron_left_rounded,
                      tooltip: MoodStrings.olderEntry,
                      onPressed: onOlder,
                    ),
                    const SizedBox(width: 16),
                    if (shown != null)
                      MoodFace(
                        level: shown,
                        size: 96,
                        glow: false,
                        faceColor: palette.faces[shown],
                        featureColor: home.headerSurface,
                      )
                    else
                      const SizedBox(width: 96, height: 96),
                    const SizedBox(width: 16),
                    _Chevron(
                      icon: Icons.chevron_right_rounded,
                      tooltip: MoodStrings.newerEntry,
                      onPressed: onNewer,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _Chevron extends StatelessWidget {
  const _Chevron({
    required this.icon,
    required this.tooltip,
    required this.onPressed,
  });

  final IconData icon;
  final String tooltip;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    final home = context.home;

    return IconButton(
      tooltip: tooltip,
      onPressed: onPressed,
      icon: Icon(icon, size: 28),
      color: home.onMedia,
      disabledColor: home.onMedia.withValues(alpha: 0.25),
    );
  }
}
