import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:signals_flutter/signals_flutter.dart';

import 'package:dailypulse/core/di/injection.dart';
import 'package:dailypulse/core/theme/context_extensions.dart';
import 'package:dailypulse/core/utils/mood_series_utils.dart';
import 'package:dailypulse/features/mood/models/mood_entry.dart';
import 'package:dailypulse/features/mood/views/widgets/mood_hero.dart';
import 'package:dailypulse/features/mood/views/widgets/mood_week_bars.dart';

/// Current mood hero with a browser over recent entries and a 7-day bar chart.
class MoodScreen extends StatefulWidget {
  const MoodScreen({super.key});

  @override
  State<MoodScreen> createState() => _MoodScreenState();
}

class _MoodScreenState extends State<MoodScreen> {
  /// Position in the newest-first entry list; 0 is the latest entry.
  int _index = 0;

  void _step(int delta, int length) {
    final next = (_index + delta).clamp(0, length - 1);
    if (next != _index) {
      HapticFeedback.selectionClick();
      setState(() => _index = next);
    }
  }

  @override
  Widget build(BuildContext context) {
    final home = context.home;

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light,
      child: Scaffold(
        backgroundColor: home.background,
        body: SignalBuilder(
          builder: (context) {
            final entries = [...appComponent.insightsSignal.getAllEntries()]
              ..sort((a, b) => b.timestamp.compareTo(a.timestamp));
            final index = entries.isEmpty
                ? 0
                : _index.clamp(0, entries.length - 1);
            final MoodEntry? current = entries.isEmpty ? null : entries[index];
            final week = MoodSeriesUtils.lastDaysAverages(
              entries,
              7,
              DateTime.now(),
            );

            return SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  MoodHero(
                    level: current?.moodLevel,
                    onOlder: index < entries.length - 1
                        ? () => _step(1, entries.length)
                        : null,
                    onNewer: index > 0 ? () => _step(-1, entries.length) : null,
                  ),
                  const SizedBox(height: 16),
                  MoodWeekBars(averages: week, today: DateTime.now()),
                  SizedBox(height: 32 + MediaQuery.paddingOf(context).bottom),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
