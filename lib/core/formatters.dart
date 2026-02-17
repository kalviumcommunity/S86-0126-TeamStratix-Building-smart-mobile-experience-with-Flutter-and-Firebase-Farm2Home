import 'package:intl/intl.dart';

// Formatting Utilities
class AppFormatters {
  // Currency Formatter
  static String currency(double amount, {String symbol = '\$'}) {
    return '$symbol${amount.toStringAsFixed(2)}';
  }
  
  // Date Formatters
  static String date(DateTime date) {
    return DateFormat('MMM dd, yyyy').format(date);
  }
  
  static String dateTime(DateTime date) {
    return DateFormat('MMM dd, yyyy • hh:mm a').format(date);
  }
  
  static String time(DateTime date) {
    return DateFormat('hh:mm a').format(date);
  }
  
  static String shortDate(DateTime date) {
    return DateFormat('MM/dd/yyyy').format(date);
  }
  
  static String relativeTime(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);
    
    if (difference.inDays > 365) {
      final years = (difference.inDays / 365).floor();
      return '$years ${years == 1 ? 'year' : 'years'} ago';
    } else if (difference.inDays > 30) {
      final months = (difference.inDays / 30).floor();
      return '$months ${months == 1 ? 'month' : 'months'} ago';
    } else if (difference.inDays > 0) {
      return '${difference.inDays} ${difference.inDays == 1 ? 'day' : 'days'} ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours} ${difference.inHours == 1 ? 'hour' : 'hours'} ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes} ${difference.inMinutes == 1 ? 'minute' : 'minutes'} ago';
    } else {
      return 'Just now';
    }
  }
  
  // Phone Number Formatter
  static String phone(String phone) {
    final cleaned = phone.replaceAll(RegExp(r'[^0-9]'), '');
    if (cleaned.length == 10) {
      return '(${cleaned.substring(0, 3)}) ${cleaned.substring(3, 6)}-${cleaned.substring(6)}';
    }
    return phone;
  }
  
  // Number with commas
  static String numberWithCommas(num number) {
    return NumberFormat('#,##0').format(number);
  }
  
  // Capitalize First Letter
  static String capitalize(String text) {
    if (text.isEmpty) return text;
    return text[0].toUpperCase() + text.substring(1).toLowerCase();
  }
  
  // Title Case
  static String titleCase(String text) {
    if (text.isEmpty) return text;
    return text.split(' ').map((word) => capitalize(word)).join(' ');
  }
  
  // Truncate Text
  static String truncate(String text, int length, {String suffix = '...'}) {
    if (text.length <= length) return text;
    return '${text.substring(0, length)}$suffix';
  }
  
  // File Size Formatter
  static String fileSize(int bytes) {
    if (bytes < 1024) return '$bytes B';
    if (bytes < 1024 * 1024) return '${(bytes / 1024).toStringAsFixed(1)} KB';
    if (bytes < 1024 * 1024 * 1024) {
      return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
    }
    return '${(bytes / (1024 * 1024 * 1024)).toStringAsFixed(1)} GB';
  }
}