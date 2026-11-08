import 'package:dailypulse/core/constant/strings/feedback_strings.dart';

/// Areas a user can flag. [id] is what gets stored and validated by rules.
enum FeedbackTag {
  performance('performance', FeedbackStrings.performance),
  bug('bug', FeedbackStrings.bug),
  userExperience('user_experience', FeedbackStrings.userExperience),
  crashes('crashes', FeedbackStrings.crashes),
  loading('loading', FeedbackStrings.loading),
  support('support', FeedbackStrings.support),
  navigation('navigation', FeedbackStrings.navigation);

  const FeedbackTag(this.id, this.label);

  final String id;
  final String label;
}
