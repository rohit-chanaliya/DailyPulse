import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:dailypulse/core/constant/strings/nav_strings.dart';
import 'package:dailypulse/core/theme/context_extensions.dart';
import 'package:dailypulse/features/app/presentation/models/nav_assets.dart';
import 'package:dailypulse/features/app/presentation/widgets/notched_bar_clipper.dart';

/// Floating bottom bar: two tabs, a raised "+" action in a notch, two tabs.
class AppBottomNavBar extends StatelessWidget {
  const AppBottomNavBar({
    super.key,
    required this.currentIndex,
    required this.onTabSelected,
    required this.onAddPressed,
  });

  final int currentIndex;
  final ValueChanged<int> onTabSelected;
  final VoidCallback onAddPressed;

  static const double _barHeight = 72;
  static const double _addSize = 60;

  static const _tabs = [
    _TabData(NavAssets.home, NavStrings.home),
    _TabData(NavAssets.history, NavStrings.history),
    _TabData(NavAssets.insights, NavStrings.insights),
    _TabData(NavAssets.settings, NavStrings.settings),
  ];

  @override
  Widget build(BuildContext context) {
    final colors = context.navBar;
    final bottomInset = MediaQuery.paddingOf(context).bottom;
    final items = [
      for (var i = 0; i < _tabs.length; i++)
        Expanded(
          child: _NavItem(
            data: _tabs[i],
            selected: i == currentIndex,
            onTap: () => onTabSelected(i),
          ),
        ),
    ];

    return SizedBox(
      height: _barHeight + _addSize / 2 + bottomInset,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            height: _barHeight + bottomInset,
            child: PhysicalShape(
              clipper: const NotchedBarClipper(),
              color: colors.surface,
              shadowColor: colors.shadow,
              elevation: 8,
              child: Padding(
                padding: EdgeInsets.only(bottom: bottomInset),
                child: Row(
                  children: [
                    ...items.take(2),
                    const Spacer(),
                    ...items.skip(2),
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Center(child: _AddButton(onPressed: onAddPressed)),
          ),
        ],
      ),
    );
  }
}

class _TabData {
  const _TabData(this.asset, this.label);

  final String asset;
  final String label;
}

class _NavItem extends StatelessWidget {
  const _NavItem({
    required this.data,
    required this.selected,
    required this.onTap,
  });

  final _TabData data;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.navBar;

    return Semantics(
      button: true,
      selected: selected,
      label: data.label,
      child: InkResponse(
        onTap: onTap,
        radius: 28,
        child: Center(
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 220),
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: selected ? colors.selectedBackground : Colors.transparent,
              boxShadow: [
                if (selected)
                  BoxShadow(
                    color: colors.addButton.withValues(alpha: 0.12),
                    blurRadius: 14,
                  ),
              ],
            ),
            child: Center(
              child: SvgPicture.asset(
                data.asset,
                width: 24,
                height: 24,
                colorFilter: ColorFilter.mode(
                  selected ? colors.selectedIcon : colors.unselectedIcon,
                  BlendMode.srcIn,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _AddButton extends StatelessWidget {
  const _AddButton({required this.onPressed});

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final colors = context.navBar;

    return Semantics(
      button: true,
      label: NavStrings.logMood,
      child: Container(
        width: AppBottomNavBar._addSize,
        height: AppBottomNavBar._addSize,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: colors.addButton,
          boxShadow: [
            BoxShadow(
              color: colors.addButton.withValues(alpha: 0.4),
              blurRadius: 40,
              spreadRadius: 4,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Material(
          type: MaterialType.transparency,
          shape: const CircleBorder(),
          child: InkWell(
            customBorder: const CircleBorder(),
            onTap: () {
              HapticFeedback.lightImpact();
              onPressed();
            },
            child: Icon(Icons.add, size: 32, weight: 300, color: colors.onAddButton),
          ),
        ),
      ),
    );
  }
}
