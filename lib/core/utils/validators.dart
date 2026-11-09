class Validators {
  static String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your email';
    }
    if (!value.contains('@')) {
      return 'Please enter a valid email';
    }
    return null;
  }

  static String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your password';
    }
    return null;
  }

  static String? validatePasswordStrength(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter a password';
    }
    if (value.length < 6) {
      return 'Password must be at least 6 characters';
    }
    return null;
  }

  static String? validateConfirmPassword(String? value, String password) {
    if (value == null || value.isEmpty) {
      return 'Please confirm your password';
    }
    if (value != password) {
      return 'Passwords do not match';
    }
    return null;
  }

  static String? validateName(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Please enter your name';
    }
    return null;
  }

  static String? validateFirstName(String? value) {
    final trimmed = value?.trim() ?? '';
    if (trimmed.isEmpty) {
      return 'Please enter your first name';
    }
    if (trimmed.length > 50) {
      return 'Keep it under 50 characters';
    }
    return null;
  }

  static String? validateLastName(String? value) {
    final trimmed = value?.trim() ?? '';
    if (trimmed.isEmpty) {
      return 'Please enter your last name';
    }
    if (trimmed.length > 50) {
      return 'Keep it under 50 characters';
    }
    return null;
  }

  static String? validateOptionalLastName(String? value) {
    final trimmed = value?.trim() ?? '';
    if (trimmed.length > 50) {
      return 'Keep it under 50 characters';
    }
    return null;
  }

  static String? validateLocation(String? value) {
    final trimmed = value?.trim() ?? '';
    if (trimmed.length > 60) {
      return 'Keep it under 60 characters';
    }
    return null;
  }
}
