import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../core/constants/app_colors.dart';
import '../../core/constants/app_dimensions.dart';
import '../../core/routes/app_routes.dart';
import '../../core/widgets/gradient_button.dart';
import '../../core/widgets/responsive_container.dart';
import '../../shared/widgets/brand_logo.dart';

/// Site-wide footer: brand block, link columns, contact, socials.
class Footer extends StatelessWidget {
  const Footer({super.key});

  @override
  Widget build(BuildContext context) {
    final isWide = MediaQuery.sizeOf(context).width >= 768;

    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFF071E45), Color(0xFF04122B)],
        ),
      ),
      padding: const EdgeInsets.only(top: AppDimensions.space4xl),
      child: Column(
        children: [
          ResponsiveContainer(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ------------------------------------------------ CTA strip
                Container(
                  padding: const EdgeInsets.all(AppDimensions.spaceXl),
                  decoration: BoxDecoration(
                    gradient: AppColors.heroGradient,
                    borderRadius: BorderRadius.circular(AppDimensions.radiusXl),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.purple.withValues(alpha: 0.35),
                        blurRadius: 40,
                        offset: const Offset(0, 16),
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
                                    'Ready to build something smart?',
                                    style: Theme.of(context)
                                        .textTheme
                                        .headlineSmall
                                        ?.copyWith(color: Colors.white),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    'Tell us about your project — free consultation, honest timelines, no obligation.',
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyMedium
                                        ?.copyWith(color: Colors.white70),
                                  ),
                                ],
                              ),
                            ),
                            GradientButton(
                              label: 'Start a Conversation',
                              gradient: const LinearGradient(
                                colors: [
                                  AppColors.tealGreen,
                                  Color(0xFF00D3A7),
                                ],
                              ),
                              onPressed: () => Get.toNamed(AppRoutes.contact),
                            ),
                          ],
                        )
                      : Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Text(
                              'Ready to build something smart?',
                              textAlign: TextAlign.center,
                              style: Theme.of(context).textTheme.titleLarge
                                  ?.copyWith(color: Colors.white),
                            ),
                            const SizedBox(height: AppDimensions.spaceMd),
                            GradientButton(
                              label: 'Start a Conversation',
                              expanded: true,
                              gradient: const LinearGradient(
                                colors: [
                                  AppColors.tealGreen,
                                  Color(0xFF00D3A7),
                                ],
                              ),
                              onPressed: () => Get.toNamed(AppRoutes.contact),
                            ),
                          ],
                        ),
                ),
                const SizedBox(height: AppDimensions.space3xl),

                // ------------------------------------------------ link grid
                if (isWide)
                  const Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(flex: 3, child: _BrandColumn()),
                      Expanded(flex: 2, child: _LinkColumn(title: 'Company')),
                      Expanded(
                        flex: 2,
                        child: _LinkColumn(title: 'Services', services: true),
                      ),
                      Expanded(flex: 3, child: _ContactColumn()),
                    ],
                  )
                else
                  const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _BrandColumn(),
                      SizedBox(height: AppDimensions.space2xl),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(child: _LinkColumn(title: 'Company')),
                          SizedBox(width: AppDimensions.spaceLg),
                          Expanded(
                            child: _LinkColumn(
                              title: 'Services',
                              services: true,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: AppDimensions.space2xl),
                      _ContactColumn(),
                    ],
                  ),
              ],
            ),
          ),

          const SizedBox(height: AppDimensions.space2xl),
          Container(height: 1, color: Colors.white12),
          ResponsiveContainer(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                vertical: AppDimensions.spaceLg,
              ),
              child: Wrap(
                alignment: WrapAlignment.spaceBetween,
                runSpacing: AppDimensions.spaceSm,
                children: [
                  Text(
                    '© ${DateTime.now().year} SoftKormo. All rights reserved.',
                    style: Theme.of(
                      context,
                    ).textTheme.bodySmall?.copyWith(color: Colors.white54),
                  ),
                  Text(
                    'Smart Software, Reliable Service',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: AppColors.tealGreen.withValues(alpha: 0.9),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _BrandColumn extends StatelessWidget {
  const _BrandColumn();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const BrandLogo(height: 38, light: true),
        const SizedBox(height: AppDimensions.spaceMd),
        ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 320),
          child: Text(
            'A modern software company delivering mobile apps, web platforms, '
            'backends, data analytics and startup packages for teams that ship.',
            style: Theme.of(
              context,
            ).textTheme.bodySmall?.copyWith(color: Colors.white60, height: 1.7),
          ),
        ),
        const SizedBox(height: AppDimensions.spaceMd),
        const _SocialRow(),
      ],
    );
  }
}

class _SocialRow extends StatelessWidget {
  const _SocialRow();

  static const _links = <Map<String, dynamic>>[
    {'icon': Icons.code_rounded, 'label': 'GitHub'},
    {'icon': Icons.work_outline_rounded, 'label': 'LinkedIn'},
    {'icon': Icons.camera_alt_outlined, 'label': 'Instagram'},
    {'icon': Icons.alternate_email_rounded, 'label': 'X / Twitter'},
  ];

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: AppDimensions.spaceSm,
      children: [
        for (final l in _links)
          Tooltip(
            message: l['label'] as String,
            child: InkWell(
              onTap: () {},
              borderRadius: BorderRadius.circular(AppDimensions.radiusSm),
              child: Container(
                width: 38,
                height: 38,
                margin: const EdgeInsets.only(right: 4),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.07),
                  borderRadius: BorderRadius.circular(AppDimensions.radiusSm),
                  border: Border.all(color: Colors.white12),
                ),
                child: Icon(
                  l['icon'] as IconData,
                  size: 18,
                  color: Colors.white70,
                ),
              ),
            ),
          ),
      ],
    );
  }
}

class _LinkColumn extends StatelessWidget {
  const _LinkColumn({required this.title, this.services = false});

  final String title;
  final bool services;

  @override
  Widget build(BuildContext context) {
    final entries = services
        ? const [
            'Mobile App Development',
            'Web Application Development',
            'Backend Development',
            'Data Analysis',
            'Firebase Solutions',
            'Startup Solutions',
          ]
        : AppRoutes.labelToRoute.keys
              .where((k) => k != 'Home')
              .toList(growable: false);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title.toUpperCase(),
          style: Theme.of(context).textTheme.labelSmall?.copyWith(
            color: AppColors.tealGreen,
            fontWeight: FontWeight.w700,
            letterSpacing: 1.4,
          ),
        ),
        const SizedBox(height: AppDimensions.spaceMd),
        for (final e in entries)
          Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: InkWell(
              onTap: () {
                if (services) {
                  Get.toNamed(AppRoutes.services);
                } else {
                  Get.toNamed(AppRoutes.labelToRoute[e] ?? AppRoutes.home);
                }
              },
              child: Text(
                e,
                style: Theme.of(
                  context,
                ).textTheme.bodySmall?.copyWith(color: Colors.white60),
              ),
            ),
          ),
      ],
    );
  }
}

class _ContactColumn extends StatelessWidget {
  const _ContactColumn();

  @override
  Widget build(BuildContext context) {
    const rows = [
      (Icons.mail_outline_rounded, 'hello@softkormo.com'),
      (Icons.phone_outlined, '+880 1700 000000'),
      (Icons.location_on_outlined, 'Dhaka, Bangladesh'),
      (Icons.schedule_rounded, 'Sun – Thu, 9:00 – 18:00 (GMT+6)'),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'CONTACT',
          style: Theme.of(context).textTheme.labelSmall?.copyWith(
            color: AppColors.tealGreen,
            fontWeight: FontWeight.w700,
            letterSpacing: 1.4,
          ),
        ),
        const SizedBox(height: AppDimensions.spaceMd),
        for (final r in rows)
          Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: Row(
              children: [
                Icon(r.$1, size: 17, color: AppColors.tealGreen),
                const SizedBox(width: 10),
                Flexible(
                  child: Text(
                    r.$2,
                    style: Theme.of(
                      context,
                    ).textTheme.bodySmall?.copyWith(color: Colors.white70),
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }
}
