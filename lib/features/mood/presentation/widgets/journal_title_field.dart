import 'package:flutter/material.dart';

import 'package:dailypulse/core/constant/strings/journal_strings.dart';
import 'package:dailypulse/core/theme/context_extensions.dart';

/// Pill-shaped single-line title input.
class JournalTitleField extends StatelessWidget {
  const JournalTitleField({super.key, required this.controller});

  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    final home = context.home;

    return Container(
      height: 52,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: home.surface,
        borderRadius: BorderRadius.circular(26),
      ),
      child: Row(
        children: [
          Icon(Icons.description_outlined, size: 20, color: home.textPrimary),
          const SizedBox(width: 12),
          Expanded(
            child: TextField(
              controller: controller,
              maxLength: JournalStrings.maxTitleLength,
              textCapitalization: TextCapitalization.sentences,
              style: context.textTheme.bodyMedium?.copyWith(
                color: home.textPrimary,
              ),
              decoration: InputDecoration(
                hintText: JournalStrings.titleHint,
                hintStyle: context.textTheme.bodyMedium?.copyWith(
                  color: home.textMuted,
                ),
                counterText: '',
                border: InputBorder.none,
                isCollapsed: true,
              ),
            ),
          ),
          const SizedBox(width: 8),
          Icon(Icons.edit_outlined, size: 20, color: home.textPrimary),
        ],
      ),
    );
  }
}
