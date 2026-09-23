import 'package:flutter/material.dart';

import '../../core/constants/app_colors.dart';
import '../../core/constants/app_dimensions.dart';
import '../../core/widgets/gradient_button.dart';
import '../../shared/models/package_model.dart';

/// Modern pricing card with popular highlight, hover glow and feature list.
class PricingCard extends StatefulWidget {
  const PricingCard({super.key, required this.package, this.onSelect});

  final PackageModel package;
  final VoidCallback? onSelect;

  @override
  State<PricingCard> createState() => _PricingCardState();
}

class _PricingCardState extends State<PricingCard> {
  bool _hover = false;

  @override
  Widget build(BuildContext context) {
    final p = widget.package;
    final highlighted = p.highlighted;

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hover = true),
      onExit: (_) => setState(() => _hover = false),
      child: AnimatedContainer(
        duration: AppDimensions.normal,
        curve: Curves.easeOut,
        transform: Matrix4.translationValues(
          0,
          _hover ? -8 : (highlighted ? -12 : 0),
          0,
        ),
        padding: const EdgeInsets.all(AppDimensions.spaceXl),
        decoration: BoxDecoration(
          gradient: highlighted
              ? AppColors.heroGradient
              : LinearGradient(
                  colors: [AppColors.surface, AppColors.surface],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
          borderRadius: BorderRadius.circular(AppDimensions.radiusXl),
          border: Border.all(
            color: highlighted
                ? Colors.transparent
                : _hover
                ? AppColors.deepBlue.withValues(alpha: 0.5)
                : AppColors.border,
            width: 1.4,
          ),
          boxShadow: [
            BoxShadow(
              color: highlighted
                  ? AppColors.purple.withValues(alpha: _hover ? 0.45 : 0.30)
                  : _hover
                  ? AppColors.deepBlue.withValues(alpha: 0.14)
                  : const Color(0x0F0B3C88),
              blurRadius: _hover ? 44 : 18,
              offset: Offset(0, _hover ? 22 : 8),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ------------------------------------------------ badge row
            Row(
              children: [
                Text(
                  p.name,
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w700,
                    color: highlighted ? Colors.white : null,
                  ),
                ),
                const Spacer(),
                if (highlighted)
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 5,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.tealGreen,
                      borderRadius: BorderRadius.circular(
                        AppDimensions.radiusPill,
                      ),
                    ),
                    child: const Text(
                      'POPULAR',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 1.1,
                        color: Colors.white,
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 6),
            Text(
              p.tagline,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: highlighted ? AppColors.tealGreen : AppColors.textMuted,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: AppDimensions.spaceLg),

            // ----------------------------------------------------- price
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Flexible(
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    alignment: Alignment.centerLeft,
                    child: Text(
                      p.price,
                      style: Theme.of(context).textTheme.displayMedium
                          ?.copyWith(
                            fontSize: 44,
                            fontWeight: FontWeight.w800,
                            color: highlighted
                                ? Colors.white
                                : AppColors.deepBlue,
                          ),
                    ),
                  ),
                ),
                if (p.period.isNotEmpty) ...[
                  const SizedBox(width: 8),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Text(
                      p.period,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: highlighted
                            ? Colors.white60
                            : AppColors.textMuted,
                      ),
                    ),
                  ),
                ],
              ],
            ),
            const SizedBox(height: AppDimensions.spaceSm),
            Text(
              p.summary,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: highlighted ? Colors.white70 : AppColors.textSecondary,
                height: 1.6,
              ),
            ),
            const SizedBox(height: AppDimensions.spaceLg),
            SizedBox(
              width: double.infinity,
              child: GradientButton(
                label: p.ctaLabel,
                expanded: true,
                gradient: highlighted
                    ? const LinearGradient(
                        colors: [AppColors.tealGreen, Color(0xFF00D3A7)],
                      )
                    : AppColors.brandGradient,
                onPressed: widget.onSelect,
              ),
            ),
            const SizedBox(height: AppDimensions.spaceLg),
            Container(
              height: 1,
              color: highlighted ? Colors.white24 : AppColors.border,
            ),
            const SizedBox(height: AppDimensions.spaceLg),

            // -------------------------------------------------- features
            Text(
              'WHAT’S INCLUDED',
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                fontWeight: FontWeight.w700,
                letterSpacing: 1.3,
                color: highlighted ? AppColors.tealGreen : AppColors.textMuted,
              ),
            ),
            const SizedBox(height: AppDimensions.spaceMd),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    for (final f in p.features)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 11),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Icon(
                              Icons.check_circle_rounded,
                              size: 18,
                              color: highlighted
                                  ? AppColors.tealGreen
                                  : AppColors.deepBlue,
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Text(
                                f,
                                style: Theme.of(context).textTheme.bodySmall
                                    ?.copyWith(
                                      color: highlighted
                                          ? Colors.white70
                                          : AppColors.textSecondary,
                                    ),
                              ),
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
    );
  }
}
