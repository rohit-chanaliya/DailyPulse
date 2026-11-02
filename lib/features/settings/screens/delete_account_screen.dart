import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:dailypulse/core/constant/links.dart';
import 'package:dailypulse/core/constant/strings/delete_account_strings.dart';
import 'package:dailypulse/core/di/injection.dart';
import 'package:dailypulse/core/router/app_routes.dart';
import 'package:dailypulse/core/theme/context_extensions.dart';
import 'package:dailypulse/core/utils/app_logger.dart';
import 'package:dailypulse/core/utils/link_launcher.dart';
import 'package:dailypulse/core/utils/snackbar_utils.dart';
import 'package:dailypulse/core/widgets/custom_text_field.dart';

/// Confirmation screen that deletes the account and every data trace of it.
class DeleteAccountScreen extends StatefulWidget {
  const DeleteAccountScreen({super.key});

  @override
  State<DeleteAccountScreen> createState() => _DeleteAccountScreenState();
}

class _DeleteAccountScreenState extends State<DeleteAccountScreen> {
  final _passwordController = TextEditingController();
  bool _isDeleting = false;

  @override
  void dispose() {
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _delete() async {
    final user = appComponent.authSignal.user.value;
    if (user == null) return;

    final needsPassword = !appComponent.authSignal.isGoogleUser;
    if (needsPassword && _passwordController.text.trim().isEmpty) {
      SnackBarUtils.showError(
        context,
        DeleteAccountStrings.passwordRequiredError,
      );
      return;
    }

    setState(() => _isDeleting = true);
    appComponent.authSignal.clearError();

    final deleted = await appComponent.authSignal.deleteAccount(
      password: needsPassword ? _passwordController.text.trim() : null,
    );

    if (!mounted) return;
    setState(() => _isDeleting = false);

    if (!deleted) {
      final message = appComponent.authSignal.errorMessage.value;
      appLogger.w('Account deletion failed from the UI');
      SnackBarUtils.showError(
        context,
        message ?? DeleteAccountStrings.deleteFailed,
      );
      return;
    }

    SnackBarUtils.showSuccess(
      context,
      DeleteAccountStrings.deletedMessage,
    );
    context.go(AppRoutes.signIn);
  }

  @override
  Widget build(BuildContext context) {
    final home = context.home;
    final user = appComponent.authSignal.user.value;
    final isGoogleUser = appComponent.authSignal.isGoogleUser;

    return Scaffold(
      backgroundColor: home.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.fromLTRB(16, 12, 16, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                children: [
                  IconButton(
                    tooltip: DeleteAccountStrings.cancelButton,
                    onPressed: _isDeleting ? null : () => context.pop(),
                    icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 18),
                    color: home.textPrimary,
                    style: IconButton.styleFrom(
                      fixedSize: const Size(44, 44),
                      side: BorderSide(
                        color: home.textPrimary.withValues(alpha: 0.6),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Text(
                      DeleteAccountStrings.title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: context.textTheme.titleLarge?.copyWith(
                        color: home.textPrimary,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              Text(
                DeleteAccountStrings.intro,
                style: context.textTheme.bodyLarge?.copyWith(
                  color: home.textSecondary,
                ),
              ),
              const SizedBox(height: 12),
              const _DeleteBullet(DeleteAccountStrings.bulletAccount),
              const _DeleteBullet(DeleteAccountStrings.bulletEntries),
              const _DeleteBullet(DeleteAccountStrings.bulletNotes),
              const _DeleteBullet(DeleteAccountStrings.bulletDevice),
              const SizedBox(height: 16),
              Text(
                DeleteAccountStrings.irreversibleNote,
                style: context.textTheme.bodySmall?.copyWith(
                  color: context.status.error,
                ),
              ),
              const SizedBox(height: 28),
              if (user != null) ...[
                Text(
                  DeleteAccountStrings.emailLabel,
                  style: context.textTheme.labelLarge?.copyWith(
                    color: home.textSecondary,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  user.email ?? user.displayName ?? '',
                  style: context.textTheme.titleMedium?.copyWith(
                    color: home.textPrimary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 24),
              ],
              if (!isGoogleUser) ...[
                CustomTextField(
                  controller: _passwordController,
                  label: DeleteAccountStrings.passwordLabel,
                  hintText: DeleteAccountStrings.passwordHint,
                  obscureText: true,
                ),
                const SizedBox(height: 8),
                Text(
                  DeleteAccountStrings.passwordHelp,
                  style: context.textTheme.bodySmall?.copyWith(
                    color: home.textMuted,
                  ),
                ),
                const SizedBox(height: 24),
              ],
              SizedBox(
                height: 54,
                child: FilledButton(
                  onPressed: _isDeleting ? null : _delete,
                  style: FilledButton.styleFrom(
                    backgroundColor: context.status.error,
                    foregroundColor: home.onMedia,
                    disabledBackgroundColor: home.searchSurface.withValues(
                      alpha: 0.5,
                    ),
                    disabledForegroundColor: home.textMuted,
                    shape: const StadiumBorder(),
                  ),
                  child: _isDeleting
                      ? SizedBox.square(
                          dimension: 22,
                          child: CircularProgressIndicator(
                            strokeWidth: 2.5,
                            color: home.onMedia,
                          ),
                        )
                      : Text(
                          DeleteAccountStrings.deleteButton,
                          textAlign: TextAlign.center,
                          style: context.textTheme.titleSmall?.copyWith(
                            color: home.onMedia,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                ),
              ),
              const SizedBox(height: 12),
              TextButton(
                onPressed: _isDeleting ? null : () => context.pop(),
                child: Text(DeleteAccountStrings.cancelButton),
              ),
              TextButton(
                onPressed: _isDeleting
                    ? null
                    : () => LinkLauncher.open(
                        context,
                        AppLinks.accountDeletion,
                      ),
                child: Text(DeleteAccountStrings.webFallback),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _DeleteBullet extends StatelessWidget {
  const _DeleteBullet(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    final home = context.home;
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.circle, size: 6, color: home.textMuted),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              text,
              style: context.textTheme.bodyMedium?.copyWith(
                color: home.textPrimary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
