import 'package:signals_flutter/signals_flutter.dart';

import '../../../mood/data/models/mood_entry.dart';
import '../../../mood/presentation/signals/mood_signal.dart';

/// Insights read from the shared mood entries signal.
class InsightsSignal {
  Signal<List<MoodEntry>> get entries => moodSignal.entries;

  List<MoodEntry> getAllEntries() => moodSignal.entries.value;
}

final insightsSignal = InsightsSignal();
