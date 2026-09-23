import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/services/firebase_service.dart';
import '../../../shared/models/contact_model.dart';
import 'contact_repository.dart';

/// Presentation logic for the contact form: validation, sanitization,
/// Firestore submission and analytics events.
class ContactController extends GetxController {
  ContactController({ContactRepository? repository})
    : _repository = repository ?? const FirestoreContactRepository();

  final ContactRepository _repository;

  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();
  final messageController = TextEditingController();

  final RxString selectedService = ''.obs;
  final RxBool isLoading = false.obs;
  final RxBool isSuccess = false.obs;

  final List<String> services = const [
    'Mobile App Development',
    'Web Application Development',
    'Backend Development',
    'API Integration',
    'Data Analysis & Business Intelligence',
    'Startup Package Solutions',
    'Firebase Solutions',
    'Software Maintenance & Support',
  ];

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  // ------------------------------------------------------------ validation
  String? validateName(String? value) {
    final v = FirebaseService.sanitize(value ?? '');
    if (v.isEmpty) return 'Please enter your name';
    if (v.length < 2) return 'Name is too short';
    if (v.length > 100) return 'Name is too long';
    return null;
  }

  String? validateEmail(String? value) {
    final v = (value ?? '').trim();
    if (v.isEmpty) return 'Please enter your email';
    final emailRe = RegExp(r'^[\w\.\-\+]+@([\w\-]+\.)+[a-zA-Z]{2,}$');
    if (!emailRe.hasMatch(v)) return 'Enter a valid email address';
    if (v.length > 254) return 'Email is too long';
    return null;
  }

  String? validatePhone(String? value) {
    final v = (value ?? '').replaceAll(RegExp(r'[\s\-\(\)]'), '');
    if (v.isEmpty) return 'Please enter your phone number';
    if (!RegExp(r'^\+?\d{7,15}$').hasMatch(v)) {
      return 'Enter a valid phone number';
    }
    return null;
  }

  String? validateMessage(String? value) {
    final v = FirebaseService.sanitize(value ?? '');
    if (v.isEmpty) return 'Please tell us about your project';
    if (v.length < 10) return 'Message should be at least 10 characters';
    if (v.length > 5000) return 'Message is too long';
    return null;
  }

  String? validateService(String? value) {
    if (selectedService.value.isEmpty) return 'Please select a service';
    return null;
  }

  // -------------------------------------------------------------- actions
  Future<void> submit() async {
    if (!(formKey.currentState?.validate() ?? false)) return;

    isLoading.value = true;
    isSuccess.value = false;

    try {
      final contact = ContactModel(
        name: FirebaseService.sanitize(nameController.text),
        email: FirebaseService.sanitize(emailController.text),
        phone: FirebaseService.sanitize(phoneController.text),
        service: selectedService.value,
        message: FirebaseService.sanitize(messageController.text),
      );

      await _repository.submit(contact);
      await FirebaseService.logEvent(
        'contact_submitted',
        params: {'service': contact.service},
      );

      isSuccess.value = true;
      clear();
      Get.rawSnackbar(
        message: 'Thanks ${contact.name}! We will reply within 24 hours.',
        backgroundColor: const Color(0xFF0B3C88),
        margin: const EdgeInsets.all(16),
        borderRadius: 12,
        duration: const Duration(seconds: 4),
      );
    } catch (e) {
      debugPrint('[Contact] submit failed: $e');
      Get.rawSnackbar(
        message: 'Something went wrong. Please try again or email us directly.',
        backgroundColor: const Color(0xFFDC2626),
        margin: const EdgeInsets.all(16),
        borderRadius: 12,
        duration: const Duration(seconds: 4),
      );
    } finally {
      isLoading.value = false;
    }
  }

  void clear() {
    nameController.clear();
    emailController.clear();
    phoneController.clear();
    messageController.clear();
    selectedService.value = '';
    formKey.currentState?.reset();
  }

  @override
  void onClose() {
    nameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    messageController.dispose();
    super.onClose();
  }
}
