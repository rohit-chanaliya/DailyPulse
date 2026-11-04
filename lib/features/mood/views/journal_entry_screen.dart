import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:dailypulse/core/constant/strings/journal_strings.dart';
import 'package:dailypulse/core/di/injection.dart';
import 'package:dailypulse/core/theme/context_extensions.dart';
import 'package:dailypulse/core/utils/snackbar_utils.dart';
import 'package:dailypulse/features/mood/models/journal_entry_args.dart';
import 'package:dailypulse/features/mood/views/widgets/journal_emotion_picker.dart';
import 'package:dailypulse/features/mood/views/widgets/journal_entry_box.dart';
import 'package:dailypulse/features/mood/views/widgets/journal_title_field.dart';

/// Journal entry form. Pops with `true` once the entry has been saved.
class JournalEntryScreen extends StatefulWidget {
  const JournalEntryScreen({super.key, required this.args});

  final JournalEntryArgs args;

  @override
  State<JournalEntryScreen> createState() => _JournalEntryScreenState();
}

class _JournalEntryScreenState extends State<JournalEntryScreen> {
  final _titleController = TextEditingController();
  final _entryController = TextEditingController();
  late int _level = widget.args.level;
  bool _saving = false;

  @override
  void dispose() {
    _titleController.dispose();
    _entryController.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    final userId = appComponent.authSignal.user.value?.uid;
    if (userId == null) {
      SnackBarUtils.showError(context, JournalStrings.signInRequired);
      return;
    }

    setState(() => _saving = true);
    final success = await appComponent.moodSignal.saveMood(
      moodLevel: _level,
      userId: userId,
      note: _entryController.text.trim(),
      title: _titleController.text.trim(),
      timestamp: widget.args.timestamp,
    );
    if (!mounted) return;

    if (success) {
      SnackBarUtils.showSuccess(context, JournalStrings.saved);
    } else {
      SnackBarUtils.showInfo(context, JournalStrings.savedOffline);
    }
    context.pop(true);
  }

  @override
  Widget build(BuildContext context) {
    final home = context.home;

    return Scaffold(
      backgroundColor: home.background,
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverFillRemaining(
              hasScrollBody: false,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const _Header(),
                    const SizedBox(height: 24),
                    const _SectionLabel(JournalStrings.titleLabel),
                    const SizedBox(height: 8),
                    JournalTitleField(controller: _titleController),
                    const SizedBox(height: 20),
                    const _SectionLabel(JournalStrings.emotionLabel),
                    const SizedBox(height: 8),
                    JournalEmotionPicker(
                      level: _level,
                      onChanged: (v) => setState(() => _level = v),
                    ),
                    const SizedBox(height: 20),
                    const _SectionLabel(JournalStrings.entryLabel),
                    const SizedBox(height: 8),
                    SizedBox(
                      height: 240,
                      child: JournalEntryBox(controller: _entryController),
                    ),
                    const Spacer(),
                    const SizedBox(height: 16),
                    ListenableBuilder(
                      listenable: Listenable.merge([
                        _titleController,
                        _entryController,
                      ]),
                      builder: (context, _) {
                        final hasContent =
                            _titleController.text.trim().isNotEmpty ||
                            _entryController.text.trim().isNotEmpty;
                        return SizedBox(
                          height: 56,
                          child: FilledButton(
                            onPressed: hasContent && !_saving ? _save : null,
                            style: FilledButton.styleFrom(
                              backgroundColor: home.accent,
                              foregroundColor: home.onMedia,
                              disabledBackgroundColor: home.searchSurface
                                  .withValues(alpha: 0.5),
                              disabledForegroundColor: home.textMuted,
                              shape: const StadiumBorder(),
                            ),
                            child: _saving
                                ? SizedBox.square(
                                    dimension: 22,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2.5,
                                      color: home.onMedia,
                                    ),
                                  )
                                : Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(
                                        JournalStrings.create,
                                        style: context.textTheme.titleSmall
                                            ?.copyWith(
                                              fontWeight: FontWeight.w700,
                                            ),
                                      ),
                                      const SizedBox(width: 12),
                                      const Icon(Icons.check_rounded, size: 20),
                                    ],
                                  ),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Header extends StatelessWidget {
  const _Header();

  @override
  Widget build(BuildContext context) {
    final home = context.home;

    return Row(
      children: [
        IconButton(
          tooltip: JournalStrings.backLabel,
          onPressed: () => context.pop(),
          icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 18),
          color: home.textPrimary,
          style: IconButton.styleFrom(
            fixedSize: const Size(44, 44),
            side: BorderSide(color: home.textPrimary.withValues(alpha: 0.6)),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Text(
            JournalStrings.screenTitle,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: context.textTheme.titleLarge?.copyWith(
              color: home.textPrimary,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ],
    );
  }
}

class _SectionLabel extends StatelessWidget {
  const _SectionLabel(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: context.textTheme.labelLarge?.copyWith(
        color: context.home.textSecondary,
      ),
    );
  }
}
