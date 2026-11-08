import 'dart:io';

import 'package:flutter/material.dart';

import 'package:dailypulse/core/theme/context_extensions.dart';
import 'package:dailypulse/features/settings/models/avatar_presets.dart';

/// Circular avatar: uploaded photo, preset, account photo, then initial.
class ProfileAvatar extends StatelessWidget {
  const ProfileAvatar({
    super.key,
    required this.size,
    this.name,
    this.imagePath,
    this.avatarId,
    this.photoUrl,
    this.borderWidth = 0,
  });

  final double size;
  final String? name;
  final String? imagePath;
  final String? avatarId;
  final String? photoUrl;
  final double borderWidth;

  @override
  Widget build(BuildContext context) {
    final home = context.home;
    final preset = AvatarPresets.byId(avatarId);
    final path = imagePath;
    final hasLocalImage =
        path != null && path.isNotEmpty && File(path).existsSync();
    final url = photoUrl;
    final hasPhotoUrl = url != null && url.isNotEmpty;
    final trimmed = name?.trim() ?? '';
    final initial = trimmed.isEmpty ? '?' : trimmed[0].toUpperCase();
    final inner = size - borderWidth * 2;

    final Widget content;
    Color background = home.accent;
    if (hasLocalImage) {
      content = Image.file(File(path), width: inner, height: inner, fit: BoxFit.cover);
    } else if (preset != null) {
      background = home.greenDark;
      content = Icon(preset.icon, size: inner * 0.5, color: home.greenLight);
    } else if (hasPhotoUrl) {
      content = Image.network(
        url,
        width: inner,
        height: inner,
        fit: BoxFit.cover,
        errorBuilder: (_, _, _) => _Initial(initial: initial, size: inner),
      );
    } else {
      content = _Initial(initial: initial, size: inner);
    }

    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: background,
        border: borderWidth > 0
            ? Border.all(color: home.background, width: borderWidth)
            : null,
      ),
      child: ClipOval(child: Center(child: content)),
    );
  }
}

class _Initial extends StatelessWidget {
  const _Initial({required this.initial, required this.size});

  final String initial;
  final double size;

  @override
  Widget build(BuildContext context) {
    return Text(
      initial,
      style: context.textTheme.displayMedium?.copyWith(
        color: context.home.onMedia,
        fontSize: size * 0.4,
      ),
    );
  }
}
