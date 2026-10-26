import 'package:flutter/material.dart';
import 'package:dailypulse/core/constant/strings/onboarding_strings.dart';
import 'package:dailypulse/core/theme/app_theme.dart';
import 'package:dailypulse/core/widgets/app_logo_widget.dart';
import '../../viewmodels/splash_signal.dart';

/// Phase 1 of splash: Displays the brand logo and name with a mindful
/// breathing pulse and seamless entrance from the OS native splash.
class BrandLogoPhase extends StatefulWidget {
  const BrandLogoPhase({super.key});

  @override
  State<BrandLogoPhase> createState() => _BrandLogoPhaseState();
}

class _BrandLogoPhaseState extends State<BrandLogoPhase>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _breatheAnimation;
  late final Animation<double> _textFadeAnimation;
  late final Animation<Offset> _textSlideAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    );

    // Subtle mindful breathing: scale 1.0 -> 1.05 -> 1.0 with smooth sine curves
    _breatheAnimation = TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween<double>(begin: 1.0, end: 1.05)
            .chain(CurveTween(curve: Curves.easeInOutSine)),
        weight: 50,
      ),
      TweenSequenceItem(
        tween: Tween<double>(begin: 1.05, end: 1.0)
            .chain(CurveTween(curve: Curves.easeInOutSine)),
        weight: 50,
      ),
    ]).animate(_controller);

    // "dailypulse.ai" fades in gently after a slight delay
    // so frame 0 perfectly matches the OS native splash (which has no text)
    _textFadeAnimation = CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.15, 0.55, curve: Curves.easeOut),
    );

    _textSlideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.25),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.15, 0.55, curve: Curves.easeOutCubic),
      ),
    );

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final splashColors = context.splash;

    return Container(
      key: const ValueKey(SplashPhase.brandLogo),
      color: splashColors.brandLogoBg,
      width: double.infinity,
      height: double.infinity,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Logo placed dead-center to align pixel-perfect with OS native splash
          Center(
            child: ScaleTransition(
              scale: _breatheAnimation,
              child: const AppLogoWidget(size: 150),
            ),
          ),
          // "dailypulse.ai" text positioned right below the centered logo
          Center(
            child: Transform.translate(
              offset: const Offset(0, 105),
              child: SlideTransition(
                position: _textSlideAnimation,
                child: FadeTransition(
                  opacity: _textFadeAnimation,
                  child: Text(
                    OnboardingStrings.splashBrandName,
                    style: context.textTheme.displaySmall?.copyWith(
                      fontWeight: FontWeight.w800,
                      color: splashColors.brandLogoColor,
                      letterSpacing: 0,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
