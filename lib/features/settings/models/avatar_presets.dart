import 'package:flutter/material.dart';

/// A built-in avatar the user can pick instead of uploading a photo.
class AvatarPreset {
  const AvatarPreset(this.id, this.icon);

  final String id;
  final IconData icon;
}

abstract final class AvatarPresets {
  static const all = [
    AvatarPreset('heartbeat', Icons.monitor_heart_rounded),
    AvatarPreset('medal', Icons.military_tech_rounded),
    AvatarPreset('health', Icons.health_and_safety_rounded),
    AvatarPreset('chart', Icons.pie_chart_rounded),
    AvatarPreset('leaf', Icons.eco_rounded),
  ];

  static AvatarPreset? byId(String? id) {
    for (final preset in all) {
      if (preset.id == id) return preset;
    }
    return null;
  }
}
