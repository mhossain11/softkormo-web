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
import '../../core/widgets/section_title.dart';
import '../../shared/models/package_model.dart';
import '../../shared/widgets/custom_app_bar.dart';
import '../../shared/widgets/custom_drawer.dart';
import '../../shared/widgets/footer.dart';
import '../../shared/widgets/pricing_card.dart';

/// Startup Package page — pricing cards + full comparison table + FAQ.
class StartupPackagePage extends StatefulWidget {
  const StartupPackagePage({super.key});

  @override
  State<StartupPackagePage> createState() => _StartupPackagePageState();
}

class _StartupPackagePageState extends State<StartupPackagePage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    FirebaseService.logScreenView('startup_package');
  }

  @override
  Widget build(BuildContext context) {
    final isWide = MediaQuery.sizeOf(context).width >= 1024;

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
                  colors: [AppColors.purple, AppColors.magenta],
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
                          'STARTUP PACKAGE SOLUTIONS',
                          style: TextStyle(
                            color: const Color(0xFFFFE08A),
                            fontWeight: FontWeight.w700,
                            letterSpacing: 2,
                            fontSize: 13,
                          ),
                        ),
                        const SizedBox(height: AppDimensions.spaceMd),
                        Text(
                          'From idea to launched product — in weeks.',
                          style: Theme.of(context).textTheme.displayMedium
                              ?.copyWith(
                                color: Colors.white,
                                fontSize: Responsive.get(
                                  context,
                                  mobile: 30,
                                  tablet: 42,
                                  desktop: 52,
                                ),
                              ),
                        ),
                        const SizedBox(height: AppDimensions.spaceMd),
                        ConstrainedBox(
                          constraints: const BoxConstraints(maxWidth: 640),
                          child: Text(
                            'Fixed scope, fixed price, weekly demos. Choose the '
                            'package that matches your stage.',
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

          // -------------------------------------------------------- pricing
          SliverToBoxAdapter(
            child: SectionWrapper(
              child: ResponsiveContainer(
                child: Column(
                  children: [
                    const SectionTitle(
                      eyebrow: 'Pricing',
                      title: 'Three packages, zero surprises',
                      subtitle:
                          'Every package includes deployment, analytics, source '
                          'code handover and post-launch support.',
                    ),
                    const SizedBox(height: AppDimensions.space3xl),
                    if (isWide)
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          for (final pkg in PackageModel.seed) ...[
                            Expanded(
                              child: AnimatedSection(
                                delay: Duration(
                                  milliseconds:
                                      100 * PackageModel.seed.indexOf(pkg),
                                ),
                                slideOffset: const Offset(0, 44),
                                child: SizedBox(
                                  height: 720,
                                  child: PricingCard(
                                    package: pkg,
                                    onSelect: () =>
                                        Get.toNamed(AppRoutes.contact),
                                  ),
                                ),
                              ),
                            ),
                            if (pkg != PackageModel.seed.last)
                              const SizedBox(width: AppDimensions.spaceLg),
                          ],
                        ],
                      )
                    else
                      for (final pkg in PackageModel.seed) ...[
                        SizedBox(
                          height: 660,
                          child: PricingCard(
                            package: pkg,
                            onSelect: () => Get.toNamed(AppRoutes.contact),
                          ),
                        ),
                        const SizedBox(height: AppDimensions.spaceLg),
                      ],
                  ],
                ),
              ),
            ),
          ),

          // --------------------------------------------- comparison table
          SliverToBoxAdapter(
            child: SectionWrapper(
              backgroundColor: AppColors.surface,
              child: ResponsiveContainer(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SectionTitle(
                      eyebrow: 'Compare',
                      title: 'Full feature comparison',
                      align: TextAlign.start,
                    ),
                    const SizedBox(height: AppDimensions.space2xl),
                    const _ComparisonTable(),
                  ],
                ),
              ),
            ),
          ),

          // ----------------------------------------------------------- FAQ
          SliverToBoxAdapter(
            child: SectionWrapper(
              child: ResponsiveContainer(
                child: Column(
                  children: [
                    const SectionTitle(
                      eyebrow: 'FAQ',
                      title: 'Questions founders ask us',
                    ),
                    const SizedBox(height: AppDimensions.space2xl),
                    const _FaqList(),
                    const SizedBox(height: AppDimensions.space2xl),
                    GradientButton(
                      label: 'Discuss Your Package',
                      icon: Icons.forum_rounded,
                      onPressed: () => Get.toNamed(AppRoutes.contact),
                    ),
                  ],
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

class _ComparisonTable extends StatelessWidget {
  const _ComparisonTable();

  @override
  Widget build(BuildContext context) {
    final rows = PackageModel.comparisonRows;

    TableRow buildRow(
      List<String> cells, {
      bool isHeader = false,
      bool alt = false,
    }) {
      final bg = isHeader
          ? AppColors.deepBlue
          : alt
          ? const Color(0xFFF7F9FF)
          : Colors.transparent;

      return TableRow(
        decoration: BoxDecoration(color: bg),
        children: [
          for (var i = 0; i < cells.length; i++)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
              alignment: i == 0 ? Alignment.centerLeft : Alignment.center,
              child: Text(
                cells[i],
                textAlign: i == 0 ? TextAlign.left : TextAlign.center,
                style: TextStyle(
                  fontSize: 13.5,
                  fontWeight: isHeader || i == 0
                      ? FontWeight.w700
                      : FontWeight.w500,
                  color: isHeader
                      ? Colors.white
                      : cells[i] == '—'
                      ? AppColors.textMuted
                      : cells[i] == '✓'
                      ? AppColors.tealGreen
                      : AppColors.textPrimary,
                ),
              ),
            ),
        ],
      );
    }

    return Container(
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppDimensions.radiusLg),
        border: Border.all(color: AppColors.border),
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: ConstrainedBox(
          constraints: const BoxConstraints(minWidth: 640),
          child: Table(
            defaultVerticalAlignment: TableCellVerticalAlignment.middle,
            columnWidths: const {
              0: FlexColumnWidth(3.0),
              1: FlexColumnWidth(1.3),
              2: FlexColumnWidth(1.3),
              3: FlexColumnWidth(1.5),
            },
            children: [
              buildRow(const [
                'Feature',
                'Starter',
                'Growth',
                'Enterprise',
              ], isHeader: true),
              for (var i = 0; i < rows.length; i++)
                buildRow(rows[i], alt: i.isEven),
            ],
          ),
        ),
      ),
    );
  }
}

class _FaqList extends StatelessWidget {
  const _FaqList();

  static const _faqs = [
    (
      'What if my scope changes mid-package?',
      'Small changes are absorbed within your revision rounds. Larger scope '
          'changes get a written quote before any work starts — you always '
          'approve price before we touch the plan.',
    ),
    (
      'Who owns the code and accounts?',
      'You do, from day one. Repositories, Firebase projects and store '
          'accounts are created under your organization and handed over as '
          'part of delivery.',
    ),
    (
      'Can you work with my in-house team?',
      'Yes. We regularly embed with internal teams — shared Slack, your '
          'rituals, your definition of done.',
    ),
    (
      'What happens after launch?',
      'Every package includes post-launch support. After that, most clients '
          'move onto a maintenance retainer with SLA response times.',
    ),
    (
      'Do you sign NDAs?',
      'Always available on request — usually before the first discovery call.',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        for (var i = 0; i < _faqs.length; i++)
          AnimatedSection(
            delay: Duration(milliseconds: 60 * i),
            child: _FaqTile(q: _faqs[i].$1, a: _faqs[i].$2),
          ),
      ],
    );
  }
}

class _FaqTile extends StatelessWidget {
  const _FaqTile({required this.q, required this.a});

  final String q;
  final String a;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: AppDimensions.spaceMd),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
        border: Border.all(color: AppColors.border),
      ),
      child: Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          shape: const Border(),
          collapsedShape: const Border(),
          tilePadding: const EdgeInsets.symmetric(
            horizontal: AppDimensions.spaceLg,
          ),
          childrenPadding: const EdgeInsets.fromLTRB(
            AppDimensions.spaceLg,
            0,
            AppDimensions.spaceLg,
            AppDimensions.spaceLg,
          ),
          iconColor: AppColors.deepBlue,
          collapsedIconColor: AppColors.textSecondary,
          title: Text(
            q,
            style: Theme.of(
              context,
            ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
          ),
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                a,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppColors.textSecondary,
                  height: 1.7,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
