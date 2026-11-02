import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:dailypulse/core/utils/snackbar_utils.dart';

/// Opens external links (privacy policy, deletion page) in the browser.
class LinkLauncher {
  LinkLauncher._();

  static Future<void> open(BuildContext context, String url) async {
    final uri = Uri.tryParse(url);
    if (uri == null || !uri.hasScheme) return;

    try {
      final launched = await launchUrl(
        uri,
        mode: LaunchMode.externalApplication,
      );
      if (!launched && context.mounted) {
        SnackBarUtils.showError(context, 'Could not open the link.');
      }
    } catch (_) {
      if (context.mounted) {
        SnackBarUtils.showError(context, 'Could not open the link.');
      }
    }
  }
}
