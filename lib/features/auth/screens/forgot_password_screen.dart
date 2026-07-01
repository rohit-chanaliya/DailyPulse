import 'package:dailypulse/app/theme/colors.dart';
import 'package:dailypulse/app/theme/typography.dart';
import 'package:dailypulse/core/utils/snackbar_utils.dart';
import 'package:dailypulse/core/widgets/custom_button.dart';
import 'package:flutter/material.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  int _selectedOptionIndex = 0; // 0: Password (Email), 1: 2FA, 2: Google Auth

  void _handleSendPassword() {
    String option = 'Password Reset Link';
    if (_selectedOptionIndex == 1) option = '2FA Code';
    if (_selectedOptionIndex == 2) option = 'Google Authenticator setup';

    SnackBarUtils.showSuccess(context, 'Reset method via $option sent successfully!');
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textDarkColor = isDark ? Colors.white : const Color(0xFF402B20); // dark brown title

    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF161210) : AppColors.splashCreamBg, // cream bg matching mockup
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(80),
        child: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leadingWidth: 72,
          leading: Padding(
            padding: const EdgeInsets.only(left: 24.0, top: 20.0),
            child: Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: isDark ? const Color(0xFF38302B) : const Color(0xFFEAE2DA),
                  width: 1.2,
                ),
              ),
              child: IconButton(
                icon: Icon(
                  Icons.chevron_left_rounded,
                  color: isDark ? Colors.white : const Color(0xFF5A4535),
                ),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ),
          ),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 28.0, vertical: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 24),
              // Title
              Text(
                'Forgot Password',
                style: AppTypography.displaySmExtraBold.copyWith(
                  color: textDarkColor,
                ),
              ),
              const SizedBox(height: 8),
              
              // Subtitle
              Text(
                'Select contact details where you want to reset your password.',
                style: AppTypography.paragraphSm.copyWith(
                  color: isDark ? Colors.grey.shade400 : Colors.grey.shade600,
                  height: 1.4,
                ),
              ),
              const SizedBox(height: 36),

              // Options list
              Expanded(
                child: ListView(
                  children: [
                    _buildOptionCard(
                      index: 0,
                      title: 'Password',
                      icon: Icons.lock_outline_rounded,
                      isDark: isDark,
                    ),
                    const SizedBox(height: 16),
                    _buildOptionCard(
                      index: 1,
                      title: 'Use 2FA',
                      icon: Icons.security_rounded,
                      isDark: isDark,
                    ),
                    const SizedBox(height: 16),
                    _buildOptionCard(
                      index: 2,
                      title: 'Google Authenticator',
                      icon: Icons.vpn_key_rounded,
                      isDark: isDark,
                    ),
                  ],
                ),
              ),

              // Send Password Button
              AppButton(
                text: 'Send Password',
                suffixIcon: Icons.lock_outline_rounded,
                onPressed: _handleSendPassword,
              ),
              const SizedBox(height: 12),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildOptionCard({
    required int index,
    required String title,
    required IconData icon,
    required bool isDark,
  }) {
    final isSelected = _selectedOptionIndex == index;
    
    // Selection Border Color: light green matching mockup
    final border = isSelected
        ? Border.all(color: const Color(0xFF98AF86), width: 1.5)
        : Border.all(color: isDark ? const Color(0xFF2C221D) : const Color(0xFFEAE2DA).withValues(alpha: 0.5), width: 1.2);

    final cardBg = isDark ? const Color(0xFF231E1B) : Colors.white;

    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedOptionIndex = index;
        });
      },
      child: Container(
        height: 84,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        decoration: BoxDecoration(
          color: cardBg,
          borderRadius: BorderRadius.circular(42), // highly rounded pill card matching mockup
          border: border,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: isDark ? 0.2 : 0.03),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            // Left custom green circle icon
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isDark ? const Color(0xFF2A3620) : const Color(0xFFC8D9B8), // light sage background
              ),
              child: Icon(
                icon,
                color: isDark ? const Color(0xFFBCC9AE) : const Color(0xFF4A6532), // dark sage icon
                size: 20,
              ),
            ),
            const SizedBox(width: 16),
            // Title
            Expanded(
              child: Text(
                title,
                style: AppTypography.textMdSemiBold.copyWith(
                  color: isDark ? Colors.white : const Color(0xFF402B20),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
