import 'package:flutter/material.dart';

import '../../core/constants/app_colors.dart';
import '../../core/constants/app_dimensions.dart';
import '../../core/utils/responsive_utils.dart';
import '../../core/widgets/animated_section.dart';
import '../../core/widgets/responsive_container.dart';
import '../../core/widgets/section_title.dart';
import 'technology_chip.dart';

/// Reusable "Technology Stack" section — grouped brand-gradient chips.
/// Used by the Home and About pages (single source of truth).
class TechnologyStackSection extends StatelessWidget {
  const TechnologyStackSection({super.key, this.showTitle = true});

  final bool showTitle;

  static const Map<String, List<String>> groups = {
    'Mobile': ['Flutter', 'Dart', 'iOS', 'Android'],
    'Web': ['Flutter Web', 'SEO', 'PWA', 'Firebase Hosting'],
    'Backend': ['Node.js', 'Cloud Functions', 'REST', 'GraphQL'],
    'Data': ['BigQuery', 'Python', 'Airflow', 'Power BI'],
    'Cloud': ['Firebase', 'GCP', 'Docker', 'CI/CD'],
    'Quality': ['Testing', 'Monitoring', 'Security Rules', 'Code Review'],
  };

  @override
  Widget build(BuildContext context) {
    final groupsPerRow = Responsive.get(
      context,
      mobile: 1,
      tablet: 2,
      laptop: 3,
      desktop: 3,
    );

    final entries = groups.entries.toList(growable: false);

    return SectionWrapper(
      child: ResponsiveContainer(
        child: Column(
          children: [
            if (showTitle) ...[
              const SectionTitle(
                eyebrow: 'Technology stack',
                title: 'Tools we master daily',
                subtitle:
                    'A modern, proven stack — chosen for velocity today and '
                    'maintainability tomorrow.',
              ),
              const SizedBox(height: AppDimensions.space2xl),
            ],
            for (var i = 0; i < entries.length; i += groupsPerRow) ...[
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  for (
                    var j = i;
                    j < (i + groupsPerRow) && j < entries.length;
                    j++
                  )
                    Expanded(
                      child: AnimatedSection(
                        delay: Duration(milliseconds: 70 * (j - i)),
                        child: _StackGroup(
                          title: entries[j].key,
                          techs: entries[j].value,
                        ),
                      ),
                    ),
                  if (entries.length - i < groupsPerRow)
                    for (
                      var k = 0;
                      k < groupsPerRow - (entries.length - i);
                      k++
                    )
                      const Expanded(child: SizedBox()),
                ],
              ),
              if (i + groupsPerRow < entries.length)
                const SizedBox(height: AppDimensions.spaceLg),
            ],
          ],
        ),
      ),
    );
  }
}

class _StackGroup extends StatelessWidget {
  const _StackGroup({required this.title, required this.techs});

  final String title;
  final List<String> techs;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(5),
      padding: const EdgeInsets.all(AppDimensions.spaceLg),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
        border: Border.all(color: AppColors.border),
        boxShadow: const [BoxShadow(color: Color(0x0A0B3C88), blurRadius: 14)],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 8,
                height: 8,
                decoration: const BoxDecoration(
                  gradient: AppColors.brandGradient,
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 8),
              Text(
                title.toUpperCase(),
                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  color: AppColors.tealGreen,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 1.4,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppDimensions.spaceMd),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              for (final t in techs) TechnologyChip(label: t, gradient: true),
            ],
          ),
        ],
      ),
    );
  }
}
