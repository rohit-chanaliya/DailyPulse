import 'dart:math' as math;

import 'package:flutter/material.dart';

import 'package:dailypulse/core/constant/strings/home_strings.dart';
import 'package:dailypulse/core/theme/context_extensions.dart';
import 'package:dailypulse/features/mood/models/home_assets.dart';
import 'home_asset_icon.dart';
import 'home_metric_card.dart';

/// Mood score ring (0-100) built from the last 30 days of entries.
class FreudScoreCard extends StatelessWidget {
  const FreudScoreCard({super.key, required this.score});

  final int? score;

  String get _label => switch (score) {
    null => HomeStrings.scoreNoData,
    >= 80 => HomeStrings.scoreExcellent,
    >= 60 => HomeStrings.scoreHealthy,
    >= 40 => HomeStrings.scoreBalanced,
    >= 20 => HomeStrings.scoreLow,
    _ => HomeStrings.scoreStruggling,
  };

  @override
  Widget build(BuildContext context) {
    final home = context.home;

    return HomeMetricCard(
      color: home.green,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            spacing: 8,
            children: [
              const HomeAssetIcon(HomeAssets.heart),
              Expanded(
                child: Text(
                  HomeStrings.scoreTitle,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: context.textTheme.titleLarge?.copyWith(
                    color: home.onMedia,
                  ),
                ),
              ),
            ],
          ),
          const Spacer(),
          Center(
            child: SizedBox(
              width: 120,
              height: 120,
              child: CustomPaint(
                painter: _RingPainter(
                  progress: (score ?? 0) / 100,
                  track: home.greenLight.withValues(alpha: 0.35),
                  fill: home.greenPale,
                ),
                child: Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        score?.toString() ?? HomeStrings.noValue,
                        style: context.textTheme.headlineLarge?.copyWith(
                          color: home.greenPale,
                        ),
                      ),
                      Text(
                        _label,
                        style: context.textTheme.labelMedium?.copyWith(
                          color: home.greenLight,
                        ),
                      ),
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
}

class _RingPainter extends CustomPainter {
  const _RingPainter({
    required this.progress,
    required this.track,
    required this.fill,
  });

  final double progress;
  final Color track;
  final Color fill;

  @override
  void paint(Canvas canvas, Size size) {
    const stroke = 12.0;
    final rect = (Offset.zero & size).deflate(stroke / 2);
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = stroke
      ..strokeCap = StrokeCap.round;

    canvas.drawArc(rect, 0, 2 * math.pi, false, paint..color = track);
    if (progress > 0) {
      canvas.drawArc(
        rect,
        -math.pi / 2,
        2 * math.pi * progress.clamp(0, 1),
        false,
        paint..color = fill,
      );
    }
  }

  @override
  bool shouldRepaint(_RingPainter oldDelegate) =>
      oldDelegate.progress != progress ||
      oldDelegate.track != track ||
      oldDelegate.fill != fill;
}
