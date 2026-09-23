import 'package:flutter/material.dart';

import '../../core/constants/app_colors.dart';
import '../../core/constants/app_dimensions.dart';
import '../../core/utils/responsive_utils.dart';
import '../../core/widgets/animated_section.dart';
import '../../core/widgets/page_scroll_shell.dart';
import '../../core/widgets/responsive_container.dart';
import '../../core/widgets/section_title.dart';
import '../../shared/widgets/custom_app_bar.dart';
import '../../shared/widgets/custom_drawer.dart';
import '../../shared/widgets/footer.dart';
import '../../shared/widgets/technology_stack_section.dart';

/// About page — story, mission, vision, values, why-softkormo and stack.
class AboutPage extends StatefulWidget {
  const AboutPage({super.key});

  @override
  State<AboutPage> createState() => _AboutPageState();
}

class _AboutPageState extends State<AboutPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

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

          // ------------------------------------------------------ page hero
          SliverToBoxAdapter(
            child: Container(
              decoration: const BoxDecoration(gradient: AppColors.heroGradient),
              padding: EdgeInsets.symmetric(
                vertical: Responsive.get(
                  context,
                  mobile: 56.0,
                  tablet: 72.0,
                  desktop: 96.0,
                ),
                horizontal: 24,
              ),
              child: Center(
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    maxWidth: Responsive.contentMaxWidth(context),
                  ),
                  child: AnimatedSection(
                    slideOffset: const Offset(0, 30),
                    alignment: Alignment.centerLeft,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'ABOUT SOFTKORMO',
                          style: TextStyle(
                            color: AppColors.tealGreen,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 2,
                            fontSize: 13,
                          ),
                        ),
                        const SizedBox(height: AppDimensions.spaceMd),
                        Text(
                          'We turn ambitious ideas into software that lasts.',
                          style: Theme.of(context).textTheme.displayMedium
                              ?.copyWith(
                                color: Colors.white,
                                fontSize: Responsive.get(
                                  context,
                                  mobile: 32,
                                  tablet: 44,
                                  desktop: 56,
                                ),
                              ),
                        ),
                        const SizedBox(height: AppDimensions.spaceMd),
                        ConstrainedBox(
                          constraints: const BoxConstraints(maxWidth: 640),
                          child: Text(
                            'Founded by engineers who got tired of watching good '
                            'products die from bad execution — SoftKormo exists to '
                            'ship software the right way, on time, every time.',
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

          // ---------------------------------------------------- story + stats
          SliverToBoxAdapter(
            child: SectionWrapper(
              child: ResponsiveContainer(
                child: isWide
                    ? const Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(flex: 6, child: _StoryBlock()),
                          SizedBox(width: AppDimensions.space3xl),
                          Expanded(flex: 5, child: _MissionVisionColumn()),
                        ],
                      )
                    : const Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          _StoryBlock(),
                          SizedBox(height: AppDimensions.space2xl),
                          _MissionVisionColumn(),
                        ],
                      ),
              ),
            ),
          ),

          // ------------------------------------------------------ core values
          SliverToBoxAdapter(
            child: SectionWrapper(
              backgroundColor: AppColors.surface,
              child: ResponsiveContainer(
                child: Column(
                  children: [
                    const SectionTitle(
                      eyebrow: 'Core values',
                      title: 'What we stand for',
                      subtitle:
                          'Five principles we hire by, estimate by and '
                          'challenge ourselves against.',
                    ),
                    const SizedBox(height: AppDimensions.space2xl),
                    const _ValuesGrid(),
                  ],
                ),
              ),
            ),
          ),

          // ------------------------------------------------------ why + stack
          SliverToBoxAdapter(
            child: SectionWrapper(
              child: ResponsiveContainer(
                child: Column(
                  children: [
                    const SectionTitle(
                      eyebrow: 'Why SoftKormo',
                      title: 'The difference is in the process',
                      subtitle:
                          'Great software is a habit, not an accident. Here is '
                          'how we keep the habit.',
                    ),
                    const SizedBox(height: AppDimensions.space2xl),
                    const _WhyList(),
                    const SizedBox(height: AppDimensions.space3xl),
                    const TechnologyStackSection(showTitle: false),
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

class _StoryBlock extends StatelessWidget {
  const _StoryBlock();

  @override
  Widget build(BuildContext context) {
    return AnimatedSection(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SectionTitle(
            eyebrow: 'Our story',
            title: 'From two laptops to a full product studio',
            align: TextAlign.start,
            showAnimation: false,
          ),
          const SizedBox(height: AppDimensions.spaceLg),
          Text(
            'SoftKormo started in 2017 when two engineers — one backend '
            'architect, one mobile developer — watched a promising startup '
            'burn six months and its entire seed round on an agency that '
            'delivered slides instead of software.\n\n'
            'They made a promise: build a company where clients see working '
            'product every single week. No surprise invoices. No junior teams '
            'billed as seniors. No hand-offs into a black box.\n\n'
            'Nine years later that promise still runs the company. We are 45+ '
            'engineers, designers and data specialists who have shipped 120+ '
            'products across fintech, health, logistics and retail — and we '
            'still demo working software every Friday.',
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              color: AppColors.textSecondary,
              height: 1.8,
            ),
          ),
          const SizedBox(height: AppDimensions.space2xl),
          const Wrap(
            spacing: AppDimensions.spaceLg,
            runSpacing: AppDimensions.spaceMd,
            children: [
              _StatChip(value: '2017', label: 'Founded'),
              _StatChip(value: '120+', label: 'Products Shipped'),
              _StatChip(value: '45+', label: 'Specialists'),
              _StatChip(value: '11', label: 'Countries Served'),
            ],
          ),
        ],
      ),
    );
  }
}

class _StatChip extends StatelessWidget {
  const _StatChip({required this.value, required this.label});

  final String value;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
        border: Border.all(color: AppColors.border),
        boxShadow: const [BoxShadow(color: Color(0x0A0B3C88), blurRadius: 14)],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            value,
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              color: AppColors.deepBlue,
              fontWeight: FontWeight.w800,
            ),
          ),
          Text(label, style: Theme.of(context).textTheme.labelSmall),
        ],
      ),
    );
  }
}

class _MissionVisionColumn extends StatelessWidget {
  const _MissionVisionColumn();

  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        _Panel(
          icon: Icons.flag_rounded,
          accent: AppColors.tealGreen,
          title: 'Mission',
          body:
              'Deliver smart, reliable software that moves our clients’ '
              'businesses forward — on time, secure and ready to scale.',
        ),
        SizedBox(height: AppDimensions.spaceLg),
        _Panel(
          icon: Icons.visibility_rounded,
          accent: AppColors.purple,
          title: 'Vision',
          body:
              'To be the most trusted software partner for founders and '
              'enterprises — known for craft, honesty and outcomes.',
        ),
      ],
    );
  }
}

class _Panel extends StatelessWidget {
  const _Panel({
    required this.icon,
    required this.accent,
    required this.title,
    required this.body,
  });

  final IconData icon;
  final Color accent;
  final String title;
  final String body;

  @override
  Widget build(BuildContext context) {
    return AnimatedSection(
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(AppDimensions.spaceXl),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [accent.withValues(alpha: 0.10), Colors.white],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(AppDimensions.radiusLg),
          border: Border.all(color: accent.withValues(alpha: 0.35)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 46,
              height: 46,
              decoration: BoxDecoration(
                color: accent,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: Colors.white, size: 24),
            ),
            const SizedBox(height: AppDimensions.spaceMd),
            Text(
              title,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                color: accent,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              body,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: AppColors.textSecondary,
                height: 1.7,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ValuesGrid extends StatelessWidget {
  const _ValuesGrid();

  static const _values = [
    (
      Icons.bolt_rounded,
      AppColors.orange,
      'Ship Weekly',
      'Working software every week beats perfect plans never built.',
    ),
    (
      Icons.fact_check_rounded,
      AppColors.deepBlue,
      'Radical Honesty',
      'If a deadline is fantasy or a feature is wrong, you hear it from us first.',
    ),
    (
      Icons.lock_rounded,
      AppColors.purple,
      'Secure by Default',
      'Auth, rules, encryption and audits are part of the definition of done.',
    ),
    (
      Icons.group_rounded,
      AppColors.tealGreen,
      'Own the Outcome',
      'We are measured by your business result, not hours billed.',
    ),
    (
      Icons.auto_awesome_rounded,
      AppColors.magenta,
      'Craft Matters',
      'Typography, motion and details are engineering, not decoration.',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final cols = Responsive.get(context, mobile: 1, tablet: 2, desktop: 3);

    return Column(
      children: [
        for (var i = 0; i < _values.length; i += cols) ...[
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              for (var j = i; j < (i + cols) && j < _values.length; j++)
                Expanded(
                  child: AnimatedSection(
                    delay: Duration(milliseconds: 80 * (j - i)),
                    child: _ValueTile(v: _values[j]),
                  ),
                ),
              if (_values.length - i < cols)
                for (var k = 0; k < cols - (_values.length - i); k++)
                  const Expanded(child: SizedBox()),
            ],
          ),
          if (i + cols < _values.length)
            const SizedBox(height: AppDimensions.spaceMd),
        ],
      ],
    );
  }
}

class _ValueTile extends StatelessWidget {
  const _ValueTile({required this.v});

  final (IconData, Color, String, String) v;

  @override
  Widget build(BuildContext context) {
    final (icon, color, title, body) = v;

    return Container(
      margin: const EdgeInsets.all(5),
      padding: const EdgeInsets.all(AppDimensions.spaceLg),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppDimensions.radiusLg),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color, size: 30),
          const SizedBox(height: AppDimensions.spaceMd),
          Text(
            title,
            style: Theme.of(
              context,
            ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 6),
          Text(
            body,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: AppColors.textSecondary,
              height: 1.65,
            ),
          ),
        ],
      ),
    );
  }
}

class _WhyList extends StatelessWidget {
  const _WhyList();

  static const _items = [
    (
      '01',
      'Weekly demo cadence',
      'Every Friday you see running software — not status reports.',
    ),
    (
      '02',
      'Senior-only delivery teams',
      'The engineers in your kickoff call are the engineers writing your code.',
    ),
    (
      '03',
      'Fixed, transparent pricing',
      'Scoped before we start. Change requests are quoted before any work begins.',
    ),
    (
      '04',
      'Security in the definition of done',
      'Rules, tests and monitoring ship with v1, never as a later phase.',
    ),
    (
      '05',
      'You own everything',
      'Code, infrastructure and accounts are yours from day one. No lock-in.',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        for (var i = 0; i < _items.length; i++)
          AnimatedSection(
            delay: Duration(milliseconds: 70 * i),
            child: Builder(
              builder: (context) {
                final (num, title, body) = _items[i];
                return Container(
                  margin: const EdgeInsets.only(bottom: AppDimensions.spaceMd),
                  padding: const EdgeInsets.all(AppDimensions.spaceLg),
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
                    border: Border.all(color: AppColors.border),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        num,
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          color: AppColors.tealGreen,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      const SizedBox(width: AppDimensions.spaceLg),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              title,
                              style: Theme.of(context).textTheme.titleMedium
                                  ?.copyWith(fontWeight: FontWeight.w700),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              body,
                              style: Theme.of(context).textTheme.bodySmall
                                  ?.copyWith(
                                    color: AppColors.textSecondary,
                                    height: 1.6,
                                  ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
      ],
    );
  }
}
