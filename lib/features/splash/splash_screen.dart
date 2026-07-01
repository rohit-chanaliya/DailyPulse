import 'dart:async';
import 'package:flutter/material.dart';

import '../../app/theme/colors.dart';
import '../../shared/navigation/fade_page_route.dart';
import '../auth/widgets/auth_wrapper.dart';

/// The four distinct phases of our premium splash screen sequence.
enum SplashPhase {
  brandLogo,       // Cream background with terracotta logo
  progressLoading, // Dark warm charcoal background with 0-100% counter
  fetchingData,    // Sage green background with "Fetching Data" and shake interaction
  quote,           // Terracotta orange background with Albert Camus quote
}

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with TickerProviderStateMixin {
  SplashPhase _currentPhase = SplashPhase.brandLogo;
  double _progressValue = 0.0;
  final List<TouchRipple> _ripples = [];
  Timer? _phaseTimer;

  // Animation Controllers
  late final AnimationController _progressController;
  late final AnimationController _shakeController;
  late final Animation<double> _shakeAnimation;

  @override
  void initState() {
    super.initState();

    // 1. Progress animation controller (0% to 100% over 1.8 seconds)
    _progressController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1800),
    )..addListener(() {
        setState(() {
          _progressValue = _progressController.value * 100;
        });
      })..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          // Subtle pause at 100% before transition
          Future.delayed(const Duration(milliseconds: 300), () {
            if (mounted) {
              _transitionTo(SplashPhase.fetchingData);
            }
          });
        }
      });

    // 2. Shake/Wiggle animation controller (triggered by interaction)
    _shakeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _shakeAnimation = TweenSequence<double>([
      TweenSequenceItem(tween: Tween(begin: 0.0, end: 12.0), weight: 1),
      TweenSequenceItem(tween: Tween(begin: 12.0, end: -12.0), weight: 2),
      TweenSequenceItem(tween: Tween(begin: -12.0, end: 10.0), weight: 2),
      TweenSequenceItem(tween: Tween(begin: 10.0, end: -8.0), weight: 2),
      TweenSequenceItem(tween: Tween(begin: -8.0, end: 6.0), weight: 2),
      TweenSequenceItem(tween: Tween(begin: 6.0, end: 0.0), weight: 1),
    ]).animate(CurvedAnimation(
      parent: _shakeController,
      curve: Curves.easeInOut,
    ));

    // Start Phase 1 timer
    _startPhase1Timer();
  }

  @override
  void dispose() {
    _phaseTimer?.cancel();
    _progressController.dispose();
    _shakeController.dispose();
    for (final ripple in _ripples) {
      ripple.controller.dispose();
    }
    super.dispose();
  }

  void _startPhase1Timer() {
    _phaseTimer = Timer(const Duration(milliseconds: 2200), () {
      if (mounted) {
        _transitionTo(SplashPhase.progressLoading);
      }
    });
  }

  void _transitionTo(SplashPhase nextPhase) {
    if (!mounted) return;
    setState(() {
      _currentPhase = nextPhase;
    });

    if (nextPhase == SplashPhase.progressLoading) {
      _progressController.forward(from: 0.0);
    } else if (nextPhase == SplashPhase.fetchingData) {
      // Phase 3: Fetching Data mock loads for 3 seconds
      _phaseTimer = Timer(const Duration(milliseconds: 3200), () {
        if (mounted) {
          _transitionTo(SplashPhase.quote);
        }
      });
    } else if (nextPhase == SplashPhase.quote) {
      // Phase 4: Stays for 4 seconds, then auto-navigates
      _phaseTimer = Timer(const Duration(milliseconds: 4500), () {
        if (mounted) {
          _navigateToAuth();
        }
      });
    }
  }

  void _navigateToAuth() {
    _phaseTimer?.cancel();
    _progressController.stop();
    _shakeController.stop();
    for (final ripple in _ripples) {
      ripple.controller.dispose();
    }
    _ripples.clear();

    Navigator.of(context).pushReplacement(
      FadePageRoute(
        page: const AuthWrapper(),
        duration: const Duration(milliseconds: 600),
      ),
    );
  }

  void _handleTapDown(TapDownDetails details) {
    if (_currentPhase == SplashPhase.fetchingData) {
      // 1. Play wiggle/shake feedback
      _shakeController.forward(from: 0.0);

      // 2. Spawn a beautiful touch ripple
      final controller = AnimationController(
        vsync: this,
        duration: const Duration(milliseconds: 800),
      );
      final ripple = TouchRipple(
        position: details.localPosition,
        controller: controller,
      );

      setState(() {
        _ripples.add(ripple);
      });

      controller.forward().then((_) {
        if (mounted) {
          setState(() {
            _ripples.remove(ripple);
          });
        }
        controller.dispose();
      });
    }
  }

  Color _getSkipButtonColor() {
    switch (_currentPhase) {
      case SplashPhase.brandLogo:
        return AppColors.splashCreamBrand.withValues(alpha: 0.5);
      case SplashPhase.progressLoading:
      case SplashPhase.fetchingData:
      case SplashPhase.quote:
        return Colors.white.withValues(alpha: 0.5);
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: Stack(
        children: [
          // Content layer with animated transitions between phases
          Positioned.fill(
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 800),
              switchInCurve: Curves.easeInOut,
              switchOutCurve: Curves.easeInOut,
              child: _buildPhaseContent(size),
            ),
          ),

          // Global skip button overlay
          Positioned(
            top: 16,
            right: 16,
            child: SafeArea(
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 400),
                child: TextButton(
                  key: ValueKey(_currentPhase),
                  onPressed: _navigateToAuth,
                  style: TextButton.styleFrom(
                    foregroundColor: _getSkipButtonColor(),
                  ),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'Skip',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 0.2,
                        ),
                      ),
                      SizedBox(width: 4),
                      Icon(Icons.chevron_right_rounded, size: 18),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPhaseContent(Size size) {
    switch (_currentPhase) {
      case SplashPhase.brandLogo:
        return _buildBrandLogoPhase(size);
      case SplashPhase.progressLoading:
        return _buildProgressLoadingPhase(size);
      case SplashPhase.fetchingData:
        return _buildFetchingDataPhase(size);
      case SplashPhase.quote:
        return _buildQuotePhase(size);
    }
  }

  // --- PHASE 1: BRAND LOGO ---
  Widget _buildBrandLogoPhase(Size size) {
    const brandColor = AppColors.splashCreamBrand; // Terracotta/Brown
    return Container(
      key: const ValueKey(SplashPhase.brandLogo),
      color: AppColors.splashCreamBg, // Creamy Off-white
      width: double.infinity,
      height: double.infinity,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const FourCircleLogo(
              size: 80,
              color: brandColor,
            ),
            const SizedBox(height: 24),
            Text(
              'dailypulse.ai',
              style: TextStyle(
                fontFamily: 'Urbanist',
                fontSize: 32,
                fontWeight: FontWeight.w800,
                color: brandColor,
                letterSpacing: -1.0,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // --- PHASE 2: PROGRESS LOADING ---
  Widget _buildProgressLoadingPhase(Size size) {
    return Container(
      key: const ValueKey(SplashPhase.progressLoading),
      color: AppColors.splashDarkBg, // Deep Dark Brown
      width: double.infinity,
      height: double.infinity,
      child: Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.center,
        children: [
          // Background overlapping circles
          ..._buildPhase2Circles(size.width, size.height),

          // Central Percentage Text
          Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.baseline,
              textBaseline: TextBaseline.alphabetic,
              children: [
                Text(
                  _progressValue.toInt().toString(),
                  style: const TextStyle(
                    fontSize: 84,
                    fontWeight: FontWeight.w800,
                    color: Colors.white,
                    letterSpacing: -2.0,
                  ),
                ),
                const SizedBox(width: 2),
                Text(
                  '%',
                  style: TextStyle(
                    fontSize: 36,
                    fontWeight: FontWeight.w700,
                    color: Colors.white.withValues(alpha: 0.7),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> _buildPhase2Circles(double width, double height) {
    const circleColor = AppColors.splashDarkOverlay;
    return [
      BackgroundCircle(
        diameter: width * 0.9,
        color: circleColor,
        top: -width * 0.35,
        left: width * 0.05,
      ),
      BackgroundCircle(
        diameter: width * 0.72,
        color: circleColor,
        top: height * 0.28,
        left: -width * 0.36,
      ),
      BackgroundCircle(
        diameter: width * 0.72,
        color: circleColor,
        top: height * 0.34,
        right: -width * 0.36,
      ),
      BackgroundCircle(
        diameter: width * 0.9,
        color: circleColor,
        bottom: -width * 0.35,
        left: width * 0.05,
      ),
    ];
  }

  // --- PHASE 3: FETCHING DATA ---
  Widget _buildFetchingDataPhase(Size size) {
    return GestureDetector(
      key: const ValueKey(SplashPhase.fetchingData),
      onTapDown: _handleTapDown,
      behavior: HitTestBehavior.opaque,
      child: Container(
        color: AppColors.splashGreenBg, // Sage Green
        width: double.infinity,
        height: double.infinity,
        child: Stack(
          alignment: Alignment.center,
          children: [
            // Background circles
            ..._buildPhase3Circles(size.width, size.height),

            // Expanding ripple paint layer
            Positioned.fill(
              child: CustomPaint(
                painter: RipplePainter(ripples: _ripples),
              ),
            ),

            // Centered Interacting and shaking text
            Center(
              child: AnimatedBuilder(
                animation: _shakeAnimation,
                builder: (context, child) {
                  return Transform.translate(
                    offset: Offset(_shakeAnimation.value, 0),
                    child: child,
                  );
                },
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'Fetching Data...',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.w800,
                        color: Colors.white,
                        letterSpacing: -0.5,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'Shake your screen to interact!',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: Colors.white.withValues(alpha: 0.75),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildPhase3Circles(double width, double height) {
    final circleColor = Colors.white.withValues(alpha: 0.18);
    return [
      BackgroundCircle(
        diameter: width * 0.6,
        color: circleColor,
        top: -width * 0.15,
        right: -width * 0.15,
      ),
      BackgroundCircle(
        diameter: width * 0.5,
        color: circleColor,
        top: height * 0.22,
        left: -width * 0.25,
      ),
      BackgroundCircle(
        diameter: width * 0.5,
        color: circleColor,
        bottom: height * 0.08,
        left: -width * 0.18,
      ),
      BackgroundCircle(
        diameter: width * 0.6,
        color: circleColor,
        bottom: -width * 0.2,
        right: -width * 0.2,
      ),
    ];
  }

  // --- PHASE 4: MINDFULNESS QUOTE ---
  Widget _buildQuotePhase(Size size) {
    return Container(
      key: const ValueKey(SplashPhase.quote),
      color: AppColors.splashOrangeBg, // Terracotta Orange
      width: double.infinity,
      height: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 40),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Spacer(flex: 3),
          const FourCircleLogo(
            size: 60,
            color: Colors.white,
          ),
          const Spacer(flex: 2),
          const Text(
            '"In the midst of winter, I found there was within me an invincible summer."',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              fontStyle: FontStyle.italic,
              color: Colors.white,
              height: 1.45,
            ),
          ),
          const SizedBox(height: 20),
          Text(
            '— ALBERT CAMUS',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w800,
              color: Colors.white.withValues(alpha: 0.8),
              letterSpacing: 2.0,
            ),
          ),
          const Spacer(flex: 3),
          // Clean custom Continue button at the bottom
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.only(bottom: 24.0),
              child: Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Colors.white.withValues(alpha: 0.4),
                    width: 1.5,
                  ),
                ),
                child: IconButton(
                  iconSize: 28,
                  padding: const EdgeInsets.all(12),
                  icon: const Icon(
                    Icons.arrow_forward_rounded,
                    color: Colors.white,
                  ),
                  onPressed: _navigateToAuth,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// A premium, custom-shaped logo with four overlapping/touching circles.
class FourCircleLogo extends StatelessWidget {
  final double size;
  final Color color;

  const FourCircleLogo({
    super.key,
    this.size = 64,
    this.color = AppColors.splashCreamBrand,
  });

  @override
  Widget build(BuildContext context) {
    final double circleSize = size * 0.46;
    final double offset = size * 0.17;

    return SizedBox(
      width: size,
      height: size,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Top Circle
          Positioned(
            top: size / 2 - circleSize / 2 - offset,
            child: _circle(),
          ),
          // Bottom Circle
          Positioned(
            bottom: size / 2 - circleSize / 2 - offset,
            child: _circle(),
          ),
          // Left Circle
          Positioned(
            left: size / 2 - circleSize / 2 - offset,
            child: _circle(),
          ),
          // Right Circle
          Positioned(
            right: size / 2 - circleSize / 2 - offset,
            child: _circle(),
          ),
        ],
      ),
    );
  }

  Widget _circle() {
    return Container(
      width: size * 0.46,
      height: size * 0.46,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
      ),
    );
  }
}

/// A utility layout widget representing background bubble elements.
class BackgroundCircle extends StatelessWidget {
  final double diameter;
  final Color color;
  final double? top;
  final double? bottom;
  final double? left;
  final double? right;

  const BackgroundCircle({
    super.key,
    required this.diameter,
    required this.color,
    this.top,
    this.bottom,
    this.left,
    this.right,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: top,
      bottom: bottom,
      left: left,
      right: right,
      width: diameter,
      height: diameter,
      child: Container(
        decoration: BoxDecoration(
          color: color,
          shape: BoxShape.circle,
        ),
      ),
    );
  }
}

/// An interactive ripple model registered on tap.
class TouchRipple {
  final Offset position;
  final AnimationController controller;

  TouchRipple({
    required this.position,
    required this.controller,
  });
}

/// Painter for Phase 3 to render dynamic touch ripples in real-time.
class RipplePainter extends CustomPainter {
  final List<TouchRipple> ripples;

  RipplePainter({required this.ripples})
      : super(repaint: Listenable.merge(ripples.map((r) => r.controller).toList()));

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..style = PaintingStyle.fill;
    for (final ripple in ripples) {
      final progress = ripple.controller.value;
      final radius = 20.0 + (190.0 * progress);
      final opacity = (1.0 - progress) * 0.22;
      paint.color = Colors.white.withValues(alpha: opacity);
      canvas.drawCircle(ripple.position, radius, paint);
    }
  }

  @override
  bool shouldRepaint(covariant RipplePainter oldDelegate) => true;
}
