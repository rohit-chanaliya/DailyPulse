import 'package:flutter/material.dart';

import 'package:dailypulse/core/constant/strings/home_strings.dart';
import 'package:dailypulse/core/theme/context_extensions.dart';
import 'package:dailypulse/features/mood/presentation/models/home_assets.dart';
import 'chatbot_illustration.dart';
import 'home_asset_icon.dart';
import 'home_section_title.dart';

class HomeChatbotSection extends StatelessWidget {
  const HomeChatbotSection({super.key});

  @override
  Widget build(BuildContext context) {
    final home = context.home;
    return Column(
      children: [
        const HomeSectionTitle(
          HomeStrings.chatbotTitle,
          actionIcon: HomeSectionTitle.chatbotSettings,
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 230,
          child: Stack(
            alignment: Alignment.topCenter,
            children: [
              Container(
                height: 198,
                decoration: BoxDecoration(
                  color: home.headerSurface,
                  borderRadius: BorderRadius.circular(32),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(32),
                  child: const Stack(
                    children: [
                      Positioned.fill(child: ChatbotIllustration()),
                      Positioned(left: 24, top: 24, child: _ChatbotCopy()),
                    ],
                  ),
                ),
              ),
              Positioned(
                bottom: 0,
                child: Row(
                  children: [
                    _ChatbotAction(color: home.green, icon: HomeAssets.add),
                    const SizedBox(width: 16),
                    _ChatbotAction(color: home.orange, icon: HomeAssets.gear),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _ChatbotCopy extends StatelessWidget {
  const _ChatbotCopy();

  @override
  Widget build(BuildContext context) {
    final home = context.home;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          HomeStrings.conversations,
          style: context.textTheme.displayMedium?.copyWith(
            color: home.onMedia,
            fontSize: 48,
            fontWeight: FontWeight.w800,
            height: 56 / 48,
            letterSpacing: -1.44,
          ),
        ),
        Text(
          HomeStrings.conversationsLabel,
          style: context.textTheme.headlineMedium?.copyWith(
            color: home.onMedia,
            fontWeight: FontWeight.w800,
          ),
        ),
        const SizedBox(height: 12),
        const _ChatbotDetail(
          icon: HomeAssets.chat,
          label: HomeStrings.conversationsLeft,
        ),
        const SizedBox(height: 4),
        const _ChatbotDetail(icon: HomeAssets.star, label: HomeStrings.goPro),
      ],
    );
  }
}

class _ChatbotDetail extends StatelessWidget {
  const _ChatbotDetail({required this.icon, required this.label});

  final String icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        HomeAssetIcon(icon, size: 20),
        const SizedBox(width: 8),
        Text(
          label,
          style: context.textTheme.bodyMedium?.copyWith(
            color: context.home.onMedia,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}

class _ChatbotAction extends StatelessWidget {
  const _ChatbotAction({required this.color, required this.icon});

  final Color color;
  final String icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 64,
      height: 64,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: color.withValues(alpha: 0.15),
            blurRadius: 32,
            offset: const Offset(0, 16),
          ),
        ],
      ),
      child: Center(child: HomeAssetIcon(icon)),
    );
  }
}
