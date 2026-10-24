import 'package:flutter/material.dart';
import 'package:signals_flutter/signals_flutter.dart';
import 'package:dailypulse/core/di/injection.dart';
import '../../../features/mood/data/models/mood_entry.dart';
import '../../../core/utils/app_logger.dart';
import '../../../core/utils/date_utils.dart' as date_utils;
import '../widgets/date_selector.dart';
import '../widgets/empty_history_state.dart';
import '../widgets/mood_history_card.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  DateTime _selectedDate = DateTime.now();

  @override
  void initState() {
    super.initState();
    appComponent.moodSignal.reloadLocalEntries();
  }

  void _selectDate(DateTime date) {
    setState(() {
      _selectedDate = date;
    });
  }

  Future<void> _refreshData() async {
    if (appComponent.authSignal.user.value != null) {
      await appComponent.moodSignal.fetchMoodEntries(
        appComponent.authSignal.user.value!.uid,
      );
    }
  }

  List<MoodEntry> _getEntriesForSelectedDate(List<MoodEntry> allEntries) {
    appLogger.d('📊 Total entries from provider: ${allEntries.length}');
    appLogger.d('📅 Selected date: $_selectedDate');

    final filtered = allEntries.where((entry) {
      final isSame = date_utils.DateUtils.isSameDay(
        entry.timestamp,
        _selectedDate,
      );
      if (allEntries.length <= 10) {
        appLogger.d('  Entry: ${entry.timestamp} | Same day: $isSame');
      }
      return isSame;
    }).toList()..sort((a, b) => b.timestamp.compareTo(a.timestamp));

    appLogger.d('✅ Filtered entries for selected date: ${filtered.length}');
    return filtered;
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Column(
      children: [
        DateSelector(selectedDate: _selectedDate, onDateChange: _selectDate),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                date_utils.DateUtils.formatDate(_selectedDate),
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: isDark ? Colors.white : Colors.black87,
                ),
              ),
              SignalBuilder(
                builder: (context) => IconButton(
                  icon: appComponent.moodSignal.isLoading.value
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Icon(Icons.refresh),
                  onPressed: appComponent.moodSignal.isLoading.value
                      ? null
                      : _refreshData,
                  tooltip: 'Refresh from Firebase',
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        Expanded(
          child: StreamBuilder<List<MoodEntry>>(
            stream: appComponent.moodSignal.watchLocalEntries(),
            initialData: appComponent.moodSignal.entries.value,
            builder: (context, snapshot) {
              final allEntries = snapshot.data ?? [];
              final entries = _getEntriesForSelectedDate(allEntries);

              if (entries.isEmpty) {
                return EmptyHistoryState(selectedDate: _selectedDate);
              }

              return ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: entries.length,
                itemBuilder: (context, index) {
                  return MoodHistoryCard(entry: entries[index]);
                },
              );
            },
          ),
        ),
      ],
    );
  }
}
