import 'package:flutter/material.dart';

import '../constants/app_colors.dart';
import '../constants/app_dimensions.dart';
import '../utils/responsive_utils.dart';
import 'animated_section.dart';

/// Eyebrow + title + optional subtitle used at the top of every section.
class SectionTitle extends StatelessWidget {
  const SectionTitle({
    super.key,
    required this.eyebrow,
    required this.title,
    this.subtitle,
    this.align = TextAlign.center,
    this.light = false,
    this.showAnimation = true,
  });

  final String eyebrow;
  final String title;
  final String? subtitle;
  final TextAlign align;
  final bool light;
  final bool showAnimation;

  @override
  Widget build(BuildContext context) {
    final titleColor = light ? AppColors.textOnDark : AppColors.textPrimary;
    final subColor = light
        ? AppColors.textOnDarkMuted
        : AppColors.textSecondary;

    final content = Column(
      crossAxisAlignment: align == TextAlign.center
          ? CrossAxisAlignment.center
          : CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(
            horizontal: AppDimensions.spaceMd,
            vertical: 6,
          ),
          decoration: BoxDecoration(
            color: AppColors.tealGreen.withValues(alpha: 0.12),
            borderRadius: BorderRadius.circular(AppDimensions.radiusPill),
            border: Border.all(
              color: AppColors.tealGreen.withValues(alpha: 0.35),
            ),
          ),
          child: Text(
            eyebrow.toUpperCase(),
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w700,
              letterSpacing: 1.6,
              color: light ? AppColors.tealGreen : AppColors.tealGreen,
            ),
          ),
        ),
        const SizedBox(height: AppDimensions.spaceMd),
        Text(
          title,
          textAlign: align,
          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
            color: titleColor,
            fontWeight: FontWeight.w700,
            fontSize: Responsive.get(
              context,
              mobile: 28,
              tablet: 34,
              desktop: 40,
            ),
          ),
        ),
        if (subtitle != null) ...[
          const SizedBox(height: AppDimensions.spaceMd),
          ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 680),
            child: Text(
              subtitle!,
              textAlign: align,
              style: Theme.of(
                context,
              ).textTheme.bodyLarge?.copyWith(color: subColor),
            ),
          ),
        ],
      ],
    );

    if (!showAnimation) return content;
    return AnimatedSection(
      alignment: align == TextAlign.center
          ? Alignment.center
          : Alignment.centerLeft,
      child: content,
    );
  }
}
