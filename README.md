# SoftKormo — Corporate Website (Flutter Web)

**Smart Software, Reliable Service**

Premium corporate website for the SoftKormo software company, built with
Flutter Web, Clean Architecture, GetX (state), GetIt (DI) and Firebase.

---

## ✅ Quality gates

| Gate | Status |
|---|---|
| `flutter analyze` | **No issues found** |
| `flutter test` | **3/3 passed** |
| `flutter build web --release` | **Built `build/web`** |

---

## 🚀 Run & build

```bash
flutter pub get
flutter run -d chrome            # local dev
flutter build web --release      # production bundle -> build/web
firebase deploy --only hosting   # deploy to Firebase Hosting
firebase deploy --only firestore:rules   # deploy security rules
```

---

## 📁 Architecture

```
lib/
├── core/
│   ├── constants/   app_colors, app_strings, app_dimensions (brand tokens)
│   ├── themes/      app_theme.dart — light/dark Material 3, Poppins + Inter
│   ├── utils/       responsive_utils.dart — 360 → 1920+ breakpoints
│   ├── services/    firebase_service, seo_service(+web/stub), injection (GetIt)
│   ├── routes/      app_routes.dart — central GetX route table
│   └── widgets/     GradientButton, SectionTitle, AnimatedSection, ResponsiveContainer
│
├── features/        home · about · services · startup_package
│                    projects · testimonials · contact
│                    (presentation) + *_controller.dart (domain)
│                    + *_repository.dart (data)
│
├── shared/
│   ├── widgets/     CustomAppBar, CustomDrawer, Footer, ServiceCard, ProjectCard,
│   │                TestimonialCard, PricingCard, ContactForm, BrandLogo
│   ├── models/      Firestore models: contact, service, project,
│   │                testimonial, package (with seed content)
│   └── extensions/  form_extensions.dart — sanitization + validators
│
├── app.dart         GetMaterialApp shell + route-aware SEO
└── main.dart        bootstrap: bindings → DI → runApp
```

### Layers
- **Presentation** — pages, section widgets, reusable cards
- **Domain** — controllers (`GetX`), validation & use-cases
- **Data** — repositories → `FirebaseService` (single Firebase gateway)

---

## 🎨 Brand system (from logo)

| Token | Hex |
|---|---|
| Deep Blue (primary) | `#0B3C88` |
| Teal Green (accent) | `#00B894` |
| Purple | `#7B2CBF` |
| Magenta | `#E91E63` |
| Orange | `#FF7A00` |

Logo asset: `assets/logo/kormosoft_s.png` (bundled).

---

## 📱 Responsive breakpoints

`mobile 360 · tablet 768 · laptop 1024 · desktop 1440 · ultraWide 1920`

Use `Responsive.get(context, mobile:, tablet:, ...)` — **no hardcoded widths**.

---

## 🗄️ Firestore collections

`contacts` · `blogs` · `projects` · `testimonials` · `services` · `packages`

- Models have `fromDoc()/toMap()` + seed fallbacks, so pages render even
  before Firestore is populated or when offline.
- `firestore.rules` — deny-by-default, validated contact creation, admin-only CMS.
- `firestore.indexes.json` — composite indexes for year/category, category/date,
  status/date queries.

---

## 🔍 SEO

- `web/index.html` — meta, keywords, Open Graph, Twitter card, canonical,
  JSON-LD `SoftwareCompany` structured data, theme color.
- `web/robots.txt` + `web/sitemap.xml` (all 8 routes).
- Runtime route-aware title/meta updates via `SeoService` (web conditional import).
- Firebase Hosting config: `cleanUrls`, security headers/CSP, SPA rewrites,
  immutable caching for compiled JS/CSS.

---

## 🔐 Security

- Firebase security rules (validated writes, no public reads of contacts).
- Input sanitization (`SanitizeFormatter` + `FirebaseService.sanitize`).
- Form validation (email/phone/length rules) with `autovalidateMode`.
- CSP + `X-Frame-Options` headers in `firebase.json`.
- Environment values isolated in `lib/firebase_options.dart`.

---

## ⚙️ Stack

Flutter Web · GetX · GetIt · Firebase (Core, Firestore, Analytics) · google_fonts (Poppins/Inter)
