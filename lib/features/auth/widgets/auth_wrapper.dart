import 'package:dailypulse/app_scaffold.dart';
import 'package:dailypulse/features/auth/presentation/providers/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../screens/sign_in_screen.dart';

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthProvider>(
      builder: (context, authProvider, _) {
        switch (authProvider.status) {
          case AuthStatus.initial:
            return const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            );
          case AuthStatus.authenticated:
            return const AppScaffold();
          case AuthStatus.unauthenticated:
          case AuthStatus.loading:
            return const SignInScreen();
        }
      },
    );
  }
}
