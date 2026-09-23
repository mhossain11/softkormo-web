import 'package:cloud_firestore/cloud_firestore.dart';

/// `services` collection document — used by the Services page & home preview.
class ServiceModel {
  const ServiceModel({
    required this.title,
    required this.description,
    required this.icon,
    required this.chips,
    this.id,
    this.ctaLabel = 'Learn More',
    this.highlight = false,
  });

  final String? id;
  final String title;
  final String description;

  /// Material icon key (e.g. phone_android, language, dns…).
  final String icon;

  /// Short feature chips displayed on the card.
  final List<String> chips;
  final String ctaLabel;
  final bool highlight;

  Map<String, dynamic> toMap() => {
    'title': title,
    'description': description,
    'icon': icon,
    'chips': chips,
    'ctaLabel': ctaLabel,
    'highlight': highlight,
  };

  factory ServiceModel.fromDoc(DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data() ?? const {};
    return ServiceModel(
      id: doc.id,
      title: data['title'] ?? '',
      description: data['description'] ?? '',
      icon: data['icon'] ?? 'code',
      chips: List<String>.from(data['chips'] ?? data['features'] ?? const []),
      ctaLabel: data['ctaLabel'] ?? 'Learn More',
      highlight: data['highlight'] ?? false,
    );
  }

  // ------------------------------------------------------- default content
  /// The six canonical SoftKormo services (home + services page).
  static const List<ServiceModel> seed = [
    ServiceModel(
      title: 'Mobile App Development',
      icon: 'phone_android',
      description:
          'Build fast, beautiful and scalable mobile applications for Android '
          'and iOS using Flutter.',
      chips: ['Flutter', 'Android', 'iOS', 'Firebase'],
    ),
    ServiceModel(
      title: 'Web Application Development',
      icon: 'language',
      description:
          'Modern, responsive and scalable web applications for businesses '
          'and startups.',
      chips: ['Flutter Web', 'SaaS', 'Dashboard', 'Business Platform'],
    ),
    ServiceModel(
      title: 'Backend Development',
      icon: 'dns',
      description:
          'Secure backend systems, REST APIs, database architecture and '
          'third-party integrations.',
      chips: ['REST API', 'Firebase', 'Authentication', 'Cloud'],
    ),
    ServiceModel(
      title: 'Data Analysis & Business Intelligence',
      icon: 'analytics',
      description:
          'Transform business data into meaningful dashboards, reports and '
          'actionable insights.',
      chips: ['Analytics', 'Dashboard', 'Reports', 'Visualization'],
      highlight: true,
    ),
    ServiceModel(
      title: 'Startup Package Solutions',
      icon: 'rocket_launch',
      description:
          'Turn your startup idea into a real product with planning, design, '
          'development and deployment.',
      chips: ['MVP', 'UI/UX', 'Development', 'Launch'],
    ),
    ServiceModel(
      title: 'Firebase Solutions',
      icon: 'local_fire_department',
      description:
          'Leverage Firebase for authentication, databases, cloud functions, '
          'storage and analytics — built to scale securely.',
      chips: ['Firestore', 'Auth', 'Cloud Functions', 'Hosting'],
    ),
  ];
}
