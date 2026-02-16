/// Form Validators Utility
/// Provides reusable validation methods for form fields
/// Each validator returns null if valid, or error message string if invalid
class FormValidators {
  /// Validate full name field
  /// Required and minimum 2 characters
  static String? validateFullName(String? value) {
    if (value == null || value.isEmpty) {
      return 'Full Name is required';
    }
    if (value.length < 2) {
      return 'Full Name must be at least 2 characters';
    }
    if (value.length > 50) {
      return 'Full Name cannot exceed 50 characters';
    }
    // Check for valid characters (letters, spaces, hyphens, apostrophes)
    if (!RegExp(r"^[a-zA-Z\s\-']*$").hasMatch(value)) {
      return 'Full Name can only contain letters, spaces, hyphens, and apostrophes';
    }
    return null; // Valid
  }

  /// Validate email field
  /// Must follow email format
  static String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Email is required';
    }
    // Simple email regex pattern
    final emailRegex = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    );
    if (!emailRegex.hasMatch(value)) {
      return 'Please enter a valid email address';
    }
    return null; // Valid
  }

  /// Validate phone number field
  /// Must be exactly 10 digits
  static String? validatePhoneNumber(String? value) {
    if (value == null || value.isEmpty) {
      return 'Phone Number is required';
    }
    // Remove any non-digit characters for validation
    final digitsOnly = value.replaceAll(RegExp(r'[^\d]'), '');
    if (digitsOnly.length != 10) {
      return 'Phone Number must be exactly 10 digits';
    }
    return null; // Valid
  }

  /// Validate password field
  /// Minimum 8 characters with mixed requirements
  static String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password is required';
    }
    if (value.length < 8) {
      return 'Password must be at least 8 characters long';
    }
    if (value.length > 50) {
      return 'Password cannot exceed 50 characters';
    }
    // Check for uppercase letter
    if (!value.contains(RegExp(r'[A-Z]'))) {
      return 'Password must contain at least one uppercase letter';
    }
    // Check for lowercase letter
    if (!value.contains(RegExp(r'[a-z]'))) {
      return 'Password must contain at least one lowercase letter';
    }
    // Check for digit
    if (!value.contains(RegExp(r'[0-9]'))) {
      return 'Password must contain at least one digit';
    }
    return null; // Valid
  }

  /// Validate confirm password field
  /// Must match the password field
  static String? validateConfirmPassword(String? value, String? password) {
    if (value == null || value.isEmpty) {
      return 'Please confirm your password';
    }
    if (value != password) {
      return 'Passwords do not match';
    }
    return null; // Valid
  }

  /// Check if all validation messages mean field is valid
  static bool isFieldValid(String? validationMessage) {
    return validationMessage == null;
  }

  /// Get password strength indicator (for UI feedback)
  static String getPasswordStrength(String password) {
    if (password.isEmpty) return '';
    if (password.length < 8) return 'Weak';
    if (password.length < 12) return 'Medium';
    if (password.length >= 12) return 'Strong';
    return '';
  }

  /// Get password strength color (for visual feedback)
  static int getPasswordStrengthColor(String password) {
    final strength = getPasswordStrength(password);
    switch (strength) {
      case 'Weak':
        return 0xFFF44336; // Red
      case 'Medium':
        return 0xFFFFC107; // Amber
      case 'Strong':
        return 0xFF4CAF50; // Green
      default:
        return 0xFF9E9E9E; // Grey
    }
  }
}
