import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../core/constants/app_colors.dart';
import '../../core/constants/app_dimensions.dart';
import '../../core/routes/app_routes.dart';
import '../../core/services/firebase_service.dart';
import '../../core/utils/responsive_utils.dart';
import '../../core/widgets/animated_section.dart';
import '../../core/widgets/gradient_button.dart';
import '../../core/widgets/page_scroll_shell.dart';
import '../../core/widgets/responsive_container.dart';
import '../../shared/models/service_model.dart';
import '../../shared/widgets/custom_app_bar.dart';
import '../../shared/widgets/custom_drawer.dart';
import '../../shared/widgets/footer.dart';
import '../../shared/widgets/how_we_work_section.dart';
import '../../shared/widgets/service_card.dart';

/// Services page — full service cards grid + process + CTA.
class ServicesPage extends StatefulWidget {
  const ServicesPage({super.key});

  @override
  State<ServicesPage> createState() => _ServicesPageState();
}

class _ServicesPageState extends State<ServicesPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  String _filter = 'All';

  static const _filters = [
    'All',
    'Mobile & Web',
    'Backend & APIs',
    'Data & BI',
    'Startup & Support',
  ];

  List<ServiceModel> get _visible {
    if (_filter == 'All') return ServiceModel.seed;
    switch (_filter) {
      case 'Mobile & Web':
        return ServiceModel.seed
            .where((s) => s.title.contains('Mobile') || s.title.contains('Web'))
            .toList();
      case 'Backend & APIs':
        return ServiceModel.seed
            .where(
              (s) => s.title.contains('Backend') || s.title.contains('API'),
            )
            .toList();
      case 'Data & BI':
        return ServiceModel.seed
            .where((s) => s.title.contains('Data'))
            .toList();
      default:
        return ServiceModel.seed
            .where(
              (s) =>
                  s.title.contains('Startup') ||
                  s.title.contains('Firebase') ||
                  s.title.contains('Maintenance'),
            )
            .toList();
    }
  }

  @override
  void initState() {
    super.initState();
    FirebaseService.logScreenView('services');
  }

  @override
  Widget build(BuildContext context) {
    final cols = Responsive.get(context, mobile: 1, tablet: 2, desktop: 3);

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

          // --------------------------------------------------------- hero
          SliverToBoxAdapter(
            child: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [AppColors.deepBlue, AppColors.purple],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              padding: EdgeInsets.symmetric(
                vertical: Responsive.get(
                  context,
                  mobile: 52.0,
                  tablet: 70.0,
                  desktop: 92.0,
                ),
                horizontal: 24,
              ),
              child: Center(
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    maxWidth: Responsive.contentMaxWidth(context),
                  ),
                  child: AnimatedSection(
                    alignment: Alignment.centerLeft,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'SERVICES',
                          style: TextStyle(
                            color: AppColors.tealGreen,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 2,
                            fontSize: 13,
                          ),
                        ),
                        const SizedBox(height: AppDimensions.spaceMd),
                        Text(
                          'Everything you need to build, launch and scale.',
                          style: Theme.of(context).textTheme.displayMedium
                              ?.copyWith(
                                color: Colors.white,
                                fontSize: Responsive.get(
                                  context,
                                  mobile: 30,
                                  tablet: 42,
                                  desktop: 54,
                                ),
                              ),
                        ),
                        const SizedBox(height: AppDimensions.spaceMd),
                        ConstrainedBox(
                          constraints: const BoxConstraints(maxWidth: 640),
                          child: Text(
                            'Six service lines, one accountable team. Pick a '
                            'single service or hand us the whole product.',
                            style: Theme.of(context).textTheme.bodyLarge
                                ?.copyWith(color: Colors.white70),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),

          // -------------------------------------------------------- filters
          SliverToBoxAdapter(
            child: SectionWrapper(
              verticalPadding: 56,
              child: ResponsiveContainer(
                child: Column(
                  children: [
                    Wrap(
                      spacing: AppDimensions.spaceSm,
                      runSpacing: AppDimensions.spaceSm,
                      alignment: WrapAlignment.center,
                      children: [
                        for (final f in _filters)
                          AnimatedContainer(
                            duration: AppDimensions.fast,
                            child: FilterChip(
                              label: Text(f),
                              selected: _filter == f,
                              onSelected: (_) => setState(() => _filter = f),
                              selectedColor: AppColors.deepBlue,
                              checkmarkColor: Colors.white,
                              labelStyle: TextStyle(
                                fontWeight: _filter == f
                                    ? FontWeight.w700
                                    : FontWeight.w500,
                                color: _filter == f
                                    ? Colors.white
                                    : AppColors.textSecondary,
                              ),
                              backgroundColor: AppColors.surface,
                              side: BorderSide(
                                color: _filter == f
                                    ? AppColors.deepBlue
                                    : AppColors.border,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(
                                  AppDimensions.radiusPill,
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: AppDimensions.space2xl),

                    // ------------------------------------------------ grid
                    AnimatedSwitcher(
                      duration: AppDimensions.normal,
                      switchInCurve: Curves.easeOutCubic,
                      child: Column(
                        key: ValueKey(_filter),
                        children: [
                          for (var i = 0; i < _visible.length; i += cols) ...[
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                for (
                                  var j = i;
                                  j < (i + cols) && j < _visible.length;
                                  j++
                                )
                                  Expanded(
                                    child: AnimatedSection(
                                      delay: Duration(
                                        milliseconds: 80 * (j - i),
                                      ),
                                      child: IntrinsicHeight(
                                        child: ServiceCard(
                                          service: _visible[j],
                                          index: j + 1,
                                          onTap: () =>
                                              Get.toNamed(AppRoutes.contact),
                                        ),
                                      ),
                                    ),
                                  ),
                                if (_visible.length - i < cols)
                                  for (
                                    var k = 0;
                                    k < cols - (_visible.length - i);
                                    k++
                                  )
                                    const Expanded(child: SizedBox()),
                              ],
                            ),
                            if (i + cols < _visible.length)
                              const SizedBox(height: AppDimensions.spaceLg),
                          ],
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // -------------------------------------------------------- process
          const SliverToBoxAdapter(child: HowWeWorkSection()),

          // ----------------------------------------------------------- CTA
          SliverToBoxAdapter(
            child: SectionWrapper(
              verticalPadding: 72,
              child: ResponsiveContainer(
                child: AnimatedSection(
                  alignment: Alignment.center,
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(AppDimensions.space2xl),
                    decoration: BoxDecoration(
                      gradient: AppColors.heroGradient,
                      borderRadius: BorderRadius.circular(
                        AppDimensions.radiusXl,
                      ),
                    ),
                    child: Column(
                      children: [
                        Text(
                          'Not sure which service you need?',
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.headlineSmall
                              ?.copyWith(color: Colors.white),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          'Book a free consultation — we will recommend the '
                          'smallest build that proves your idea.',
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.bodyMedium
                              ?.copyWith(color: Colors.white70),
                        ),
                        const SizedBox(height: AppDimensions.spaceLg),
                        GradientButton(
                          label: 'Get Free Consultation',
                          icon: Icons.chat_bubble_rounded,
                          gradient: const LinearGradient(
                            colors: [AppColors.tealGreen, Color(0xFF00D3A7)],
                          ),
                          onPressed: () => Get.toNamed(AppRoutes.contact),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),

          const SliverToBoxAdapter(child: Footer()),
        ],
      ),
    );
  }
}
