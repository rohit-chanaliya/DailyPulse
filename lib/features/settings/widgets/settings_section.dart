import 'package:flutter/material.dart';

import 'package:dailypulse/core/theme/context_extensions.dart';
import 'package:dailypulse/features/settings/widgets/settings_card.dart';

/// Section title above a [SettingsCard] holding [child].
class SettingsSection extends StatelessWidget {
  const SettingsSection({
    super.key,
    required this.title,
    required this.child,
    this.cardPadding,
  });

  final String title;
  final Widget child;
  final EdgeInsetsGeometry? cardPadding;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: context.textTheme.headlineSmall?.copyWith(
            color: context.home.textPrimary,
          ),
        ),
        const SizedBox(height: 12),
        SettingsCard(padding: cardPadding, child: child),
      ],
    );
  }
}
