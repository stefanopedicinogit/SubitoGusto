import 'package:flutter/material.dart';

/// Device type enumeration
enum DeviceType { mobile, tablet, desktop }

/// Breakpoints for responsive design
class Breakpoints {
  static const double mobile = 600;
  static const double tablet = 1024;
  static const double desktop = 1440;
}

/// Responsive utilities for adaptive layouts
class Responsive {
  /// Get the current device type based on screen width
  static DeviceType getDeviceType(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    if (width < Breakpoints.mobile) {
      return DeviceType.mobile;
    } else if (width < Breakpoints.tablet) {
      return DeviceType.tablet;
    } else {
      return DeviceType.desktop;
    }
  }

  /// Check if current device is mobile
  static bool isMobile(BuildContext context) {
    return MediaQuery.sizeOf(context).width < Breakpoints.mobile;
  }

  /// Check if current device is tablet
  static bool isTablet(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    return width >= Breakpoints.mobile && width < Breakpoints.tablet;
  }

  /// Check if current device is desktop
  static bool isDesktop(BuildContext context) {
    return MediaQuery.sizeOf(context).width >= Breakpoints.tablet;
  }

  /// Returns true for mobile and tablet (use mobile layout)
  static bool useMobileLayout(BuildContext context) {
    return MediaQuery.sizeOf(context).width < Breakpoints.tablet;
  }

  /// Get responsive value based on device type
  static T value<T>(
    BuildContext context, {
    required T mobile,
    T? tablet,
    required T desktop,
  }) {
    final deviceType = getDeviceType(context);
    switch (deviceType) {
      case DeviceType.mobile:
        return mobile;
      case DeviceType.tablet:
        return tablet ?? mobile;
      case DeviceType.desktop:
        return desktop;
    }
  }

  /// Get responsive padding based on device type
  static EdgeInsets padding(BuildContext context) {
    return value(
      context,
      mobile: const EdgeInsets.all(16),
      tablet: const EdgeInsets.all(24),
      desktop: const EdgeInsets.all(32),
    );
  }

  /// Get responsive horizontal padding
  static EdgeInsets horizontalPadding(BuildContext context) {
    return value(
      context,
      mobile: const EdgeInsets.symmetric(horizontal: 16),
      tablet: const EdgeInsets.symmetric(horizontal: 24),
      desktop: const EdgeInsets.symmetric(horizontal: 32),
    );
  }

  /// Get sidebar width for desktop
  static double sidebarWidth(BuildContext context) {
    return value(
      context,
      mobile: 0,
      tablet: 72,
      desktop: 280,
    );
  }

  /// Get number of grid columns
  static int gridColumns(BuildContext context) {
    return value(
      context,
      mobile: 2,
      tablet: 3,
      desktop: 4,
    );
  }

  /// Get card width for menu items
  static double menuCardWidth(BuildContext context) {
    return value(
      context,
      mobile: double.infinity,
      tablet: 300,
      desktop: 320,
    );
  }
}

/// Extension on BuildContext for easy responsive access
extension ResponsiveExtension on BuildContext {
  bool get isMobile => Responsive.isMobile(this);
  bool get isTablet => Responsive.isTablet(this);
  bool get isDesktop => Responsive.isDesktop(this);
  bool get useMobileLayout => Responsive.useMobileLayout(this);
  DeviceType get deviceType => Responsive.getDeviceType(this);
}
