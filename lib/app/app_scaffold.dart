import 'package:dailypulse/features/auth/presentation/providers/auth_provider.dart';
import 'package:dailypulse/features/history/screens/history_screen.dart';
import 'package:dailypulse/features/insights/screens/insights_screen.dart';
import 'package:dailypulse/features/mood/presentation/providers/mood_provider.dart';
import 'package:dailypulse/features/mood/presentation/screens/home_mood_screen.dart';
import 'package:dailypulse/features/settings/screens/settings_screen.dart';
import 'package:dailypulse/shared/widgets/nav_bar_item.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:dailypulse/core/utils/app_logger.dart';

class AppScaffold extends StatefulWidget {
  const AppScaffold({super.key});

  @override
  State<AppScaffold> createState() => _AppScaffoldState();
}

class _AppScaffoldState extends State<AppScaffold>
    with SingleTickerProviderStateMixin {
  int _currentIndex = 0;
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  final _screens = const [
    HomeMoodScreen(), // Home
    HistoryScreen(), // Journey
    Center(child: Text('Ask Screen')), // Ask (Placeholder)
    InsightsScreen(), // Library
    SettingsScreen(), // Calendar
  ];

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
    _animationController.forward();

    // Fetch data from Firebase when user logs in
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final authProvider = context.read<AuthProvider>();
      final moodProvider = context.read<MoodProvider>();

      if (authProvider.user != null) {
        final userId = authProvider.user!.uid;
        appLogger.i('Fetching mood entries for user: $userId');
        await moodProvider.fetchMoodEntries(userId);
        appLogger.i('Initial mood entries fetch complete');
        moodProvider.startBackgroundSync();
      }
    });
  }

  @override
  void dispose() {
    context.read<MoodProvider>().stopBackgroundSync();
    _animationController.dispose();
    super.dispose();
  }

  void _onTabChanged(int index) {
    if (index != _currentIndex) {
      _animationController.reset();
      setState(() => _currentIndex = index);
      _animationController.forward();
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      color: Theme.of(context).scaffoldBackgroundColor,
      child: Scaffold(
        body: _currentIndex == 0
            ? FadeTransition(
                opacity: _fadeAnimation,
                child: _screens[_currentIndex],
              )
            : SafeArea(
                bottom: false,
                child: FadeTransition(
                  opacity: _fadeAnimation,
                  child: _screens[_currentIndex],
                ),
              ),
        bottomNavigationBar: Container(
          margin: const EdgeInsets.only(left: 16, right: 16, bottom: 24, top: 8),
          padding: const EdgeInsets.symmetric(vertical: 16),
          decoration: BoxDecoration(
            color: isDark ? const Color(0xFF2C2C2C) : Colors.white,
            borderRadius: BorderRadius.circular(30),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.05),
                blurRadius: 20,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              NavBarItem(
                icon: CupertinoIcons.home,
                selectedIcon: CupertinoIcons.house_fill,
                label: 'Home',
                isSelected: _currentIndex == 0,
                onTap: () => _onTabChanged(0),
                isDark: isDark,
              ),
              NavBarItem(
                icon: CupertinoIcons.chart_bar,
                selectedIcon: CupertinoIcons.chart_bar_fill,
                label: 'Journey',
                isSelected: _currentIndex == 1,
                onTap: () => _onTabChanged(1),
                isDark: isDark,
              ),
              NavBarItem(
                icon: CupertinoIcons.chat_bubble_text,
                selectedIcon: CupertinoIcons.chat_bubble_text_fill,
                label: 'Ask',
                isSelected: _currentIndex == 2,
                onTap: () => _onTabChanged(2),
                isDark: isDark,
              ),
              NavBarItem(
                icon: CupertinoIcons.play_rectangle,
                selectedIcon: CupertinoIcons.play_rectangle_fill,
                label: 'Library',
                isSelected: _currentIndex == 3,
                onTap: () => _onTabChanged(3),
                isDark: isDark,
              ),
              NavBarItem(
                icon: CupertinoIcons.calendar,
                selectedIcon: CupertinoIcons.calendar,
                label: 'Calendar',
                isSelected: _currentIndex == 4,
                onTap: () => _onTabChanged(4),
                isDark: isDark,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
