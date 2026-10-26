import 'package:dailypulse/core/di/injection.dart';
import 'package:dailypulse/core/router/app_routes.dart';
import 'package:dailypulse/core/router/route_error_screen.dart';
import 'package:dailypulse/core/router/router_refresh_stream.dart';
import 'package:dailypulse/features/app/presentation/app_shell.dart';
import 'package:dailypulse/features/auth/screens/forgot_password_screen.dart';
import 'package:dailypulse/features/auth/screens/reset_password_screen.dart';
import 'package:dailypulse/features/auth/screens/sign_in_screen.dart';
import 'package:dailypulse/features/auth/screens/sign_up_screen.dart';
import 'package:dailypulse/features/auth/screens/verify_email_screen.dart';
import 'package:dailypulse/features/history/screens/history_screen.dart';
import 'package:dailypulse/features/insights/screens/insights_screen.dart';
import 'package:dailypulse/features/mood/presentation/models/mood_option.dart';
import 'package:dailypulse/features/mood/presentation/screens/add_note_screen.dart';
import 'package:dailypulse/features/mood/presentation/screens/home_mood_screen.dart';
import 'package:dailypulse/features/onboarding/views/onboarding_screen.dart';
import 'package:dailypulse/features/onboarding/views/splash_screen.dart';
import 'package:dailypulse/features/onboarding/views/welcome_screen.dart';
import 'package:dailypulse/features/settings/screens/settings_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

GoRouter createAppRouter({GlobalKey<NavigatorState>? navigatorKey}) {
  return GoRouter(
    navigatorKey: navigatorKey,
    initialLocation: AppRoutes.splash,
    refreshListenable: RouterRefreshStream(
      FirebaseAuth.instance.authStateChanges(),
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
            VerifyEmailScreen(
              email: extra['email'] as String? ?? '',
              password: extra['password'] as String? ?? '',
            ),
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
        path: AppRoutes.addNote,
        pageBuilder: (context, state) {
          final mood = state.extra! as MoodOption;
          final userId = FirebaseAuth.instance.currentUser?.uid ?? '';
          return _fadePage(state, AddNoteScreen(mood: mood, userId: userId));
        },
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

  final user = FirebaseAuth.instance.currentUser;

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
    // Unverified user tried to go somewhere protected: sign them out and
    // send to sign-in so they can re-authenticate after verifying.
    if (!AppRoutes.publicRoutes.contains(location)) {
      return AppRoutes.signIn;
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
