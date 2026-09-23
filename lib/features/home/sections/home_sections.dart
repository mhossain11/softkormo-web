import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_dimensions.dart';
import '../../../core/routes/app_routes.dart';
import '../../../core/utils/responsive_utils.dart';
import '../../../core/widgets/animated_section.dart';
import '../../../core/widgets/gradient_button.dart';
import '../../../core/widgets/responsive_container.dart';
import '../../../core/widgets/section_title.dart';
import '../../../shared/models/package_model.dart';
import '../../../shared/models/project_model.dart';
import '../../../shared/models/testimonial_model.dart';
import '../../../shared/widgets/pricing_card.dart';
import '../../../shared/widgets/project_card.dart';
import '../../../shared/widgets/testimonial_card.dart';

/// Featured projects grid (home preview) — all six showcase projects
/// plus a "View All Projects →" button.
class FeaturedProjectsSection extends StatelessWidget {
  const FeaturedProjectsSection({super.key});

  @override
  Widget build(BuildContext context) {
    final featured = ProjectModel.seed
        .where((p) => p.featured)
        .take(6)
        .toList();
    final cols = Responsive.get(
      context,
      mobile: 1,
      tablet: 2,
      laptop: 3,
      desktop: 3,
    );

    return SectionWrapper(
      backgroundColor: AppColors.backgroundDark,
      clip: true,
      child: Stack(
        children: [
          Positioned(
            top: -120,
            right: -80,
            child: Container(
              width: 340,
              height: 340,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    AppColors.purple.withValues(alpha: 0.35),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),
          ResponsiveContainer(
            child: Column(
              children: [
                const SectionTitle(
                  eyebrow: 'Our work',
                  title: 'Featured Projects',
                  subtitle:
                      'Explore some of the digital products and solutions we '
                      'build.',
                  light: true,
                ),
                const SizedBox(height: AppDimensions.space2xl),
                for (var i = 0; i < featured.length; i += cols) ...[
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      for (
                        var j = i;
                        j < (i + cols) && j < featured.length;
                        j++
                      )
                        Expanded(
                          child: AnimatedSection(
                            delay: Duration(milliseconds: 80 * (j - i)),
                            slideOffset: const Offset(0, 40),
                            child: IntrinsicHeight(
                              child: ProjectCard(
                                project: featured[j],
                                onTap: () =>
                                    showProjectDialog(context, featured[j]),
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                  if (i + cols < featured.length)
                    const SizedBox(height: AppDimensions.spaceLg),
                ],
                const SizedBox(height: AppDimensions.space2xl),
                GradientButton(
                  label: 'View All Projects',
                  icon: Icons.arrow_forward_rounded,
                  gradient: const LinearGradient(
                    colors: [AppColors.tealGreen, Color(0xFF00D3A7)],
                  ),
                  onPressed: () => Get.toNamed(AppRoutes.projects),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Startup package pricing preview (3 cards).
class PackagesPreviewSection extends StatelessWidget {
  const PackagesPreviewSection({super.key});

  @override
  Widget build(BuildContext context) {
    final isWide = MediaQuery.sizeOf(context).width >= 1024;

    return SectionWrapper(
      background: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFFF6F9FF), Color(0xFFEDF3FF)],
        ),
      ),
      child: ResponsiveContainer(
        child: Column(
          children: [
            const SectionTitle(
              eyebrow: 'Startup packages',
              title: 'Transparent pricing, fixed scope',
              subtitle:
                  'Launch a production-ready product in weeks. Every package '
                  'includes deployment, analytics and post-launch support.',
            ),
            const SizedBox(height: AppDimensions.space3xl),
            if (isWide)
              // Equal-height cards from real content (no fixed 700px box):
              // IntrinsicHeight measures the tallest card, stretch shares it.
              IntrinsicHeight(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    for (final pkg in PackageModel.seed) ...[
                      Expanded(
                        child: AnimatedSection(
                          delay: Duration(
                            milliseconds: 100 * PackageModel.seed.indexOf(pkg),
                          ),
                          slideOffset: const Offset(0, 44),
                          child: PricingCard(
                            package: pkg,
                            onSelect: () =>
                                Get.toNamed(AppRoutes.startupPackage),
                          ),
                        ),
                      ),
                      if (pkg != PackageModel.seed.last)
                        const SizedBox(width: AppDimensions.spaceLg),
                    ],
                  ],
                ),
              )
            else
              for (final pkg in PackageModel.seed) ...[
                // Bounded height for the card's Expanded feature list;
                // sized to real content instead of a fixed 640px box.
                IntrinsicHeight(
                  child: PricingCard(
                    package: pkg,
                    onSelect: () => Get.toNamed(AppRoutes.startupPackage),
                  ),
                ),
                const SizedBox(height: AppDimensions.spaceLg),
              ],
            const SizedBox(height: AppDimensions.space2xl),
            GradientButton(
              label: 'Compare All Features',
              icon: Icons.table_chart_rounded,
              onPressed: () => Get.toNamed(AppRoutes.startupPackage),
            ),
          ],
        ),
      ),
    );
  }
}

/// Client testimonials — horizontal scroll on desktop, stacked on mobile.
class TestimonialsPreviewSection extends StatelessWidget {
  const TestimonialsPreviewSection({super.key});

  @override
  Widget build(BuildContext context) {
    final isWide = MediaQuery.sizeOf(context).width >= 1024;

    final cards = [
      for (final t in TestimonialModel.seed.take(4))
        SizedBox(
          width: 420,
          height: 340,
          child: AnimatedSection(
            slideOffset: const Offset(36, 0),
            child: TestimonialCard(testimonial: t),
          ),
        ),
    ];

    return SectionWrapper(
      backgroundColor: AppColors.surface,
      child: ResponsiveContainer(
        child: Column(
          children: [
            const SectionTitle(
              eyebrow: 'Client voices',
              title: 'Trusted by founders and CTOs',
              subtitle: 'Real outcomes from teams who shipped with SoftKormo.',
            ),
            const SizedBox(height: AppDimensions.space2xl),
            if (isWide)
              SizedBox(
                height: 360,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: cards.length,
                  separatorBuilder: (_, _) =>
                      const SizedBox(width: AppDimensions.spaceLg),
                  itemBuilder: (_, i) => cards[i],
                ),
              )
            else
              for (var i = 0; i < cards.length; i++) ...[
                SizedBox(width: double.infinity, height: 340, child: cards[i]),
                const SizedBox(height: AppDimensions.spaceLg),
              ],
            const SizedBox(height: AppDimensions.spaceLg),
            TextButton.icon(
              onPressed: () => Get.toNamed(AppRoutes.testimonials),
              icon: const Icon(Icons.format_quote_rounded),
              label: const Text('Read all testimonials'),
            ),
          ],
        ),
      ),
    );
  }
}

/// Final gradient CTA banner before the footer.
class CtaSection extends StatelessWidget {
  const CtaSection({super.key});

  @override
  Widget build(BuildContext context) {
    final isWide = MediaQuery.sizeOf(context).width >= 900;

    return SectionWrapper(
      verticalPadding: 72,
      backgroundColor: AppColors.background,
      child: ResponsiveContainer(
        child: AnimatedSection(
          slideOffset: const Offset(0, 36),
          alignment: Alignment.center,
          child: Container(
            width: double.infinity,
            padding: EdgeInsets.all(
              isWide ? AppDimensions.space3xl : AppDimensions.spaceXl,
            ),
            decoration: BoxDecoration(
              gradient: AppColors.heroGradient,
              borderRadius: BorderRadius.circular(AppDimensions.radiusXl),
              boxShadow: [
                BoxShadow(
                  color: AppColors.purple.withValues(alpha: 0.4),
                  blurRadius: 60,
                  offset: const Offset(0, 28),
                ),
              ],
            ),
            child: isWide
                ? Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Your idea deserves a team that ships.',
                              style: Theme.of(context).textTheme.headlineMedium
                                  ?.copyWith(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w700,
                                  ),
                            ),
                            const SizedBox(height: AppDimensions.spaceMd),
                            Text(
                              'Free 30-minute consultation — bring your goals, leave '
                              'with a roadmap and a realistic budget range.',
                              style: Theme.of(context).textTheme.bodyLarge
                                  ?.copyWith(color: Colors.white70),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: AppDimensions.space2xl),
                      GradientButton(
                        label: 'Get Free Consultation',
                        icon: Icons.calendar_today_rounded,
                        gradient: const LinearGradient(
                          colors: [AppColors.tealGreen, Color(0xFF00D3A7)],
                        ),
                        onPressed: () => Get.toNamed(AppRoutes.contact),
                      ),
                    ],
                  )
                : Column(
                    children: [
                      Text(
                        'Your idea deserves a team that ships.',
                        textAlign: TextAlign.center,
                        style: Theme.of(
                          context,
                        ).textTheme.titleLarge?.copyWith(color: Colors.white),
                      ),
                      const SizedBox(height: AppDimensions.spaceMd),
                      Text(
                        'Free 30-minute consultation — leave with a roadmap '
                        'and a realistic budget.',
                        textAlign: TextAlign.center,
                        style: Theme.of(
                          context,
                        ).textTheme.bodyMedium?.copyWith(color: Colors.white70),
                      ),
                      const SizedBox(height: AppDimensions.spaceXl),
                      GradientButton(
                        label: 'Get Free Consultation',
                        expanded: true,
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
    );
  }
}
