import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:signals_flutter/signals_flutter.dart';

import 'package:dailypulse/core/constant/links.dart';
import 'package:dailypulse/core/constant/strings/notification_settings_strings.dart';
import 'package:dailypulse/core/constant/strings/profile_strings.dart';
import 'package:dailypulse/core/constant/strings/settings_strings.dart';
import 'package:dailypulse/core/di/injection.dart';
import 'package:dailypulse/core/router/app_routes.dart';
import 'package:dailypulse/core/theme/context_extensions.dart';
import 'package:dailypulse/core/utils/dialog_utils.dart';
import 'package:dailypulse/core/utils/link_launcher.dart';
import 'package:dailypulse/features/settings/views/widgets/settings_header.dart';
import 'package:dailypulse/features/settings/views/widgets/settings_section.dart';
import 'package:dailypulse/features/settings/views/widgets/settings_tile.dart';

/// Account header, general settings, security, danger zone and sign out.
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

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarIconBrightness: Brightness.light,
        statusBarBrightness: Brightness.dark,
      ),
      child: Scaffold(
        backgroundColor: home.background,
        body: SignalBuilder(
          builder: (context) {
            final user = appComponent.authSignal.user.value;
            final profile = appComponent.authSignal.profile.value;
            final name = profile?.fullName.isNotEmpty == true
                ? profile!.fullName
                : user?.displayName;

            return SingleChildScrollView(
              padding: EdgeInsets.only(
                bottom: 24 + MediaQuery.paddingOf(context).bottom,
              ),
              child: Column(
                children: [
                  SettingsHeader(
                    displayName: name,
                    email: user?.email,
                    memberSince: user?.metadata.creationTime,
                    imagePath: appComponent.authSignal.profileImagePath.value,
                    avatarId: profile?.avatarId,
                    photoUrl: user?.photoURL,
                    onAvatarTap: () => context.push(AppRoutes.profile),
                    onEditProfile: () => context.push(AppRoutes.profileEdit),
                    onMoodInsights: () => context.go(AppRoutes.insights),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 32, 16, 0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      spacing: 32,
                      children: [
                        SettingsSection(
                          title: SettingsStrings.generalSettings,
                          children: [
                            SettingsTile(
                              icon: Icons.notifications_none_rounded,
                              title: SettingsStrings.notifications,
                              value: appComponent
                                      .notificationSettingsSignal
                                      .reminderEnabled
                                      .value
                                  ? NotificationSettingsStrings.on
                                  : NotificationSettingsStrings.off,
                              onTap: () => context.push(
                                AppRoutes.notificationSettings,
                              ),
                            ),
                            SettingsTile(
                              icon: Icons.person_outline_rounded,
                              title: ProfileStrings.personalInfo,
                              subtitle: ProfileStrings.editProfileSubtitle,
                              onTap: () => context.push(AppRoutes.profileEdit),
                            ),
                            SettingsTile(
                              icon: Icons.chat_bubble_outline_rounded,
                              title: SettingsStrings.submitFeedback,
                              subtitle: SettingsStrings.submitFeedbackSubtitle,
                              onTap: () => context.push(AppRoutes.feedback),
                            ),
                          ],
                        ),
                        SettingsSection(
                          title: SettingsStrings.securityPrivacy,
                          children: [
                            SettingsTile(
                              icon: Icons.lock_outline_rounded,
                              title: SettingsStrings.privacy,
                              subtitle: SettingsStrings.privacySubtitle,
                              onTap: () => LinkLauncher.open(
                                context,
                                AppLinks.privacyPolicy,
                              ),
                            ),
                            SettingsTile(
                              icon: Icons.help_outline_rounded,
                              title: SettingsStrings.helpCenter,
                              subtitle: SettingsStrings.helpCenterSubtitle,
                              onTap: () => LinkLauncher.open(
                                context,
                                AppLinks.supportMailto(
                                  SettingsStrings.helpEmailSubject,
                                ),
                              ),
                            ),
                            SettingsTile(
                              icon: Icons.info_outline_rounded,
                              title: SettingsStrings.about,
                              onTap: () => DialogUtils.showInfoDialog(
                                context: context,
                                title: SettingsStrings.appName,
                                message: SettingsStrings.aboutMessage,
                              ),
                            ),
                          ],
                        ),
                        SettingsSection(
                          title: SettingsStrings.dangerZone,
                          trailingIcon: Icons.warning_amber_rounded,
                          trailingIconColor: home.orange,
                          children: [
                            SettingsTile(
                              icon: Icons.delete_outline_rounded,
                              title: SettingsStrings.deleteAccount,
                              subtitle: SettingsStrings.deleteAccountSubtitle,
                              isDestructive: true,
                              onTap: () => context.push(AppRoutes.deleteAccount),
                            ),
                          ],
                        ),
                        SettingsSection(
                          title: SettingsStrings.signOut,
                          children: [
                            SettingsTile(
                              icon: Icons.logout_rounded,
                              title: SettingsStrings.signOut,
                              subtitle: SettingsStrings.signOutSubtitle,
                              onTap: _handleSignOut,
                            ),
                          ],
                        ),
                        const _AppFooter(),
                      ],
                    ),
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
          child: Icon(Icons.bolt_rounded, color: home.onMedia, size: 26),
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
