import 'package:flutter/material.dart';

import '../../core/constants/app_colors.dart';
import '../../core/constants/app_dimensions.dart';

/// Widget-built project preview mockups â€” no images, no blank areas.
///
/// Each [type] draws an attractive, on-brand visual:
///  * phoneManagement â€” phone frame + operations app UI
///  * chartsDashboard â€” analytics dashboard with bar/line charts + KPIs
///  * browserSaaS     â€” browser frame + SaaS dashboard
///  * phoneShopping   â€” phone frame + e-commerce storefront
///  * apiCode         â€” API/code architecture visual
///  * dataViz         â€” data-visualization widgets (donut, area, KPIs)
class ProjectPreview extends StatelessWidget {
  const ProjectPreview({
    super.key,
    required this.type,
    this.accent = AppColors.deepBlue,
    this.compact = false,
  });

  final String type;
  final Color accent;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final radius = BorderRadius.circular(AppDimensions.radiusMd);

    final Widget body;
    switch (type) {
      case 'phoneManagement':
        body = const _PhoneMockBox(child: _PhoneManagementUI());
        break;
      case 'chartsDashboard':
        body = const _ChartsDashboardUI();
        break;
      case 'phoneShopping':
        body = const _PhoneMockBox(child: _PhoneShoppingUI());
        break;
      case 'apiCode':
        body = const _ApiCodeUI();
        break;
      case 'dataViz':
        body = const _DataVizUI();
        break;
      case 'browserSaaS':
      default:
        body = const _BrowserSaaSUI();
    }

    return Container(
      width: double.infinity,
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        borderRadius: radius,
        gradient: LinearGradient(
          colors: [
            accent.withValues(alpha: 0.16),
            AppColors.deepBlueDark.withValues(alpha: 0.10),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        border: Border.all(color: accent.withValues(alpha: 0.25)),
      ),
      child: ConstrainedBox(
        // Aspect-driven height with a generous minimum so the internal
        // mockups (phone UIs, dashboards, code panes) never overflow, no
        // matter how narrow the card gets. ConstrainedBox+AspectRatio (not
        // LayoutBuilder) keeps intrinsics intact for IntrinsicHeight cards.
        constraints: const BoxConstraints(minHeight: 240),
        child: AspectRatio(
          aspectRatio: compact ? 1.55 : 1.62,
          child: _buildStack(context, body, accent),
        ),
      ),
    );
  }

  Widget _buildStack(BuildContext context, Widget body, Color accent) {
    return Stack(
      fit: StackFit.expand,
      children: [
        // blueprint grid backdrop
        CustomPaint(painter: _PreviewGridPainter(accent)),
        // soft glow
        Positioned(
          top: -30,
          right: -20,
          child: Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(
                colors: [accent.withValues(alpha: 0.25), Colors.transparent],
              ),
            ),
          ),
        ),
        Center(
          child: Padding(padding: const EdgeInsets.all(14), child: body),
        ),
      ],
    );
  }
}

/// Design-size frame for the fixed-composition phone mockups.
///
/// The phone rows are built from fixed widths (118px frame + 16/14px gap +
/// 96/98px side card = 230px total), which overflows narrower preview
/// contexts: the 3-column laptop grid gives an inner width of 228px
/// (1024–1439px windows) and the detail dialog drops to 188px on a 360px
/// screen — the source of the reported "RenderFlex overflowed by 6.4
/// pixels" at project_preview.dart:274.
///
/// Rendering at the 230×212 design size inside a [FittedBox] scales the
/// whole mock proportionally to whatever space exists, so this decorative
/// art can never trigger a RenderFlex overflow at any width, while keeping
/// its exact proportions (unlike Flexible/Expanded, which would starve the
/// side cards and reflow the layout).
class _PhoneMockBox extends StatelessWidget {
  const _PhoneMockBox({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return FittedBox(
      fit: BoxFit.scaleDown,
      child: SizedBox(width: 230, height: 212, child: child),
    );
  }
}

// ======================================================= shared primitives

class _WindowChrome extends StatelessWidget {
  const _WindowChrome({this.label});

  final String? label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.85),
        border: Border(
          bottom: BorderSide(color: Colors.black.withValues(alpha: 0.06)),
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 8,
            height: 8,
            decoration: const BoxDecoration(
              color: Color(0xFFFF5F57),
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 5),
          Container(
            width: 8,
            height: 8,
            decoration: const BoxDecoration(
              color: Color(0xFFFEBC2E),
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 5),
          Container(
            width: 8,
            height: 8,
            decoration: const BoxDecoration(
              color: Color(0xFF28C840),
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Container(
              height: 14,
              decoration: BoxDecoration(
                color: AppColors.background,
                borderRadius: BorderRadius.circular(7),
              ),
              alignment: Alignment.centerLeft,
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Text(
                label ?? 'app.softkormo.com',
                style: const TextStyle(fontSize: 8, color: AppColors.textMuted),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _MiniBar extends StatelessWidget {
  const _MiniBar({required this.value, required this.color});

  final double value; // 0..1
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: LayoutBuilder(
        builder: (context, constraints) {
          final maxH = constraints.maxHeight.isFinite
              ? constraints.maxHeight
              : 60.0;
          return Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              width: 10,
              height: maxH * value.clamp(0.05, 1.0),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [color, color.withValues(alpha: 0.55)],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
                borderRadius: BorderRadius.circular(3),
              ),
            ),
          );
        },
      ),
    );
  }
}

// =========================================================== phone mocks

class _PhoneFrame extends StatelessWidget {
  const _PhoneFrame({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 118,
      height: double.infinity,
      padding: const EdgeInsets.all(5),
      decoration: BoxDecoration(
        color: const Color(0xFF0F172A),
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.35),
            blurRadius: 16,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Container(
        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(13),
        ),
        child: Stack(
          children: [
            Positioned.fill(child: child),
            Positioned(
              top: 4,
              left: 0,
              right: 0,
              child: Center(
                child: Container(
                  width: 38,
                  height: 7,
                  decoration: BoxDecoration(
                    color: const Color(0xFF0F172A),
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _PhoneManagementUI extends StatelessWidget {
  const _PhoneManagementUI();

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        _PhoneFrame(
          child: Padding(
            padding: const EdgeInsets.only(top: 16, left: 8, right: 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Dashboard',
                  style: TextStyle(fontSize: 9, fontWeight: FontWeight.w800),
                ),
                const SizedBox(height: 7),
                Container(
                  padding: const EdgeInsets.all(7),
                  decoration: BoxDecoration(
                    gradient: AppColors.brandGradient,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Revenue',
                        style: TextStyle(fontSize: 7, color: Colors.white70),
                      ),
                      Text(
                        '\$48,920',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.white,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 7),
                for (final (label, color) in const [
                  ('Tasks', AppColors.tealGreen),
                  ('Invoices', AppColors.orange),
                  ('Team', AppColors.purple),
                ])
                  Container(
                    margin: const EdgeInsets.only(bottom: 5),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 6,
                      vertical: 5,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.background,
                      borderRadius: BorderRadius.circular(6),
                      border: Border.all(color: AppColors.border),
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 10,
                          height: 10,
                          decoration: BoxDecoration(
                            color: color,
                            borderRadius: BorderRadius.circular(3),
                          ),
                        ),
                        const SizedBox(width: 5),
                        Expanded(
                          child: Text(
                            label,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontSize: 7.5,
                              color: AppColors.textSecondary,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        const Icon(
                          Icons.chevron_right_rounded,
                          size: 10,
                          color: AppColors.textMuted,
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          ),
        ),
        const SizedBox(width: 16),
        // floating stat card
        Container(
          width: 96,
          padding: const EdgeInsets.all(9),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: AppColors.tealGreen.withValues(alpha: 0.4),
            ),
            boxShadow: [
              BoxShadow(
                color: AppColors.deepBlue.withValues(alpha: 0.18),
                blurRadius: 14,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.check_circle_rounded,
                size: 16,
                color: AppColors.tealGreen,
              ),
              const SizedBox(height: 5),
              const Text(
                '24',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w800,
                  color: AppColors.textPrimary,
                ),
              ),
              Text(
                'tasks done today',
                style: TextStyle(fontSize: 7.5, color: AppColors.textMuted),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _PhoneShoppingUI extends StatelessWidget {
  const _PhoneShoppingUI();

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        _PhoneFrame(
          child: Padding(
            padding: const EdgeInsets.only(top: 16, left: 7, right: 7),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Expanded(
                      child: Text(
                        'Discover',
                        style: TextStyle(
                          fontSize: 9,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.all(3),
                      decoration: BoxDecoration(
                        color: AppColors.magenta.withValues(alpha: 0.12),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.shopping_bag_rounded,
                        size: 9,
                        color: AppColors.magenta,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Container(
                  height: 14,
                  decoration: BoxDecoration(
                    color: AppColors.background,
                    borderRadius: BorderRadius.circular(7),
                    border: Border.all(color: AppColors.border),
                  ),
                  alignment: Alignment.centerLeft,
                  padding: const EdgeInsets.symmetric(horizontal: 6),
                  child: const Text(
                    'Search productsâ€¦',
                    style: TextStyle(fontSize: 7, color: AppColors.textMuted),
                  ),
                ),
                const SizedBox(height: 7),
                Row(
                  children: [
                    for (final color in const [
                      AppColors.deepBlue,
                      AppColors.magenta,
                    ]) ...[
                      Expanded(
                        child: Container(
                          height: 44,
                          margin: const EdgeInsets.only(right: 4),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [color, color.withValues(alpha: 0.55)],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            borderRadius: BorderRadius.circular(7),
                          ),
                          child: const Align(
                            alignment: Alignment.bottomLeft,
                            child: Padding(
                              padding: EdgeInsets.all(4),
                              child: Text(
                                '\$129',
                                style: TextStyle(
                                  fontSize: 8,
                                  color: Colors.white,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
                const SizedBox(height: 7),
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: AppColors.tealGreen.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(7),
                      border: Border.all(
                        color: AppColors.tealGreen.withValues(alpha: 0.4),
                      ),
                    ),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.shopping_cart_rounded,
                          size: 12,
                          color: AppColors.tealGreen,
                        ),
                        const SizedBox(width: 4),
                        const Expanded(
                          child: Text(
                            'Cart · 3 items',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 7.5,
                              fontWeight: FontWeight.w700,
                              color: AppColors.textPrimary,
                            ),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 3,
                            vertical: 3,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.tealGreen,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Text(
                            'Checkout',
                            style: TextStyle(
                              fontSize: 6,
                              color: Colors.white,
                              fontWeight: FontWeight.w700,
                            ),
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
        const SizedBox(width: 14),
        Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            for (final (icon, label, color) in const [
              (Icons.local_shipping_rounded, 'Fast delivery', AppColors.orange),
              (Icons.verified_rounded, 'Secure pay', AppColors.tealGreen),
              (Icons.star_rounded, '4.9 rating', AppColors.purple),
            ])
              Container(
                width: 98,
                margin: const EdgeInsets.only(bottom: 7),
                padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: AppColors.border),
                  boxShadow: const [
                    BoxShadow(
                      color: Color(0x140B3C88),
                      blurRadius: 10,
                      offset: Offset(0, 4),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Icon(icon, size: 12, color: color),
                    const SizedBox(width: 5),
                    Expanded(
                      child: Text(
                        label,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 7.5,
                          fontWeight: FontWeight.w700,
                          color: AppColors.textPrimary,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ],
    );
  }
}

// ========================================================= browser mocks

class _BrowserSaaSUI extends StatelessWidget {
  const _BrowserSaaSUI();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(9),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.20),
            blurRadius: 18,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        children: [
          const _WindowChrome(label: 'app.softkormo.com/workspace'),
          Expanded(
            child: Row(
              children: [
                // sidebar
                Container(
                  width: 54,
                  color: const Color(0xFFF5F8FF),
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: Column(
                    children: [
                      Container(
                        width: 26,
                        height: 26,
                        decoration: BoxDecoration(
                          gradient: AppColors.brandGradient,
                          borderRadius: BorderRadius.circular(7),
                        ),
                        child: const Icon(
                          Icons.bolt_rounded,
                          size: 14,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 10),
                      for (var i = 0; i < 5; i++)
                        Container(
                          width: 34,
                          height: 8,
                          margin: const EdgeInsets.only(bottom: 8),
                          decoration: BoxDecoration(
                            color: i == 0
                                ? AppColors.deepBlue.withValues(alpha: 0.75)
                                : AppColors.border,
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                    ],
                  ),
                ),
                // content
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(9),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Expanded(
                              child: Text(
                                'Workspace overview',
                                style: TextStyle(
                                  fontSize: 9,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                gradient: AppColors.accentGradient,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: const Text(
                                '+ New project',
                                style: TextStyle(
                                  fontSize: 7,
                                  color: Colors.white,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            for (final (label, value, color) in const [
                              ('Seats', '3,120', AppColors.deepBlue),
                              ('MRR', '\$28.4k', AppColors.tealGreen),
                              ('Churn', '1.9%', AppColors.purple),
                            ])
                              Expanded(
                                child: Container(
                                  margin: const EdgeInsets.only(right: 6),
                                  padding: const EdgeInsets.all(6),
                                  decoration: BoxDecoration(
                                    color: AppColors.background,
                                    borderRadius: BorderRadius.circular(7),
                                    border: Border.all(color: AppColors.border),
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        label,
                                        style: const TextStyle(
                                          fontSize: 7,
                                          color: AppColors.textMuted,
                                        ),
                                      ),
                                      Text(
                                        value,
                                        style: TextStyle(
                                          fontSize: 11,
                                          fontWeight: FontWeight.w800,
                                          color: color,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Expanded(
                          child: Container(
                            padding: const EdgeInsets.all(7),
                            decoration: BoxDecoration(
                              color: const Color(0xFFF8FAFF),
                              borderRadius: BorderRadius.circular(7),
                              border: Border.all(color: AppColors.border),
                            ),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                _MiniBar(
                                  value: .45,
                                  color: AppColors.deepBlue.withValues(
                                    alpha: .85,
                                  ),
                                ),
                                _MiniBar(value: .7, color: AppColors.tealGreen),
                                _MiniBar(value: .35, color: AppColors.purple),
                                _MiniBar(value: .9, color: AppColors.orange),
                                _MiniBar(value: .6, color: AppColors.magenta),
                                _MiniBar(value: .78, color: AppColors.deepBlue),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ChartsDashboardUI extends StatelessWidget {
  const _ChartsDashboardUI();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: const Color(0xFF0B1730),
        borderRadius: BorderRadius.circular(9),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.30),
            blurRadius: 18,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Expanded(
                child: Text(
                  'Analytics',
                  style: TextStyle(
                    fontSize: 9,
                    fontWeight: FontWeight.w800,
                    color: Colors.white,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
                decoration: BoxDecoration(
                  color: AppColors.tealGreen.withValues(alpha: 0.22),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Text(
                  'â— Live',
                  style: TextStyle(
                    fontSize: 7,
                    color: AppColors.tealGreen,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 7),
          Row(
            children: [
              for (final (label, value, color) in const [
                ('Visitors', '84.2k', AppColors.tealGreen),
                ('Revenue', '\$92.7k', AppColors.orange),
                ('Orders', '5,411', AppColors.purple),
              ])
                Expanded(
                  child: Container(
                    margin: const EdgeInsets.only(right: 6),
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.06),
                      borderRadius: BorderRadius.circular(7),
                      border: Border.all(color: Colors.white12),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          label,
                          style: const TextStyle(
                            fontSize: 7,
                            color: Colors.white54,
                          ),
                        ),
                        Text(
                          value,
                          style: TextStyle(
                            fontSize: 11.5,
                            fontWeight: FontWeight.w800,
                            color: color,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 8),
          Expanded(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // bar chart
                Expanded(
                  flex: 3,
                  child: Container(
                    padding: const EdgeInsets.fromLTRB(7, 7, 7, 4),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.05),
                      borderRadius: BorderRadius.circular(7),
                      border: Border.all(color: Colors.white12),
                    ),
                    child: Column(
                      children: [
                        const Expanded(
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              _MiniBar(
                                value: .35,
                                color: AppColors.deepBlueLight,
                              ),
                              _MiniBar(value: .55, color: AppColors.tealGreen),
                              _MiniBar(
                                value: .42,
                                color: AppColors.deepBlueLight,
                              ),
                              _MiniBar(value: .78, color: AppColors.orange),
                              _MiniBar(value: .62, color: AppColors.tealGreen),
                              _MiniBar(value: .92, color: AppColors.magenta),
                              _MiniBar(value: .7, color: AppColors.purple),
                            ],
                          ),
                        ),
                        const SizedBox(height: 4),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            for (final d in const [
                              'M',
                              'T',
                              'W',
                              'T',
                              'F',
                              'S',
                              'S',
                            ])
                              Text(
                                d,
                                style: const TextStyle(
                                  fontSize: 6,
                                  color: Colors.white38,
                                ),
                              ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 7),
                // donut
                Expanded(
                  flex: 2,
                  child: Container(
                    padding: const EdgeInsets.all(7),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.05),
                      borderRadius: BorderRadius.circular(7),
                      border: Border.all(color: Colors.white12),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Channels',
                          style: TextStyle(
                            fontSize: 7,
                            color: Colors.white54,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Center(
                          child: SizedBox(
                            width: 46,
                            height: 46,
                            child: Stack(
                              fit: StackFit.expand,
                              children: [
                                CircularProgressIndicator(
                                  value: 0.68,
                                  strokeWidth: 7,
                                  backgroundColor: Colors.white12,
                                  valueColor: const AlwaysStoppedAnimation(
                                    AppColors.tealGreen,
                                  ),
                                ),
                                Center(
                                  child: Text(
                                    '68%',
                                    style: TextStyle(
                                      fontSize: 9,
                                      fontWeight: FontWeight.w800,
                                      color: Colors.white,
                                    ),
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
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _DataVizUI extends StatelessWidget {
  const _DataVizUI();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(9),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.22),
            blurRadius: 18,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 18,
                height: 18,
                decoration: BoxDecoration(
                  gradient: AppColors.vibrantGradient,
                  borderRadius: BorderRadius.circular(5),
                ),
                child: const Icon(
                  Icons.insights_rounded,
                  size: 11,
                  color: Colors.white,
                ),
              ),
              const SizedBox(width: 6),
              const Expanded(
                child: Text(
                  'Data Intelligence',
                  style: TextStyle(fontSize: 9, fontWeight: FontWeight.w800),
                ),
              ),
              const Icon(
                Icons.calendar_today_rounded,
                size: 9,
                color: AppColors.textMuted,
              ),
              const SizedBox(width: 4),
              const Text(
                'Last 30 days',
                style: TextStyle(fontSize: 7, color: AppColors.textMuted),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Expanded(
            child: Row(
              children: [
                // area-style chart
                Expanded(
                  flex: 3,
                  child: Container(
                    padding: const EdgeInsets.all(7),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF8FAFF),
                      borderRadius: BorderRadius.circular(7),
                      border: Border.all(color: AppColors.border),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Revenue trend',
                          style: TextStyle(
                            fontSize: 7,
                            color: AppColors.textMuted,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 5),
                        Expanded(
                          child: CustomPaint(painter: _AreaChartPainter()),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 7),
                // KPI column
                Expanded(
                  flex: 2,
                  child: Column(
                    children: [
                      for (final (label, value, delta, color) in const [
                        ('Conversion', '4.8%', '+0.9', AppColors.tealGreen),
                        ('Retention', '92%', '+3.1', AppColors.deepBlue),
                        ('AOV', '\$86', '+12', AppColors.orange),
                      ])
                        Expanded(
                          child: Container(
                            width: double.infinity,
                            margin: const EdgeInsets.only(bottom: 6),
                            padding: const EdgeInsets.all(6),
                            decoration: BoxDecoration(
                              color: const Color(0xFFF8FAFF),
                              borderRadius: BorderRadius.circular(7),
                              border: Border.all(color: AppColors.border),
                            ),
                            child: FittedBox(
                              fit: BoxFit.scaleDown,
                              alignment: Alignment.centerLeft,
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    label,
                                    style: const TextStyle(
                                      fontSize: 7,
                                      color: AppColors.textMuted,
                                    ),
                                  ),
                                  Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(
                                        value,
                                        style: TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w800,
                                          color: color,
                                        ),
                                      ),
                                      const SizedBox(width: 4),
                                      Text(
                                        delta,
                                        style: TextStyle(
                                          fontSize: 7,
                                          fontWeight: FontWeight.w700,
                                          color: color,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ApiCodeUI extends StatelessWidget {
  const _ApiCodeUI();

  static const _lines = [
    ('GET', '/api/v2/projects', '200', AppColors.tealGreen),
    ('POST', '/api/v2/orders', '201', AppColors.orange),
    ('GET', '/api/v2/analytics', '200', AppColors.tealGreen),
    ('PUT', '/api/v2/users/:id', '200', AppColors.tealGreen),
    ('DELETE', '/api/v2/sessions', '401', AppColors.magenta),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: const Color(0xFF0B1730),
        borderRadius: BorderRadius.circular(9),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.30),
            blurRadius: 18,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 6),
            color: Colors.white.withValues(alpha: 0.05),
            child: Row(
              children: [
                Container(
                  width: 8,
                  height: 8,
                  decoration: const BoxDecoration(
                    color: AppColors.tealGreen,
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 6),
                const Expanded(
                  child: Text(
                    'api-gateway Â· v2',
                    style: TextStyle(
                      fontSize: 8,
                      color: Colors.white70,
                      fontWeight: FontWeight.w600,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const Text(
                  '99.98% uptime',
                  style: TextStyle(fontSize: 7, color: AppColors.tealGreen),
                ),
              ],
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  for (final (verb, path, code, color) in _lines)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 6),
                      child: Row(
                        children: [
                          Container(
                            width: 40,
                            padding: const EdgeInsets.symmetric(vertical: 3),
                            decoration: BoxDecoration(
                              color: color.withValues(alpha: 0.18),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            alignment: Alignment.center,
                            child: Text(
                              verb,
                              style: TextStyle(
                                fontSize: 7,
                                color: color,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                          ),
                          const SizedBox(width: 7),
                          Expanded(
                            child: Text(
                              path,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                fontFamily: 'monospace',
                                fontSize: 8,
                                color: Colors.white70,
                              ),
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 6,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.08),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              code,
                              style: TextStyle(
                                fontSize: 7,
                                color: color,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  const Spacer(),
                  Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: Colors.black.withValues(alpha: 0.35),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: const Row(
                      children: [
                        Text(
                          '> ',
                          style: TextStyle(
                            fontSize: 8,
                            color: AppColors.tealGreen,
                            fontFamily: 'monospace',
                          ),
                        ),
                        Expanded(
                          child: Text(
                            'curl -H "Authorization: â€¢â€¢" /api/v2',
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 8,
                              color: Colors.white70,
                              fontFamily: 'monospace',
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 6,
                          height: 10,
                          child: ColoredBox(color: AppColors.tealGreen),
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
    );
  }
}

// ============================================================== painters

class _PreviewGridPainter extends CustomPainter {
  _PreviewGridPainter(this.accent);

  final Color accent;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = accent.withValues(alpha: 0.10)
      ..strokeWidth = 1;

    const gap = 22.0;
    for (double x = 0; x < size.width; x += gap) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), paint);
    }
    for (double y = 0; y < size.height; y += gap) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }
  }

  @override
  bool shouldRepaint(_PreviewGridPainter old) => old.accent != accent;
}

class _AreaChartPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final path = Path()
      ..moveTo(0, size.height * 0.85)
      ..cubicTo(
        size.width * 0.2,
        size.height * 0.7,
        size.width * 0.3,
        size.height * 0.35,
        size.width * 0.5,
        size.height * 0.5,
      )
      ..cubicTo(
        size.width * 0.7,
        size.height * 0.65,
        size.width * 0.8,
        size.height * 0.2,
        size.width,
        size.height * 0.25,
      );

    final fill = Path.from(path)
      ..lineTo(size.width, size.height)
      ..lineTo(0, size.height)
      ..close();

    canvas.drawPath(
      fill,
      Paint()
        ..shader = LinearGradient(
          colors: [
            AppColors.tealGreen.withValues(alpha: 0.35),
            AppColors.tealGreen.withValues(alpha: 0.02),
          ],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ).createShader(Offset.zero & size),
    );

    canvas.drawPath(
      path,
      Paint()
        ..color = AppColors.tealGreen
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2
        ..strokeCap = StrokeCap.round,
    );

    // secondary line
    final path2 = Path()
      ..moveTo(0, size.height * 0.6)
      ..cubicTo(
        size.width * 0.25,
        size.height * 0.5,
        size.width * 0.45,
        size.height * 0.8,
        size.width * 0.7,
        size.height * 0.6,
      )
      ..cubicTo(
        size.width * 0.85,
        size.height * 0.5,
        size.width * 0.9,
        size.height * 0.75,
        size.width,
        size.height * 0.65,
      );

    canvas.drawPath(
      path2,
      Paint()
        ..color = AppColors.deepBlue.withValues(alpha: 0.75)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.6
        ..strokeCap = StrokeCap.round,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
