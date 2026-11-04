import 'package:flutter/material.dart';

/// Bar outline with rounded top corners and a smooth dip under the center button.
class NotchedBarClipper extends CustomClipper<Path> {
  const NotchedBarClipper({
    this.cornerRadius = 36,
    this.notchDepth = 37,
    this.notchHalfWidth = 66,
  });

  final double cornerRadius;
  final double notchDepth;
  final double notchHalfWidth;

  @override
  Path getClip(Size size) {
    final cx = size.width / 2;
    final r = cornerRadius;
    final w = notchHalfWidth;
    final shoulder = w * 0.6;

    return Path()
      ..moveTo(0, r)
      ..arcToPoint(Offset(r, 0), radius: Radius.circular(r))
      ..lineTo(cx - w, 0)
      ..cubicTo(
        cx - w + shoulder,
        0,
        cx - w * 0.55,
        notchDepth,
        cx,
        notchDepth,
      )
      ..cubicTo(
        cx + w * 0.55,
        notchDepth,
        cx + w - shoulder,
        0,
        cx + w,
        0,
      )
      ..lineTo(size.width - r, 0)
      ..arcToPoint(Offset(size.width, r), radius: Radius.circular(r))
      ..lineTo(size.width, size.height)
      ..lineTo(0, size.height)
      ..close();
  }

  @override
  bool shouldReclip(NotchedBarClipper old) =>
      old.cornerRadius != cornerRadius ||
      old.notchDepth != notchDepth ||
      old.notchHalfWidth != notchHalfWidth;
}
