# SoftKormo Admin Web App — Feature Summary

A complete feature inventory for the admin panel that manages the SoftKormo
public web app (`softkormo.web.app`). Everything below is derived from what
the public site actually renders and what the Firestore schema already
supports — so each admin screen maps 1:1 to real content.

**Stack (mirrors the public app):** Flutter Web · GetX · GetIt · Firebase
(Auth + Firestore + Analytics) · Clean Architecture · Poppins/Inter ·
brand tokens `#0B3C88 / #00B894 / #7B2CBF / #E91E63 / #FF7A00`.

---

## 1. Foundation already in place

The public app ships with an admin-friendly backend, so the admin panel is
mostly UI on top of existing contracts:

| Building block | Where it lives | What the admin gets from it |
|---|---|---|
| `isAdmin()` security rule | `firestore.rules` | Writes to all CMS collections already require `request.auth.token.admin == true` — no new rules needed to start |
| Public-read / admin-write split | `firestore.rules` | `services`, `packages`, `projects`, `testimonials` are readable by everyone, writable only by admins |
| Lead write-only rule | `firestore.rules` | Visitors can only `create` validated `contacts`; admins alone can read/update/delete them |
| Sanitized writes + server timestamps | `FirebaseService.submitDocument` | Every write is trimmed, control-char stripped, capped at 5000 chars, stamped `createdAt` + `source` |
| Models with `toMap()/fromDoc()` | `lib/shared/models/*` | Forms can be generated straight from the model field lists |
| Seed fallbacks | `*.seed` on each model | Pages never break while content is empty — admin edits are additive |
| Composite indexes | `firestore.indexes.json` | `contacts (status, createdAt DESC)`, `projects (year DESC, category ASC)` ready for list queries |
| Analytics hooks | `FirebaseService.logScreenView/logEvent` | Screen views + `contact_submitted` event already emitted by the public site |
| Route-aware SEO | `SeoTags.pages`, `web/sitemap.xml` | Per-route title/description the admin should be able to edit |

> **Gap to be aware of:** today only **Projects** reads Firestore
> (`ProjectsController.loadProjects` → seed fallback). Services, Packages and
> Testimonials still render their hardcoded `seed` lists. The admin app must
> land the matching Firestore reads (same pattern as Projects) or its edits
> will have nowhere to show up.

---

## 2. Authentication & roles

1. **Email/password + Google sign-in** (Firebase Auth).
2. **Admin custom claim** (`admin: true`) — set once via Admin SDK/Cloud
   Function; the existing rules key off exactly this claim.
3. **Role levels:** `viewer` (read-only dashboards), `editor` (CMS content),
   `admin` (leads, users, settings, destructive actions).
4. **Session handling:** auto refresh, "session expiring" warning, guarded
   `/admin/*` routes with redirect to sign-in.
5. **Password reset** + **device/session list** (where to sign out remotely).
6. **Failed-attempt lockout** messaging and audit entries on every sign-in.

---

## 3. Dashboard (home)

- **Lead KPIs:** total, `new`, `contacted`, `converted` (from
  `contacts`, using the existing `status + createdAt` index).
- **Conversion funnel** (new → contacted → converted) for the last 7/30 days.
- **Top requested services** — grouped by the `service` field of leads.
- **Content counts:** services, projects (featured vs total), packages,
  testimonials — each linking to its CRUD screen.
- **Recent leads** table (last 10) and **recent content changes**.
- **Site health tiles:** Firebase reachable (vs. seed-fallback mode),
  last deploy, sitemap status.
- **Analytics snapshot:** screen views for home/services/projects/contact
  from Firebase Analytics.

---

## 4. Lead management (CRM)

The contact form writes `contacts` with `name, email, phone, service,
message, status='new', createdAt, source`.

1. **Inbox list** — server-paged, sorted by `createdAt` desc, filtered by
   `status` and `service`, free-text search on name/email/message.
2. **Lead detail** — full message, contact actions (`mailto:`, `tel:`,
   copy-to-clipboard), timeline of status changes.
3. **Status workflow** — `new → contacted → qualified → converted → closed`,
   bulk status changes, assignment to a team member, internal notes.
4. **Validation parity** with the public form (email ≤254, message 10–5000,
   name ≤100, phone ≤30) so bad writes are caught client-side too.
5. **Export** CSV/Excel, **saved filters**, **unread badge** in the sidebar.
6. **Delete with confirmation** (admin-only, matches the rule).

---

## 5. Content management (CMS)

Each module: list (search/sort/paginate) + create/edit form + live preview
against the public site's card design + archive/delete.

### 5.1 Services (6 cards on Home + Services page)
`title · description · icon · chips[] · ctaLabel · highlight`
- Icon picker keyed on the existing Material keys (`phone_android`,
  `language`, `dns`, `analytics`, `rocket_launch`, `local_fire_department`).
- `highlight` toggles the featured/teal treatment.
- Reordering controls; count guard keeps the "6 cards" grid sane.

### 5.2 Projects (Home featured grid + Projects page)
`title · category · description · tags[] · client · previewType ·
techStack[] · keyFeatures[] · challenges · solution · results · year · featured`
- Category filter must mirror the site:
  `Mobile Apps | Web Apps | Backend | Data Analytics`.
- `previewType` dropdown for the widget mockup:
  `phoneManagement | chartsDashboard | browserSaaS | phoneShopping |
  apiCode | dataViz`.
- `featured` flag drives the ≥4-card Home showcase; `year` powers the
  existing `year DESC, category ASC` sort.
- Full **case-study editor** (challenges/solution/results) used by the
  "View Details" dialog.

### 5.3 Packages & pricing (Startup Solutions page)
`name · price · period · tagline · summary · features[] · highlighted ·
ctaLabel`
- `highlighted` = the "Most popular" plan.
- Separate **comparison-table editor** (12 rows × 3 columns: platforms,
  screens, backend, payments, analytics, API count, CI/CD, security audit,
  revisions, delivery, support, channel).
- Price formatting helper (`$2,499` / `Custom`) + duplicate-name guard.

### 5.4 Testimonials (Home strip + Testimonials page)
`name · role · company · quote · rating (1–5) · avatar`
- Star widget input, quote length guard (card overflow protection),
  avatar upload to Firebase Storage (URL stored in `avatar`),
  featured/hidden toggle.

### 5.5 Site settings & SEO
- **Brand copy:** hero headline/subheadline, primary/secondary CTA labels,
  tagline, footer email/phone/address/map embed URL.
- **SEO per route:** title + description for `/`, `/about`, `/services`,
  `/startup-package`, `/projects`, `/portfolio`, `/testimonials`,
  `/contact` (currently `SeoTags.pages`), plus keywords and canonical
  `siteUrl`; auto-regenerate `web/sitemap.xml`.
- **Nav/footer links:** edit labels and order of the label→route map that
  drives header, drawer and footer (adding Blog back later would be a
  one-line entry here).
- **Brand tokens:** color palette + font pair (with a "restore defaults"
  action).

### 5.6 Media library
Upload/organise images (logos, project shots, avatars), list/preview/delete,
Firebase Storage paths with cache headers.

---

## 6. Users & access

- List admins/editors (custom claims), invite by email, change role,
  revoke access.
- **Audit log:** who created/edited/deleted what, with timestamp and diff —
  written to an `auditLogs` collection (new).

---

## 7. Analytics & reporting

- Firebase Analytics readouts: screen views per page, `contact_submitted`
  volume by `service`, top landing routes.
- Lead sources (`source: web|app`), conversion rate, service demand chart.
- Date-range picker, CSV export.

---

## 8. System

- **Firestore console shortcuts** for the 6 collections
  (`contacts · projects · services · packages · testimonials · blogs`).
- **Backup/export** (JSON) and **import/seed** from the model `.seed`
  lists — useful to populate an empty Firestore in one click.
- **Feature toggles:** maintenance banner, CTA enable/disable.
- **Health check:** Firebase init status (the public app degrades to seed
  mode when Firebase is unavailable — surfaced here).

---

## 9. Non-functional requirements

- **Responsive** at 360 / 768 / 1024 / 1440 / 1920 (same `Responsive.get`
  breakpoints as the public site) — zero layout overflow.
- **Sticky glass sidebar/topbar**, brand gradient, 300–600 ms animations.
- **Same quality gates:** `flutter analyze` 0 issues · `flutter test` green
  (`takeException()` = no overflows) · `flutter build web --release`.
- Accessibility: clamped text scaling (0.9–1.3), semantic labels, keyboard
  navigation, contrast-safe brand colors.
- Secure by default: all writes already gated by `isAdmin()`; deny-by-default
  rule at the bottom of `firestore.rules`.

---

## 10. Suggested route map

```
/login
/admin                 → dashboard (KPIs, recent leads)
/admin/leads           → CRM inbox
/admin/leads/:id       → lead detail
/admin/services        → services CRUD
/admin/projects        → projects CRUD + case-study editor
/admin/packages        → pricing + comparison table
/admin/testimonials    → testimonials CRUD
/admin/media           → media library
/admin/settings/site   → brand copy, contact info, nav links
/admin/settings/seo    → per-route SEO + sitemap
/admin/settings/users  → roles & invites
/admin/settings/audit  → audit log
```

---

## 11. Delivery phases

| Phase | Scope |
|---|---|
| **1 — Core** | Auth + admin claim, dashboard, Lead CRM (the only collection that is truly live today) |
| **2 — CMS** | Services/Projects/Packages/Testimonials CRUD **+ wire the public pages to read Firestore with seed fallback** (only Projects does today) |
| **3 — Settings** | Brand copy, per-route SEO + sitemap, nav/footer links |
| **4 — Ops** | Media library, users/roles, audit log, analytics, backup/import |
