import 'dart:ui' show ImageFilter;

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../core/constants/app_colors.dart';
import '../../core/constants/app_dimensions.dart';
import '../../core/routes/app_routes.dart';
import '../../core/utils/responsive_utils.dart';
import '../../core/widgets/gradient_button.dart';
import '../../core/widgets/page_scroll_shell.dart';
import 'brand_logo.dart';

/// Glassmorphism navigation bar. On <1024px it collapses to a menu button
/// that opens [CustomDrawer].
class CustomAppBar extends StatefulWidget {
  const CustomAppBar({super.key, this.onMenuPressed});

  final VoidCallback? onMenuPressed;

  @override
  State<CustomAppBar> createState() => _CustomAppBarState();
}

class _CustomAppBarState extends State<CustomAppBar> {
  int _hovered = -1;

  String get _currentRoute => Get.currentRoute;

  @override
  Widget build(BuildContext context) {
    final isWide = Responsive.useDesktopNav(context);
    final scrolled = ScrollUiScope.maybeOf(context)?.scrolled;
    if (scrolled == null) {
      // Rendered outside a PageScrollShell (tests, previews): flat bar.
      return _bar(context, isWide, scrolled: false);
    }
    return ValueListenableBuilder<bool>(
      valueListenable: scrolled,
      builder: (context, isScrolled, _) =>
          _bar(context, isWide, scrolled: isScrolled),
    );
  }

  /// The pinned glass navbar; [scrolled] flips the soft shadow on/off.
  Widget _bar(BuildContext context, bool isWide, {required bool scrolled}) {
    // The same value goes to `scrolledUnderElevation` so this signal wins
    // over the framework's scrolled-under detection — and because M3's
    // default `shadowColor` is transparent (an invisible shadow) unless it
    // is set explicitly.
    final elevation = scrolled ? 6.0 : 0.0;

    return SliverAppBar(
      pinned: true,
      // Deliberately NOT `floating: true`. With pinned + floating + bottom
      // the framework sets collapsedHeight = bottom + topPadding (≈1px),
      // and lays the header child out at max(1, 77 - scrollOffset): while
      // the user scrolls, the toolbar is squeezed from 76px toward 0 and
      // the nav items RenderFlex-overflow (reported: 8.5px in Poppins).
      // Plain `pinned` keeps minExtent == maxExtent == 77, so the toolbar
      // is always 76px, the bar never collapses, and it stays fixed at the
      // top at every scroll offset ("always visible" per spec).
      elevation: elevation,
      scrolledUnderElevation: elevation,
      shadowColor: Colors.black.withValues(alpha: 0.16),
      backgroundColor: AppColors.glassHeader,
      // Transparent tint: applySurfaceTint() leaves it untouched, so the
      // glass fill never darkens as the elevation animates.
      surfaceTintColor: Colors.transparent,
      // Glass effect: blur the page behind the bar — flexibleSpace paints
      // beneath the toolbar and the 1px divider, exactly bar-sized.
      flexibleSpace: ClipRect(
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 14, sigmaY: 14),
          child: const SizedBox.expand(),
        ),
      ),
      toolbarHeight: 76,
      title: BrandLogo(height: 38),
      titleSpacing: 24,
      actions: [
        if (isWide) ...[
          for (var i = 0; i < AppRoutes.labelToRoute.length; i++)
            _NavItem(
              label: AppRoutes.labelToRoute.keys.elementAt(i),
              route: AppRoutes.labelToRoute.values.elementAt(i),
              active:
                  _currentRoute == AppRoutes.labelToRoute.values.elementAt(i),
              hovered: _hovered == i,
              onHover: (h) => setState(() => _hovered = h ? i : -1),
              onTap: () =>
                  Get.toNamed(AppRoutes.labelToRoute.values.elementAt(i)),
            ),
          const SizedBox(width: AppDimensions.spaceMd),
          // The Material toolbar lays its trailing slot out with unbounded
          // width, so cap the CTA: the button hugs its label but can never
          // exceed this bound (the label ellipsizes instead of asserting).
          // Shown only at >=1440: nav items + logo + CTA need ~1170px under
          // the test font — at laptop widths the button pushed the toolbar
          // Row into a RenderFlex overflow (the reported 167px in Poppins).
          // Between 1024–1439 the nav's "Contact" link covers the CTA.
          if (MediaQuery.sizeOf(context).width >= Responsive.desktop) ...[
            ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 240),
              child: GradientButton(
                label: 'Get Free Consultation',
                fontSize: 13,
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 12,
                ),
                onPressed: () => Get.toNamed(AppRoutes.contact),
              ),
            ),
            const SizedBox(width: AppDimensions.spaceMd),
          ],
        ] else if (widget.onMenuPressed != null)
          IconButton(
            onPressed: widget.onMenuPressed,
            icon: const Icon(Icons.menu_rounded, size: 28),
            tooltip: 'Open menu',
          ),
      ],
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(1),
        child: Container(
          height: 1,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Colors.transparent,
                AppColors.deepBlue.withValues(alpha: 0.18),
                Colors.transparent,
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  const _NavItem({
    required this.label,
    required this.route,
    required this.active,
    required this.hovered,
    required this.onHover,
    required this.onTap,
  });

  final String label;
  final String route;
  final bool active;
  final bool hovered;
  final ValueChanged<bool> onHover;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final color = active
        ? AppColors.deepBlue
        : hovered
        ? AppColors.tealGreen
        : AppColors.textSecondary;

    return MouseRegion(
      onEnter: (_) => onHover(true),
      onExit: (_) => onHover(false),
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: onTap,
        behavior: HitTestBehavior.opaque,
        child: AnimatedContainer(
          duration: AppDimensions.fast,
          curve: Curves.easeOut,
          padding: const EdgeInsets.symmetric(
            horizontal: 10,
            vertical: AppDimensions.spaceSm + 2,
          ),
          decoration: BoxDecoration(
            color: hovered || active
                ? AppColors.tealGreen.withValues(alpha: 0.09)
                : Colors.transparent,
            borderRadius: BorderRadius.circular(AppDimensions.radiusSm),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: active ? FontWeight.w700 : FontWeight.w500,
                  color: color,
                ),
              ),
              const SizedBox(height: 3),
              AnimatedContainer(
                duration: AppDimensions.fast,
                height: 2,
                width: active ? 22 : 0,
                decoration: BoxDecoration(
                  gradient: AppColors.accentGradient,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
