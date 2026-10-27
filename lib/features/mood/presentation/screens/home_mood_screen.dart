import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:signals_flutter/signals_flutter.dart';

import 'package:dailypulse/core/constant/strings/home_strings.dart';
import 'package:dailypulse/core/di/injection.dart';
import 'package:dailypulse/core/theme/context_extensions.dart';
import '../widgets/home_articles_section.dart';
import '../widgets/home_chatbot_section.dart';
import '../widgets/home_header.dart';
import '../widgets/home_metrics_section.dart';
import '../widgets/home_mood_picker.dart';
import '../widgets/home_tracker_section.dart';

class HomeMoodScreen extends StatelessWidget {
  const HomeMoodScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SignalBuilder(
      builder: (context) {
        final userName =
            appComponent.authSignal.user.value?.displayName?.split(' ').first ??
            HomeStrings.defaultUserName;
        return AnnotatedRegion<SystemUiOverlayStyle>(
          value: SystemUiOverlayStyle(
            statusBarColor: context.home.headerSurface,
            statusBarIconBrightness: Brightness.light,
            statusBarBrightness: Brightness.dark,
          ),
          child: Scaffold(
            backgroundColor: context.home.background,
            body: Stack(
              children: [
                Positioned(
                  left: 0,
                  top: 0,
                  right: 0,
                  height: MediaQuery.paddingOf(context).top,
                  child: ColoredBox(color: context.home.headerSurface),
                ),
                CustomScrollView(
                  slivers: [
                    SliverToBoxAdapter(child: HomeHeader(userName: userName)),
                    const SliverToBoxAdapter(child: SizedBox(height: 20)),
                    const SliverPadding(
                      padding: EdgeInsets.symmetric(horizontal: 16),
                      sliver: SliverToBoxAdapter(child: HomeMoodPicker()),
                    ),
                    const SliverToBoxAdapter(child: SizedBox(height: 24)),
                    const SliverToBoxAdapter(child: HomeMetricsSection()),
                    const SliverToBoxAdapter(child: SizedBox(height: 32)),
                    const SliverPadding(
                      padding: EdgeInsets.symmetric(horizontal: 16),
                      sliver: SliverToBoxAdapter(child: HomeTrackerSection()),
                    ),
                    const SliverToBoxAdapter(child: SizedBox(height: 32)),
                    const SliverPadding(
                      padding: EdgeInsets.symmetric(horizontal: 16),
                      sliver: SliverToBoxAdapter(child: HomeChatbotSection()),
                    ),
                    const SliverToBoxAdapter(child: SizedBox(height: 32)),
                    const SliverToBoxAdapter(child: HomeArticlesSection()),
                    const SliverToBoxAdapter(child: SizedBox(height: 40)),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
