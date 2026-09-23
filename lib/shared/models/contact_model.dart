import 'package:cloud_firestore/cloud_firestore.dart';

/// `contacts` collection document.
class ContactModel {
  const ContactModel({
    required this.name,
    required this.email,
    required this.phone,
    required this.service,
    required this.message,
    this.id,
    this.createdAt,
    this.status = 'new',
  });

  final String? id;
  final String name;
  final String email;
  final String phone;
  final String service;
  final String message;
  final DateTime? createdAt;
  final String status;

  Map<String, dynamic> toMap() => {
    'name': name,
    'email': email,
    'phone': phone,
    'service': service,
    'message': message,
    'status': status,
  };

  factory ContactModel.fromDoc(DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data() ?? const {};
    return ContactModel(
      id: doc.id,
      name: data['name'] ?? '',
      email: data['email'] ?? '',
      phone: data['phone'] ?? '',
      service: data['service'] ?? '',
      message: data['message'] ?? '',
      status: data['status'] ?? 'new',
      createdAt: (data['createdAt'] as Timestamp?)?.toDate(),
    );
  }
}
