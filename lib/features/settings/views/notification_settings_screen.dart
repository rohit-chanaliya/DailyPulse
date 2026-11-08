import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:signals_flutter/signals_flutter.dart';

import 'package:dailypulse/core/constant/strings/notification_settings_strings.dart';
import 'package:dailypulse/core/di/injection.dart';
import 'package:dailypulse/core/theme/context_extensions.dart';
import 'package:dailypulse/core/utils/snackbar_utils.dart';
import 'package:dailypulse/core/widgets/app_top_nav.dart';
import 'package:dailypulse/features/settings/viewmodels/notification_settings_signal.dart';
import 'package:dailypulse/features/settings/views/widgets/settings_section.dart';
import 'package:dailypulse/features/settings/views/widgets/settings_switch.dart';
import 'package:dailypulse/features/settings/views/widgets/settings_switch_tile.dart';
import 'package:dailypulse/features/settings/views/widgets/settings_tile.dart';

/// Daily reminder toggle and time plus sound and vibration options.
class NotificationSettingsScreen extends StatelessWidget {
  const NotificationSettingsScreen({super.key});

  Future<void> _toggleReminder(
    BuildContext context,
    NotificationSettingsSignal settings,
    bool value,
  ) async {
    final granted = await settings.setReminderEnabled(value);
    if (!granted && context.mounted) {
      SnackBarUtils.showInfo(context, NotificationSettingsStrings.permissionDenied);
    }
  }

  Future<void> _pickTime(
    BuildContext context,
    NotificationSettingsSignal settings,
  ) async {
    final picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay(
        hour: settings.hour.value,
        minute: settings.minute.value,
      ),
    );
    if (picked != null) {
      await settings.setTime(newHour: picked.hour, newMinute: picked.minute);
    }
  }

  @override
  Widget build(BuildContext context) {
    final settings = appComponent.notificationSettingsSignal;

    return Scaffold(
      backgroundColor: context.home.background,
      body: SafeArea(
        child: SignalBuilder(
          builder: (context) {
            final enabled = settings.reminderEnabled.value;
            final time = DateFormat('h:mm a').format(
              DateTime(2026, 1, 1, settings.hour.value, settings.minute.value),
            );

            return SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 32),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                spacing: 32,
                children: [
                  const AppTopNav(title: NotificationSettingsStrings.title),
                  SettingsSection(
                    title: NotificationSettingsStrings.remindersSection,
                    children: [
                      SettingsTile(
                        icon: Icons.notifications_none_rounded,
                        title: NotificationSettingsStrings.dailyReminder,
                        subtitle: enabled
                            ? '${NotificationSettingsStrings.dailyReminderAt}$time'
                            : NotificationSettingsStrings.dailyReminderOff,
                        onTap: () => _toggleReminder(context, settings, !enabled),
                        trailing: SettingsSwitch(
                          value: enabled,
                          onChanged: (v) => _toggleReminder(context, settings, v),
                        ),
                      ),
                      if (enabled)
                        SettingsTile(
                          icon: Icons.schedule_rounded,
                          title: NotificationSettingsStrings.reminderTime,
                          value: time,
                          onTap: () => _pickTime(context, settings),
                        ),
                    ],
                  ),
                  SettingsSection(
                    title: NotificationSettingsStrings.alertsSection,
                    children: [
                      SettingsSwitchTile(
                        title: NotificationSettingsStrings.sound,
                        description: NotificationSettingsStrings.soundDescription,
                        value: settings.soundEnabled.value,
                        onChanged: settings.setSoundEnabled,
                      ),
                      SettingsSwitchTile(
                        title: NotificationSettingsStrings.vibration,
                        description:
                            NotificationSettingsStrings.vibrationDescription,
                        value: settings.vibrationEnabled.value,
                        onChanged: settings.setVibrationEnabled,
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
