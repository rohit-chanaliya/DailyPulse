import 'package:flutter/material.dart';

import 'package:dailypulse/core/constant/strings/journal_strings.dart';
import 'package:dailypulse/core/theme/context_extensions.dart';

/// Multi-line entry box with undo/redo and a character counter.
class JournalEntryBox extends StatefulWidget {
  const JournalEntryBox({super.key, required this.controller});

  final TextEditingController controller;

  @override
  State<JournalEntryBox> createState() => _JournalEntryBoxState();
}

class _JournalEntryBoxState extends State<JournalEntryBox> {
  final _undo = UndoHistoryController();

  @override
  void dispose() {
    _undo.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final home = context.home;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: home.surface,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: home.searchSurface.withValues(alpha: 0.6)),
      ),
      child: Column(
        children: [
          Expanded(
            child: TextField(
              controller: widget.controller,
              undoController: _undo,
              expands: true,
              maxLines: null,
              minLines: null,
              textAlignVertical: TextAlignVertical.top,
              maxLength: JournalStrings.maxEntryLength,
              textCapitalization: TextCapitalization.sentences,
              style: context.textTheme.titleMedium?.copyWith(
                color: home.textPrimary,
                fontWeight: FontWeight.w500,
              ),
              decoration: InputDecoration(
                hintText: JournalStrings.entryHint,
                hintStyle: context.textTheme.titleMedium?.copyWith(
                  color: home.textMuted,
                ),
                counterText: '',
                border: InputBorder.none,
              ),
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              ValueListenableBuilder<UndoHistoryValue>(
                valueListenable: _undo,
                builder: (context, value, _) => Row(
                  children: [
                    _HistoryButton(
                      icon: Icons.undo_rounded,
                      tooltip: JournalStrings.undo,
                      onPressed: value.canUndo ? _undo.undo : null,
                    ),
                    const SizedBox(width: 8),
                    _HistoryButton(
                      icon: Icons.redo_rounded,
                      tooltip: JournalStrings.redo,
                      onPressed: value.canRedo ? _undo.redo : null,
                    ),
                  ],
                ),
              ),
              const Spacer(),
              Icon(Icons.description_outlined, size: 18, color: home.textMuted),
              const SizedBox(width: 6),
              ValueListenableBuilder<TextEditingValue>(
                valueListenable: widget.controller,
                builder: (context, value, _) => Text(
                  '${value.text.characters.length}/'
                  '${JournalStrings.maxEntryLength}',
                  style: context.textTheme.labelMedium?.copyWith(
                    color: home.textMuted,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _HistoryButton extends StatelessWidget {
  const _HistoryButton({
    required this.icon,
    required this.tooltip,
    required this.onPressed,
  });

  final IconData icon;
  final String tooltip;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    final home = context.home;

    return IconButton(
      tooltip: tooltip,
      onPressed: onPressed,
      icon: Icon(icon, size: 20),
      color: home.textPrimary,
      disabledColor: home.textMuted.withValues(alpha: 0.5),
      style: IconButton.styleFrom(
        backgroundColor: home.searchSurface.withValues(alpha: 0.5),
        fixedSize: const Size(44, 44),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      ),
    );
  }
}
