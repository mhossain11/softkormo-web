import 'package:flutter/material.dart';

import '../constants/app_dimensions.dart';

enum ScreenSize { mobile, tablet, laptop, desktop, ultraWide }

/// Breakpoint-driven responsive helpers.
///
/// Never hardcode widths — resolve them through [Responsive.get] so the
/// layout adapts from 360px to 1920px+ automatically.
abstract class Responsive {
  // ------------------------------------------------------------ breakpoints
  static const double mobile = AppDimensions.mobile;
  static const double tablet = AppDimensions.tablet;
  static const double laptop = AppDimensions.laptop;
  static const double desktop = AppDimensions.desktop;
  static const double ultraWide = AppDimensions.ultraWide;

  static ScreenSize of(BuildContext context) =>
      classify(MediaQuery.sizeOf(context).width);

  static ScreenSize classify(double width) {
    if (width < tablet) return ScreenSize.mobile;
    if (width < laptop) return ScreenSize.tablet;
    if (width < desktop) return ScreenSize.laptop;
    if (width < ultraWide) return ScreenSize.desktop;
    return ScreenSize.ultraWide;
  }

  static bool isMobile(BuildContext context) =>
      of(context) == ScreenSize.mobile;
  static bool isTablet(BuildContext context) =>
      of(context) == ScreenSize.tablet;
  static bool isDesktop(BuildContext context) {
    final s = of(context);
    return s == ScreenSize.laptop ||
        s == ScreenSize.desktop ||
        s == ScreenSize.ultraWide;
  }

  /// True when a desktop navigation bar should replace the drawer.
  ///
  /// The toolbar (logo + 7 items + CTA) needs ~1170px under the wide test
  /// font (~910px in Poppins), so desktop nav starts at [laptop]; at the
  /// old 768 threshold the toolbar RenderFlex overflowed by ~400px.
  static bool useDesktopNav(BuildContext context) =>
      MediaQuery.sizeOf(context).width >= laptop;

  /// Selects a value based on the active breakpoint.
  static T get<T>(
    BuildContext context, {
    required T mobile,
    T? tablet,
    T? laptop,
    T? desktop,
    T? ultraWide,
  }) {
    switch (of(context)) {
      case ScreenSize.mobile:
        return mobile;
      case ScreenSize.tablet:
        return tablet ?? mobile;
      case ScreenSize.laptop:
        return laptop ?? tablet ?? mobile;
      case ScreenSize.desktop:
        return desktop ?? laptop ?? tablet ?? mobile;
      case ScreenSize.ultraWide:
        return ultraWide ?? desktop ?? laptop ?? tablet ?? mobile;
    }
  }

  /// Fluid typography: clamps [min]..[max] against viewport width.
  static double fluid(
    BuildContext context, {
    required double min,
    required double max,
    double factor = 0.045,
  }) {
    final w = MediaQuery.sizeOf(context).width;
    return (w * factor).clamp(min, max);
  }

  /// Page content max-width for the current breakpoint.
  static double contentMaxWidth(BuildContext context) => get(
    context,
    mobile: mobile,
    tablet: 720.0,
    laptop: 960.0,
    desktop: 1200.0,
    ultraWide: 1360.0,
  );
}
