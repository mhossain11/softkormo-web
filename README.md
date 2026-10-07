# SoftKormo — Corporate Website (Flutter Web)

**Smart Software, Reliable Service**

Premium corporate website for the SoftKormo software company, built with
Flutter Web, Clean Architecture, GetX (state), GetIt (DI) and Firebase.

---

## ✨ Features

### Pages & routes (7 public URLs)

| Route | Page | What it contains |
|---|---|---|
| `/` | `HomePage` | Hero → stats → services → projects → why us → tech stack → pricing → process → testimonials → CTA |
| `/about` | `AboutPage` | Story timeline, stat chips, Mission/Vision panels, values grid, "why teams choose us" list, process section |
| `/services` | `ServicesPage` | All 6 service cards with feature chips + detail copy |
| `/projects` | `ProjectsPage` | Category filter chips, responsive project grid, case-study dialog, CTA |
| `/startup-package` | `StartupPackagePage` | 3 pricing cards, 12-row feature comparison table, FAQ accordion |
| `/testimonials` | `TestimonialsPage` | Rating summary, outcome metrics, testimonial grid |
| `/contact` | `ContactPage` | Validated contact form, embedded map, contact/social cards |
| `/portfolio` | *(alias)* | Legacy URL that redirects to `/projects` ("Portfolio" was renamed everywhere) |

Navigation: **Home · About · Services · Projects · Startup Solutions ·
Contact** (6 items) — one `labelToRoute` map drives the header, mobile
drawer and footer, so link order can never drift between them.
Unknown URLs land on the built-in 404 page.

### Home page sections (top → bottom)

1. **Hero** — headline *"Building Smart Software for Modern Businesses"*,
   dual CTAs, animated illustration (looping, gradient).
2. **Stats strip** — projects delivered / clients / years / team numbers.
3. **OUR SERVICES** — 6 cards (Mobile, Web, Backend, Data Analytics,
   Startup Package, Firebase) with feature chips and CTA.
4. **Featured Projects** — ≥4 showcase cards with animated device/browser
   mockups and **View Details** dialogs.
5. **Why teams choose us** — reason tiles with hover states.
6. **Tools we master daily** — technology stack chips.
7. **Transparent pricing, fixed scope** — Starter / Growth / Enterprise.
8. **A process built for momentum** — 4-step delivery process.
9. **Trusted by founders and CTOs** — testimonial preview strip.
10. **CTA band** — *"Your idea deserves a team that ships."* opens a
    contact form dialog (works on every breakpoint).

### Global UI

- **Sticky glass navbar** — always visible & pinned at every scroll offset,
  `BackdropFilter` blur, elevation + soft shadow that fades in once the page
  scrolls past the top, active-route highlight, animated underline hover.
- **Mobile drawer** — same link map, icons, active state, close button.
- **Back-to-top button** — floating bottom-left, appears after 300 px,
  brand gradient, hover scale + shadow, smooth 600 ms eased scroll;
  offsets 30/24/16 px for desktop/tablet/mobile.
- **Footer** — brand column, Company/Services link columns, contact column,
  social icons, copyright.
- **Animations** — section reveal + staggered list entrances (300–600 ms),
  hero loop, button/card hover states.
- **Responsive** — 360 / 768 / 1024 / 1440 / 1920 with no hardcoded widths
  and **zero layout-overflow exceptions** (asserted in tests).
- **Theme** — Material 3 light/dark tokens (light by default), Poppins +
  Inter, text scaling clamped 0.9–1.3 for accessibility.

### Forms & data

- Contact form: name/email/phone/service/message with inline validators,
  `SanitizeFormatter`, autovalidate-on-interaction, success/error snackbars,
  loading state on the submit button.
- Submissions are written to `contacts` with `status: 'new'`,
  server timestamp and `source` (web/app), then logged as a
  `contact_submitted` analytics event.

### Content (Firestore-backed with seed fallback)

`services` · `projects` · `packages` · `testimonials` each have a model with
`fromDoc()/toMap()` plus curated seed content, so every page renders fully
even before Firestore is populated, offline, or when Firebase isn't
configured. Projects already reads Firestore (`orderBy('year')`, falls back
to seed on empty/error); the other collections ship their seed lists and are
ready for the admin CMS — see [`docs/ADMIN_APP_FEATURES.md`](docs/ADMIN_APP_FEATURES.md).

### Analytics & SEO

- Firebase Analytics screen views per page + `contact_submitted` event
  (disabled in debug builds).
- Runtime route-aware `<title>`/meta/OG/canonical updates via `SeoService`
  (conditional web import — no-op on other platforms).

---

## ✅ Quality gates

| Gate | Status |
|---|---|
| `flutter analyze` | **No issues found** |
| `flutter test` | **20/20 passed** |
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
│   └── widgets/     GradientButton, SectionTitle, AnimatedSection, ResponsiveContainer,
│                    PageScrollShell (scroll scope), BackToTopButton
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
- `firestore.indexes.json` — composite indexes for `projects (year, category)`,
  `contacts (status, createdAt)` and the legacy `blogs` pair.
- `blogs` still exists in Firestore (rules/index) but is no longer used by
  the site — the Blog page and nav link were removed.

---

## 🔍 SEO

- `web/index.html` — meta, keywords, Open Graph, Twitter card, canonical,
  JSON-LD `SoftwareCompany` structured data, theme color.
- `web/robots.txt` + `web/sitemap.xml` (all 7 public URLs).
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
