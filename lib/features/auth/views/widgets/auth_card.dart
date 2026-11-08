import 'package:flutter/material.dart';

/// Pass-through wrapper for auth form content without boxed card borders.
class AuthCard extends StatelessWidget {
  final Widget child;

  const AuthCard({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return child;
  }
}
