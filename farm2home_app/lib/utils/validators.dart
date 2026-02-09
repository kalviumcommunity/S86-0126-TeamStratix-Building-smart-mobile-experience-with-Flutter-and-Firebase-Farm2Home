/// Reusable form validators for the Farm2Home application
///
/// This utility class provides common form field validators that can be reused
/// across the application for consistent validation logic.
class Validators {
  /// Validates that a field is not empty
  ///
  /// Returns an error message if the field is empty, null otherwise
  static String? required(String? value, {String? fieldName}) {
    if (value == null || value.trim().isEmpty) {
      return '${fieldName ?? "This field"} is required';
    }
    return null;
  }

  /// Validates email format using regex
  ///
  /// Returns an error message if email is invalid, null otherwise
  static String? email(String? value) {
    if (value == null || value.isEmpty) {
      return 'Email is required';
    }

    final emailRegex = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    );

    if (!emailRegex.hasMatch(value)) {
      return 'Enter a valid email address';
    }
    return null;
  }

  /// Validates password with customizable minimum length
  ///
  /// Returns an error message if password doesn't meet requirements, null otherwise
  static String? password(String? value, {int minLength = 8}) {
    if (value == null || value.isEmpty) {
      return 'Password is required';
    }

    if (value.length < minLength) {
      return 'Password must be at least $minLength characters';
    }

    return null;
  }

  /// Validates strong password (contains uppercase, lowercase, number, special char)
  ///
  /// Returns an error message if password doesn't meet requirements, null otherwise
  static String? strongPassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password is required';
    }

    if (value.length < 8) {
      return 'Password must be at least 8 characters';
    }

    final hasUppercase = value.contains(RegExp(r'[A-Z]'));
    final hasLowercase = value.contains(RegExp(r'[a-z]'));
    final hasDigit = value.contains(RegExp(r'[0-9]'));
    final hasSpecialChar = value.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'));

    if (!hasUppercase) {
      return 'Password must contain at least one uppercase letter';
    }
    if (!hasLowercase) {
      return 'Password must contain at least one lowercase letter';
    }
    if (!hasDigit) {
      return 'Password must contain at least one number';
    }
    if (!hasSpecialChar) {
      return 'Password must contain at least one special character';
    }

    return null;
  }

  /// Validates password confirmation matches original password
  ///
  /// Returns an error message if passwords don't match, null otherwise
  static String? passwordConfirm(String? value, String? password) {
    if (value == null || value.isEmpty) {
      return 'Please confirm your password';
    }

    if (value != password) {
      return 'Passwords do not match';
    }

    return null;
  }

  /// Validates phone number (10 digits)
  ///
  /// Returns an error message if phone is invalid, null otherwise
  static String? phoneNumber(String? value) {
    if (value == null || value.isEmpty) {
      return 'Phone number is required';
    }

    // Remove common separators
    final cleaned = value.replaceAll(RegExp(r'[\s\-\(\)]'), '');

    final phoneRegex = RegExp(r'^[0-9]{10}$');
    if (!phoneRegex.hasMatch(cleaned)) {
      return 'Enter a valid 10-digit phone number';
    }

    return null;
  }

  /// Validates minimum length
  ///
  /// Returns an error message if value is too short, null otherwise
  static String? minLength(String? value, int min, {String? fieldName}) {
    if (value == null || value.isEmpty) {
      return '${fieldName ?? "This field"} is required';
    }

    if (value.length < min) {
      return '${fieldName ?? "This field"} must be at least $min characters';
    }

    return null;
  }

  /// Validates maximum length
  ///
  /// Returns an error message if value is too long, null otherwise
  static String? maxLength(String? value, int max, {String? fieldName}) {
    if (value != null && value.length > max) {
      return '${fieldName ?? "This field"} must be at most $max characters';
    }

    return null;
  }

  /// Validates numeric input
  ///
  /// Returns an error message if value is not a valid number, null otherwise
  static String? numeric(String? value, {String? fieldName}) {
    if (value == null || value.isEmpty) {
      return '${fieldName ?? "This field"} is required';
    }

    if (double.tryParse(value) == null) {
      return '${fieldName ?? "This field"} must be a valid number';
    }

    return null;
  }

  /// Validates value is within a numeric range
  ///
  /// Returns an error message if value is out of range, null otherwise
  static String? range(
    String? value,
    double min,
    double max, {
    String? fieldName,
  }) {
    if (value == null || value.isEmpty) {
      return '${fieldName ?? "This field"} is required';
    }

    final number = double.tryParse(value);
    if (number == null) {
      return '${fieldName ?? "This field"} must be a valid number';
    }

    if (number < min || number > max) {
      return '${fieldName ?? "This field"} must be between $min and $max';
    }

    return null;
  }

  /// Validates URL format
  ///
  /// Returns an error message if URL is invalid, null otherwise
  static String? url(String? value) {
    if (value == null || value.isEmpty) {
      return 'URL is required';
    }

    final urlRegex = RegExp(
      r'^(https?:\/\/)?([\da-z\.-]+)\.([a-z\.]{2,6})([\/\w \.-]*)*\/?$',
    );

    if (!urlRegex.hasMatch(value)) {
      return 'Enter a valid URL';
    }

    return null;
  }

  /// Validates username (alphanumeric and underscores, 3-20 chars)
  ///
  /// Returns an error message if username is invalid, null otherwise
  static String? username(String? value) {
    if (value == null || value.isEmpty) {
      return 'Username is required';
    }

    if (value.length < 3 || value.length > 20) {
      return 'Username must be 3-20 characters';
    }

    final usernameRegex = RegExp(r'^[a-zA-Z0-9_]+$');
    if (!usernameRegex.hasMatch(value)) {
      return 'Username can only contain letters, numbers, and underscores';
    }

    return null;
  }

  /// Validates credit card number using Luhn algorithm
  ///
  /// Returns an error message if card number is invalid, null otherwise
  static String? creditCard(String? value) {
    if (value == null || value.isEmpty) {
      return 'Card number is required';
    }

    final cleaned = value.replaceAll(RegExp(r'[\s\-]'), '');

    if (cleaned.length < 13 || cleaned.length > 19) {
      return 'Enter a valid card number';
    }

    if (!_luhnCheck(cleaned)) {
      return 'Invalid card number';
    }

    return null;
  }

  /// Helper method for Luhn algorithm (credit card validation)
  static bool _luhnCheck(String cardNumber) {
    int sum = 0;
    bool alternate = false;

    for (int i = cardNumber.length - 1; i >= 0; i--) {
      int digit = int.tryParse(cardNumber[i]) ?? 0;

      if (alternate) {
        digit *= 2;
        if (digit > 9) {
          digit -= 9;
        }
      }

      sum += digit;
      alternate = !alternate;
    }

    return sum % 10 == 0;
  }

  /// Validates CVV (3 or 4 digits)
  ///
  /// Returns an error message if CVV is invalid, null otherwise
  static String? cvv(String? value) {
    if (value == null || value.isEmpty) {
      return 'CVV is required';
    }

    final cvvRegex = RegExp(r'^[0-9]{3,4}$');
    if (!cvvRegex.hasMatch(value)) {
      return 'Enter a valid CVV (3 or 4 digits)';
    }

    return null;
  }

  /// Validates zip/postal code
  ///
  /// Returns an error message if zip code is invalid, null otherwise
  static String? zipCode(String? value) {
    if (value == null || value.isEmpty) {
      return 'Zip code is required';
    }

    // US format: 5 digits or 5+4 digits
    final zipRegex = RegExp(r'^\d{5}(-\d{4})?$');
    if (!zipRegex.hasMatch(value)) {
      return 'Enter a valid zip code (e.g., 12345 or 12345-6789)';
    }

    return null;
  }

  /// Combines multiple validators
  ///
  /// Returns the first error message encountered, or null if all pass
  static String? Function(String?) combine(
    List<String? Function(String?)> validators,
  ) {
    return (String? value) {
      for (final validator in validators) {
        final error = validator(value);
        if (error != null) {
          return error;
        }
      }
      return null;
    };
  }
}
