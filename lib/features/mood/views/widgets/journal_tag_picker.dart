import 'package:flutter/material.dart';

import 'package:dailypulse/core/constant/strings/journal_strings.dart';
import 'package:dailypulse/core/theme/context_extensions.dart';
import 'package:dailypulse/core/theme/typography/app_typography.dart';

/// Interactive tag chip picker for mood reflections.
class JournalTagPicker extends StatelessWidget {
  const JournalTagPicker({
    super.key,
    required this.selectedTags,
    required this.onTagToggled,
  });

  final Set<String> selectedTags;
  final ValueChanged<String> onTagToggled;

  static IconData iconForTag(String tag) => switch (tag.toLowerCase()) {
        'sleep' => Icons.bed_rounded,
        'work' => Icons.work_outline_rounded,
        'family' => Icons.family_restroom_rounded,
        'friends' => Icons.people_outline_rounded,
        'exercise' => Icons.fitness_center_rounded,
        'loneliness' => Icons.cloud_outlined,
        'health' => Icons.healing_rounded,
        _ => Icons.tag_rounded,
      };

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: [
        for (final tag in JournalStrings.defaultTags)
          _TagChip(
            tag: tag,
            icon: iconForTag(tag),
            isSelected: selectedTags.contains(tag),
            onTap: () => onTagToggled(tag),
          ),
      ],
    );
  }
}

class _TagChip extends StatelessWidget {
  const _TagChip({
    required this.tag,
    required this.icon,
    required this.isSelected,
    required this.onTap,
  });

  final String tag;
  final IconData icon;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final home = context.home;

    final bgColor = isSelected ? home.accent : home.surface;
    final borderColor = isSelected
        ? home.accent
        : home.textMuted.withValues(alpha: 0.25);
    final fgColor = isSelected ? home.onMedia : home.textSecondary;

    return Semantics(
      button: true,
      selected: isSelected,
      label: tag,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(20),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 180),
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
            decoration: BoxDecoration(
              color: bgColor,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: borderColor, width: 1.2),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(icon, size: 16, color: fgColor),
                const SizedBox(width: 6),
                Text(
                  tag,
                  style: AppTypography.textXsBold.copyWith(
                    color: fgColor,
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
