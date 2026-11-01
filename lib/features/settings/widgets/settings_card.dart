import 'package:flutter/material.dart';

import 'package:dailypulse/core/theme/context_extensions.dart';

/// Rounded surface that groups related settings rows.
class SettingsCard extends StatelessWidget {
  const SettingsCard({super.key, required this.child, this.padding});

  final Widget child;
  final EdgeInsetsGeometry? padding;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding,
      decoration: BoxDecoration(
        color: context.home.surface,
        borderRadius: BorderRadius.circular(28),
      ),
      clipBehavior: Clip.antiAlias,
      child: child,
    );
  }
}
