import 'package:get/get.dart';

import '../../features/about/about_page.dart';
import '../../features/contact/contact_page.dart';
import '../../features/home/home_page.dart';
import '../../features/projects/projects_page.dart';
import '../../features/services/services_page.dart';
import '../../features/startup_package/startup_package_page.dart';
import '../../features/testimonials/testimonials_page.dart';

/// Central route table — every URL is defined once here so navigation
/// (links, drawer, footer) stays consistent and SEO-friendly.
abstract class AppRoutes {
  static const String home = '/';
  static const String about = '/about';
  static const String services = '/services';
  static const String startupPackage = '/startup-package';

  /// Canonical projects route (user-facing label: "Projects").
  static const String projects = '/projects';

  /// Legacy alias kept so old links to /portfolio keep working.
  static const String portfolio = '/portfolio';

  static const String testimonials = '/testimonials';
  static const String contact = '/contact';

  /// Map label (used in the nav bar) -> route path.
  /// Order here defines the header / drawer / footer order.
  static const Map<String, String> labelToRoute = {
    'Home': home,
    'About': about,
    'Services': services,
    'Projects': projects,
    'Startup Solutions': startupPackage,
    'Contact': contact,
  };

  static List<GetPage<dynamic>> pages = [
    GetPage(name: home, page: () => const HomePage()),
    GetPage(name: about, page: () => const AboutPage()),
    GetPage(name: services, page: () => const ServicesPage()),
    GetPage(name: startupPackage, page: () => const StartupPackagePage()),
    GetPage(name: projects, page: () => const ProjectsPage()),
    GetPage(name: portfolio, page: () => const ProjectsPage()),
    GetPage(name: testimonials, page: () => const TestimonialsPage()),
    GetPage(name: contact, page: () => const ContactPage()),
  ];
}
