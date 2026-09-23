import 'package:flutter/material.dart';

import '../../core/services/firebase_service.dart';
import '../../core/utils/responsive_utils.dart';
import '../../core/widgets/page_scroll_shell.dart';
import '../../shared/widgets/custom_app_bar.dart';
import '../../shared/widgets/custom_drawer.dart';
import '../../shared/widgets/footer.dart';
import '../../shared/widgets/how_we_work_section.dart';
import '../../shared/widgets/technology_stack_section.dart';
import 'sections/hero_section.dart';
import 'sections/home_sections.dart';
import 'sections/services_preview_section.dart';

/// Home page — hero (with stats), services ("OUR SERVICES"), featured
/// projects, why-us, technology stack, startup solutions, how we work,
/// testimonials, CTA and footer.
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    FirebaseService.logScreenView('home');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      endDrawer: Responsive.useDesktopNav(context)
          ? null
          : const CustomDrawer(),
      body: PageScrollShell(
        slivers: [
          CustomAppBar(
            onMenuPressed: () => _scaffoldKey.currentState?.openEndDrawer(),
          ),
          const SliverToBoxAdapter(child: HeroSection()),
          const SliverToBoxAdapter(child: ServicesPreviewSection()),
          const SliverToBoxAdapter(child: FeaturedProjectsSection()),
          const SliverToBoxAdapter(child: WhyChooseSection()),
          const SliverToBoxAdapter(child: TechnologyStackSection()),
          const SliverToBoxAdapter(child: PackagesPreviewSection()),
          const SliverToBoxAdapter(child: HowWeWorkSection()),
          const SliverToBoxAdapter(child: TestimonialsPreviewSection()),
          const SliverToBoxAdapter(child: CtaSection()),
          const SliverToBoxAdapter(child: Footer()),
        ],
      ),
    );
  }
}
