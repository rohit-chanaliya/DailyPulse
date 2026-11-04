import 'package:inject_annotation/inject_annotation.dart';
import 'package:signals_flutter/signals_flutter.dart';

import 'package:dailypulse/core/utils/mood_series_utils.dart';
import '../../mood/models/mood_entry.dart';
import '../../mood/viewmodels/mood_signal.dart';

/// Derived insights state read from the shared mood entries signal.
@singleton
class InsightsSignal {
  @inject
  InsightsSignal(this._moodSignal);

  final MoodSignal _moodSignal;

  final granularity = signal<MoodGranularity>(MoodGranularity.all);

  Signal<List<MoodEntry>> get entries => _moodSignal.entries;

  late final seriesPoints = computed<List<MoodPoint>>(
    () => MoodSeriesUtils.series(_moodSignal.entries.value, granularity.value),
  );

  late final weekAverages = computed<List<double?>>(
    () => MoodSeriesUtils.weekAverages(_moodSignal.entries.value, DateTime.now()),
  );

  List<MoodEntry> getAllEntries() => _moodSignal.orderedEntries.value;
}
