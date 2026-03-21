import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../../../../core/utils/mood_utils.dart';
import '../../../../core/utils/snackbar_utils.dart';
import '../../../../shared/navigation/fade_page_route.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../models/mood_option.dart';
import 'add_note_screen.dart';
import '../../../../app/theme/app_theme.dart';

class HomeMoodScreen extends StatelessWidget {
  const HomeMoodScreen({super.key});

  void _onMoodSelected(BuildContext context, MoodOption mood) {
    final authProvider = context.read<AuthProvider>();
    final userId = authProvider.user?.uid;

    if (userId == null) {
      SnackBarUtils.showError(context, 'Please sign in to log your mood');
      return;
    }

    Navigator.push(
      context,
      FadePageRoute(
        page: AddNoteScreen(mood: mood, userId: userId),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final moods = MoodUtils.getMoodOptions();
    final authProvider = context.watch<AuthProvider>();
    final userName =
        authProvider.user?.displayName?.split(' ').first ?? 'Friend';

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light.copyWith(
        statusBarColor: Colors.transparent, // Allow purple to show through
      ),
      child: Stack(
        children: [
          // Top Purple Background covering the whole screen underneath
          Positioned.fill(
            child: Container(
              color: AppTheme.primaryBlue,
            ),
          ),

          SafeArea(
            child: Column(
              children: [
                // Header Row
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 12,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      CircleAvatar(
                        radius: 20,
                        backgroundColor: Colors.orange.shade200,
                        child: Text(
                          userName.isNotEmpty ? userName[0].toUpperCase() : 'U',
                          style: const TextStyle(
                            color: Colors.black87,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const Icon(
                        Icons.filter_vintage,
                        color: Colors.white,
                        size: 28,
                      ),
                      IconButton(
                        icon: const Icon(CupertinoIcons.bell),
                        color: Colors.white,
                        onPressed: () {},
                      ),
                    ],
                  ),
                ),

                // Search Bar
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Container(
                    height: 48,
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(24),
                    ),
                    child: Row(
                      children: [
                        const SizedBox(width: 16),
                        Icon(
                          CupertinoIcons.search,
                          color: Colors.white.withValues(alpha: 0.8),
                          size: 20,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'Search about anything...',
                          style: TextStyle(
                            color: Colors.white.withValues(alpha: 0.8),
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 24),

                // Greeting
                Text(
                  'Good Morning, $userName 👋',
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.9),
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'How are you today?',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 24),

                // Mood Selector
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: moods.take(5).map((mood) {
                      bool isNeutral = mood.label.toLowerCase() == 'neutral';
                      return GestureDetector(
                        onTap: () => _onMoodSelected(context, mood),
                        child: Column(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: isNeutral
                                      ? Colors.white
                                      : Colors.white.withValues(alpha: 0.3),
                                  width: isNeutral ? 2 : 1,
                                ),
                              ),
                              child: Text(
                                mood.emoji,
                                style: const TextStyle(fontSize: 28),
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              mood.label,
                              style: TextStyle(
                                color: isNeutral
                                    ? Colors.white
                                    : Colors.white.withValues(alpha: 0.7),
                                fontSize: 12,
                                fontWeight: isNeutral
                                    ? FontWeight.w600
                                    : FontWeight.normal,
                              ),
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                  ),
                ),

                const SizedBox(height: 32),

                // Bottom White Container Overlap
                Expanded(
                  child: ClipPath(
                    clipper: TopCurveClipper(),
                    child: Container(
                      width: double.infinity,
                      color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
                      child: ListView(
                        padding: const EdgeInsets.only(
                          top: 48,
                          left: 24,
                          right: 24,
                          bottom: 24,
                        ),
                        children: [
                          // Mood Tracking Section Placeholder
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Mood Tracking',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: isDark ? Colors.white : Colors.black87,
                                ),
                              ),
                              Text(
                                'View Details',
                                style: TextStyle(
                                  color: AppTheme.accentPink,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          Container(
                            padding: const EdgeInsets.all(20),
                            decoration: BoxDecoration(
                              color: isDark
                                  ? const Color(0xFF2C2C2C)
                                  : Colors.white,
                              borderRadius: BorderRadius.circular(24),
                              border: Border.all(
                                color: isDark
                                    ? Colors.transparent
                                    : Colors.grey.shade200,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withValues(alpha: 0.03),
                                  blurRadius: 10,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children:
                                  [
                                    'Mon',
                                    'Tue',
                                    'Wed',
                                    'Thu',
                                    'Fri',
                                    'Sat',
                                    'Sun',
                                  ].map((day) {
                                    return Column(
                                      children: [
                                        Text(
                                          ['Mon', 'Wed'].contains(day)
                                              ? '😔'
                                              : (['Tue', 'Thu'].contains(day)
                                                    ? '😊'
                                                    : '—'),
                                          style: TextStyle(
                                            fontSize: 20,
                                            color: Colors.grey.shade400,
                                          ),
                                        ),
                                        const SizedBox(height: 8),
                                        Text(
                                          day,
                                          style: TextStyle(
                                            fontSize: 12,
                                            color: Colors.grey.shade600,
                                          ),
                                        ),
                                      ],
                                    );
                                  }).toList(),
                            ),
                          ),

                          const SizedBox(height: 32),

                          // Start Your Day Section
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Start Your Day',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: isDark ? Colors.white : Colors.black87,
                                ),
                              ),
                              Text(
                                'View All',
                                style: TextStyle(
                                  color: AppTheme.accentPink,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          Container(
                            padding: const EdgeInsets.all(20),
                            decoration: BoxDecoration(
                              color: isDark
                                  ? const Color(0xFF2C2C2C)
                                  : Colors.white,
                              borderRadius: BorderRadius.circular(24),
                              border: Border.all(
                                color: isDark
                                    ? Colors.transparent
                                    : Colors.grey.shade200,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withValues(alpha: 0.03),
                                  blurRadius: 10,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Take pleasure in five deep breaths',
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                          color: isDark
                                              ? Colors.white
                                              : Colors.black87,
                                        ),
                                      ),
                                      const SizedBox(height: 12),
                                      Row(
                                        children: [
                                          Container(
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 10,
                                              vertical: 4,
                                            ),
                                            decoration: BoxDecoration(
                                              color: AppTheme.primaryBlue
                                                  .withValues(alpha: 0.1),
                                              borderRadius:
                                                  BorderRadius.circular(12),
                                            ),
                                            child: Text(
                                              'Mindful Activity',
                                              style: TextStyle(
                                                color: AppTheme.primaryBlue,
                                                fontSize: 10,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                          ),
                                          const SizedBox(width: 8),
                                          Row(
                                            children: [
                                              Icon(
                                                CupertinoIcons.clock,
                                                size: 12,
                                                color: Colors.grey.shade600,
                                              ),
                                              const SizedBox(width: 4),
                                              Text(
                                                '1 min',
                                                style: TextStyle(
                                                  color: Colors.grey.shade600,
                                                  fontSize: 12,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(width: 16),
                                Icon(
                                  CupertinoIcons.wind,
                                  size: 40,
                                  color: AppTheme.primaryBlue,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class TopCurveClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = Path();
    path.moveTo(0, 40);
    path.quadraticBezierTo(size.width / 2, 0, size.width, 40);
    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
