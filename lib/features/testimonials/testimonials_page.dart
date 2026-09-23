import 'package:flutter/material.dart';

import '../../core/constants/app_colors.dart';
import '../../core/constants/app_dimensions.dart';
import '../../core/services/firebase_service.dart';
import '../../core/utils/responsive_utils.dart';
import '../../core/widgets/animated_section.dart';
import '../../core/widgets/page_scroll_shell.dart';
import '../../core/widgets/responsive_container.dart';
import '../../core/widgets/section_title.dart';
import '../../shared/models/testimonial_model.dart';
import '../../shared/widgets/custom_app_bar.dart';
import '../../shared/widgets/custom_drawer.dart';
import '../../shared/widgets/footer.dart';
import '../../shared/widgets/testimonial_card.dart';

/// Testimonials page — rating summary + animated card wall.
class TestimonialsPage extends StatefulWidget {
  const TestimonialsPage({super.key});

  @override
  State<TestimonialsPage> createState() => _TestimonialsPageState();
}

class _TestimonialsPageState extends State<TestimonialsPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    FirebaseService.logScreenView('testimonials');
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
                  colors: [Color(0xFF071E45), AppColors.purple],
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
                          'TESTIMONIALS',
                          style: TextStyle(
                            color: AppColors.tealGreen,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 2,
                            fontSize: 13,
                          ),
                        ),
                        const SizedBox(height: AppDimensions.spaceMd),
                        Text(
                          'Don’t take our word for it.',
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
                        const SizedBox(height: AppDimensions.spaceLg),
                        const _RatingSummary(),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),

          // ------------------------------------------------- card wall
          SliverToBoxAdapter(
            child: SectionWrapper(
              backgroundColor: AppColors.surface,
              child: ResponsiveContainer(
                child: Column(
                  children: [
                    const SectionTitle(
                      eyebrow: 'Client stories',
                      title: 'What founders and CTOs say',
                      subtitle:
                          'Feedback from teams we have built with — launches, '
                          'scale-ups and long-term partnerships.',
                    ),
                    const SizedBox(height: AppDimensions.space2xl),
                    if (isWide)
                      _staggeredWall()
                    else
                      Column(
                        children: [
                          for (var i = 0; i < TestimonialModel.seed.length; i++)
                            AnimatedSection(
                              delay: Duration(milliseconds: 70 * i),
                              slideOffset: const Offset(0, 36),
                              child: SizedBox(
                                width: double.infinity,
                                height: 360,
                                child: TestimonialCard(
                                  testimonial: TestimonialModel.seed[i],
                                ),
                              ),
                            ),
                        ],
                      ),
                  ],
                ),
              ),
            ),
          ),

          // ------------------------------------------------------ numbers
          SliverToBoxAdapter(
            child: SectionWrapper(
              child: ResponsiveContainer(
                child: AnimatedSection(
                  alignment: Alignment.center,
                  child: Wrap(
                    spacing: AppDimensions.spaceLg,
                    runSpacing: AppDimensions.spaceLg,
                    alignment: WrapAlignment.center,
                    children: const [
                      _Metric(value: '4.9/5', label: 'Average rating'),
                      _Metric(value: '98%', label: 'Would recommend us'),
                      _Metric(value: '120+', label: 'Happy clients'),
                      _Metric(value: '6 yrs', label: 'Longest partnership'),
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

  /// Two-column wall with alternating offsets for a lively, modern rhythm.
  Widget _staggeredWall() {
    final items = TestimonialModel.seed;
    final left = <int>[];
    final right = <int>[];
    for (var i = 0; i < items.length; i++) {
      (i.isEven ? left : right).add(i);
    }

    Widget column(List<int> indices, double offset) => Transform.translate(
      offset: Offset(0, offset),
      child: Column(
        children: [
          for (final i in indices)
            AnimatedSection(
              delay: Duration(milliseconds: 80 * i),
              slideOffset: const Offset(0, 40),
              child: SizedBox(
                width: double.infinity,
                height: 360,
                child: TestimonialCard(testimonial: items[i]),
              ),
            ),
        ],
      ),
    );

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(child: column(left, 0)),
        const SizedBox(width: AppDimensions.spaceLg),
        Expanded(child: column(right, 48)),
      ],
    );
  }
}

class _RatingSummary extends StatelessWidget {
  const _RatingSummary();

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: AppDimensions.spaceLg,
      runSpacing: AppDimensions.spaceMd,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            for (var i = 0; i < 5; i++)
              const Padding(
                padding: EdgeInsets.only(right: 4),
                child: Icon(
                  Icons.star_rounded,
                  color: AppColors.orange,
                  size: 26,
                ),
              ),
            const SizedBox(width: 8),
            const Text(
              '4.9',
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.w800,
              ),
            ),
          ],
        ),
        Text(
          'Based on 86 verified client reviews',
          style: Theme.of(
            context,
          ).textTheme.bodyMedium?.copyWith(color: Colors.white70),
        ),
      ],
    );
  }
}

class _Metric extends StatelessWidget {
  const _Metric({required this.value, required this.label});

  final String value;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 190,
      padding: const EdgeInsets.all(AppDimensions.spaceLg),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppDimensions.radiusLg),
        border: Border.all(color: AppColors.border),
        boxShadow: const [BoxShadow(color: Color(0x0F0B3C88), blurRadius: 18)],
      ),
      child: Column(
        children: [
          Text(
            value,
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
              color: AppColors.deepBlue,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            textAlign: TextAlign.center,
            style: Theme.of(
              context,
            ).textTheme.bodySmall?.copyWith(color: AppColors.textSecondary),
          ),
        ],
      ),
    );
  }
}
