import 'package:flutter/material.dart';

import 'package:dailypulse/core/constant/strings/history_strings.dart';
import 'package:dailypulse/core/theme/context_extensions.dart';

/// Outlined pill that switches between newest-first and oldest-first.
class JournalSortPill extends StatelessWidget {
  const JournalSortPill({
    super.key,
    required this.newestFirst,
    required this.onChanged,
  });

  final bool newestFirst;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    final home = context.home;

    return PopupMenuButton<bool>(
      tooltip: HistoryStrings.sortTooltip,
      onSelected: onChanged,
      color: home.surface,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      itemBuilder: (_) => const [
        PopupMenuItem(value: true, child: Text(HistoryStrings.newest)),
        PopupMenuItem(value: false, child: Text(HistoryStrings.oldest)),
      ],
      child: Container(
        height: 40,
        padding: const EdgeInsets.symmetric(horizontal: 14),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: home.textPrimary.withValues(alpha: 0.85)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.swap_vert_rounded, size: 20, color: home.textPrimary),
            const SizedBox(width: 8),
            Text(
              newestFirst ? HistoryStrings.newest : HistoryStrings.oldest,
              style: context.textTheme.labelLarge?.copyWith(
                color: home.textPrimary,
              ),
            ),
            const SizedBox(width: 4),
            Icon(
              Icons.keyboard_arrow_down_rounded,
              size: 20,
              color: home.textPrimary,
            ),
          ],
        ),
      ),
    );
  }
}
