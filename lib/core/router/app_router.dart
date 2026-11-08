import 'package:dailypulse/core/di/injection.dart';
import 'package:dailypulse/core/router/app_routes.dart';
import 'package:dailypulse/core/router/route_error_screen.dart';
import 'package:dailypulse/core/router/router_refresh_stream.dart';
import 'package:dailypulse/features/app/views/app_shell.dart';
import 'package:dailypulse/features/auth/views/forgot_password_screen.dart';
import 'package:dailypulse/features/auth/views/reset_password_screen.dart';
import 'package:dailypulse/features/auth/views/sign_in_screen.dart';
import 'package:dailypulse/features/auth/views/sign_up_screen.dart';
import 'package:dailypulse/features/auth/views/verify_email_screen.dart';
import 'package:dailypulse/features/history/views/history_screen.dart';
import 'package:dailypulse/features/insights/views/insights_screen.dart';
import 'package:dailypulse/features/mood/models/journal_entry_args.dart';
import 'package:dailypulse/features/mood/views/home_mood_screen.dart';
import 'package:dailypulse/features/mood/views/journal_entry_screen.dart';
import 'package:dailypulse/features/mood/views/log_mood_screen.dart';
import 'package:dailypulse/features/mood/views/mood_screen.dart';
import 'package:dailypulse/features/onboarding/views/onboarding_screen.dart';
import 'package:dailypulse/features/onboarding/views/splash_screen.dart';
import 'package:dailypulse/features/onboarding/views/welcome_screen.dart';
import 'package:dailypulse/features/settings/views/delete_account_screen.dart';
import 'package:dailypulse/features/settings/views/feedback_screen.dart';
import 'package:dailypulse/features/settings/views/notification_settings_screen.dart';
import 'package:dailypulse/features/settings/views/personal_info_screen.dart';
import 'package:dailypulse/features/settings/views/profile_screen.dart';
import 'package:dailypulse/features/settings/views/settings_screen.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

GoRouter createAppRouter({GlobalKey<NavigatorState>? navigatorKey}) {
  return GoRouter(
    navigatorKey: navigatorKey,
    initialLocation: AppRoutes.splash,
    refreshListenable: RouterRefreshStream(
      appComponent.authSignal.userChanges,
    ),
    redirect: _redirect,
    routes: [
      GoRoute(
        path: AppRoutes.splash,
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
        path: AppRoutes.welcome,
        pageBuilder: (context, state) =>
            _fadePage(state, const WelcomeScreen()),
      ),
      GoRoute(
        path: AppRoutes.onboarding,
        pageBuilder: (context, state) =>
            _fadePage(state, const OnboardingScreen()),
      ),
      GoRoute(
        path: AppRoutes.signIn,
        pageBuilder: (context, state) => _fadePage(state, const SignInScreen()),
      ),
      GoRoute(
        path: AppRoutes.signUp,
        pageBuilder: (context, state) => _fadePage(state, const SignUpScreen()),
      ),
      GoRoute(
        path: AppRoutes.forgotPassword,
        pageBuilder: (context, state) =>
            _fadePage(state, const ForgotPasswordScreen()),
      ),
      GoRoute(
        path: AppRoutes.verifyEmail,
        pageBuilder: (context, state) {
          final extra = state.extra as Map<String, dynamic>? ?? {};
          return _fadePage(
            state,
            VerifyEmailScreen(email: extra['email'] as String? ?? ''),
          );
        },
      ),
      GoRoute(
        path: AppRoutes.resetPassword,
        pageBuilder: (context, state) {
          final oobCode = state.extra as String? ?? '';
          return _fadePage(state, ResetPasswordScreen(oobCode: oobCode));
        },
      ),
      GoRoute(
        path: AppRoutes.logMood,
        pageBuilder: (context, state) {
          final (level, timestamp) = switch (state.extra) {
            final int l => (l, null),
            final DateTime dt => (LogMoodScreen.defaultLevel, dt),
            final Map<String, dynamic> map => (
              map['level'] as int? ?? LogMoodScreen.defaultLevel,
              map['timestamp'] as DateTime?,
            ),
            _ => (LogMoodScreen.defaultLevel, null),
          };
          return _fadePage(
            state,
            LogMoodScreen(initialLevel: level, initialTimestamp: timestamp),
          );
        },
      ),
      GoRoute(
        path: AppRoutes.journalEntry,
        pageBuilder: (context, state) {
          final args =
              state.extra as JournalEntryArgs? ??
              const JournalEntryArgs(level: LogMoodScreen.defaultLevel);
          return _fadePage(state, JournalEntryScreen(args: args));
        },
      ),
      GoRoute(
        path: AppRoutes.deleteAccount,
        pageBuilder: (context, state) =>
            _fadePage(state, const DeleteAccountScreen()),
      ),
      GoRoute(
        path: AppRoutes.profile,
        pageBuilder: (context, state) =>
            _fadePage(state, const ProfileScreen()),
      ),
      GoRoute(
        path: AppRoutes.profileEdit,
        pageBuilder: (context, state) =>
            _fadePage(state, const PersonalInfoScreen()),
      ),
      GoRoute(
        path: AppRoutes.notificationSettings,
        pageBuilder: (context, state) =>
            _fadePage(state, const NotificationSettingsScreen()),
      ),
      GoRoute(
        path: AppRoutes.feedback,
        pageBuilder: (context, state) =>
            _fadePage(state, const FeedbackScreen()),
      ),
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) {
          return AppShell(navigationShell: navigationShell);
        },
        branches: [
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.home,
                builder: (context, state) => const HomeMoodScreen(),
                routes: [
                  GoRoute(
                    path: 'mood',
                    builder: (context, state) => const MoodScreen(),
                  ),
                ],
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.history,
                builder: (context, state) =>
                    const SafeArea(bottom: false, child: HistoryScreen()),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.insights,
                builder: (context, state) =>
                    const SafeArea(bottom: false, child: InsightsScreen()),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.settings,
                builder: (context, state) => const SettingsScreen(),
              ),
            ],
          ),
        ],
      ),
    ],
    errorBuilder: (context, state) => RouteErrorScreen(error: state.error),
  );
}

String? _redirect(BuildContext context, GoRouterState state) {
  final location = state.matchedLocation;

  // Splash owns its own timing and then decides where to go.
  if (location == AppRoutes.splash) {
    return null;
  }

  // Password reset must stay reachable even when a user is already signed in.
  if (location == AppRoutes.resetPassword) {
    return null;
  }

  final user = appComponent.authSignal.currentUser;

  if (user == null) {
    if (AppRoutes.publicRoutes.contains(location)) {
      final isOnboardingRoute = AppRoutes.onboardingRoutes.contains(location);
      final hasSeenOnboarding =
          appComponent.onboardingRepository.hasSeenOnboarding;
      if (isOnboardingRoute && hasSeenOnboarding) {
        return AppRoutes.signIn;
      }
      return null;
    }
    return AppRoutes.signIn;
  }

  // User is logged in — check if email is verified (Google users are always verified).
  final isGoogleUser = user.providerData.any(
    (info) => info.providerId == 'google.com',
  );
  if (!user.emailVerified && !isGoogleUser) {
    // Unverified users keep their session only to resend the link.
    if (!AppRoutes.publicRoutes.contains(location)) {
      return AppRoutes.verifyEmail;
    }
    return null;
  }

  if (AppRoutes.publicRoutes.contains(location)) {
    return AppRoutes.home;
  }

  return null;
}

CustomTransitionPage<void> _fadePage(
  GoRouterState state,
  Widget child, {
  Duration duration = const Duration(milliseconds: 300),
}) {
  return CustomTransitionPage<void>(
    key: state.pageKey,
    child: child,
    transitionDuration: duration,
    reverseTransitionDuration: duration,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      return FadeTransition(opacity: animation, child: child);
    },
  );
}
