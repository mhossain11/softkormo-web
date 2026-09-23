import 'package:cloud_firestore/cloud_firestore.dart';

/// `testimonials` collection document.
class TestimonialModel {
  const TestimonialModel({
    required this.name,
    required this.role,
    required this.quote,
    this.id,
    this.company = '',
    this.rating = 5,
    this.avatar = '',
  });

  final String? id;
  final String name;
  final String role;
  final String company;
  final String quote;
  final int rating;
  final String avatar;

  Map<String, dynamic> toMap() => {
    'name': name,
    'role': role,
    'company': company,
    'quote': quote,
    'rating': rating,
    'avatar': avatar,
  };

  factory TestimonialModel.fromDoc(DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data() ?? const {};
    return TestimonialModel(
      id: doc.id,
      name: data['name'] ?? '',
      role: data['role'] ?? '',
      company: data['company'] ?? '',
      quote: data['quote'] ?? '',
      rating: data['rating'] ?? 5,
      avatar: data['avatar'] ?? '',
    );
  }

  // ------------------------------------------------------- default content
  static const List<TestimonialModel> seed = [
    TestimonialModel(
      name: 'Sarah Ahmed',
      role: 'CEO',
      company: 'LogisticsCo',
      rating: 5,
      quote:
          'SoftKormo shipped our fleet app two weeks ahead of schedule. Their Flutter team understood both the business side and the engineering — rare combination.',
    ),
    TestimonialModel(
      name: 'David Chen',
      role: 'Founder',
      company: 'MediDesk Health',
      rating: 5,
      quote:
          'From MVP to 40,000 monthly patients in under a year. The startup package gave us a production-grade foundation without burning our runway.',
    ),
    TestimonialModel(
      name: 'Priya Nair',
      role: 'CTO',
      company: 'PayGrid',
      rating: 5,
      quote:
          'Their backend engineers rebuilt our payment pipeline with zero downtime migration. 2M transactions a month and the system never flinched.',
    ),
    TestimonialModel(
      name: 'Marcus Webb',
      role: 'Head of Data',
      company: 'RetailSense',
      rating: 4,
      quote:
          'The BI dashboards replaced eleven spreadsheets. Our regional managers now make decisions in meetings instead of waiting for reports.',
    ),
    TestimonialModel(
      name: 'Amina Rahman',
      role: 'Product Lead',
      company: 'AgriLink',
      rating: 5,
      quote:
          'They designed for low-bandwidth rural users when everyone else said it was impossible. Download retention jumped 41% after launch.',
    ),
    TestimonialModel(
      name: 'Tomás Oliveira',
      role: 'COO',
      company: 'Nova Retail',
      rating: 5,
      quote:
          'Communication was transparent from day one — weekly demos, honest timelines, no surprises. Exactly what you want in a software partner.',
    ),
  ];
}
