import 'package:dailypulse/features/auth/presentation/providers/auth_provider.dart';
import 'package:dailypulse/features/settings/presentation/providers/theme_provider.dart';
import 'package:dailypulse/core/utils/dialog_utils.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../widgets/settings_card.dart';
import '../widgets/theme_selector.dart';
import '../widgets/user_profile_card.dart';
import '../widgets/settings_tile.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _isAppearanceExpanded = true;

  void _toggleAppearance() {
    setState(() {
      _isAppearanceExpanded = !_isAppearanceExpanded;
    });
  }

  Future<void> _handleSignOut(BuildContext context) async {
    final confirm = await DialogUtils.showConfirmDialog(
      context: context,
      title: 'Sign Out',
      message: 'Are you sure you want to sign out?',
      confirmText: 'Sign Out',
      isDanger: true,
    );

    if (confirm && context.mounted) {
      await context.read<AuthProvider>().signOut();
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final themeProvider = context.watch<ThemeProvider>();
    final authProvider = context.watch<AuthProvider>();
    final primaryColor = Theme.of(context).primaryColor;

    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF121212) : const Color(0xFFF8F9FA),
      body: CustomScrollView(
        slivers: [
          SliverAppBar.large(
            backgroundColor: isDark ? const Color(0xFF121212) : const Color(0xFFF8F9FA),
            elevation: 0,
            title: Text(
              'Settings',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                letterSpacing: -1,
                color: isDark ? Colors.white : Colors.black87,
              ),
            ),
            actions: [
              IconButton(
                onPressed: () {},
                icon: const Icon(Icons.search),
                color: isDark ? Colors.white70 : Colors.black54,
              ),
            ],
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 32),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  UserProfileCard(
                    displayName: authProvider.user?.displayName,
                    email: authProvider.user?.email,
                  ),
                  const SizedBox(height: 32),
                  
                  _buildSectionHeader('Appearance', isDark),
                  const SizedBox(height: 12),
                  SettingsCard(
                    child: Column(
                      children: [
                        SettingsTile(
                          icon: Icons.palette_outlined,
                          iconColor: Colors.purple,
                          title: 'Theme Mode',
                          subtitle: _getThemeName(themeProvider),
                          onTap: _toggleAppearance,
                          trailing: AnimatedRotation(
                            turns: _isAppearanceExpanded ? 0.5 : 0,
                            duration: const Duration(milliseconds: 300),
                            child: const Icon(Icons.keyboard_arrow_down, size: 20),
                          ),
                        ),
                        AnimatedCrossFade(
                          firstChild: const SizedBox.shrink(),
                          secondChild: Padding(
                            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                            child: ThemeSelector(
                              isLightMode: themeProvider.isLightMode,
                              isDarkMode: themeProvider.isDarkMode,
                              isSystemMode: themeProvider.isSystemMode,
                              onLightMode: themeProvider.setLightTheme,
                              onDarkMode: themeProvider.setDarkTheme,
                              onSystemMode: themeProvider.setSystemTheme,
                            ),
                          ),
                          crossFadeState: _isAppearanceExpanded
                              ? CrossFadeState.showSecond
                              : CrossFadeState.showFirst,
                          duration: const Duration(milliseconds: 300),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 32),
                  
                  _buildSectionHeader('Preferences', isDark),
                  const SizedBox(height: 12),
                  SettingsCard(
                    child: Column(
                      children: [
                        SettingsTile(
                          icon: Icons.notifications_none_rounded,
                          iconColor: Colors.blue,
                          title: 'Notifications',
                          subtitle: 'Manage app alerts',
                          onTap: () {},
                        ),
                        const Divider(height: 1, indent: 60),
                        SettingsTile(
                          icon: Icons.language_rounded,
                          iconColor: Colors.orange,
                          title: 'Language',
                          subtitle: 'English (US)',
                          onTap: () {},
                        ),
                        const Divider(height: 1, indent: 60),
                        SettingsTile(
                          icon: Icons.lock_outline_rounded,
                          iconColor: Colors.green,
                          title: 'Privacy & Security',
                          subtitle: 'Control your data',
                          onTap: () {},
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 32),
                  
                  _buildSectionHeader('Support', isDark),
                  const SizedBox(height: 12),
                  SettingsCard(
                    child: Column(
                      children: [
                        SettingsTile(
                          icon: Icons.help_outline_rounded,
                          iconColor: Colors.teal,
                          title: 'Help Center',
                          onTap: () {},
                        ),
                        const Divider(height: 1, indent: 60),
                        SettingsTile(
                          icon: Icons.info_outline_rounded,
                          iconColor: Colors.indigo,
                          title: 'About DailyPulse',
                          onTap: () {},
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 32),
                  
                  _buildSectionHeader('Account', isDark),
                  const SizedBox(height: 12),
                  SettingsCard(
                    child: SettingsTile(
                      icon: Icons.logout_rounded,
                      iconColor: Colors.red,
                      title: 'Sign Out',
                      subtitle: 'Exit your current session',
                      isDestructive: true,
                      onTap: () => _handleSignOut(context),
                    ),
                  ),
                  
                  const SizedBox(height: 48),
                  Center(
                    child: Column(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: primaryColor.withValues(alpha: 0.1),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Icons.bolt,
                            color: primaryColor,
                            size: 24,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'DailyPulse',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1,
                            color: isDark ? Colors.white70 : Colors.black54,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Version 1.0.0',
                          style: TextStyle(
                            fontSize: 13,
                            color: isDark ? Colors.grey.shade600 : Colors.grey.shade400,
                          ),
                        ),
                        const SizedBox(height: 32),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _getThemeName(ThemeProvider provider) {
    if (provider.isSystemMode) return 'System';
    if (provider.isDarkMode) return 'Dark';
    return 'Light';
  }

  Widget _buildSectionHeader(String title, bool isDark) {
    return Padding(
      padding: const EdgeInsets.only(left: 4, bottom: 8),
      child: Text(
        title.toUpperCase(),
        style: TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.bold,
          letterSpacing: 1.2,
          color: isDark ? Colors.grey.shade500 : Colors.grey.shade600,
        ),
      ),
    );
  }
}
