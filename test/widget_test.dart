import 'package:flutter_test/flutter_test.dart';
import 'package:softkormo/core/constants/app_strings.dart';
import 'package:softkormo/core/utils/responsive_utils.dart';

void main() {
  group('AppStrings', () {
    test('brand identity is complete', () {
      expect(AppStrings.appName, 'SoftKormo');
      expect(AppStrings.tagline, 'Smart Software, Reliable Service');
      expect(AppStrings.heroHeadline, isNotEmpty);
      expect(AppStrings.seoKeywords, contains('SoftKormo'));
    });

    test('all six nav items map to routes', () {
      expect(AppStrings.navItems.length, 6);
      expect(SoftKormoRoutes.labels.length, AppStrings.navItems.length);
      expect(AppStrings.navItems, SoftKormoRoutes.labels);
      expect(AppStrings.navItems, isNot(contains('Portfolio')));
      expect(AppStrings.navItems, contains('Projects'));
      expect(AppStrings.navItems, isNot(contains('Blog')));
    });
  });

  group('Responsive', () {
    test('classifies breakpoints correctly', () {
      expect(Responsive.classify(360), ScreenSize.mobile);
      expect(Responsive.classify(767), ScreenSize.mobile);
      expect(Responsive.classify(768), ScreenSize.tablet);
      expect(Responsive.classify(1024), ScreenSize.laptop);
      expect(Responsive.classify(1440), ScreenSize.desktop);
      expect(Responsive.classify(1920), ScreenSize.ultraWide);
    });
  });
}

/// Tiny helper so the nav/route mapping can be asserted without widgets.
abstract class SoftKormoRoutes {
  static const List<String> labels = [
    'Home',
    'About',
    'Services',
    'Projects',
    'Startup Solutions',
    'Contact',
  ];
}
