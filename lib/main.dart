import 'package:dailypulse/core/router/app_router.dart';
import 'package:dailypulse/core/services/app_preferences.dart';
import 'package:dailypulse/core/theme/app_theme.dart';
import 'package:dailypulse/features/mood/data/local/hive_service.dart';
import 'package:dailypulse/features/settings/presentation/signals/theme_signal.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:signals_flutter/signals_flutter.dart';

import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await HiveService.init();
  await AppPreferences.init();

  runApp(DailyPulseApp(router: createAppRouter()));
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
        themeMode: themeSignal.themeMode,
        debugShowCheckedModeBanner: false,
        routerConfig: router,
      ),
    );
  }
}
