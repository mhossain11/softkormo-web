import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../core/constants/app_colors.dart';
import '../../core/constants/app_dimensions.dart';
import '../../core/routes/app_routes.dart';
import '../../core/widgets/gradient_button.dart';
import '../../shared/models/project_model.dart';
import 'project_preview.dart';
import 'technology_chip.dart';

/// Projects grid tile: widget-built preview mockup, category
/// badge, name, description, technology chips and "View Details" button.
class ProjectCard extends StatefulWidget {
  const ProjectCard({super.key, required this.project, this.onTap});

  final ProjectModel project;
  final VoidCallback? onTap;

  @override
  State<ProjectCard> createState() => _ProjectCardState();
}

class _ProjectCardState extends State<ProjectCard> {
  bool _hover = false;

  Color get _categoryColor {
    switch (widget.project.category) {
      case 'Mobile Apps':
        return AppColors.tealGreen;
      case 'Backend':
        return AppColors.purple;
      case 'Data Analytics':
        return AppColors.orange;
      default:
        return AppColors.deepBlue;
    }
  }

  IconData get _categoryIcon {
    switch (widget.project.category) {
      case 'Mobile Apps':
        return Icons.phone_iphone_rounded;
      case 'Backend':
        return Icons.storage_rounded;
      case 'Data Analytics':
        return Icons.bar_chart_rounded;
      default:
        return Icons.web_rounded;
    }
  }

  @override
  Widget build(BuildContext context) {
    final p = widget.project;

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hover = true),
      onExit: (_) => setState(() => _hover = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: AppDimensions.normal,
          curve: Curves.easeOut,
          transform: Matrix4.translationValues(0, _hover ? -8 : 0, 0),
          clipBehavior: Clip.antiAlias,
          padding: const EdgeInsets.all(AppDimensions.spaceLg),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(AppDimensions.radiusLg),
            border: Border.all(
              color: _hover ? _categoryColor : AppColors.border,
              width: _hover ? 1.5 : 1.2,
            ),
            boxShadow: [
              BoxShadow(
                color: _hover
                    ? _categoryColor.withValues(alpha: 0.26)
                    : const Color(0x0F0B3C88),
                blurRadius: _hover ? 32 : 14,
                offset: Offset(0, _hover ? 18 : 6),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              // ------------------------------------------------ preview
              Stack(
                children: [
                  AnimatedScale(
                    scale: _hover ? 1.03 : 1.0,
                    duration: AppDimensions.normal,
                    curve: Curves.easeOut,
                    child: ProjectPreview(
                      type: p.previewType,
                      accent: _categoryColor,
                      compact: true,
                    ),
                  ),
                  // category badge
                  Positioned(
                    top: 10,
                    left: 10,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 11,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.94),
                        borderRadius: BorderRadius.circular(
                          AppDimensions.radiusPill,
                        ),
                        boxShadow: const [
                          BoxShadow(color: Color(0x1A0B3C88), blurRadius: 10),
                        ],
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(_categoryIcon, size: 12, color: _categoryColor),
                          const SizedBox(width: 5),
                          Text(
                            p.category,
                            style: TextStyle(
                              fontSize: 11.5,
                              fontWeight: FontWeight.w700,
                              color: _categoryColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppDimensions.spaceMd),

              // -------------------------------------------------- title
              Row(
                children: [
                  Expanded(
                    child: Text(
                      p.title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  if (p.year.isNotEmpty)
                    Text(p.year, style: Theme.of(context).textTheme.labelSmall),
                ],
              ),
              const SizedBox(height: 6),

              // ------------------------------------------- description
              Text(
                p.description,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: AppColors.textSecondary,
                  height: 1.55,
                ),
              ),
              const SizedBox(height: AppDimensions.spaceMd),

              // ------------------------------------------- tech chips
              Wrap(
                spacing: 7,
                runSpacing: 7,
                children: [
                  for (final t in p.tags.take(3))
                    TechnologyChip(
                      label: t,
                      gradient: true,
                      color: _categoryColor,
                    ),
                ],
              ),
              const SizedBox(height: AppDimensions.spaceMd),

              // ------------------------------------------ view details button
              AnimatedContainer(
                duration: AppDimensions.normal,
                width: double.infinity,
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 11,
                ),
                decoration: BoxDecoration(
                  color: _hover
                      ? _categoryColor
                      : _categoryColor.withValues(alpha: 0.08),
                  borderRadius: BorderRadius.circular(AppDimensions.radiusPill),
                  border: Border.all(
                    color: _categoryColor.withValues(alpha: _hover ? 1 : 0.45),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'View Details',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: _hover ? Colors.white : _categoryColor,
                      ),
                    ),
                    const SizedBox(width: 7),
                    AnimatedContainer(
                      duration: AppDimensions.normal,
                      transform: Matrix4.translationValues(
                        _hover ? 5 : 0,
                        0,
                        0,
                      ),
                      child: Icon(
                        Icons.arrow_outward_rounded,
                        size: 16,
                        color: _hover ? Colors.white : _categoryColor,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Full project-details dialog: name, category, visual, description,
/// technologies, key features, challenges, solution, results and a
/// "Start a Similar Project" CTA.
void showProjectDialog(BuildContext context, ProjectModel project) {
  final p = project;

  Color accent;
  switch (p.category) {
    case 'Mobile Apps':
      accent = AppColors.tealGreen;
      break;
    case 'Backend':
      accent = AppColors.purple;
      break;
    case 'Data Analytics':
      accent = AppColors.orange;
      break;
    default:
      accent = AppColors.deepBlue;
  }

  showDialog(
    context: context,
    barrierDismissible: true,
    builder: (ctx) => Dialog(
      backgroundColor: AppColors.background,
      insetPadding: const EdgeInsets.all(24),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppDimensions.radiusXl),
      ),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 780, maxHeight: 720),
        child: Column(
          children: [
            // ------------------------------------------------ header
            Container(
              padding: const EdgeInsets.fromLTRB(
                AppDimensions.spaceXl,
                AppDimensions.spaceXl,
                AppDimensions.spaceMd,
                AppDimensions.spaceLg,
              ),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [accent, AppColors.deepBlueDark],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 11,
                            vertical: 5,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.18),
                            borderRadius: BorderRadius.circular(
                              AppDimensions.radiusPill,
                            ),
                            border: Border.all(color: Colors.white30),
                          ),
                          child: Text(
                            p.category,
                            style: const TextStyle(
                              fontSize: 11.5,
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          p.title,
                          style: Theme.of(ctx).textTheme.headlineSmall
                              ?.copyWith(
                                fontWeight: FontWeight.w800,
                                color: Colors.white,
                              ),
                        ),
                        if (p.client.isNotEmpty) ...[
                          const SizedBox(height: 4),
                          Text(
                            '${p.client}${p.year.isNotEmpty ? ' â€¢ ${p.year}' : ''}',
                            style: Theme.of(ctx).textTheme.bodySmall?.copyWith(
                              color: Colors.white70,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                  IconButton(
                    onPressed: () => Navigator.of(ctx).pop(),
                    icon: const Icon(Icons.close_rounded, color: Colors.white),
                    tooltip: 'Close',
                  ),
                ],
              ),
            ),

            // ------------------------------------------------- content
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(AppDimensions.spaceXl),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // project visual
                    ProjectPreview(type: p.previewType, accent: accent),
                    const SizedBox(height: AppDimensions.spaceLg),

                    Text(
                      p.description,
                      style: Theme.of(ctx).textTheme.bodyLarge?.copyWith(
                        color: AppColors.textSecondary,
                        height: 1.75,
                      ),
                    ),
                    const SizedBox(height: AppDimensions.spaceXl),

                    // technologies
                    _SectionLabel('TECHNOLOGIES', color: accent),
                    const SizedBox(height: 10),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        for (final t in p.techStack)
                          TechnologyChip(label: t, gradient: true),
                      ],
                    ),
                    const SizedBox(height: AppDimensions.spaceXl),

                    // key features
                    if (p.keyFeatures.isNotEmpty) ...[
                      _SectionLabel('KEY FEATURES', color: accent),
                      const SizedBox(height: 10),
                      Wrap(
                        spacing: 10,
                        runSpacing: 10,
                        children: [
                          for (final f in p.keyFeatures)
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 13,
                                vertical: 9,
                              ),
                              decoration: BoxDecoration(
                                color: AppColors.surface,
                                borderRadius: BorderRadius.circular(
                                  AppDimensions.radiusMd,
                                ),
                                border: Border.all(color: AppColors.border),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    Icons.check_circle_rounded,
                                    size: 15,
                                    color: accent,
                                  ),
                                  const SizedBox(width: 7),
                                  // Flexible: non-flex Row children get an
                                  // unbounded width, so a long feature string
                                  // overflowed this chip in the narrow detail
                                  // dialog (Row at :401, +120px). A flex child
                                  // is capped at the remaining free space and
                                  // wraps instead; short labels still
                                  // shrink-wrap because the fit is loose.
                                  Flexible(
                                    child: Text(
                                      f,
                                      style: const TextStyle(
                                        fontSize: 13,
                                        fontWeight: FontWeight.w600,
                                        color: AppColors.textPrimary,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                        ],
                      ),
                      const SizedBox(height: AppDimensions.spaceXl),
                    ],

                    // challenges / solution / results
                    if (p.challenges.isNotEmpty) ...[
                      _SectionLabel('THE CHALLENGE', color: accent),
                      const SizedBox(height: 8),
                      Text(
                        p.challenges,
                        style: Theme.of(ctx).textTheme.bodyMedium?.copyWith(
                          color: AppColors.textSecondary,
                          height: 1.7,
                        ),
                      ),
                      const SizedBox(height: AppDimensions.spaceLg),
                    ],
                    if (p.solution.isNotEmpty) ...[
                      _SectionLabel('OUR SOLUTION', color: accent),
                      const SizedBox(height: 8),
                      Text(
                        p.solution,
                        style: Theme.of(ctx).textTheme.bodyMedium?.copyWith(
                          color: AppColors.textSecondary,
                          height: 1.7,
                        ),
                      ),
                      const SizedBox(height: AppDimensions.spaceLg),
                    ],
                    if (p.results.isNotEmpty) ...[
                      _SectionLabel('THE RESULTS', color: accent),
                      const SizedBox(height: 8),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(AppDimensions.spaceLg),
                        decoration: BoxDecoration(
                          color: accent.withValues(alpha: 0.08),
                          borderRadius: BorderRadius.circular(
                            AppDimensions.radiusMd,
                          ),
                          border: Border.all(
                            color: accent.withValues(alpha: 0.35),
                          ),
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Icon(Icons.trending_up_rounded, color: accent),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Text(
                                p.results,
                                style: Theme.of(ctx).textTheme.bodyMedium
                                    ?.copyWith(
                                      color: AppColors.textPrimary,
                                      height: 1.7,
                                      fontWeight: FontWeight.w500,
                                    ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: AppDimensions.spaceXl),
                    ],

                    // CTA
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(AppDimensions.spaceXl),
                      decoration: BoxDecoration(
                        gradient: AppColors.heroGradient,
                        borderRadius: BorderRadius.circular(
                          AppDimensions.radiusLg,
                        ),
                      ),
                      child: Wrap(
                        alignment: WrapAlignment.spaceBetween,
                        runSpacing: 14,
                        spacing: 16,
                        crossAxisAlignment: WrapCrossAlignment.center,
                        children: [
                          ConstrainedBox(
                            constraints: const BoxConstraints(maxWidth: 380),
                            child: Text(
                              'Want results like these for your product?',
                              style: Theme.of(ctx).textTheme.titleMedium
                                  ?.copyWith(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w700,
                                  ),
                            ),
                          ),
                          GradientButton(
                            label: 'Start a Similar Project',
                            icon: Icons.rocket_launch_rounded,
                            gradient: const LinearGradient(
                              colors: [AppColors.tealGreen, Color(0xFF00D3A7)],
                            ),
                            onPressed: () {
                              Navigator.of(ctx).pop();
                              Get.toNamed(AppRoutes.contact);
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    ),
  );
}

class _SectionLabel extends StatelessWidget {
  const _SectionLabel(this.text, {required this.color});

  final String text;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 4,
          height: 16,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(width: 8),
        Text(
          text,
          style: Theme.of(context).textTheme.labelSmall?.copyWith(
            fontWeight: FontWeight.w800,
            letterSpacing: 1.4,
            color: AppColors.textPrimary,
          ),
        ),
      ],
    );
  }
}
