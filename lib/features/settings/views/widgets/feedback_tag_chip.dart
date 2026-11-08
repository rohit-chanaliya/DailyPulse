import 'package:flutter/material.dart';

import 'package:dailypulse/core/theme/context_extensions.dart';
import 'package:dailypulse/features/settings/models/feedback_tag.dart';

/// Pill chip that is outlined when idle and filled with a color when picked.
class FeedbackTagChip extends StatelessWidget {
  const FeedbackTagChip({
    super.key,
    required this.tag,
    required this.selected,
    required this.onTap,
  });

  final FeedbackTag tag;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final home = context.home;
    final fill = switch (tag) {
      FeedbackTag.performance || FeedbackTag.loading => home.purple,
      FeedbackTag.bug || FeedbackTag.crashes => home.orange,
      FeedbackTag.userExperience || FeedbackTag.support => home.green,
      FeedbackTag.navigation => home.yellow,
    };

    return Semantics(
      button: true,
      selected: selected,
      label: tag.label,
      child: Material(
        color: selected ? fill : Colors.transparent,
        shape: StadiumBorder(
          side: BorderSide(color: selected ? fill : home.textPrimary),
        ),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 18),
            child: Text(
              tag.label.toUpperCase(),
              style: context.textTheme.titleMedium?.copyWith(
                color: selected ? home.onMedia : home.textPrimary,
                letterSpacing: 2,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
