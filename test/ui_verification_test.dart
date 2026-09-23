import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:softkormo/core/widgets/back_to_top_button.dart';
import 'package:softkormo/features/contact/contact_page.dart';
import 'package:softkormo/features/home/home_page.dart';
import 'package:softkormo/features/home/sections/home_sections.dart';
import 'package:softkormo/features/home/sections/services_preview_section.dart';
import 'package:softkormo/features/projects/projects_page.dart';
import 'package:softkormo/shared/models/service_model.dart';
import 'package:softkormo/shared/widgets/custom_app_bar.dart';
import 'package:softkormo/shared/widgets/project_card.dart';
import 'package:softkormo/shared/widgets/project_filter_chip.dart';
import 'package:softkormo/shared/widgets/project_preview.dart';
import 'package:softkormo/shared/widgets/service_card.dart';

/// UI verification for the SoftKormo update:
///  * Services ("OUR SERVICES") renders with all 6 cards right after the hero
///  * Featured Projects renders with 6 rich preview cards
///  * Navigation says "Projects", never "Portfolio"
///  * Responsive columns: 1 / 2 / 3 per breakpoint, no RenderFlex overflow
void main() {
  void useSize(WidgetTester tester, double w, double h) {
    tester.view.physicalSize = Size(w, h);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.reset);
  }

  Future<void> pumpScrollable(
    WidgetTester tester,
    Widget child, {
    required double w,
    required double h,
  }) async {
    useSize(tester, w, h);
    await tester.pumpWidget(
      GetMaterialApp(
        home: Scaffold(body: SingleChildScrollView(child: child)),
      ),
    );
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 400));
    // Flush AnimatedSection reveal delays (Future.delayed).
    await tester.pump(const Duration(seconds: 1));
  }

  List<double> cardXs(WidgetTester tester, Type type) => tester
      .widgetList(find.byType(type))
      .map((w) => tester.getTopLeft(find.byWidget(w)).dx)
      .toList();

  // ------------------------------------------------------------ services
  testWidgets('Services: 6 cards, 1 column at 360 (mobile)', (tester) async {
    await pumpScrollable(
      tester,
      const ServicesPreviewSection(),
      w: 360,
      h: 800,
    );

    expect(find.text('OUR SERVICES'), findsOneWidget);
    expect(
      find.text(
        'Complete software solutions for startups and modern businesses.',
      ),
      findsOneWidget,
    );
    expect(find.byType(ServiceCard), findsNWidgets(6));
    expect(find.text('Learn More'), findsNWidgets(6));
    for (final s in ServiceModel.seed) {
      expect(find.text(s.title), findsOneWidget, reason: 'missing ${s.title}');
    }

    // 1 column → every card starts at the same x.
    final xs = cardXs(tester, ServiceCard);
    expect(xs[1], xs[0]);
    expect(xs[5], xs[0]);
    expect(tester.takeException(), isNull);
  });

  testWidgets('Services: 2 columns at 768 (tablet)', (tester) async {
    await pumpScrollable(
      tester,
      const ServicesPreviewSection(),
      w: 768,
      h: 1024,
    );

    expect(find.byType(ServiceCard), findsNWidgets(6));
    final xs = cardXs(tester, ServiceCard);
    expect(xs[1], greaterThan(xs[0]), reason: 'tablet needs 2 columns');
    expect(xs[2], xs[0], reason: 'third card wraps to row 2');
    expect(tester.takeException(), isNull);
  });

  testWidgets('Services: 3 columns at 1440 (desktop)', (tester) async {
    await pumpScrollable(
      tester,
      const ServicesPreviewSection(),
      w: 1440,
      h: 900,
    );

    expect(find.byType(ServiceCard), findsNWidgets(6));
    expect(find.text('View All Services'), findsOneWidget);
    final xs = cardXs(tester, ServiceCard);
    expect(xs[1], greaterThan(xs[0]), reason: 'desktop needs 3 columns');
    expect(xs[2], greaterThan(xs[1]), reason: 'desktop needs 3 columns');
    expect(xs[3], xs[0], reason: 'fourth card wraps to row 2');
    expect(tester.takeException(), isNull);
  });

  testWidgets('Services: 3 columns at 1024 (laptop), no overflow', (
    tester,
  ) async {
    await pumpScrollable(
      tester,
      const ServicesPreviewSection(),
      w: 1024,
      h: 900,
    );

    expect(find.byType(ServiceCard), findsNWidgets(6));
    final xs = cardXs(tester, ServiceCard);
    expect(xs[1], greaterThan(xs[0]), reason: 'laptop needs 3 columns');
    expect(xs[2], greaterThan(xs[1]), reason: 'laptop needs 3 columns');
    expect(xs[3], xs[0], reason: 'fourth card wraps to row 2');
    expect(tester.takeException(), isNull);
  });

  // ----------------------------------------------------------- projects
  testWidgets('Featured Projects: 6 preview cards, responsive grid', (
    tester,
  ) async {
    await pumpScrollable(
      tester,
      const FeaturedProjectsSection(),
      w: 1440,
      h: 900,
    );

    expect(find.text('Featured Projects'), findsOneWidget);
    expect(
      find.text('Explore some of the digital products and solutions we build.'),
      findsOneWidget,
    );
    expect(find.byType(ProjectCard), findsNWidgets(6));
    expect(
      find.byType(ProjectPreview),
      findsNWidgets(6),
      reason: 'every card needs a widget-built preview',
    );
    expect(find.text('View Details'), findsNWidgets(6));
    expect(find.text('View All Projects'), findsOneWidget);
    expect(find.text('Agragami Somiti App'), findsOneWidget);
    expect(find.text('Data Intelligence System'), findsOneWidget);
    expect(find.text('Portfolio'), findsNothing);
    expect(tester.takeException(), isNull);
  });

  testWidgets('Featured Projects: 1 column at 360 with previews', (
    tester,
  ) async {
    await pumpScrollable(
      tester,
      const FeaturedProjectsSection(),
      w: 360,
      h: 800,
    );

    expect(find.byType(ProjectCard), findsNWidgets(6));
    expect(find.byType(ProjectPreview), findsNWidgets(6));
    final xs = cardXs(tester, ProjectCard);
    expect(xs[1], xs[0], reason: 'mobile stacks to a single column');
    expect(tester.takeException(), isNull);
  });

  testWidgets('Featured Projects: 2 columns at 768', (tester) async {
    await pumpScrollable(
      tester,
      const FeaturedProjectsSection(),
      w: 768,
      h: 1024,
    );

    final xs = cardXs(tester, ProjectCard);
    expect(xs[1], greaterThan(xs[0]), reason: 'tablet needs 2 columns');
    expect(xs[2], xs[0], reason: 'third card wraps to row 2');
    expect(tester.takeException(), isNull);
  });

  testWidgets('Featured Projects: 3 columns at 1024 (laptop), no overflow', (
    tester,
  ) async {
    // Laptop content is capped at 960 - 48 padding = 912px, so 3 columns
    // give 304px cards → 256px previews → 228px inner width. The phone
    // mocks need 230px at design size: this is the 2px-overflow window
    // band (1024–1439px) that no other test covers.
    await pumpScrollable(
      tester,
      const FeaturedProjectsSection(),
      w: 1024,
      h: 900,
    );

    expect(find.byType(ProjectCard), findsNWidgets(6));
    expect(find.byType(ProjectPreview), findsNWidgets(6));
    final xs = cardXs(tester, ProjectCard);
    expect(xs[1], greaterThan(xs[0]), reason: 'laptop needs 3 columns');
    expect(xs[3], xs[0], reason: 'fourth card wraps to row 2');
    expect(tester.takeException(), isNull);
  });

  testWidgets('Phone previews fit 223.6px and 188px inner widths', (
    tester,
  ) async {
    // 251.6px produced the reported "RenderFlex overflowed by 6.4 pixels"
    // (inner = 251.6 - 28 = 223.6 < the mock's 230px design width); 216px
    // is the detail-dialog preview on a 360px screen (inner = 188).
    for (final width in [251.6, 216.0]) {
      for (final type in ['phoneManagement', 'phoneShopping']) {
        await tester.pumpWidget(
          GetMaterialApp(
            home: Scaffold(
              // Align (not SingleChildScrollView): it hands the child LOOSE
              // constraints so SizedBox(width:) actually decides the width.
              body: Align(
                alignment: Alignment.topLeft,
                child: SizedBox(
                  width: width,
                  child: ProjectPreview(type: type),
                ),
              ),
            ),
          ),
        );
        await tester.pump();
        await tester.pump(const Duration(milliseconds: 450));
        expect(
          tester.takeException(),
          isNull,
          reason: '$type must fit a ${width}px preview without overflow',
        );
      }
    }
  });

  // --------------------------------------------------------------- nav
  testWidgets('Navigation shows Projects, never Portfolio (desktop)', (
    tester,
  ) async {
    useSize(tester, 1440, 900);
    await tester.pumpWidget(
      GetMaterialApp(
        home: Scaffold(body: CustomScrollView(slivers: [const CustomAppBar()])),
      ),
    );
    await tester.pump();
    await tester.pump(const Duration(seconds: 1));

    for (final label in [
      'Home',
      'About',
      'Services',
      'Projects',
      'Startup Solutions',
      'Contact',
    ]) {
      expect(find.text(label), findsOneWidget, reason: 'nav missing $label');
    }
    expect(find.text('Portfolio'), findsNothing);
    expect(find.text('Blog'), findsNothing);
    expect(find.text('Startup Package'), findsNothing);
    expect(tester.takeException(), isNull);
  });

  testWidgets('Mobile nav collapses to the menu button', (tester) async {
    useSize(tester, 360, 800);
    await tester.pumpWidget(
      GetMaterialApp(
        home: Scaffold(
          endDrawer: null,
          body: CustomScrollView(slivers: [CustomAppBar(onMenuPressed: () {})]),
        ),
      ),
    );
    await tester.pump();

    expect(find.byTooltip('Open menu'), findsOneWidget);
    expect(find.text('Portfolio'), findsNothing);
    expect(tester.takeException(), isNull);
  });

  // ----------------------------------------------------- full home order
  testWidgets('Home page follows the required section order (desktop)', (
    tester,
  ) async {
    // The full home page is ~10300px tall at 1440: the viewport must cover
    // it, or the trailing CTA/footer slivers are never laid out and finders
    // (skipOffstage: true by default) miss them.
    useSize(tester, 1440, 11000);
    await tester.pumpWidget(const GetMaterialApp(home: HomePage()));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 400));
    await tester.pump(const Duration(seconds: 1));

    double yOf(String text) => tester.getTopLeft(find.text(text)).dy;

    final order = [
      'Projects Delivered', // hero + stats
      'OUR SERVICES', // services
      'Featured Projects', // featured projects
      'Why teams choose us', // why choose
      'Tools we master daily', // technology stack
      'Transparent pricing, fixed scope', // startup solutions
      'A process built for momentum', // how we work
      'Trusted by founders and CTOs', // testimonials
      'Your idea deserves a team that ships.', // CTA
    ];

    for (var i = 1; i < order.length; i++) {
      expect(
        yOf(order[i]),
        greaterThan(yOf(order[i - 1])),
        reason: '"${order[i]}" must come after "${order[i - 1]}"',
      );
    }

    // All six services and all six projects on the home page.
    expect(find.byType(ServiceCard), findsNWidgets(6));
    expect(find.byType(ProjectCard), findsNWidgets(6));
    expect(find.byType(ProjectPreview), findsNWidgets(6));

    // "Projects" everywhere, never "Portfolio".
    expect(find.text('Portfolio'), findsNothing);
    expect(find.text('Projects'), findsWidgets);
    expect(find.text('Startup Solutions'), findsWidgets);
    expect(find.text('View All Projects'), findsOneWidget);

    expect(tester.takeException(), isNull);
  });

  // ------------------------------------------------------- projects page
  testWidgets('Projects page: filters, grid and detail dialog', (tester) async {
    useSize(tester, 1440, 1800);
    await tester.pumpWidget(const GetMaterialApp(home: ProjectsPage()));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 400));
    await tester.pump(const Duration(seconds: 1));

    expect(find.text('PROJECTS'), findsOneWidget);
    expect(find.byType(ProjectFilterChip), findsNWidgets(5));
    expect(find.byType(ProjectCard), findsNWidgets(6));
    expect(find.text('Portfolio'), findsNothing);
    expect(tester.takeException(), isNull);

    // Filter → Mobile Apps shows only the two mobile projects.
    await tester.tap(
      find.descendant(
        of: find.byType(ProjectFilterChip),
        matching: find.text('Mobile Apps'),
      ),
    );
    await tester.pump(const Duration(milliseconds: 500));
    expect(find.byType(ProjectCard), findsNWidgets(2));
    expect(find.text('E-Commerce Mobile App'), findsOneWidget);
    expect(find.text('Startup SaaS Platform'), findsNothing);
    expect(tester.takeException(), isNull);

    // Back to All.
    await tester.tap(
      find.descendant(
        of: find.byType(ProjectFilterChip),
        matching: find.text('All'),
      ),
    );
    await tester.pump(const Duration(milliseconds: 500));
    expect(find.byType(ProjectCard), findsNWidgets(6));

    // Detail dialog with full case-study content + CTA.
    await tester.tap(find.text('View Details').first);
    await tester.pumpAndSettle();
    expect(find.text('TECHNOLOGIES'), findsOneWidget);
    expect(find.text('KEY FEATURES'), findsOneWidget);
    expect(find.text('THE CHALLENGE'), findsOneWidget);
    expect(find.text('OUR SOLUTION'), findsOneWidget);
    expect(find.text('THE RESULTS'), findsOneWidget);
    expect(
      find.descendant(
        of: find.byType(Dialog),
        matching: find.text('Start a Similar Project'),
      ),
      findsOneWidget,
      reason: 'detail dialog carries its own CTA (page has one too)',
    );
    expect(find.byType(ProjectPreview), findsWidgets);
    expect(tester.takeException(), isNull);
  });

  testWidgets('Projects page at 360: detail dialog preview never overflows', (
    tester,
  ) async {
    // Narrowest real dialog: 360 - 80 inset - 64 content padding → 216px
    // preview → 188px inner width for the 230px-wide phone mock design.
    // Height 3600 (not 800): AnimatedSection's SlideTransition receives
    // pixel slideOffsets but applies them as fractions of the child size,
    // so an unrevealed card is painted ~18000px below its true offset and
    // its button is not hit-testable. The tall viewport keeps card 1's
    // section box (true y ≈ 768) inside 0.92 × height, so it reveals on
    // the first frame, the slide finishes during the initial pumps, and
    // the button sits at its true, tappable position.
    useSize(tester, 360, 3600);
    await tester.pumpWidget(const GetMaterialApp(home: ProjectsPage()));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 400));
    await tester.pump(const Duration(seconds: 1));

    await tester.tap(find.text('View Details').first);
    await tester.pumpAndSettle();

    expect(find.byType(Dialog), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  // ------------------------------------------------------- contact page
  testWidgets('Contact page: no RenderFlex overflow at any breakpoint', (
    tester,
  ) async {
    // Regression (user report in the "Tell us about your project" form
    // section: "RenderFlex overflowed by 167 pixels"): the service
    // dropdown laid its widest IndexedStack item unbounded (fixed with
    // isExpanded: true), and the info-card value column was a non-flex
    // Row child (fixed with Flexible). Height 4000 so the map, socials
    // and footer slivers are laid out too, not just the form section.
    for (final w in [360.0, 768.0, 1024.0, 1440.0, 1920.0]) {
      useSize(tester, w, 4000);
      await tester.pumpWidget(const GetMaterialApp(home: ContactPage()));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 400));
      await tester.pump(const Duration(seconds: 1));

      final error = tester.takeException();
      if (error != null) {
        fail('Contact page layout error at ${w}px:\n$error');
      }
    }

    expect(find.text('Tell us about your project'), findsOneWidget);
    // Info card + footer contact column both list it.
    expect(find.text('hello@softkormo.com'), findsWidgets);
  });

  // ------------------------------------- sticky glass navbar + back to top
  testWidgets('Sticky glass navbar + Back to top button (desktop)', (
    tester,
  ) async {
    useSize(tester, 1440, 900);
    await tester.pumpWidget(const GetMaterialApp(home: HomePage()));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 400));
    await tester.pump(const Duration(seconds: 1));

    SliverAppBar bar() =>
        tester.widget<SliverAppBar>(find.byType(SliverAppBar));
    AnimatedOpacity buttonOpacity() => tester.widget<AnimatedOpacity>(
      find.descendant(
        of: find.byType(BackToTopButton),
        matching: find.byType(AnimatedOpacity),
      ),
    );
    IgnorePointer buttonIgnore() => tester.widget<IgnorePointer>(
      find.descendant(
        of: find.byType(BackToTopButton),
        matching: find.byType(IgnorePointer),
      ),
    );

    // The bar is a glass slab: a backdrop blur paints behind the toolbar.
    expect(
      find.descendant(
        of: find.byType(SliverAppBar),
        matching: find.byType(BackdropFilter),
      ),
      findsOneWidget,
    );

    // At rest: no shadow, button faded out and dead to hit-testing.
    expect(bar().elevation, 0);
    expect(buttonOpacity().opacity, 0);
    expect(buttonIgnore().ignoring, isTrue);

    // Scroll well past the 300px reveal threshold (no fling: a plain drag).
    await tester.drag(find.byType(CustomScrollView), const Offset(0, -700));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 500));

    expect(buttonOpacity().opacity, 1);
    expect(buttonIgnore().ignoring, isFalse);
    expect(bar().elevation, 6);
    // The canvas Material under the glass carries the animated shadow.
    expect(
      tester
          .widget<AnimatedPhysicalModel>(
            find
                .descendant(
                  of: find.byType(SliverAppBar),
                  matching: find.byType(AnimatedPhysicalModel),
                )
                .first,
          )
          .elevation,
      6,
    );

    // The button smooth-scrolls home; both UI bits fade back out.
    await tester.tap(find.byType(BackToTopButton));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 650));
    await tester.pump(const Duration(milliseconds: 500));

    final pixels = tester
        .state<ScrollableState>(
          find
              .descendant(
                of: find.byType(CustomScrollView),
                matching: find.byType(Scrollable),
              )
              .first,
        )
        .position
        .pixels;
    expect(pixels, closeTo(0, 1), reason: 'animateTo should land at the top');
    expect(buttonOpacity().opacity, 0);
    expect(buttonIgnore().ignoring, isTrue);
    expect(bar().elevation, 0);

    expect(tester.takeException(), isNull);
  });

  testWidgets('Navbar never squeezes while scrolling (no RenderFlex)', (
    tester,
  ) async {
    useSize(tester, 1440, 900);
    await tester.pumpWidget(const GetMaterialApp(home: HomePage()));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 400));
    await tester.pump(const Duration(seconds: 1));

    final position = tester
        .state<ScrollableState>(
          find
              .descendant(
                of: find.byType(CustomScrollView),
                matching: find.byType(Scrollable),
              )
              .first,
        )
        .position;

    // Step through the danger zone in 5px increments (a single drag jumps
    // over it): with `floating: true` + pinned + bottom, the framework
    // shrank the header child to max(1, 77 - scrollOffset), squeezing the
    // toolbar from 76px toward 0 and overflowing the nav item Column at
    // every offset in this range (reported: 8.5px at Poppins).
    for (var pixels = 5.0; pixels <= 300; pixels += 5) {
      position.jumpTo(pixels);
      await tester.pump();
      final error = tester.takeException();
      if (error != null) {
        fail('Layout error while scrolled to ${pixels}px:\n$error');
      }
    }

    // Plain pinned keeps minExtent == maxExtent: the bar never collapses.
    expect(
      tester.widget<SliverAppBar>(find.byType(SliverAppBar)).floating,
      isFalse,
    );
    expect(find.text('Contact'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}
