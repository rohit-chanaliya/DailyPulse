import 'package:flutter/material.dart';

import 'package:dailypulse/core/theme/context_extensions.dart';

/// Pencil shown at the end of a tappable profile field.
class ProfileEditIcon extends StatelessWidget {
  const ProfileEditIcon({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 16),
      child: Icon(
        Icons.edit_outlined,
        color: context.home.textPrimary,
        size: 22,
      ),
    );
  }
}
