import 'package:cloud_firestore/cloud_firestore.dart';

/// `projects` collection document — powers the Projects grid.
class ProjectModel {
  const ProjectModel({
    required this.title,
    required this.category,
    required this.description,
    required this.tags,
    this.id,
    this.client = '',
    this.previewType = 'browserSaaS',
    this.techStack = const [],
    this.keyFeatures = const [],
    this.challenges = '',
    this.solution = '',
    this.results = '',
    this.year = '',
    this.featured = false,
  });

  final String? id;
  final String title;

  /// One of: Mobile Apps | Web Apps | Backend | Data Analytics
  final String category;
  final String description;
  final List<String> tags;
  final String client;

  /// Widget-mockup selector consumed by [ProjectPreview]:
  /// phoneManagement | chartsDashboard | browserSaaS | phoneShopping |
  /// apiCode | dataViz
  final String previewType;
  final List<String> techStack;
  final List<String> keyFeatures;
  final String challenges;
  final String solution;
  final String results;
  final String year;
  final bool featured;

  Map<String, dynamic> toMap() => {
    'title': title,
    'category': category,
    'description': description,
    'tags': tags,
    'client': client,
    'previewType': previewType,
    'techStack': techStack,
    'keyFeatures': keyFeatures,
    'challenges': challenges,
    'solution': solution,
    'results': results,
    'year': year,
    'featured': featured,
  };

  factory ProjectModel.fromDoc(DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data() ?? const {};
    return ProjectModel(
      id: doc.id,
      title: data['title'] ?? '',
      category: data['category'] ?? 'Web Apps',
      description: data['description'] ?? '',
      tags: List<String>.from(data['tags'] ?? const []),
      client: data['client'] ?? '',
      previewType: data['previewType'] ?? 'browserSaaS',
      techStack: List<String>.from(data['techStack'] ?? const []),
      keyFeatures: List<String>.from(data['keyFeatures'] ?? const []),
      challenges: data['challenges'] ?? '',
      solution: data['solution'] ?? '',
      results: data['results'] ?? '',
      year: data['year'] ?? '',
      featured: data['featured'] ?? false,
    );
  }

  // ------------------------------------------------------- default content
  /// Six featured showcase projects rendered on the Home & Projects pages.
  static const List<ProjectModel> seed = [
    ProjectModel(
      title: 'Agragami Somiti App',
      category: 'Mobile Apps',
      client: 'SoftKormo Showcase',
      year: '2026',
      featured: true,
      previewType: 'phoneManagement',
      description:
          'A community organization app for managing members, events, '
          'donations and announcements in one place.',
      tags: ['Flutter', 'Firebase', 'GetX'],
      techStack: ['Flutter', 'Firebase', 'GetX'],
      keyFeatures: [
        'Member & role management',
        'Events and announcements',
        'Donation tracking with receipts',
        'Offline-first sync',
      ],
      challenges:
          'Committees ran their society on paper registers, cash books and '
          'scattered chat threads — members missed announcements and donors '
          'never received receipts.',
      solution:
          'We shipped a Flutter + GetX app backed by Firestore with offline '
          'caching, realtime announcement feeds, role-based access and '
          'automatic donation receipts.',
      results:
          'Member engagement rose 3×, donation disputes dropped to zero, and '
          'monthly reporting now takes minutes instead of days.',
    ),
    ProjectModel(
      title: 'E-Commerce Dashboard',
      category: 'Web Apps',
      client: 'SoftKormo Showcase',
      year: '2026',
      featured: true,
      previewType: 'browserSaaS',
      description:
          'An operations dashboard for e-commerce teams — orders, catalogue, '
          'revenue and stock at a glance.',
      tags: ['Flutter Web', 'Firebase'],
      techStack: ['Flutter Web', 'Firebase'],
      keyFeatures: [
        'Orders & catalogue management',
        'Revenue & conversion analytics',
        'Low-stock alerts',
        'Role-based access control',
      ],
      challenges:
          'The ops team jumped between the store backend, spreadsheets and '
          'payment panels to answer basic questions, and stock mismatches '
          'caused cancellations.',
      solution:
          'A single Flutter Web dashboard on Firebase with realtime order '
          'streams, aggregated revenue metrics, alert rules and granular '
          'staff permissions.',
      results:
          'Order processing time fell 55%, stock discrepancies dropped by '
          '87%, and daily standups now start from one shared screen.',
    ),
    ProjectModel(
      title: 'Sales Analytics Dashboard',
      category: 'Data Analytics',
      client: 'SoftKormo Showcase',
      year: '2026',
      featured: true,
      previewType: 'chartsDashboard',
      description:
          'A sales analytics dashboard that turns raw CRM data into clear '
          'pipeline and performance insights.',
      tags: ['Python', 'Power BI'],
      techStack: ['Python', 'Power BI'],
      keyFeatures: [
        'Pipeline & funnel views',
        'Rep leaderboard',
        'Forecast trends',
        'Scheduled report delivery',
      ],
      challenges:
          'Sales reports were stitched together manually from three exports, '
          'metric definitions differed between regions, and forecasting was '
          'a monthly guessing game.',
      solution:
          'A Python pipeline cleans and models the CRM data nightly, and '
          'Power BI publishes governed KPIs, rep leaderboards and rolling '
          'forecasts on a refresh schedule.',
      results:
          'Report prep dropped from 2 days to minutes, forecast accuracy '
          'improved 23%, and regional KPIs finally match across teams.',
    ),
    ProjectModel(
      title: 'E-Commerce Mobile App',
      category: 'Mobile Apps',
      client: 'SoftKormo Showcase',
      year: '2025',
      featured: true,
      previewType: 'phoneShopping',
      description:
          'A modern shopping experience with product discovery, cart and '
          'order management.',
      tags: ['Flutter', 'Firebase'],
      techStack: ['Flutter', 'Cloud Functions', 'Stripe', 'Firebase Storage'],
      keyFeatures: [
        'Personalised discovery feed',
        'Cart & wishlist sync',
        'Secure checkout',
        'Live order tracking',
      ],
      challenges:
          'The retailer’s mobile web store bounced 68% of shoppers on product '
          'pages and had no push channel to bring buyers back.',
      solution:
          'A Flutter shopping app with a cached catalogue, one-tap checkout, '
          'FCM push campaigns and analytics wired to every funnel step.',
      results:
          'Conversion rose 2.4×, average order value grew 31%, and repeat '
          'purchases via push reached 19% of the user base.',
    ),
    ProjectModel(
      title: 'API & Authentication System',
      category: 'Backend',
      client: 'SoftKormo Showcase',
      year: '2025',
      featured: true,
      previewType: 'apiCode',
      description:
          'A secure API and authentication layer powering web, mobile and '
          'partner integrations.',
      tags: ['Node.js', 'Firebase'],
      techStack: ['Node.js', 'Firebase'],
      keyFeatures: [
        'Token & session authentication',
        'Role-based permissions',
        'Webhook delivery with retries',
        'Rate limiting & audit logs',
      ],
      challenges:
          'Every client re-implemented login and permissions, tokens expired '
          'inconsistently across apps, and partner integrations had no '
          'observability or rate protection.',
      solution:
          'We centralised auth behind one Node.js service with Firebase-backed '
          'tokens, documented endpoints, idempotent webhooks and per-key rate '
          'limits.',
      results:
          'New integrations dropped from 3 weeks to 4 days, login-related '
          'support tickets fell 76%, with 99.98% uptime across 2M+ monthly '
          'calls.',
    ),
    ProjectModel(
      title: 'Data Intelligence System',
      category: 'Data Analytics',
      client: 'SoftKormo Showcase',
      year: '2025',
      featured: true,
      previewType: 'dataViz',
      description:
          'A data intelligence system for reporting, visualization and '
          'business decision making.',
      tags: ['Analytics', 'Dashboard', 'Cloud'],
      techStack: ['Python', 'Airflow', 'BigQuery', 'Looker Studio'],
      keyFeatures: [
        'Automated ETL pipelines',
        'Executive KPI views',
        'Anomaly alerts',
        'Drill-down exploration',
      ],
      challenges:
          'Data lived in six tools, overnight jobs failed silently, and '
          'executives distrusted the numbers enough to re-check them by hand.',
      solution:
          'A monitored Airflow pipeline with freshness checks feeds a '
          'governed warehouse, and dashboards publish confidence badges with '
          'every refresh.',
      results:
          'Report accuracy complaints fell to zero, night jobs run 3× '
          'faster, and the exec pack now ships automatically each Monday.',
    ),
  ];
}
