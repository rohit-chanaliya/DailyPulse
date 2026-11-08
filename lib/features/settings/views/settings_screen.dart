import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:signals_flutter/signals_flutter.dart';

import 'package:dailypulse/core/constant/links.dart';
import 'package:dailypulse/core/constant/strings/settings_strings.dart';
import 'package:dailypulse/core/di/injection.dart';
import 'package:dailypulse/core/router/app_routes.dart';
import 'package:dailypulse/core/theme/context_extensions.dart';
import 'package:dailypulse/core/utils/dialog_utils.dart';
import 'package:dailypulse/core/utils/link_launcher.dart';
import 'package:dailypulse/core/widgets/screen_header.dart';
import 'package:dailypulse/features/settings/views/widgets/reminder_settings_tile.dart';
import 'package:dailypulse/features/settings/views/widgets/settings_section.dart';
import 'package:dailypulse/features/settings/views/widgets/settings_tile.dart';
import 'package:dailypulse/features/settings/views/widgets/theme_selector.dart';
import 'package:dailypulse/features/settings/views/widgets/user_profile_card.dart';

/// Account summary, appearance, preferences, support and sign out.
class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  Future<void> _handleSignOut() async {
    final confirm = await DialogUtils.showConfirmDialog(
      context: context,
      title: SettingsStrings.signOut,
      message: SettingsStrings.signOutMessage,
      confirmText: SettingsStrings.signOut,
      isDanger: true,
    );

    if (confirm && mounted) {
      await appComponent.authSignal.signOut();
    }
  }

  @override
  Widget build(BuildContext context) {
    final home = context.home;
    final divider = Divider(
      height: 1,
      indent: 78,
      endIndent: 16,
      color: home.textMuted.withValues(alpha: 0.2),
    );

    return Scaffold(
      backgroundColor: home.background,
      body: SafeArea(
        bottom: false,
        child: SignalBuilder(
          builder: (context) {
            final user = appComponent.authSignal.user.value;
            final theme = appComponent.themeSignal;

            return SingleChildScrollView(
              padding: EdgeInsets.fromLTRB(
                16,
                24,
                16,
                24 + MediaQuery.paddingOf(context).bottom,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const ScreenHeader(
                    title: SettingsStrings.title,
                    subtitle: SettingsStrings.subtitle,
                  ),
                  const SizedBox(height: 24),
                  UserProfileCard(
                    displayName: user?.displayName,
                    email: user?.email,
                    memberSince: user?.metadata.creationTime,
                    entryCount: appComponent.moodSignal.entries.value.length,
                  ),
                  const SizedBox(height: 28),
                  SettingsSection(
                    title: SettingsStrings.appearance,
                    cardPadding: const EdgeInsets.all(12),
                    child: ThemeSelector(
                      isLightMode: theme.isLightMode,
                      isDarkMode: theme.isDarkMode,
                      isSystemMode: theme.isSystemMode,
                      onLightMode: theme.setLightTheme,
                      onDarkMode: theme.setDarkTheme,
                      onSystemMode: theme.setSystemTheme,
                    ),
                  ),
                  const SizedBox(height: 28),
                  SettingsSection(
                    title: SettingsStrings.preferences,
                    child: Column(
                      children: [
                        const ReminderSettingsTile(),
                        divider,
                        SettingsTile(
                          icon: Icons.language_rounded,
                          iconBackground: home.yellowDark,
                          iconColor: home.yellow,
                          title: SettingsStrings.language,
                          subtitle: SettingsStrings.languageSubtitle,
                        ),
                        divider,
                        SettingsTile(
                          icon: Icons.lock_outline_rounded,
                          iconBackground: home.greenDark,
                          iconColor: home.green,
                          title: SettingsStrings.privacy,
                          subtitle: SettingsStrings.privacySubtitle,
                          onTap: () => LinkLauncher.open(
                            context,
                            AppLinks.privacyPolicy,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 28),
                  SettingsSection(
                    title: SettingsStrings.support,
                    child: Column(
                      children: [
                        SettingsTile(
                          icon: Icons.help_outline_rounded,
                          iconBackground: home.greenDark,
                          iconColor: home.green,
                          title: SettingsStrings.helpCenter,
                        ),
                        divider,
                        SettingsTile(
                          icon: Icons.info_outline_rounded,
                          iconBackground: home.purpleDark,
                          iconColor: home.purple,
                          title: SettingsStrings.about,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 28),
                  SettingsSection(
                    title: SettingsStrings.account,
                    child: Column(
                      children: [
                        SettingsTile(
                          icon: Icons.logout_rounded,
                          iconBackground: home.orangeDark,
                          iconColor: home.orange,
                          title: SettingsStrings.signOut,
                          subtitle: SettingsStrings.signOutSubtitle,
                          onTap: _handleSignOut,
                        ),
                        divider,
                        SettingsTile(
                          icon: Icons.delete_outline_rounded,
                          iconBackground: home.orangeDark,
                          iconColor: home.orange,
                          title: SettingsStrings.deleteAccount,
                          subtitle: SettingsStrings.deleteAccountSubtitle,
                          isDestructive: true,
                          onTap: () =>
                              context.push(AppRoutes.deleteAccount),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 36),
                  const Center(child: _AppFooter()),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

class _AppFooter extends StatelessWidget {
  const _AppFooter();

  @override
  Widget build(BuildContext context) {
    final home = context.home;

    return Column(
      children: [
        Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: home.headerSurface,
            shape: BoxShape.circle,
          ),
          child: Icon(Icons.bolt_rounded, color: home.accent, size: 26),
        ),
        const SizedBox(height: 12),
        Text(
          SettingsStrings.appName,
          style: context.textTheme.titleLarge?.copyWith(
            color: home.textSecondary,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          SettingsStrings.version,
          style: context.textTheme.bodySmall?.copyWith(color: home.textMuted),
        ),
      ],
    );
  }
}
