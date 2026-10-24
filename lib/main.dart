import 'dart:async';

import 'package:dailypulse/core/di/injection.dart';
import 'package:dailypulse/core/router/app_router.dart';
import 'package:dailypulse/core/services/app_preferences.dart';
import 'package:dailypulse/core/services/deep_link_service.dart';
import 'package:dailypulse/core/theme/app_theme.dart';
import 'package:dailypulse/features/mood/data/local/hive_service.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:signals_flutter/signals_flutter.dart';

import 'firebase_options.dart';

final _navigatorKey = GlobalKey<NavigatorState>();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await HiveService.init();
  await AppPreferences.init();

  initDependencies();

  // Start the auth listener before the first frame so the user is known early.
  final _ = appComponent.authSignal;

  final router = createAppRouter(navigatorKey: _navigatorKey);

  // Initialise deep-link handling for email verification.
  unawaited(DeepLinkService.init(_navigatorKey));

  runApp(DailyPulseApp(router: router));
}

class DailyPulseApp extends StatelessWidget {
  const DailyPulseApp({super.key, required this.router});

  final GoRouter router;

  @override
  Widget build(BuildContext context) {
    return SignalBuilder(
      builder: (context) => MaterialApp.router(
        title: 'DailyPulse',
        theme: AppTheme.lightTheme,
        darkTheme: AppTheme.darkTheme,
        themeMode: appComponent.themeSignal.themeMode,
        debugShowCheckedModeBanner: false,
        routerConfig: router,
      ),
    );
  }
}
