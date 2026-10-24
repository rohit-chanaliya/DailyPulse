import 'package:inject_annotation/inject_annotation.dart';
import 'package:signals_flutter/signals_flutter.dart';

import '../../../mood/data/models/mood_entry.dart';
import '../../../mood/presentation/signals/mood_signal.dart';

/// Insights read from the shared mood entries signal.
@singleton
class InsightsSignal {
  @inject
  InsightsSignal(this._moodSignal);

  final MoodSignal _moodSignal;

  Signal<List<MoodEntry>> get entries => _moodSignal.entries;

  List<MoodEntry> getAllEntries() => _moodSignal.entries.value;
}
