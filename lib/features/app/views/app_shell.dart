import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:dailypulse/core/router/app_routes.dart';
import 'package:dailypulse/core/theme/context_extensions.dart';
import 'package:dailypulse/features/app/views/widgets/app_bottom_nav_bar.dart';

/// Persistent bottom-navigation shell for the authenticated app.
class AppShell extends StatelessWidget {
  const AppShell({super.key, required this.navigationShell});

  final StatefulNavigationShell navigationShell;

  void _onTabSelected(int index) {
    navigationShell.goBranch(
      index,
      initialLocation: index == navigationShell.currentIndex,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.home.background,
      extendBody: true,
      body: navigationShell,
      bottomNavigationBar: AppBottomNavBar(
        currentIndex: navigationShell.currentIndex,
        onTabSelected: _onTabSelected,
        onAddPressed: () => context.push(AppRoutes.logMood),
      ),
    );
  }
}
