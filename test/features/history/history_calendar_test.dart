import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:dailypulse/core/theme/light_theme.dart';
import 'package:dailypulse/features/history/views/widgets/history_calendar_strip.dart';
import 'package:dailypulse/features/mood/models/mood_entry.dart';

void main() {
  testWidgets('HistoryCalendarStrip renders and triggers date selection',
      (tester) async {
    DateTime? selected;

    final testEntries = [
      MoodEntry(
        timestamp: DateTime.now().subtract(const Duration(days: 1)),
        moodLevel: 4,
      ),
    ];

    await tester.pumpWidget(
      MaterialApp(
        theme: lightTheme,
        home: Scaffold(
          body: HistoryCalendarStrip(
            selectedDate: selected,
            onDateSelected: (d) => selected = d,
            entries: testEntries,
            onBackfillPressed: () {},
          ),
        ),
      ),
    );

    expect(find.byType(HistoryCalendarStrip), findsOneWidget);
    expect(find.byType(ListView), findsOneWidget);

    // Tap on the first visible day cell in the strip (29 days ago)
    final firstDayNumber =
        DateTime.now().subtract(const Duration(days: 29)).day.toString();
    final dayFinder = find.text(firstDayNumber);
    expect(dayFinder, findsWidgets);
    await tester.tap(dayFinder.first);
    await tester.pumpAndSettle();

    expect(selected, isNotNull);
  });
}
