import 'package:flutter/material.dart';

import 'package:dailypulse/core/theme/context_extensions.dart';

/// Switch styled with the app's green track and white thumb.
class SettingsSwitch extends StatelessWidget {
  const SettingsSwitch({super.key, required this.value, this.onChanged});

  final bool value;
  final ValueChanged<bool>? onChanged;

  @override
  Widget build(BuildContext context) {
    final home = context.home;

    return Switch(
      value: value,
      onChanged: onChanged,
      activeThumbColor: home.onMedia,
      activeTrackColor: home.green,
      inactiveThumbColor: home.accent,
      inactiveTrackColor: home.background,
      trackOutlineColor: const WidgetStatePropertyAll(Colors.transparent),
    );
  }
}
