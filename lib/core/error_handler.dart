import 'package:flutter/material.dart';

// Centralized Error Handler
class ErrorHandler {
  static String getErrorMessage(dynamic error) {
    if (error is String) {
      return error;
    }
    
    // Firebase Auth Errors
    if (error.toString().contains('email-already-in-use')) {
      return 'This email is already registered';
    }
    if (error.toString().contains('user-not-found')) {
      return 'No account found with this email';
    }
    if (error.toString().contains('wrong-password')) {
      return 'Incorrect password';
    }
    if (error.toString().contains('weak-password')) {
      return 'Password is too weak';
    }
    if (error.toString().contains('invalid-email')) {
      return 'Invalid email address';
    }
    if (error.toString().contains('network-request-failed')) {
      return 'Network error. Please check your connection';
    }
    
    // Firestore Errors
    if (error.toString().contains('permission-denied')) {
      return 'You don\'t have permission to perform this action';
    }
    if (error.toString().contains('unavailable')) {
      return 'Service temporarily unavailable';
    }
    
    // Generic error
    return 'An error occurred. Please try again';
  }
  
  static void logError(dynamic error, StackTrace? stackTrace) {
    // In production, send to error monitoring service (e.g., Sentry, Firebase Crashlytics)
    debugPrint('ERROR: $error');
    if (stackTrace != null) {
      debugPrint('STACK TRACE: $stackTrace');
    }
  }
  
  static Future<void> handleError(
    dynamic error,
    StackTrace? stackTrace, {
    BuildContext? context,
    bool showSnackBar = true,
  }) async {
    logError(error, stackTrace);
    
    if (context != null && showSnackBar) {
      final message = getErrorMessage(error);
      showErrorSnackBar(context, message);
    }
  }
  
  static void showErrorSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.error_outline, color: Colors.white),
            const SizedBox(width: 12),
            Expanded(child: Text(message)),
          ],
        ),
        backgroundColor: Colors.red.shade700,
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 4),
        action: SnackBarAction(
          label: 'Dismiss',
          textColor: Colors.white,
          onPressed: () {
            ScaffoldMessenger.of(context).hideCurrentSnackBar();
          },
        ),
      ),
    );
  }
}

// Notification/SnackBar Helper
class AppNotification {
  // Success Notification
  static void showSuccess(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.check_circle_outline, color: Colors.white),
            const SizedBox(width: 12),
            Expanded(child: Text(message)),
          ],
        ),
        backgroundColor: Colors.green.shade700,
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 3),
      ),
    );
  }
  
  // Error Notification
  static void showError(BuildContext context, String message) {
    ErrorHandler.showErrorSnackBar(context, message);
  }
  
  // Info Notification
  static void showInfo(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.info_outline, color: Colors.white),
            const SizedBox(width: 12),
            Expanded(child: Text(message)),
          ],
        ),
        backgroundColor: Colors.blue.shade700,
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 3),
      ),
    );
  }
  
  // Warning Notification
  static void showWarning(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.warning_amber_outlined, color: Colors.white),
            const SizedBox(width: 12),
            Expanded(child: Text(message)),
          ],
        ),
        backgroundColor: Colors.orange.shade700,
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 3),
      ),
    );
  }
  
  // Loading Notification (dismissible)
  static ScaffoldFeatureController<SnackBar, SnackBarClosedReason> showLoading(
    BuildContext context,
    String message,
  ) {
    return ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(child: Text(message)),
          ],
        ),
        duration: const Duration(days: 1), // Very long, dismiss manually
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
  
  // Dismiss current snackbar
  static void dismiss(BuildContext context) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
  }
}
