import 'package:flutter/material.dart';

class AppLogoWidget extends StatelessWidget {
  final double size;

  const AppLogoWidget({
    super.key,
    this.size = 150.0,
  });

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      'assets/mindful_yoga_logo.png',
      width: size,
      height: size,
      fit: BoxFit.contain,
    );
  }
}
