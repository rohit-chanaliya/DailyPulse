import 'package:dailypulse/core/theme/colors.dart';
import 'package:dailypulse/core/theme/typography.dart';
import 'package:dailypulse/features/splash/presentation/widgets/four_circle_logo.dart';
import 'package:flutter/material.dart';

/// Reusable curved wave header for Sign In & Sign Up screens.
class CurvedHeader extends StatelessWidget {
  final double height;
  const CurvedHeader({super.key, this.height = 175});

  @override
  Widget build(BuildContext context) {
    return ClipPath(
      clipper: CurvedHeaderClipper(),
      child: Container(
        width: double.infinity,
        height: height,
        color: AppColors.splashGreenBg, // Sage Green
        child: const Center(
          child: SafeArea(
            bottom: false,
            child: FourCircleLogo(
              size: 48,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}

/// Custom clipper that draws a smooth, convex wave bowing down in the center.
class CurvedHeaderClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    path.lineTo(0, size.height - 35);
    
    final firstControlPoint = Offset(size.width / 2, size.height + 15);
    final firstEndPoint = Offset(size.width, size.height - 35);
    path.quadraticBezierTo(
      firstControlPoint.dx,
      firstControlPoint.dy,
      firstEndPoint.dx,
      firstEndPoint.dy,
    );
    
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => false;
}




/// Facebook, Google, and Instagram circular social buttons.
class SocialRow extends StatelessWidget {
  const SocialRow({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final circleColor = isDark ? const Color(0xFF2C221D) : const Color(0xFFEAE2DA);

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildSocialCircle('f', circleColor, isDark),
        const SizedBox(width: 16),
        _buildSocialCircle('G', circleColor, isDark),
        const SizedBox(width: 16),
        _buildSocialCircle(null, circleColor, isDark, icon: Icons.camera_alt_outlined),
      ],
    );
  }

  Widget _buildSocialCircle(String? text, Color bgColor, bool isDark, {IconData? icon}) {
    final textColor = isDark ? Colors.white.withValues(alpha: 0.9) : const Color(0xFF5A4535);

    return Container(
      width: 44,
      height: 44,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: bgColor,
      ),
      child: Center(
        child: text != null
            ? Text(
                text,
                style: AppTypography.textLgBold.copyWith(
                  color: textColor,
                  fontFamily: 'serif',
                ),
              )
            : Icon(
                icon,
                size: 18,
                color: textColor,
              ),
      ),
    );
  }
}
