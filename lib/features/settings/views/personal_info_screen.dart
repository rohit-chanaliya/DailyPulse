import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';
import 'package:signals_flutter/signals_flutter.dart';

import 'package:dailypulse/core/constant/strings/profile_strings.dart';
import 'package:dailypulse/core/di/injection.dart';
import 'package:dailypulse/core/theme/context_extensions.dart';
import 'package:dailypulse/core/utils/app_logger.dart';
import 'package:dailypulse/core/utils/dialog_utils.dart';
import 'package:dailypulse/core/utils/result.dart';
import 'package:dailypulse/core/utils/snackbar_utils.dart';
import 'package:dailypulse/core/utils/validators.dart';
import 'package:dailypulse/core/widgets/accent_pill_button.dart';
import 'package:dailypulse/core/widgets/app_top_nav.dart';
import 'package:dailypulse/core/widgets/custom_text_field.dart';
import 'package:dailypulse/features/settings/views/widgets/profile_avatar_picker.dart';
import 'package:dailypulse/features/settings/views/widgets/profile_edit_icon.dart';
import 'package:dailypulse/features/settings/views/widgets/profile_gender_pills.dart';

/// Edit name, password, birth date, avatar, location and gender.
class PersonalInfoScreen extends StatefulWidget {
  const PersonalInfoScreen({super.key});

  @override
  State<PersonalInfoScreen> createState() => _PersonalInfoScreenState();
}

class _PersonalInfoScreenState extends State<PersonalInfoScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _firstNameController;
  late final TextEditingController _lastNameController;
  late final TextEditingController _emailController;
  late final TextEditingController _dobController;
  late final TextEditingController _locationController;
  final _passwordController = TextEditingController(
    text: ProfileStrings.passwordMask,
  );
  String _gender = '';
  String _avatarId = '';
  DateTime? _dateOfBirth;
  bool _loaded = false;

  @override
  void initState() {
    super.initState();
    final user = appComponent.authSignal.user.value;
    final profile = appComponent.authSignal.profile.value;

    var first = profile?.firstName ?? '';
    var last = profile?.lastName ?? '';
    if (first.isEmpty && last.isEmpty && user?.displayName != null) {
      final parts = user!.displayName!.trim().split(RegExp(r'\s+'));
      first = parts.first;
      last = parts.length > 1 ? parts.sublist(1).join(' ') : '';
    }

    _firstNameController = TextEditingController(text: first);
    _lastNameController = TextEditingController(text: last);
    _emailController = TextEditingController(text: user?.email ?? '');
    _locationController = TextEditingController(text: profile?.location ?? '');
    _dobController = TextEditingController();
    _gender = profile?.gender ?? '';
    _avatarId = profile?.avatarId ?? '';
    _setDateOfBirth(profile?.dateOfBirth);

    _loadLatestProfile();
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _dobController.dispose();
    _locationController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _setDateOfBirth(DateTime? value) {
    _dateOfBirth = value;
    _dobController.text = value == null ? '' : DateFormat.yMMMd().format(value);
  }

  Future<void> _loadLatestProfile() async {
    final loaded = await appComponent.authSignal.loadProfile();
    if (!mounted || loaded == null || _loaded) return;
    setState(() {
      if (loaded.firstName.isNotEmpty) {
        _firstNameController.text = loaded.firstName;
      }
      if (loaded.lastName.isNotEmpty) _lastNameController.text = loaded.lastName;
      _locationController.text = loaded.location;
      _gender = loaded.gender;
      _avatarId = loaded.avatarId;
      _setDateOfBirth(loaded.dateOfBirth);
      _loaded = true;
    });
  }

  Future<void> _pickDateOfBirth() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: _dateOfBirth ?? DateTime(now.year - 25, now.month, now.day),
      firstDate: DateTime(1900),
      lastDate: now,
      helpText: ProfileStrings.dateOfBirthLabel,
    );
    if (picked != null && mounted) setState(() => _setDateOfBirth(picked));
  }

  Future<void> _changePassword() async {
    final confirm = await DialogUtils.showConfirmDialog(
      context: context,
      title: ProfileStrings.resetPasswordTitle,
      message: ProfileStrings.resetPasswordMessage,
      confirmText: ProfileStrings.resetPasswordConfirm,
    );
    if (!confirm || !mounted) return;

    final result = await appComponent.authSignal.sendPasswordResetToCurrentUser();
    if (!mounted) return;
    switch (result) {
      case Ok():
        SnackBarUtils.showSuccess(context, ProfileStrings.resetPasswordSent);
      case Err(:final message):
        SnackBarUtils.showError(context, message ?? ProfileStrings.saveError);
    }
  }

  Future<void> _uploadAvatar() async {
    try {
      final picked = await ImagePicker().pickImage(
        source: ImageSource.gallery,
        maxWidth: 800,
        maxHeight: 800,
        imageQuality: 85,
      );
      if (picked == null) return;

      final extension = path.extension(picked.path).toLowerCase();
      if (extension != '.png' && extension != '.jpg' && extension != '.jpeg') {
        if (mounted) {
          SnackBarUtils.showError(context, ProfileStrings.invalidImageFormat);
        }
        return;
      }

      final dir = await getApplicationDocumentsDirectory();
      final userId = appComponent.authSignal.user.value?.uid ?? 'user';
      final destination = File('${dir.path}/profile_avatar_$userId$extension');
      await File(picked.path).copy(destination.path);

      await appComponent.authSignal.updateProfileImage(destination.path);
      if (mounted) {
        setState(() => _avatarId = '');
        SnackBarUtils.showSuccess(context, ProfileStrings.imageUpdatedSuccess);
      }
    } catch (e, st) {
      appLogger.e('Failed to pick profile image', error: e, stackTrace: st);
      if (mounted) SnackBarUtils.showError(context, ProfileStrings.saveError);
    }
  }

  Future<void> _selectPreset(String id) async {
    setState(() => _avatarId = id);
    await appComponent.authSignal.updateProfileImage(null);
  }

  Future<void> _handleSave() async {
    if (!_formKey.currentState!.validate()) return;

    final result = await appComponent.authSignal.updateProfile(
      firstName: _firstNameController.text.trim(),
      lastName: _lastNameController.text.trim(),
      gender: _gender,
      dateOfBirth: _dateOfBirth,
      location: _locationController.text.trim(),
      avatarId: _avatarId,
    );
    if (!mounted) return;

    switch (result) {
      case Ok():
        SnackBarUtils.showSuccess(context, ProfileStrings.saveSuccess);
      case Err(:final message):
        SnackBarUtils.showError(context, message ?? ProfileStrings.saveError);
    }
  }

  @override
  Widget build(BuildContext context) {
    final home = context.home;
    final authSignal = appComponent.authSignal;
    final verified = authSignal.isEmailVerified;

    return Scaffold(
      backgroundColor: home.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 32),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              spacing: 20,
              children: [
                const AppTopNav(title: ProfileStrings.personalInfo),
                const SizedBox(height: 4),
                CustomTextField(
                  controller: _firstNameController,
                  label: ProfileStrings.firstNameLabel,
                  hintText: ProfileStrings.firstNameHint,
                  keyboardType: TextInputType.name,
                  validator: Validators.validateFirstName,
                ),
                CustomTextField(
                  controller: _lastNameController,
                  label: ProfileStrings.lastNameLabel,
                  hintText: ProfileStrings.lastNameHint,
                  keyboardType: TextInputType.name,
                  validator: Validators.validateOptionalLastName,
                ),
                CustomTextField(
                  controller: _emailController,
                  label: ProfileStrings.emailLabel,
                  keyboardType: TextInputType.emailAddress,
                  readOnly: true,
                  enabled: false,
                  suffixIcon: Padding(
                    padding: const EdgeInsets.only(right: 16),
                    child: Icon(
                      verified
                          ? Icons.verified_rounded
                          : Icons.lock_outline_rounded,
                      color: verified ? home.green : home.textMuted,
                      size: 20,
                    ),
                  ),
                ),
                if (!authSignal.isGoogleUser)
                  CustomTextField(
                    controller: _passwordController,
                    label: ProfileStrings.passwordLabel,
                    obscureText: true,
                    readOnly: true,
                    onTap: _changePassword,
                    suffixIcon: const ProfileEditIcon(),
                  ),
                CustomTextField(
                  controller: _dobController,
                  label: ProfileStrings.dateOfBirthLabel,
                  hintText: ProfileStrings.dateOfBirthHint,
                  readOnly: true,
                  onTap: _pickDateOfBirth,
                  suffixIcon: const ProfileEditIcon(),
                ),
                ProfileAvatarPicker(
                  selectedId: _avatarId,
                  onUpload: _uploadAvatar,
                  onSelect: _selectPreset,
                ),
                CustomTextField(
                  controller: _locationController,
                  label: ProfileStrings.locationLabel,
                  hintText: ProfileStrings.locationHint,
                  validator: Validators.validateLocation,
                ),
                ProfileGenderPills(
                  selectedGender: _gender,
                  onChanged: (value) => setState(() => _gender = value),
                ),
                const SizedBox(height: 4),
                SignalBuilder(
                  builder: (context) => AccentPillButton(
                    label: ProfileStrings.saveButton,
                    icon: Icons.check_rounded,
                    isLoading: authSignal.isUpdatingProfile.value,
                    onPressed: _handleSave,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
