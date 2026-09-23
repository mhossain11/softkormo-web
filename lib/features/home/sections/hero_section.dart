import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_dimensions.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/routes/app_routes.dart';
import '../../../core/utils/responsive_utils.dart';
import '../../../core/widgets/gradient_button.dart';

/// Full-viewport hero: animated gradient mesh, glow orbs, headline with
/// staggered entrance, glass stat cards and a glass dashboard illustration
/// with floating tech badges (Flutter, Firebase, Web App, Data Analytics).
class HeroSection extends StatefulWidget {
  const HeroSection({super.key});

  @override
  State<HeroSection> createState() => _HeroSectionState();
}

class _HeroSectionState extends State<HeroSection>
    with SingleTickerProviderStateMixin {
  late final AnimationController _intro;
  late final Animation<double> _fade;
  late final Animation<Offset> _slide;

  @override
  void initState() {
    super.initState();
    _intro = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    )..forward();
    _fade = CurvedAnimation(parent: _intro, curve: Curves.easeOut);
    _slide = Tween<Offset>(
      begin: const Offset(0, 0.35),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _intro, curve: Curves.easeOutCubic));
  }

  @override
  void dispose() {
    _intro.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isWide = MediaQuery.sizeOf(context).width >= 1024;
    final headlineSize = Responsive.fluid(context, min: 34, max: 68);

    return Container(
      width: double.infinity,
      clipBehavior: Clip.antiAlias,
      decoration: const BoxDecoration(gradient: AppColors.heroGradient),
      child: Stack(
        children: [
          // ------------------------------------------------- glow orbs
          Positioned(
            top: -140,
            right: -80,
            child: _orb(AppColors.tealGreen.withValues(alpha: 0.35), 340),
          ),
          Positioned(
            bottom: -160,
            left: -100,
            child: _orb(AppColors.magenta.withValues(alpha: 0.25), 380),
          ),
          Positioned(
            top: 120,
            left: MediaQuery.sizeOf(context).width * 0.42,
            child: _orb(AppColors.orange.withValues(alpha: 0.15), 260),
          ),

          // ------------------------------------------------ content
          Center(
            child: ConstrainedBox(
              constraints: BoxConstraints(
                maxWidth: Responsive.contentMaxWidth(context),
              ),
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: Responsive.get(
                    context,
                    mobile: 72.0,
                    tablet: 96.0,
                    desktop: 128.0,
                  ),
                ),
                child: FadeTransition(
                  opacity: _fade,
                  child: SlideTransition(
                    position: _slide,
                    child: isWide
                        ? _wideLayout(headlineSize)
                        : _narrowLayout(headlineSize),
                  ),
                ),
              ),
            ),
          ),

          // -------------------------------------------- bottom fade strip
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              height: 60,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.transparent,
                    AppColors.background.withValues(alpha: 0.9),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _wideLayout(double headlineSize) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          flex: 7,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _eyebrow(),
              const SizedBox(height: AppDimensions.spaceLg),
              _headline(headlineSize),
              const SizedBox(height: AppDimensions.spaceLg),
              _subheadline(maxWidth: 560),
              const SizedBox(height: AppDimensions.spaceXl),
              _buttons(expanded: false),
              const SizedBox(height: AppDimensions.space3xl),
              const _StatRow(),
            ],
          ),
        ),
        const SizedBox(width: AppDimensions.space3xl),
        const Expanded(flex: 5, child: _HeroIllustration()),
      ],
    );
  }

  Widget _narrowLayout(double headlineSize) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _eyebrow(),
        const SizedBox(height: AppDimensions.spaceMd),
        _headline(headlineSize),
        const SizedBox(height: AppDimensions.spaceMd),
        _subheadline(),
        const SizedBox(height: AppDimensions.spaceXl),
        _buttons(expanded: true),
        const SizedBox(height: AppDimensions.space2xl),
        const _StatRow(),
        const SizedBox(height: AppDimensions.space3xl),
        const _HeroIllustration(),
      ],
    );
  }

  Widget _eyebrow() => Container(
    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
    decoration: BoxDecoration(
      color: Colors.white.withValues(alpha: 0.12),
      borderRadius: BorderRadius.circular(AppDimensions.radiusPill),
      border: Border.all(color: Colors.white24),
    ),
    child: Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 8,
          height: 8,
          decoration: const BoxDecoration(
            color: AppColors.tealGreen,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 8),
        const Text(
          AppStrings.tagline,
          style: TextStyle(
            color: Colors.white,
            fontSize: 13,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.4,
          ),
        ),
      ],
    ),
  );

  Widget _headline(double size) => Text(
    AppStrings.heroHeadline,
    style: TextStyle(
      fontSize: size,
      height: 1.08,
      fontWeight: FontWeight.w800,
      letterSpacing: -1.4,
      color: Colors.white,
      shadows: [
        Shadow(
          color: Colors.black.withValues(alpha: 0.25),
          blurRadius: 24,
          offset: const Offset(0, 8),
        ),
      ],
    ),
  );

  Widget _subheadline({double? maxWidth}) {
    final text = Text(
      AppStrings.heroSubheadline,
      style: TextStyle(
        fontSize: 17.5,
        height: 1.7,
        color: Colors.white.withValues(alpha: 0.88),
      ),
    );
    return maxWidth == null
        ? text
        : ConstrainedBox(
            constraints: BoxConstraints(maxWidth: maxWidth),
            child: text,
          );
  }

  Widget _buttons({required bool expanded}) {
    final primary = GradientButton(
      label: AppStrings.primaryCta,
      icon: Icons.chat_bubble_rounded,
      expanded: expanded,
      gradient: const LinearGradient(
        colors: [AppColors.tealGreen, Color(0xFF00D3A7)],
      ),
      onPressed: () => Get.toNamed(AppRoutes.contact),
    );
    final secondary = GradientButton(
      label: AppStrings.secondaryCta,
      icon: Icons.explore_rounded,
      expanded: expanded,
      outlined: true,
      gradient: const LinearGradient(colors: [Colors.white, Colors.white]),
      onPressed: () => Get.toNamed(AppRoutes.services),
    );

    if (expanded) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          primary,
          const SizedBox(height: AppDimensions.spaceMd),
          secondary,
        ],
      );
    }

    return Wrap(
      spacing: AppDimensions.spaceMd,
      runSpacing: AppDimensions.spaceMd,
      children: [primary, secondary],
    );
  }

  Widget _orb(Color color, double size) => Container(
    width: size,
    height: size,
    decoration: BoxDecoration(
      shape: BoxShape.circle,
      gradient: RadialGradient(colors: [color, color.withValues(alpha: 0)]),
    ),
  );
}

/// Glass stat cards under the hero copy.
class _StatRow extends StatelessWidget {
  const _StatRow();

  static const _stats = [
    ('120+', 'Projects Delivered'),
    ('98%', 'Client Retention'),
    ('45+', 'Team Members'),
    ('9', 'Years of Experience'),
  ];

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: AppDimensions.spaceMd,
      runSpacing: AppDimensions.spaceMd,
      children: [
        for (final (value, label) in _stats)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.10),
              borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
              border: Border.all(color: Colors.white24),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.10),
                  blurRadius: 20,
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.w800,
                    color: Colors.white,
                    height: 1.1,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 12.5,
                    color: Colors.white.withValues(alpha: 0.75),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }
}

/// Decorative right-hand visual: a glass browser/dashboard window
/// (chrome bar, icon rail, KPI cards, bar chart) surrounded by four
/// floating tech badges that bob on staggered phases of a 6s loop.
class _HeroIllustration extends StatefulWidget {
  const _HeroIllustration();

  @override
  State<_HeroIllustration> createState() => _HeroIllustrationState();
}

class _HeroIllustrationState extends State<_HeroIllustration>
    with SingleTickerProviderStateMixin {
  late final AnimationController _loop;
  late final List<Animation<double>> _floats;

  static const _badges = <(IconData, String, Color)>[
    (Icons.flutter_dash, 'Flutter', AppColors.tealGreen),
    (Icons.local_fire_department, 'Firebase', AppColors.orange),
    (Icons.language, 'Web App', AppColors.deepBlue),
    (Icons.insights, 'Data Analytics', AppColors.purple),
  ];

  static const _barHeights = [0.45, 0.62, 0.38, 0.8, 0.55, 0.95];
  static const _barColors = <Color>[
    AppColors.tealGreen,
    AppColors.purple,
    AppColors.magenta,
    AppColors.orange,
    AppColors.deepBlueLight,
    AppColors.tealGreen,
  ];

  @override
  void initState() {
    super.initState();
    _loop = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 6),
    )..repeat(reverse: true);

    // Each badge moves only inside its own phase window of the loop so
    // the four never bob in sync: window i = [i*0.175, i*0.175+0.45].
    _floats = [
      for (var i = 0; i < _badges.length; i++)
        Tween<double>(begin: -7, end: 7).animate(
          CurvedAnimation(
            parent: _loop,
            curve: Interval(
              i * 0.175,
              i * 0.175 + 0.45,
              curve: Curves.easeInOut,
            ),
          ),
        ),
    ];
  }

  @override
  void dispose() {
    _loop.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        _dashboard(),
        Positioned(top: -16, left: -18, child: _badge(0)),
        Positioned(top: -16, right: -18, child: _badge(1)),
        Positioned(bottom: -18, left: -14, child: _badge(2)),
        Positioned(bottom: -18, right: -18, child: _badge(3)),
      ],
    );
  }

  Widget _badge(int index) {
    final (icon, label, color) = _badges[index];
    return AnimatedBuilder(
      animation: _floats[index],
      builder: (context, child) => Transform.translate(
        offset: Offset(0, _floats[index].value),
        child: child,
      ),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.94),
          borderRadius: BorderRadius.circular(AppDimensions.radiusPill),
          border: Border.all(color: Colors.white),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.22),
              blurRadius: 18,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 15, color: color),
            const SizedBox(width: 6),
            Text(
              label,
              style: const TextStyle(
                color: AppColors.textPrimary,
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Glass browser window: chrome bar, icon rail + KPI/chart dashboard.
  Widget _dashboard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppDimensions.spaceMd),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.10),
        borderRadius: BorderRadius.circular(AppDimensions.radiusXl),
        border: Border.all(color: Colors.white24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.25),
            blurRadius: 50,
            offset: const Offset(0, 24),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // ---------------------------------------------- chrome bar
          Row(
            children: [
              const DotMarker(Color(0xFFFF5F57)),
              const SizedBox(width: 7),
              const DotMarker(Color(0xFFFEBC2E)),
              const SizedBox(width: 7),
              const DotMarker(Color(0xFF28C840)),
              const SizedBox(width: 12),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 5,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.10),
                    borderRadius: BorderRadius.circular(
                      AppDimensions.radiusPill,
                    ),
                  ),
                  child: const Text(
                    'softkormo.web.app/dashboard',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(color: Colors.white70, fontSize: 11.5),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Container(height: 1, color: Colors.white12),
          const SizedBox(height: 14),

          // ------------------------------------ icon rail + dashboard
          IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _iconRail(),
                const SizedBox(width: 14),
                Expanded(child: _dashBody()),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _iconRail() {
    return Container(
      width: 44,
      padding: const EdgeInsets.symmetric(vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _railTile(Icons.dashboard_rounded, active: true),
          const SizedBox(height: 10),
          _railTile(Icons.insights_rounded, active: false),
          const SizedBox(height: 10),
          _railTile(Icons.settings_rounded, active: false),
        ],
      ),
    );
  }

  Widget _railTile(IconData icon, {required bool active}) {
    return Container(
      width: 28,
      height: 28,
      decoration: BoxDecoration(
        color: active
            ? AppColors.tealGreen.withValues(alpha: 0.85)
            : Colors.white.withValues(alpha: 0.10),
        borderRadius: BorderRadius.circular(AppDimensions.radiusSm),
      ),
      child: Icon(icon, size: 15, color: Colors.white),
    );
  }

  Widget _dashBody() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            _kpi('24.9K', 'Users'),
            const SizedBox(width: 8),
            _kpi('99.9%', 'Uptime'),
            const SizedBox(width: 8),
            _kpi('1.2M', 'Events'),
          ],
        ),
        const SizedBox(height: 14),
        _barChart(),
      ],
    );
  }

  Widget _kpi(String value, String label) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 8),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.12),
          borderRadius: BorderRadius.circular(AppDimensions.radiusSm),
          border: Border.all(color: Colors.white24),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              value,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.w800,
                height: 1.1,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: Colors.white.withValues(alpha: 0.72),
                fontSize: 10,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Bounded bar chart: six bars of varying height sharing one baseline.
  Widget _barChart() {
    return SizedBox(
      height: 96,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          for (var i = 0; i < _barHeights.length; i++) ...[
            if (i > 0) const SizedBox(width: 8),
            Expanded(
              child: FractionallySizedBox(
                alignment: Alignment.bottomCenter,
                heightFactor: _barHeights[i],
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.bottomCenter,
                      end: Alignment.topCenter,
                      colors: [
                        _barColors[i],
                        _barColors[i].withValues(alpha: 0.45),
                      ],
                    ),
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(5),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

/// Window-chrome dot shared by the hero dashboard illustration.
class DotMarker extends StatelessWidget {
  const DotMarker(this.color, {super.key});
  final Color color;

  @override
  Widget build(BuildContext context) => Container(
    width: 11,
    height: 11,
    decoration: BoxDecoration(color: color, shape: BoxShape.circle),
  );
}
