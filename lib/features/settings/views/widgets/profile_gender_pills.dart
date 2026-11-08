import 'package:flutter/material.dart';

import 'package:dailypulse/core/constant/strings/profile_strings.dart';
import 'package:dailypulse/core/theme/context_extensions.dart';

/// Gender choice as a 2x2 grid of radio pills.
class ProfileGenderPills extends StatelessWidget {
  const ProfileGenderPills({
    super.key,
    required this.selectedGender,
    required this.onChanged,
  });

  static const options = [
    ProfileStrings.genderMale,
    ProfileStrings.genderFemale,
    ProfileStrings.genderTransgender,
    ProfileStrings.genderOther,
  ];

  final String selectedGender;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 10,
      children: [
        Text(
          ProfileStrings.genderLabel,
          style: context.textTheme.titleMedium?.copyWith(
            color: context.home.textSecondary,
          ),
        ),
        for (var i = 0; i < options.length; i += 2)
          Row(
            spacing: 12,
            children: [
              for (final option in options.skip(i).take(2))
                Expanded(
                  child: _GenderPill(
                    label: option,
                    selected: selectedGender == option,
                    onTap: () => onChanged(option),
                  ),
                ),
            ],
          ),
      ],
    );
  }
}

class _GenderPill extends StatelessWidget {
  const _GenderPill({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final home = context.home;
    final foreground = selected ? home.onMedia : home.textPrimary;

    return Semantics(
      button: true,
      selected: selected,
      label: label,
      child: Material(
        color: selected ? home.orange : home.surface,
        shape: const StadiumBorder(),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    label,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: context.textTheme.titleLarge?.copyWith(
                      color: foreground,
                    ),
                  ),
                ),
                Icon(
                  selected
                      ? Icons.radio_button_checked_rounded
                      : Icons.radio_button_unchecked_rounded,
                  size: 24,
                  color: foreground,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
