import 'package:flutter/material.dart';

import '../../core/constants/app_colors.dart';
import '../../core/constants/app_dimensions.dart';

/// Small technology / feature chip.
///
/// [gradient] renders the brand-gradient pill (tech stack highlights),
/// otherwise a soft outlined chip (feature lists).
class TechnologyChip extends StatelessWidget {
  const TechnologyChip({
    super.key,
    required this.label,
    this.gradient = false,
    this.icon,
    this.color,
    this.onTap,
  });

  final String label;
  final bool gradient;
  final IconData? icon;
  final Color? color;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final accent = color ?? AppColors.deepBlue;

    final Widget child = Container(
      padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 6),
      decoration: BoxDecoration(
        gradient: gradient ? AppColors.brandGradient : null,
        color: gradient ? null : accent.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(AppDimensions.radiusPill),
        border: gradient
            ? null
            : Border.all(color: accent.withValues(alpha: 0.28), width: 1),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, size: 12, color: gradient ? Colors.white : accent),
            const SizedBox(width: 5),
          ],
          // Flexible: non-flex Row children are laid out with unbounded
          // width — cap the label at the free space so a long label in a
          // narrow Wrap (detail dialog) wraps instead of overflowing.
          Flexible(
            child: Text(
              label,
              style: TextStyle(
                fontSize: 11.5,
                fontWeight: FontWeight.w600,
                letterSpacing: 0.15,
                color: gradient ? Colors.white : accent.withValues(alpha: 0.95),
              ),
            ),
          ),
        ],
      ),
    );

    if (onTap == null) return child;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppDimensions.radiusPill),
      child: child,
    );
  }
}
