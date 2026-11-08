import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:dailypulse/core/router/app_routes.dart';
import 'package:dailypulse/core/theme/context_extensions.dart';

/// Outlined round back button with an optional screen title.
class AppTopNav extends StatelessWidget {
  const AppTopNav({super.key, this.title, this.color, this.onBack});

  final String? title;

  /// Foreground for the button outline, icon and title.
  final Color? color;
  final VoidCallback? onBack;

  @override
  Widget build(BuildContext context) {
    final foreground = color ?? context.home.textPrimary;

    return Row(
      spacing: 12,
      children: [
        Material(
          color: Colors.transparent,
          shape: CircleBorder(side: BorderSide(color: foreground)),
          clipBehavior: Clip.antiAlias,
          child: InkWell(
            onTap: onBack ??
                () => context.canPop()
                    ? context.pop()
                    : context.go(AppRoutes.settings),
            child: SizedBox(
              width: 48,
              height: 48,
              child: Icon(
                Icons.chevron_left_rounded,
                size: 28,
                color: foreground,
              ),
            ),
          ),
        ),
        if (title != null)
          Expanded(
            child: Text(
              title!,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: context.textTheme.headlineMedium?.copyWith(
                color: foreground,
              ),
            ),
          ),
      ],
    );
  }
}
