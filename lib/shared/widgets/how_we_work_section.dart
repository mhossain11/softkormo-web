import 'package:flutter/material.dart';

import '../../core/constants/app_colors.dart';
import '../../core/constants/app_dimensions.dart';
import '../../core/widgets/animated_section.dart';
import '../../core/widgets/responsive_container.dart';
import '../../core/widgets/section_title.dart';

/// Reusable "How We Work" process section â€” four phases with weekly demos.
/// Used by the Home and Services pages (single source of truth).
class HowWeWorkSection extends StatelessWidget {
  const HowWeWorkSection({super.key, this.showTitle = true, this.subtitle});

  final bool showTitle;
  final String? subtitle;

  static const List<(String, String, String)> steps = [
    (
      '01',
      'Discover',
      'Workshops, users, constraints â€” we define the real problem before '
          'writing code.',
    ),
    (
      '02',
      'Design',
      'Wireframes, design system and clickable prototype signed off in week '
          'one or two.',
    ),
    (
      '03',
      'Build',
      'Two-week sprints with a working demo every Friday and a live staging '
          'environment.',
    ),
    (
      '04',
      'Launch & Grow',
      'Store submission, monitoring, analytics and an iterative roadmap after '
          'release.',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final isWide = MediaQuery.sizeOf(context).width >= 900;

    return SectionWrapper(
      backgroundColor: AppColors.surface,
      child: ResponsiveContainer(
        child: Column(
          children: [
            if (showTitle) ...[
              SectionTitle(
                eyebrow: 'How we work',
                title: 'A process built for momentum',
                subtitle:
                    subtitle ??
                    'Four phases, weekly demos and one point of contact from '
                        'kickoff to launch.',
              ),
              const SizedBox(height: AppDimensions.space2xl),
            ],
            if (isWide)
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  for (var i = 0; i < steps.length; i++)
                    Expanded(
                      child: AnimatedSection(
                        delay: Duration(milliseconds: 90 * i),
                        child: _StepTile(
                          step: steps[i],
                          last: i == steps.length - 1,
                        ),
                      ),
                    ),
                ],
              )
            else
              Column(
                children: [
                  for (var i = 0; i < steps.length; i++)
                    _StepTile(step: steps[i], last: i == steps.length - 1),
                ],
              ),
          ],
        ),
      ),
    );
  }
}

class _StepTile extends StatelessWidget {
  const _StepTile({required this.step, required this.last});

  final (String, String, String) step;
  final bool last;

  @override
  Widget build(BuildContext context) {
    final (num, title, body) = step;

    return Container(
      margin: EdgeInsets.only(
        right: last ? 0 : AppDimensions.spaceMd,
        bottom: AppDimensions.spaceMd,
      ),
      padding: const EdgeInsets.all(AppDimensions.spaceLg),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(AppDimensions.radiusLg),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            num,
            style: Theme.of(context).textTheme.displaySmall?.copyWith(
              fontSize: 34,
              fontWeight: FontWeight.w800,
              color: AppColors.tealGreen.withValues(alpha: 0.6),
            ),
          ),
          const SizedBox(height: 10),
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
              height: 1.6,
            ),
          ),
        ],
      ),
    );
  }
}
