import 'package:flutter/material.dart';

import '../../core/constants/app_colors.dart';
import '../../core/constants/app_dimensions.dart';
import '../../shared/models/testimonial_model.dart';

/// Animated testimonial card: quote mark, stars, avatar and hover glow.
class TestimonialCard extends StatefulWidget {
  const TestimonialCard({
    super.key,
    required this.testimonial,
    this.dark = false,
  });

  final TestimonialModel testimonial;
  final bool dark;

  @override
  State<TestimonialCard> createState() => _TestimonialCardState();
}

class _TestimonialCardState extends State<TestimonialCard> {
  bool _hover = false;

  String get _initials {
    final parts = widget.testimonial.name
        .trim()
        .split(RegExp(r'\s+'))
        .where((w) => w.isNotEmpty);
    if (parts.isEmpty) return '?';
    if (parts.length == 1) return parts.first.characters.first.toUpperCase();
    return (parts.first.characters.first + parts.last.characters.first)
        .toUpperCase();
  }

  Color get _avatarColor {
    final colors = AppColors.brandPalette;
    return colors[widget.testimonial.name.hashCode.abs() % colors.length];
  }

  @override
  Widget build(BuildContext context) {
    final t = widget.testimonial;

    return MouseRegion(
      onEnter: (_) => setState(() => _hover = true),
      onExit: (_) => setState(() => _hover = false),
      child: AnimatedContainer(
        duration: AppDimensions.normal,
        curve: Curves.easeOut,
        transform: Matrix4.translationValues(0, _hover ? -6 : 0, 0),
        padding: const EdgeInsets.all(AppDimensions.spaceXl),
        decoration: BoxDecoration(
          color: widget.dark
              ? Colors.white.withValues(alpha: 0.05)
              : AppColors.surface,
          borderRadius: BorderRadius.circular(AppDimensions.radiusLg),
          border: Border.all(
            color: _hover
                ? AppColors.purple.withValues(alpha: 0.5)
                : widget.dark
                ? Colors.white12
                : AppColors.border,
          ),
          boxShadow: [
            BoxShadow(
              color: _hover
                  ? AppColors.purple.withValues(alpha: 0.15)
                  : const Color(0x0F0B3C88),
              blurRadius: _hover ? 30 : 12,
              offset: Offset(0, _hover ? 14 : 5),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ------------------------------------------------ quote mark
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '“',
                  style: TextStyle(
                    fontSize: 64,
                    height: 0.7,
                    fontWeight: FontWeight.w700,
                    color: AppColors.tealGreen.withValues(
                      alpha: _hover ? 1 : 0.6,
                    ),
                  ),
                ),
                const Spacer(),
                Row(
                  children: [
                    for (var i = 0; i < 5; i++)
                      Icon(
                        i < t.rating
                            ? Icons.star_rounded
                            : Icons.star_outline_rounded,
                        size: 19,
                        color: i < t.rating
                            ? AppColors.orange
                            : AppColors.textMuted,
                      ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: AppDimensions.spaceSm),

            // ------------------------------------------------------ quote
            Expanded(
              child: Text(
                t.quote,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: widget.dark
                      ? AppColors.textOnDarkMuted
                      : AppColors.textSecondary,
                  height: 1.75,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ),
            const SizedBox(height: AppDimensions.spaceLg),
            const Divider(height: 1),
            const SizedBox(height: AppDimensions.spaceMd),

            // --------------------------------------------------- identity
            Row(
              children: [
                AnimatedContainer(
                  duration: AppDimensions.normal,
                  width: 46,
                  height: 46,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        _avatarColor,
                        _avatarColor.withValues(alpha: 0.65),
                      ],
                    ),
                    shape: BoxShape.circle,
                    boxShadow: _hover
                        ? [
                            BoxShadow(
                              color: _avatarColor.withValues(alpha: 0.5),
                              blurRadius: 16,
                            ),
                          ]
                        : null,
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    _initials,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                      fontSize: 16,
                    ),
                  ),
                ),
                const SizedBox(width: AppDimensions.spaceMd),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        t.name,
                        style: Theme.of(context).textTheme.titleMedium
                            ?.copyWith(fontWeight: FontWeight.w700),
                      ),
                      Text(
                        '${t.role}${t.company.isNotEmpty ? ' • ${t.company}' : ''}',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: AppColors.tealGreen,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
