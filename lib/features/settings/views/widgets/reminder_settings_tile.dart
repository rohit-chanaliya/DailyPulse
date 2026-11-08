import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:dailypulse/core/constant/strings/settings_strings.dart';
import 'package:dailypulse/core/di/injection.dart';
import 'package:dailypulse/core/theme/context_extensions.dart';

/// Interactive settings row with toggle and time picker for daily mood reminders.
class ReminderSettingsTile extends StatefulWidget {
  const ReminderSettingsTile({super.key});

  @override
  State<ReminderSettingsTile> createState() => _ReminderSettingsTileState();
}

class _ReminderSettingsTileState extends State<ReminderSettingsTile> {
  late bool _enabled;
  late int _hour;
  late int _minute;

  @override
  void initState() {
    super.initState();
    final prefs = appComponent.appPreferences;
    _enabled = prefs.isReminderEnabled;
    _hour = prefs.reminderHour;
    _minute = prefs.reminderMinute;
  }

  String get _formattedTime {
    final dt = DateTime(2026, 1, 1, _hour, _minute);
    return DateFormat('h:mm a').format(dt);
  }

  Future<void> _pickTime() async {
    final picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay(hour: _hour, minute: _minute),
    );
    if (picked != null) {
      setState(() {
        _hour = picked.hour;
        _minute = picked.minute;
      });
      if (_enabled) {
        await appComponent.notificationService.scheduleDailyReminder(
          hour: _hour,
          minute: _minute,
        );
      }
    }
  }

  Future<void> _toggle(bool value) async {
    if (value) {
      final granted =
          await appComponent.notificationService.requestPermission();
      if (!granted && mounted) {
        setState(() => _enabled = false);
        return;
      }
      await appComponent.notificationService.scheduleDailyReminder(
        hour: _hour,
        minute: _minute,
      );
    } else {
      await appComponent.notificationService.cancelDailyReminder();
    }
    if (mounted) {
      setState(() => _enabled = value);
    }
  }

  @override
  Widget build(BuildContext context) {
    final home = context.home;

    final subtitle = _enabled
        ? '${SettingsStrings.dailyReminderAt}$_formattedTime'
        : SettingsStrings.dailyReminderOff;

    return InkWell(
      onTap: _enabled ? _pickTime : () => _toggle(true),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: home.orangeDark,
                borderRadius: BorderRadius.circular(14),
              ),
              child: Icon(
                Icons.notifications_active_outlined,
                size: 24,
                color: home.orange,
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    SettingsStrings.dailyReminder,
                    style: context.textTheme.titleLarge?.copyWith(
                      color: home.textPrimary,
                    ),
                  ),
                  Text(
                    subtitle,
                    style: context.textTheme.bodySmall?.copyWith(
                      color: _enabled ? home.accent : home.textMuted,
                      fontWeight:
                          _enabled ? FontWeight.w600 : FontWeight.normal,
                    ),
                  ),
                ],
              ),
            ),
            Switch(
              value: _enabled,
              onChanged: _toggle,
              activeThumbColor: home.accent,
            ),
          ],
        ),
      ),
    );
  }
}
