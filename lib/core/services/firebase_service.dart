import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';

import '../../firebase_options.dart';

/// Thin wrapper around Firebase core services so features never talk to
/// Firebase directly (Dependency Inversion — swap the implementation here).
class FirebaseService {
  FirebaseService();

  static FirebaseAnalytics? _analytics;

  // ------------------------------------------------------------ lifecycle
  static Future<void> initialize() async {
    try {
      await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      );
      _analytics = FirebaseAnalytics.instance;
      await _analytics?.setAnalyticsCollectionEnabled(!kDebugMode);
      debugPrint(
        '[Firebase] initialized (${_analytics != null ? 'analytics on' : 'analytics off'})',
      );
    } catch (e) {
      // Never crash the site when Firebase is not configured yet —
      // Firestore-backed sections fall back to local seed data.
      debugPrint('[Firebase] init failed, running in offline mode: $e');
    }
  }

  // -------------------------------------------------------------- getters
  static FirebaseFirestore get db => FirebaseFirestore.instance;

  static FirebaseAnalytics? get analytics => _analytics;

  // ------------------------------------------------------------ analytics
  static Future<void> logScreenView(String screenName) async {
    try {
      await _analytics?.logScreenView(screenName: screenName);
    } catch (_) {}
  }

  static Future<void> logEvent(
    String name, {
    Map<String, Object>? params,
  }) async {
    try {
      await _analytics?.logEvent(name: name, parameters: params);
    } catch (_) {}
  }

  // --------------------------------------------------------------- write
  /// Generic, sanitized write used by every collection in the schema.
  static Future<void> submitDocument(
    String collection,
    Map<String, dynamic> data,
  ) async {
    final sanitized = <String, dynamic>{
      for (final entry in data.entries)
        entry.key: entry.value is String
            ? sanitize(entry.value as String)
            : entry.value,
      'createdAt': FieldValue.serverTimestamp(),
      'source': kIsWeb ? 'web' : 'app',
    };
    await db.collection(collection).add(sanitized);
  }

  /// Basic input sanitization: trims and strips control characters.
  static String sanitize(String input) {
    final cleaned = input
        .replaceAll(RegExp(r'[\u0000-\u001F\u007F]'), '')
        .trim();
    return cleaned.length > 5000 ? cleaned.substring(0, 5000) : cleaned;
  }
}
