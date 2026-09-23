import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../core/constants/app_colors.dart';
import '../../core/constants/app_dimensions.dart';
import '../../core/routes/app_routes.dart';
import 'brand_logo.dart';

/// Mobile navigation drawer with animated menu items.
class CustomDrawer extends StatelessWidget {
  const CustomDrawer({super.key});

  void _navigate(String route) {
    Get.back(); // close drawer first
    Get.toNamed(route);
  }

  @override
  Widget build(BuildContext context) {
    final current = Get.currentRoute;

    return Drawer(
      backgroundColor: AppColors.surface,
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.all(AppDimensions.spaceLg),
              child: Row(
                children: [
                  BrandLogo(height: 36),
                  const Spacer(),
                  IconButton(
                    onPressed: () => Get.back(),
                    icon: const Icon(Icons.close_rounded),
                    tooltip: 'Close menu',
                  ),
                ],
              ),
            ),
            const Divider(height: 1),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(
                  vertical: AppDimensions.spaceMd,
                ),
                children: [
                  for (final entry in AppRoutes.labelToRoute.entries)
                    _DrawerItem(
                      label: entry.key,
                      icon: _iconFor(entry.key),
                      active: current == entry.value,
                      onTap: () => _navigate(entry.value),
                    ),
                ],
              ),
            ),
            const Divider(height: 1),
            Padding(
              padding: const EdgeInsets.all(AppDimensions.spaceLg),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Smart Software, Reliable Service',
                    style: Theme.of(context).textTheme.labelSmall,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'hello@softkormo.com',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: AppColors.deepBlue,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  static IconData _iconFor(String label) {
    switch (label) {
      case 'Home':
        return Icons.home_outlined;
      case 'About':
        return Icons.corporate_fare_outlined;
      case 'Services':
        return Icons.widgets_outlined;
      case 'Startup Solutions':
        return Icons.rocket_launch_outlined;
      case 'Projects':
        return Icons.grid_view_rounded;
      case 'Contact':
        return Icons.mail_outline_rounded;
      default:
        return Icons.circle_outlined;
    }
  }
}

class _DrawerItem extends StatelessWidget {
  const _DrawerItem({
    required this.label,
    required this.icon,
    required this.active,
    required this.onTap,
  });

  final String label;
  final IconData icon;
  final bool active;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      leading: Icon(
        icon,
        color: active ? AppColors.deepBlue : AppColors.textSecondary,
        size: 22,
      ),
      title: Text(
        label,
        style: TextStyle(
          fontWeight: active ? FontWeight.w700 : FontWeight.w500,
          color: active ? AppColors.deepBlue : AppColors.textPrimary,
        ),
      ),
      trailing: active
          ? Container(
              width: 6,
              height: 6,
              decoration: const BoxDecoration(
                color: AppColors.tealGreen,
                shape: BoxShape.circle,
              ),
            )
          : null,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppDimensions.radiusSm),
      ),
      tileColor: active ? AppColors.tealGreen.withValues(alpha: 0.08) : null,
      contentPadding: const EdgeInsets.symmetric(
        horizontal: AppDimensions.spaceLg,
      ),
    );
  }
}
