import 'package:dailypulse/app/theme/app_theme.dart';
import 'package:dailypulse/features/auth/presentation/providers/auth_provider.dart';
import 'package:dailypulse/features/insights/presentation/providers/insights_provider.dart';
import 'package:dailypulse/features/mood/data/local/hive_service.dart';
import 'package:dailypulse/features/mood/presentation/providers/mood_provider.dart';
import 'package:dailypulse/features/settings/presentation/providers/theme_provider.dart';
import 'package:dailypulse/features/splash/splash_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await HiveService.init();

  runApp(const DailyPulseApp());
}

class DailyPulseApp extends StatelessWidget {
  const DailyPulseApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => MoodProvider()),
        ChangeNotifierProvider(create: (_) => InsightsProvider()),
      ],
      child: Consumer<ThemeProvider>(
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
