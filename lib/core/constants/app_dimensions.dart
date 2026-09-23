/// Spacing, radius and layout constants — every value is scale-independent
/// so the same tokens work from 360px mobile up to 1920px ultra-wide.
abstract class AppDimensions {
  // ------------------------------------------------------------- spacing
  static const double spaceXs = 4;
  static const double spaceSm = 8;
  static const double spaceMd = 16;
  static const double spaceLg = 24;
  static const double spaceXl = 32;
  static const double space2xl = 48;
  static const double space3xl = 64;
  static const double space4xl = 96;
  static const double sectionGap = 96;

  // -------------------------------------------------------------- radius
  static const double radiusSm = 8;
  static const double radiusMd = 12;
  static const double radiusLg = 16;
  static const double radiusXl = 24;
  static const double radiusPill = 999;

  // ------------------------------------------------------------ elevation
  static const double shadowSm = 4;
  static const double shadowMd = 12;
  static const double shadowLg = 24;

  // ---------------------------------------------------------- breakpoints
  static const double mobile = 360;
  static const double tablet = 768;
  static const double laptop = 1024;
  static const double desktop = 1440;
  static const double ultraWide = 1920;

  // ----------------------------------------------------------- durations
  static const Duration fast = Duration(milliseconds: 300);
  static const Duration normal = Duration(milliseconds: 450);
  static const Duration slow = Duration(milliseconds: 600);
}
