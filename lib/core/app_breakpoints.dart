import 'package:flutter/material.dart';

// Responsive Breakpoints
class AppBreakpoints {
  static const double mobile = 600;
  static const double tablet = 900;
  static const double desktop = 1200;
  
  static bool isMobile(BuildContext context) =>
      MediaQuery.of(context).size.width < mobile;
  
  static bool isTablet(BuildContext context) =>
      MediaQuery.of(context).size.width >= mobile &&
      MediaQuery.of(context).size.width < desktop;
  
  static bool isDesktop(BuildContext context) =>
      MediaQuery.of(context).size.width >= desktop;
  
  static int getGridCrossAxisCount(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    if (width < mobile) return 2; // Mobile
    if (width < tablet) return 3; // Large mobile / Small tablet
    if (width < desktop) return 4; // Tablet
    return 6; // Desktop
  }
  
  static double getResponsivePadding(BuildContext context) {
    if (isMobile(context)) return 16.0;
    if (isTablet(context)) return 24.0;
    return 32.0;
  }
  
  static double getResponsiveFontSize(BuildContext context, double baseSize) {
    if (isMobile(context)) return baseSize;
    if (isTablet(context)) return baseSize * 1.1;
    return baseSize * 1.2;
  }
}

// Spacing Constants
class AppSpacing {
  static const double xs = 4.0;
  static const double sm = 8.0;
  static const double md = 16.0;
  static const double lg = 24.0;
  static const double xl = 32.0;
  static const double xxl = 48.0;
  
  // Card Spacing
  static const double cardPadding = md;
  static const double cardMargin = sm;
  static const double cardBorderRadius = 16.0;
  
  // Input Spacing
  static const double inputPadding = md;
  static const double inputBorderRadius = 12.0;
  
  // Button Spacing
  static const double buttonPadding = md;
  static const double buttonBorderRadius = 12.0;
}

// Responsive Helper Extension
extension ResponsiveContext on BuildContext {
  bool get isMobile => AppBreakpoints.isMobile(this);
  bool get isTablet => AppBreakpoints.isTablet(this);
  bool get isDesktop => AppBreakpoints.isDesktop(this);
  
  double get responsivePadding => AppBreakpoints.getResponsivePadding(this);
  int get gridColumns => AppBreakpoints.getGridCrossAxisCount(this);
}
