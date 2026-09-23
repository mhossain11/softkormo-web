import 'package:web/web.dart' as web;
import 'seo_service.dart';
import 'seo_tags.dart';

/// Browser implementation: rewrites <title>, meta description, canonical,
/// Open Graph and Twitter card tags in place (works with Firebase Hosting).
Future<void> initSeo() async {
  SeoService.bind((path, title, description, imageUrl) async {
    final doc = web.document;

    doc.title = title;

    _setMeta(doc, 'description', description);
    _setMeta(doc, 'keywords', SeoTags.keywords);

    // ------------------------------------------------------------- OG
    _setMeta(doc, 'og:title', title, property: true);
    _setMeta(doc, 'og:description', description, property: true);
    _setMeta(doc, 'og:url', '${SeoTags.siteUrl}$path', property: true);
    _setMeta(doc, 'og:type', 'website', property: true);
    _setMeta(doc, 'og:site_name', SeoTags.siteName, property: true);
    _setMeta(
      doc,
      'og:image',
      imageUrl ?? '${SeoTags.siteUrl}/icons/Icon-512.png',
      property: true,
    );

    // --------------------------------------------------------- Twitter
    _setMeta(doc, 'twitter:card', 'summary_large_image');
    _setMeta(doc, 'twitter:title', title);
    _setMeta(doc, 'twitter:description', description);
    _setMeta(
      doc,
      'twitter:image',
      imageUrl ?? '${SeoTags.siteUrl}/icons/Icon-512.png',
    );

    // ------------------------------------------------------- canonical
    _setCanonical(doc, '${SeoTags.siteUrl}$path');
  });
}

void _setMeta(
  web.Document doc,
  String key,
  String content, {
  bool property = false,
}) {
  final attr = property ? 'property' : 'name';
  var el = doc.querySelector('meta[$attr="$key"]') as web.HTMLMetaElement?;
  if (el == null) {
    el = web.document.createElement('meta') as web.HTMLMetaElement;
    el.setAttribute(attr, key);
    (doc.head ?? doc.documentElement)!.appendChild(el);
  }
  el.content = content;
}

void _setCanonical(web.Document doc, String href) {
  var el = doc.querySelector('link[rel="canonical"]') as web.HTMLLinkElement?;
  if (el == null) {
    el = doc.createElement('link') as web.HTMLLinkElement;
    el.rel = 'canonical';
    (doc.head ?? doc.documentElement)!.appendChild(el);
  }
  el.href = href;
}
