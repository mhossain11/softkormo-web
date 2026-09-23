/// Static SEO metadata shared by web/index.html, sitemap and runtime tags.
abstract class SeoTags {
  static const String siteName = 'SoftKormo';
  static const String siteUrl = 'https://softkormo.web.app';
  static const String tagline = 'Smart Software, Reliable Service';
  static const String keywords =
      'SoftKormo, Software Company, Flutter Development, Web Development, '
      'Backend Development, Data Analysis, Startup Solutions, Firebase Solutions';
  static const String description =
      'SoftKormo is a modern software company delivering Mobile App Development, '
      'Web Application Development, Backend Development, API Integration, Data '
      'Analysis, Firebase Solutions and Startup Package Solutions.';

  /// path -> [title, description] used when routes change at runtime.
  static const Map<String, List<String>> pages = {
    '/': ['SoftKormo — Smart Software, Reliable Service', description],
    '/about': [
      'About SoftKormo — Our Story, Mission & Values',
      'Meet the team behind SoftKormo: a 45+ person software studio that has '
          'shipped 120+ products since 2017. Our mission, vision and core values.',
    ],
    '/services': [
      'Software Development Services — SoftKormo',
      'Mobile app development, web applications, backend, API integration, '
          'data analysis, Firebase solutions and software maintenance.',
    ],
    '/startup-package': [
      'Startup Package Solutions — Fixed-Price MVP | SoftKormo',
      'Starter, Growth and Enterprise packages to take your startup from idea '
          'to launched product in weeks with fixed, transparent pricing.',
    ],
    '/projects': [
      'Projects — Digital Products Shipped by SoftKormo',
      'Case studies across Mobile Apps, Web Apps, Backend systems and Data '
          'Analytics for fintech, health, logistics and retail clients.',
    ],
    '/portfolio': [
      'Projects — Digital Products Shipped by SoftKormo',
      'Case studies across Mobile Apps, Web Apps, Backend systems and Data '
          'Analytics for fintech, health, logistics and retail clients.',
    ],
    '/testimonials': [
      'Client Testimonials — SoftKormo Reviews',
      'What founders, CTOs and product leaders say about working with '
          'SoftKormo. 4.9/5 average rating from 86 verified reviews.',
    ],
    '/contact': [
      'Contact SoftKormo — Free Consultation',
      'Get a free 30-minute consultation. Reply within 24 hours. Tell us '
          'about your project and leave with a roadmap and budget range.',
    ],
  };

  /// JSON-LD structured data injected into index.html.
  static const String organizationJsonLd =
      '''
{
  "@context": "https://schema.org",
  "@type": "SoftwareCompany",
  "name": "SoftKormo",
  "slogan": "$tagline",
  "url": "$siteUrl",
  "logo": "$siteUrl/icons/Icon-512.png",
  "description": "$description",
  "address": {
    "@type": "PostalAddress",
    "addressLocality": "Dhaka",
    "addressCountry": "BD"
  },
  "sameAs": [
    "https://github.com/softkormo",
    "https://www.linkedin.com/company/softkormo",
    "https://twitter.com/softkormo"
  ],
  "knowsAbout": [
    "Mobile App Development",
    "Web Application Development",
    "Backend Development",
    "API Integration",
    "Data Analysis",
    "Startup Solutions",
    "Firebase Solutions"
  ]
}
''';
}
