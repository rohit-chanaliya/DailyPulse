import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:dailypulse/core/theme/context_extensions.dart';
import 'package:dailypulse/core/utils/mood_utils.dart';
import 'package:dailypulse/features/mood/presentation/widgets/mood_face.dart';

/// Horizontal row of mood faces; the chosen one is ringed.
class JournalEmotionPicker extends StatefulWidget {
  const JournalEmotionPicker({
    super.key,
    required this.level,
    required this.onChanged,
  });

  final int level;
  final ValueChanged<int> onChanged;

  static const double faceSize = 56;
  static const double ringGap = 4;
  static const double spacing = 12;

  @override
  State<JournalEmotionPicker> createState() => _JournalEmotionPickerState();
}

class _JournalEmotionPickerState extends State<JournalEmotionPicker> {
  static const double _slot =
      JournalEmotionPicker.faceSize +
      JournalEmotionPicker.ringGap * 2 +
      JournalEmotionPicker.spacing;

  late final ScrollController _controller = ScrollController(
    initialScrollOffset: math.max(0, widget.level * _slot - _slot * 2),
  );

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final home = context.home;
    final palette = context.logMood;
    final moods = MoodUtils.getMoodOptions();

    return SizedBox(
      height: JournalEmotionPicker.faceSize + JournalEmotionPicker.ringGap * 2,
      child: ListView.separated(
        controller: _controller,
        scrollDirection: Axis.horizontal,
        itemCount: moods.length,
        separatorBuilder: (_, _) =>
            const SizedBox(width: JournalEmotionPicker.spacing),
        itemBuilder: (context, i) {
          final selected = i == widget.level;
          return Semantics(
            button: true,
            selected: selected,
            label: moods[i].label,
            child: GestureDetector(
              onTap: () {
                if (!selected) HapticFeedback.selectionClick();
                widget.onChanged(i);
              },
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: const EdgeInsets.all(JournalEmotionPicker.ringGap),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: selected ? home.textPrimary : Colors.transparent,
                    width: 2,
                  ),
                ),
                child: MoodFace(
                  level: i,
                  size: JournalEmotionPicker.faceSize,
                  faceColor: palette.faces[i],
                  featureColor: palette.backgrounds[i],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
