import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_dimensions.dart';
import '../../../core/routes/app_routes.dart';
import '../../../core/utils/responsive_utils.dart';
import '../../../core/widgets/gradient_button.dart';
import '../../../core/widgets/responsive_container.dart';
import '../../../core/widgets/section_title.dart';
import '../../../core/widgets/animated_section.dart';
import '../../../shared/models/service_model.dart';
import '../../../shared/widgets/service_card.dart';

/// Services preview — the six canonical service cards + link to the full
/// services page. Heading: "OUR SERVICES" (eyebrow: "What We Do").
class ServicesPreviewSection extends StatelessWidget {
  const ServicesPreviewSection({super.key});

  @override
  Widget build(BuildContext context) {
    final cols = Responsive.get(
      context,
      mobile: 1,
      tablet: 2,
      laptop: 3,
      desktop: 3,
    );

    final services = ServiceModel.seed.take(6).toList(growable: false);

    return SectionWrapper(
      child: ResponsiveContainer(
        child: Column(
          children: [
            const SectionTitle(
              eyebrow: 'What We Do',
              title: 'OUR SERVICES',
              subtitle:
                  'Complete software solutions for startups and modern '
                  'businesses.',
            ),
            const SizedBox(height: AppDimensions.space2xl),
            for (var i = 0; i < services.length; i += cols) ...[
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  for (var j = i; j < (i + cols) && j < services.length; j++)
                    Expanded(
                      child: AnimatedSection(
                        delay: Duration(milliseconds: 80 * (j - i)),
                        child: IntrinsicHeight(
                          child: ServiceCard(
                            service: services[j],
                            index: j + 1,
                            onTap: () => Get.toNamed(AppRoutes.services),
                          ),
                        ),
                      ),
                    ),
                ],
              ),
              if (i + cols < services.length)
                const SizedBox(height: AppDimensions.spaceLg),
            ],
            const SizedBox(height: AppDimensions.space2xl),
            GradientButton(
              label: 'View All Services',
              icon: Icons.arrow_forward_rounded,
              onPressed: () => Get.toNamed(AppRoutes.services),
            ),
          ],
        ),
      ),
    );
  }
}

/// "Why Choose SoftKormo" value grid with icon tiles.
class WhyChooseSection extends StatelessWidget {
  const WhyChooseSection({super.key});

  static const _reasons = [
    (
      Icons.rocket_launch_rounded,
      AppColors.tealGreen,
      'Startup Speed',
      'Fixed-scope packages and weekly demos mean you see working software '
          'every seven days — no black-box phases.',
    ),
    (
      Icons.shield_rounded,
      AppColors.deepBlue,
      'Engineered to Last',
      'Security rules, tests, CI/CD and monitoring ship by default. We build '
          'systems you can hand to your next engineer.',
    ),
    (
      Icons.insights_rounded,
      AppColors.purple,
      'Data-Driven Delivery',
      'Velocity, quality and budget tracked openly. Decisions come from '
          'numbers, not gut feeling.',
    ),
    (
      Icons.handshake_rounded,
      AppColors.magenta,
      'Real Partnership',
      'A named lead, direct Slack access and honest timelines. We say no to '
          'features that hurt your product.',
    ),
    (
      Icons.auto_awesome_rounded,
      AppColors.orange,
      'Premium Craft',
      'Glass surfaces, motion design and typography systems inspired by '
          'Stripe, Linear and Vercel.',
    ),
    (
      Icons.support_agent_rounded,
      AppColors.tealGreen,
      'Reliable Support',
      'SLA-backed maintenance keeps your product healthy long after launch '
          'day.',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final cols = Responsive.get(context, mobile: 1, tablet: 2, desktop: 3);

    return SectionWrapper(
      backgroundColor: AppColors.surface,
      background: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFFFFFFFF), Color(0xFFF3F7FF)],
        ),
      ),
      child: ResponsiveContainer(
        child: Column(
          children: [
            const SectionTitle(
              eyebrow: 'Why SoftKormo',
              title: 'Why teams choose us',
              subtitle:
                  'We combine the speed of a startup studio with the discipline '
                  'of an enterprise engineering team.',
            ),
            const SizedBox(height: AppDimensions.space2xl),
            for (var i = 0; i < _reasons.length; i += cols) ...[
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  for (var j = i; j < (i + cols) && j < _reasons.length; j++)
                    Expanded(
                      child: AnimatedSection(
                        delay: Duration(milliseconds: 80 * (j - i)),
                        child: _ReasonTile(reason: _reasons[j]),
                      ),
                    ),
                ],
              ),
              if (i + cols < _reasons.length)
                const SizedBox(height: AppDimensions.spaceLg),
            ],
          ],
        ),
      ),
    );
  }
}

class _ReasonTile extends StatefulWidget {
  const _ReasonTile({required this.reason});

  final (IconData, Color, String, String) reason;

  @override
  State<_ReasonTile> createState() => _ReasonTileState();
}

class _ReasonTileState extends State<_ReasonTile> {
  bool _hover = false;

  @override
  Widget build(BuildContext context) {
    final (icon, color, title, body) = widget.reason;

    return MouseRegion(
      onEnter: (_) => setState(() => _hover = true),
      onExit: (_) => setState(() => _hover = false),
      child: AnimatedContainer(
        duration: AppDimensions.normal,
        transform: Matrix4.translationValues(0, _hover ? -5 : 0, 0),
        margin: const EdgeInsets.all(6),
        padding: const EdgeInsets.all(AppDimensions.spaceLg),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(AppDimensions.radiusLg),
          border: Border.all(
            color: _hover ? color.withValues(alpha: 0.5) : AppColors.border,
          ),
          boxShadow: [
            BoxShadow(
              color: _hover
                  ? color.withValues(alpha: 0.14)
                  : const Color(0x0A0B3C88),
              blurRadius: _hover ? 28 : 12,
              offset: Offset(0, _hover ? 12 : 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
              ),
              child: Icon(icon, color: color, size: 25),
            ),
            const SizedBox(height: AppDimensions.spaceMd),
            Text(
              title,
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 8),
            Text(
              body,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: AppColors.textSecondary,
                height: 1.65,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
