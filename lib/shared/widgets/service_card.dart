import 'package:flutter/material.dart';

import '../../core/constants/app_colors.dart';
import '../../core/constants/app_dimensions.dart';
import '../../shared/models/service_model.dart';
import 'technology_chip.dart';

/// Rich service card: gradient icon tile, service number, title,
/// description, feature chips and a "Learn More" button.
/// Hover lifts the card, reveals the brand-gradient border and glow.
class ServiceCard extends StatefulWidget {
  const ServiceCard({
    super.key,
    required this.service,
    required this.index,
    this.onTap,
  });

  final ServiceModel service;

  /// 1-based service number shown on the card.
  final int index;

  final VoidCallback? onTap;

  @override
  State<ServiceCard> createState() => _ServiceCardState();
}

class _ServiceCardState extends State<ServiceCard> {
  bool _hover = false;

  static const _iconPalette = <String, Color>{
    'phone_android': AppColors.tealGreen,
    'language': AppColors.deepBlue,
    'dns': AppColors.purple,
    'analytics': AppColors.orange,
    'rocket_launch': AppColors.magenta,
    'support_agent': AppColors.tealGreen,
    'cable': AppColors.magenta,
    'local_fire_department': AppColors.orange,
    'build': AppColors.deepBlue,
  };

  IconData get _icon {
    switch (widget.service.icon) {
      case 'phone_android':
        return Icons.phone_android_rounded;
      case 'language':
        return Icons.language_rounded;
      case 'web':
        return Icons.web_rounded;
      case 'dns':
        return Icons.dns_rounded;
      case 'analytics':
        return Icons.analytics_rounded;
      case 'rocket_launch':
        return Icons.rocket_launch_rounded;
      case 'support_agent':
        return Icons.support_agent_rounded;
      case 'cable':
        return Icons.cable_rounded;
      case 'local_fire_department':
        return Icons.local_fire_department_rounded;
      case 'build':
        return Icons.build_rounded;
      default:
        return Icons.code_rounded;
    }
  }

  Color get _accent => _iconPalette[widget.service.icon] ?? AppColors.deepBlue;

  String get _number => widget.index.toString().padLeft(2, '0');

  @override
  Widget build(BuildContext context) {
    final s = widget.service;

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
          padding: const EdgeInsets.all(AppDimensions.spaceXl),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(AppDimensions.radiusLg),
            border: Border.all(
              color: _hover ? _accent : AppColors.border,
              width: _hover ? 1.6 : 1.2,
            ),
            gradient: _hover
                ? LinearGradient(
                    colors: [
                      _accent.withValues(alpha: 0.06),
                      AppColors.surface,
                      AppColors.surface,
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  )
                : null,
            boxShadow: [
              BoxShadow(
                color: _hover
                    ? _accent.withValues(alpha: 0.28)
                    : const Color(0x0F0B3C88),
                blurRadius: _hover ? 34 : 14,
                offset: Offset(0, _hover ? 18 : 6),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ------------------------------------------- icon + number
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AnimatedContainer(
                    duration: AppDimensions.normal,
                    width: 58,
                    height: 58,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [_accent, _accent.withValues(alpha: 0.62)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(
                        AppDimensions.radiusMd,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: _accent.withValues(
                            alpha: _hover ? 0.55 : 0.30,
                          ),
                          blurRadius: _hover ? 22 : 12,
                          offset: const Offset(0, 7),
                        ),
                      ],
                    ),
                    child: Icon(_icon, color: Colors.white, size: 29),
                  ),
                  const Spacer(),
                  Text(
                    _number,
                    style: TextStyle(
                      fontSize: 34,
                      fontWeight: FontWeight.w800,
                      height: 1,
                      letterSpacing: -1,
                      color: _accent.withValues(alpha: _hover ? 0.85 : 0.28),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppDimensions.spaceLg),

              // ---------------------------------------------------- title
              Text(
                s.title,
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w700,
                  height: 1.3,
                ),
              ),
              const SizedBox(height: AppDimensions.spaceSm),

              // ---------------------------------------------- description
              Text(
                s.description,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppColors.textSecondary,
                  height: 1.65,
                ),
              ),
              const SizedBox(height: AppDimensions.spaceMd),

              // ---------------------------------------------- feature chips
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  for (final chip in s.chips)
                    TechnologyChip(label: chip, color: _accent),
                ],
              ),
              const SizedBox(height: AppDimensions.spaceLg),
              const Spacer(),

              // ------------------------------------------ learn more button
              AnimatedContainer(
                duration: AppDimensions.normal,
                width: double.infinity,
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 11,
                ),
                decoration: BoxDecoration(
                  color: _hover ? _accent : _accent.withValues(alpha: 0.08),
                  borderRadius: BorderRadius.circular(AppDimensions.radiusPill),
                  border: Border.all(
                    color: _accent.withValues(alpha: _hover ? 1 : 0.45),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      s.ctaLabel,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: _hover ? Colors.white : _accent,
                      ),
                    ),
                    const SizedBox(width: 8),
                    AnimatedContainer(
                      duration: AppDimensions.normal,
                      transform: Matrix4.translationValues(
                        _hover ? 6 : 0,
                        0,
                        0,
                      ),
                      child: Icon(
                        Icons.arrow_forward_rounded,
                        size: 17,
                        color: _hover ? Colors.white : _accent,
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
