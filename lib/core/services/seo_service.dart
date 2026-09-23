 /// Route-aware SEO: updates document title, description, canonical URL,
/// Open Graph and Twitter tags whenever navigation settles.
///
/// Web implementation lives in `seo_service_web.dart`; other platforms get
/// a no-op via `seo_service_stub.dart` (conditional import).
typedef SeoUpdater =
    Future<void> Function(
      String path,
      String title,
      String description,
      String? imageUrl,
    );

abstract class SeoService {
  static SeoUpdater? _impl;

  /// Injected by the platform-specific file on first use.
  static void bind(SeoUpdater impl) {
    _impl = impl;
  }

  static Future<void> update({
    required String path,
    required String title,
    required String description,
    String? imageUrl,
  }) async {
    final impl = _impl;
    if (impl == null) return;
    await impl(path, title, description, imageUrl);
  }
}
