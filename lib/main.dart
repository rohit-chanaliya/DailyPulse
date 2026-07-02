import 'package:dailypulse/core/theme/app_theme.dart';
import 'package:dailypulse/features/auth/presentation/providers/auth_provider.dart';
import 'package:dailypulse/features/insights/presentation/providers/insights_provider.dart';
import 'package:dailypulse/features/mood/data/local/objectbox_service.dart';
import 'package:dailypulse/features/mood/presentation/providers/mood_provider.dart';
import 'package:dailypulse/features/settings/presentation/providers/theme_provider.dart';
import 'package:dailypulse/features/splash/views/splash_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:provider/provider.dart' as legacy_provider;
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await ObjectBoxService.init();

  runApp(const ProviderScope(child: DailyPulseApp()));
}

class DailyPulseApp extends StatelessWidget {
  const DailyPulseApp({super.key});

  @override
  Widget build(BuildContext context) {
    return legacy_provider.MultiProvider(
      providers: [
        legacy_provider.ChangeNotifierProvider(create: (_) => ThemeProvider()),
        legacy_provider.ChangeNotifierProvider(create: (_) => AuthProvider()),
        legacy_provider.ChangeNotifierProvider(create: (_) => MoodProvider()),
        legacy_provider.ChangeNotifierProvider(
          create: (_) => InsightsProvider(),
        ),
      ],
      child: legacy_provider.Consumer<ThemeProvider>(
        builder: (context, theme, _) {
          return MaterialApp(
            title: 'DailyPulse',
            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,
            themeMode: theme.themeMode,
            home: const SplashScreen(),
          );
        },
      ),
    );
  }
}
