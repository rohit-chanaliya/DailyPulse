import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';

import 'package:dailypulse/core/constant/strings/log_mood_strings.dart';
import 'package:dailypulse/core/di/injection.dart';
import 'package:dailypulse/core/router/app_routes.dart';
import 'package:dailypulse/core/theme/context_extensions.dart';
import 'package:dailypulse/core/utils/mood_utils.dart';
import 'package:dailypulse/core/utils/snackbar_utils.dart';
import 'package:dailypulse/features/mood/presentation/models/journal_entry_args.dart';
import 'package:dailypulse/features/mood/presentation/widgets/log_mood_top_bar.dart';
import 'package:dailypulse/features/mood/presentation/widgets/mood_arc_slider.dart';
import 'package:dailypulse/features/mood/presentation/widgets/mood_face.dart';

/// Immersive mood logging: pick a level on the arc, tap "Set Mood" to save.
/// The top-bar journal action opens the full journal entry form instead.
class LogMoodScreen extends StatefulWidget {
  const LogMoodScreen({super.key, this.initialLevel = defaultLevel});

  final int initialLevel;

  /// Neutral, the middle of the scale.
  static const int defaultLevel = 3;

  @override
  State<LogMoodScreen> createState() => _LogMoodScreenState();
}

class _LogMoodScreenState extends State<LogMoodScreen> {
  late int _level = widget.initialLevel;
  DateTime? _timestamp;
  bool _saving = false;

  Future<void> _save() async {
    final userId = appComponent.authSignal.user.value?.uid;
    if (userId == null) {
      SnackBarUtils.showError(context, LogMoodStrings.signInRequired);
      return;
    }

    setState(() => _saving = true);
    final success = await appComponent.moodSignal.saveMood(
      moodLevel: _level,
      userId: userId,
      timestamp: _timestamp,
    );
    if (!mounted) return;

    if (success) {
      SnackBarUtils.showSuccess(context, LogMoodStrings.saved);
    } else {
      SnackBarUtils.showInfo(context, LogMoodStrings.savedOffline);
    }
    context.pop();
  }

  Future<void> _openJournal() async {
    final saved = await context.push<bool>(
      AppRoutes.journalEntry,
      extra: JournalEntryArgs(level: _level, timestamp: _timestamp),
    );
    if (saved == true && mounted) context.pop();
  }

  @override
  Widget build(BuildContext context) {
    final palette = context.logMood;
    final label = MoodUtils.getMoodOptions()[_level].label;
    final userName =
        appComponent.authSignal.user.value?.displayName?.split(' ').first ??
        LogMoodStrings.defaultUserName;
    final background = palette.backgrounds[_level];

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light.copyWith(
        statusBarColor: Colors.transparent,
        systemNavigationBarColor: background,
      ),
      child: Scaffold(
        backgroundColor: background,
        body: AnimatedContainer(
          duration: const Duration(milliseconds: 350),
          color: background,
          child: SafeArea(
            child: Column(
              children: [
                LogMoodTopBar(
                  timestamp: _timestamp,
                  onTimestampChanged: (v) => setState(() => _timestamp = v),
                  onJournalTap: _openJournal,
                ),
                Expanded(
                  child: CustomScrollView(
                    slivers: [
                      SliverFillRemaining(
                        hasScrollBody: false,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: Column(
                            children: [
                              const Spacer(),
                              Text(
                                '${LogMoodStrings.greetingPrefix}$userName'
                                '${LogMoodStrings.greetingSuffix}',
                                style: context.textTheme.bodyLarge?.copyWith(
                                  color: palette.onMood,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                ),
                                child: Text(
                                  LogMoodStrings.question,
                                  textAlign: TextAlign.center,
                                  style: context.textTheme.headlineMedium
                                      ?.copyWith(
                                        color: palette.onMood,
                                        fontWeight: FontWeight.w700,
                                      ),
                                ),
                              ),
                              const Spacer(flex: 2),
                              AnimatedSwitcher(
                                duration: const Duration(milliseconds: 250),
                                transitionBuilder: (child, animation) =>
                                    ScaleTransition(
                                      scale: animation,
                                      child: FadeTransition(
                                        opacity: animation,
                                        child: child,
                                      ),
                                    ),
                                child: MoodFace(
                                  key: ValueKey(_level),
                                  level: _level,
                                  faceColor: palette.faces[_level],
                                  featureColor: background,
                                ),
                              ),
                              const Spacer(flex: 2),
                              Text(
                                '${LogMoodStrings.feelingPrefix}$label',
                                style: context.textTheme.titleMedium?.copyWith(
                                  color: palette.onMood,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              const SizedBox(height: 32),
                              MoodArcSlider(
                                level: _level,
                                onChanged: (v) => setState(() => _level = v),
                              ),
                              const Spacer(),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
                  child: SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: FilledButton(
                      onPressed: _saving ? null : _save,
                      style: FilledButton.styleFrom(
                        backgroundColor: palette.buttonSurface,
                        foregroundColor: palette.onButton,
                        disabledBackgroundColor: palette.buttonSurface
                            .withValues(alpha: 0.6),
                        shape: const StadiumBorder(),
                      ),
                      child: _saving
                          ? SizedBox.square(
                              dimension: 22,
                              child: CircularProgressIndicator(
                                strokeWidth: 2.5,
                                color: palette.onButton,
                              ),
                            )
                          : Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  LogMoodStrings.setMood,
                                  style: context.textTheme.titleSmall?.copyWith(
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                const SizedBox(width: 12),
                                const Icon(Icons.check_rounded, size: 20),
                              ],
                            ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
