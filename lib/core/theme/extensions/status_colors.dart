import 'package:flutter/material.dart';

class StatusColors extends ThemeExtension<StatusColors> {
  final Color success;
  final Color warning;
  final Color error;
  final Color info;

  StatusColors({
    required this.success,
    required this.warning,
    required this.error,
    required this.info,
  });

  @override
  StatusColors copyWith({
    Color? success,
    Color? warning,
    Color? error,
    Color? info,
  }) {
    return StatusColors(
      success: success ?? this.success,
      warning: warning ?? this.warning,
      error: error ?? this.error,
      info: info ?? this.info,
    );
  }

  @override
  StatusColors lerp(ThemeExtension<StatusColors>? other, double t) {
    if (other is! StatusColors) return this;
    return StatusColors(
      success: Color.lerp(success, other.success, t)!,
      warning: Color.lerp(warning, other.warning, t)!,
      error: Color.lerp(error, other.error, t)!,
      info: Color.lerp(info, other.info, t)!,
    );
  }
}
