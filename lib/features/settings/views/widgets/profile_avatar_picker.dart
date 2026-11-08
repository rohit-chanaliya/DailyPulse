import 'dart:math' as math;

import 'package:flutter/material.dart';

import 'package:dailypulse/core/constant/strings/profile_strings.dart';
import 'package:dailypulse/core/theme/context_extensions.dart';
import 'package:dailypulse/features/settings/models/avatar_presets.dart';

/// Horizontal row: upload button followed by the preset avatars.
class ProfileAvatarPicker extends StatelessWidget {
  const ProfileAvatarPicker({
    super.key,
    required this.selectedId,
    required this.onUpload,
    required this.onSelect,
  });

  final String selectedId;
  final VoidCallback onUpload;
  final ValueChanged<String> onSelect;

  @override
  Widget build(BuildContext context) {
    final home = context.home;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 12,
      children: [
        Text(
          ProfileStrings.chooseAvatarLabel,
          style: context.textTheme.titleMedium?.copyWith(
            color: home.textSecondary,
          ),
        ),
        SizedBox(
          height: 64,
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: [
              _UploadButton(onTap: onUpload),
              for (final preset in AvatarPresets.all) ...[
                const SizedBox(width: 12),
                _PresetButton(
                  preset: preset,
                  selected: preset.id == selectedId,
                  onTap: () => onSelect(preset.id),
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }
}

class _UploadButton extends StatelessWidget {
  const _UploadButton({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final home = context.home;

    return Tooltip(
      message: ProfileStrings.uploadAvatarTooltip,
      child: GestureDetector(
        onTap: onTap,
        child: CustomPaint(
          painter: _DashedCirclePainter(color: home.textMuted),
          child: SizedBox(
            width: 64,
            height: 64,
            child: Icon(Icons.upload_rounded, size: 24, color: home.accent),
          ),
        ),
      ),
    );
  }
}

class _PresetButton extends StatelessWidget {
  const _PresetButton({
    required this.preset,
    required this.selected,
    required this.onTap,
  });

  final AvatarPreset preset;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final home = context.home;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 64,
        height: 64,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: home.greenDark,
          border: Border.all(
            color: selected ? home.orange : Colors.transparent,
            width: 3,
          ),
        ),
        child: Icon(preset.icon, size: 28, color: home.greenLight),
      ),
    );
  }
}

class _DashedCirclePainter extends CustomPainter {
  const _DashedCirclePainter({required this.color});

  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.2;
    final rect = Offset.zero & size;
    const dashes = 24;
    const sweep = 2 * math.pi / dashes;
    for (var i = 0; i < dashes; i++) {
      canvas.drawArc(rect.deflate(1), i * sweep, sweep * 0.6, false, paint);
    }
  }

  @override
  bool shouldRepaint(_DashedCirclePainter oldDelegate) =>
      oldDelegate.color != color;
}
