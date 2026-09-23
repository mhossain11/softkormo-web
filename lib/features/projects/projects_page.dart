import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../core/constants/app_colors.dart';
import '../../core/constants/app_dimensions.dart';
import '../../core/routes/app_routes.dart';
import '../../core/utils/responsive_utils.dart';
import '../../core/widgets/animated_section.dart';
import '../../core/widgets/gradient_button.dart';
import '../../core/widgets/page_scroll_shell.dart';
import '../../core/widgets/responsive_container.dart';
import '../../core/widgets/section_title.dart';
import '../../shared/widgets/custom_app_bar.dart';
import '../../shared/widgets/custom_drawer.dart';
import '../../shared/widgets/footer.dart';
import '../../shared/widgets/project_card.dart';
import '../../shared/widgets/project_filter_chip.dart';
import 'projects_controller.dart';

/// Projects page — filterable project grid with detail dialog.
class ProjectsPage extends StatefulWidget {
  const ProjectsPage({super.key});

  @override
  State<ProjectsPage> createState() => _ProjectsPageState();
}

class _ProjectsPageState extends State<ProjectsPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  late final ProjectsController _controller;

  @override
  void initState() {
    super.initState();
    _controller = Get.isRegistered<ProjectsController>()
        ? Get.find<ProjectsController>()
        : Get.put(ProjectsController());
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
                  colors: [AppColors.deepBlue, AppColors.tealGreen],
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
                          'PROJECTS',
                          style: TextStyle(
                            color: const Color(0xFFFFE08A),
                            fontWeight: FontWeight.w700,
                            letterSpacing: 2,
                            fontSize: 13,
                          ),
                        ),
                        const SizedBox(height: AppDimensions.spaceMd),
                        Text(
                          'Digital products that moved the numbers.',
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
                        Text(
                          '120+ products shipped across fintech, health, '
                          'logistics, retail and agriculture.',
                          style: Theme.of(context).textTheme.bodyLarge
                              ?.copyWith(color: Colors.white70),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),

          // ------------------------------------------------- filters + grid
          SliverToBoxAdapter(
            child: SectionWrapper(
              child: ResponsiveContainer(
                child: Column(
                  children: [
                    // ---------------------------------------- filter chips
                    Obx(
                      () => Wrap(
                        spacing: AppDimensions.spaceSm,
                        runSpacing: AppDimensions.spaceSm,
                        alignment: WrapAlignment.center,
                        children: [
                          for (final c in ProjectsController.categories)
                            ProjectFilterChip(
                              label: c,
                              selected: _controller.activeCategory.value == c,
                              onTap: () => _controller.setCategory(c),
                            ),
                        ],
                      ),
                    ),
                    const SizedBox(height: AppDimensions.space2xl),

                    // ------------------------------------------------ grid
                    Obx(() {
                      final projects = _controller.filtered;

                      if (_controller.isLoading.value) {
                        return const Padding(
                          padding: EdgeInsets.only(top: 60),
                          child: CircularProgressIndicator(),
                        );
                      }

                      if (projects.isEmpty) {
                        return Padding(
                          padding: const EdgeInsets.only(top: 40),
                          child: Column(
                            children: [
                              const Icon(
                                Icons.search_off_rounded,
                                size: 56,
                                color: AppColors.textMuted,
                              ),
                              const SizedBox(height: 16),
                              Text(
                                'No projects in this category yet.',
                                style: Theme.of(context).textTheme.bodyLarge
                                    ?.copyWith(color: AppColors.textSecondary),
                              ),
                            ],
                          ),
                        );
                      }

                      return Column(
                        children: [
                          for (var i = 0; i < projects.length; i += cols) ...[
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                for (
                                  var j = i;
                                  j < (i + cols) && j < projects.length;
                                  j++
                                )
                                  Expanded(
                                    child: AnimatedSection(
                                      delay: Duration(
                                        milliseconds: 80 * (j - i),
                                      ),
                                      slideOffset: const Offset(0, 36),
                                      child: IntrinsicHeight(
                                        child: ProjectCard(
                                          project: projects[j],
                                          onTap: () => showProjectDialog(
                                            context,
                                            projects[j],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                if (projects.length - i < cols)
                                  for (
                                    var k = 0;
                                    k < cols - (projects.length - i);
                                    k++
                                  )
                                    const Expanded(child: SizedBox()),
                              ],
                            ),
                            if (i + cols < projects.length)
                              const SizedBox(height: AppDimensions.spaceLg),
                          ],
                        ],
                      );
                    }),
                  ],
                ),
              ),
            ),
          ),

          // ---------------------------------------------------- section note
          SliverToBoxAdapter(
            child: SectionWrapper(
              verticalPadding: 72,
              backgroundColor: AppColors.surface,
              child: ResponsiveContainer(
                child: AnimatedSection(
                  alignment: Alignment.center,
                  child: Column(
                    children: [
                      const SectionTitle(
                        eyebrow: 'Case studies',
                        title: 'Want the deep dive?',
                        subtitle:
                            'Full case studies with metrics, architecture '
                            'diagrams and lessons learned are shared under NDA.',
                      ),
                      const SizedBox(height: AppDimensions.spaceLg),
                      GradientButton(
                        label: 'Start a Similar Project',
                        icon: Icons.rocket_launch_rounded,
                        onPressed: () => Get.toNamed(AppRoutes.contact),
                      ),
                    ],
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
