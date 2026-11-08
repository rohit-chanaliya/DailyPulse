import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:signals_flutter/signals_flutter.dart';

import 'package:dailypulse/core/constant/strings/feedback_strings.dart';
import 'package:dailypulse/core/di/injection.dart';
import 'package:dailypulse/core/theme/context_extensions.dart';
import 'package:dailypulse/core/utils/snackbar_utils.dart';
import 'package:dailypulse/core/widgets/accent_pill_button.dart';
import 'package:dailypulse/core/widgets/app_top_nav.dart';
import 'package:dailypulse/features/mood/views/widgets/mood_face.dart';
import 'package:dailypulse/features/settings/models/feedback_tag.dart';
import 'package:dailypulse/features/settings/viewmodels/feedback_signal.dart';
import 'package:dailypulse/features/settings/views/widgets/feedback_banner.dart';
import 'package:dailypulse/features/settings/views/widgets/feedback_tag_chip.dart';

/// Pick the areas that need improvement and send them as feedback.
class FeedbackScreen extends StatelessWidget {
  const FeedbackScreen({super.key});

  Future<void> _submit(BuildContext context, FeedbackSignal feedback) async {
    final outcome = await feedback.submit();
    if (!context.mounted) return;
    switch (outcome) {
      case FeedbackOutcome.sent:
        SnackBarUtils.showSuccess(context, FeedbackStrings.successMessage);
        context.pop();
      case FeedbackOutcome.queued:
        SnackBarUtils.showInfo(context, FeedbackStrings.queuedMessage);
        context.pop();
      case FeedbackOutcome.notSignedIn:
        SnackBarUtils.showError(context, FeedbackStrings.signInRequired);
      case FeedbackOutcome.failed:
        SnackBarUtils.showError(context, FeedbackStrings.errorMessage);
    }
  }

  @override
  Widget build(BuildContext context) {
    final home = context.home;
    final top = MediaQuery.paddingOf(context).top;
    final feedback = appComponent.feedbackSignal;
    const sheetRadius = Radius.circular(40);

    return Scaffold(
      backgroundColor: home.background,
      body: Stack(
        children: [
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            height: top + 280,
            child: const FeedbackBanner(),
          ),
          Positioned(
            top: top + 16,
            left: 16,
            right: 16,
            child: AppTopNav(
              title: FeedbackStrings.title,
              color: home.onMedia,
              onBack: () {
                feedback.reset();
                context.pop();
              },
            ),
          ),
          Positioned.fill(
            top: top + 196,
            child: DecoratedBox(
              decoration: BoxDecoration(
                color: home.background,
                borderRadius: const BorderRadius.vertical(top: sheetRadius),
              ),
              child: SingleChildScrollView(
                padding: EdgeInsets.fromLTRB(
                  16,
                  72,
                  16,
                  24 + MediaQuery.paddingOf(context).bottom,
                ),
                child: SignalBuilder(
                  builder: (context) {
                    final selected = feedback.selected.value;

                    return Column(
                      spacing: 32,
                      children: [
                        Text(
                          FeedbackStrings.question,
                          textAlign: TextAlign.center,
                          style: context.textTheme.displaySmall?.copyWith(
                            color: home.textPrimary,
                          ),
                        ),
                        Wrap(
                          alignment: WrapAlignment.center,
                          spacing: 8,
                          runSpacing: 8,
                          children: [
                            for (final tag in FeedbackTag.values)
                              FeedbackTagChip(
                                tag: tag,
                                selected: selected.contains(tag),
                                onTap: () => feedback.toggle(tag),
                              ),
                          ],
                        ),
                        AccentPillButton(
                          label: FeedbackStrings.submit,
                          icon: Icons.arrow_forward_rounded,
                          isLoading: feedback.isSubmitting.value,
                          onPressed: selected.isEmpty
                              ? null
                              : () => _submit(context, feedback),
                        ),
                      ],
                    );
                  },
                ),
              ),
            ),
          ),
          Positioned(
            top: top + 148,
            left: 0,
            right: 0,
            child: Center(
              child: Container(
                width: 96,
                height: 96,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: home.background,
                ),
                child: MoodFace(
                  level: 4,
                  size: 72,
                  glow: false,
                  faceColor: home.green,
                  featureColor: home.background,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
