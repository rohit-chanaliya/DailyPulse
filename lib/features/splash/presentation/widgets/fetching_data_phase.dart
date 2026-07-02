import 'package:flutter/material.dart';
import 'package:dailypulse/core/theme/colors.dart';
import 'background_circle.dart';
import '../providers/splash_provider.dart';

class TouchRipple {
  final Offset position;
  final AnimationController controller;

  TouchRipple({
    required this.position,
    required this.controller,
  });
}

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

class FetchingDataPhase extends StatefulWidget {
  const FetchingDataPhase({super.key});

  @override
  State<FetchingDataPhase> createState() => _FetchingDataPhaseState();
}

class _FetchingDataPhaseState extends State<FetchingDataPhase> with TickerProviderStateMixin {
  final List<TouchRipple> _ripples = [];
  late final AnimationController _shakeController;
  late final Animation<double> _shakeAnimation;

  @override
  void initState() {
    super.initState();
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
  }

  @override
  void dispose() {
    _shakeController.dispose();
    for (final ripple in _ripples) {
      ripple.controller.dispose();
    }
    super.dispose();
  }

  void _handleTapDown(TapDownDetails details) {
    _shakeController.forward(from: 0.0);

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

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final width = size.width;
    final height = size.height;
    final circleColor = Colors.white.withValues(alpha: 0.18);

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
}
