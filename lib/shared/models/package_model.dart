import 'package:cloud_firestore/cloud_firestore.dart';

/// `packages` collection document — pricing cards & comparison table.
class PackageModel {
  const PackageModel({
    required this.name,
    required this.price,
    required this.period,
    required this.summary,
    required this.features,
    this.id,
    this.tagline = '',
    this.highlighted = false,
    this.ctaLabel = 'Get Started',
  });

  final String? id;
  final String name;
  final String price;
  final String period;
  final String tagline;
  final String summary;
  final List<String> features;
  final bool highlighted;
  final String ctaLabel;

  Map<String, dynamic> toMap() => {
    'name': name,
    'price': price,
    'period': period,
    'tagline': tagline,
    'summary': summary,
    'features': features,
    'highlighted': highlighted,
    'ctaLabel': ctaLabel,
  };

  factory PackageModel.fromDoc(DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data() ?? const {};
    return PackageModel(
      id: doc.id,
      name: data['name'] ?? '',
      price: data['price'] ?? '',
      period: data['period'] ?? '',
      tagline: data['tagline'] ?? '',
      summary: data['summary'] ?? '',
      features: List<String>.from(data['features'] ?? const []),
      highlighted: data['highlighted'] ?? false,
      ctaLabel: data['ctaLabel'] ?? 'Get Started',
    );
  }

  // ------------------------------------------------------- default content
  static const List<PackageModel> seed = [
    PackageModel(
      name: 'Starter',
      price: '\$2,499',
      period: 'one-time',
      tagline: 'Validate your idea',
      summary: 'A focused MVP for founders who need to test the market fast.',
      ctaLabel: 'Start Starter',
      features: [
        '1 platform (Web or Mobile)',
        'Up to 6 core screens',
        'Firebase Auth + Firestore',
        'Basic admin dashboard',
        '2 rounds of revisions',
        '2-week delivery',
        '30 days post-launch support',
        'Email support',
      ],
    ),
    PackageModel(
      name: 'Growth',
      price: '\$6,999',
      period: 'one-time',
      tagline: 'Most popular',
      summary: 'Full product build with the integrations a scaling team needs.',
      highlighted: true,
      ctaLabel: 'Start Growth',
      features: [
        '2 platforms (Mobile + Web)',
        'Up to 15 screens & flows',
        'Advanced Firebase backend',
        'Payment & API integrations',
        'Analytics + BI dashboard',
        'CI/CD deployment pipeline',
        'Unlimited revisions in scope',
        '4–6 week delivery',
        '90 days post-launch support',
        'Priority Slack support',
      ],
    ),
    PackageModel(
      name: 'Enterprise',
      price: 'Custom',
      period: 'retainer',
      tagline: 'Mission critical',
      summary: 'Dedicated squad, SLAs and compliance for serious scale.',
      ctaLabel: 'Talk to Sales',
      features: [
        'Unlimited platforms & screens',
        'Dedicated cross-functional team',
        'Custom backend architecture',
        'SSO, RBAC & audit logging',
        'Security review & compliance',
        'SLA-backed maintenance',
        'Quarterly roadmap workshops',
        '24/7 incident response',
        'Named account manager',
      ],
    ),
  ];

  /// Rows of the comparison table: [feature, starter, growth, enterprise].
  static const List<List<String>> comparisonRows = [
    ['Platforms supported', '1', '2', 'Unlimited'],
    ['Core screens / flows', '6', '15', 'Unlimited'],
    ['Firebase backend', 'Basic', 'Advanced', 'Custom'],
    ['Payment integration', '—', '✓', '✓'],
    ['Analytics & BI dashboard', '—', '✓', '✓'],
    ['API integrations', '1', '5', 'Unlimited'],
    ['CI/CD pipeline', '—', '✓', '✓'],
    ['Security audit', '—', '—', '✓'],
    ['Revisions', '2 rounds', 'In scope', 'Unlimited'],
    ['Delivery time', '2 weeks', '4–6 weeks', 'Custom'],
    ['Post-launch support', '30 days', '90 days', 'SLA'],
    ['Support channel', 'Email', 'Priority Slack', '24/7 + AM'],
  ];
}
