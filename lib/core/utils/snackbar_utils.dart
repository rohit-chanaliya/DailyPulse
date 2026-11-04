import 'package:flutter/material.dart';

import 'package:dailypulse/core/theme/context_extensions.dart';

class SnackBarUtils {
  static void showError(BuildContext context, String message) {
    _show(context, message, context.status.error);
  }

  static void showSuccess(BuildContext context, String message) {
    _show(context, message, context.status.success);
  }

  static void showInfo(BuildContext context, String message) {
    _show(context, message, context.status.info);
  }

  static void _show(BuildContext context, String message, Color background) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: background),
    );
  }
}
