import 'package:flutter/material.dart';

import '../../core/constants/app_colors.dart';
import '../../core/constants/app_dimensions.dart';
import '../../core/constants/app_strings.dart';
import '../../core/services/firebase_service.dart';
import '../../core/utils/responsive_utils.dart';
import '../../core/widgets/animated_section.dart';
import '../../core/widgets/page_scroll_shell.dart';
import '../../core/widgets/responsive_container.dart';
import '../../shared/widgets/contact_form.dart';
import '../../shared/widgets/custom_app_bar.dart';
import '../../shared/widgets/custom_drawer.dart';
import '../../shared/widgets/footer.dart';

/// Contact page — info panel, validated form, map and social links.
class ContactPage extends StatefulWidget {
  const ContactPage({super.key});

  @override
  State<ContactPage> createState() => _ContactPageState();
}

class _ContactPageState extends State<ContactPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    FirebaseService.logScreenView('contact');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      endDrawer: Responsive.useDesktopNav(context)
          ? null
          : const CustomDrawer(),
      body: PageScrollShell(
        slivers: [
          CustomAppBar(
            onMenuPressed: () => _scaffoldKey.currentState?.openEndDrawer(),
          ),

          // --------------------------------------------------------- hero
          SliverToBoxAdapter(
            child: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [AppColors.deepBlue, Color(0xFF134BB8)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              padding: EdgeInsets.symmetric(
                vertical: Responsive.get(
                  context,
                  mobile: 48.0,
                  tablet: 64.0,
                  desktop: 84.0,
                ),
                horizontal: 24,
              ),
              child: Center(
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    maxWidth: Responsive.contentMaxWidth(context),
                  ),
                  child: AnimatedSection(
                    alignment: Alignment.centerLeft,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'CONTACT',
                          style: TextStyle(
                            color: AppColors.tealGreen,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 2,
                            fontSize: 13,
                          ),
                        ),
                        const SizedBox(height: AppDimensions.spaceMd),
                        Text(
                          'Let’s talk about your project.',
                          style: Theme.of(context).textTheme.displayMedium
                              ?.copyWith(
                                color: Colors.white,
                                fontSize: Responsive.get(
                                  context,
                                  mobile: 30,
                                  tablet: 42,
                                  desktop: 52,
                                ),
                              ),
                        ),
                        const SizedBox(height: AppDimensions.spaceMd),
                        Text(
                          'Free consultation · Reply within 24 hours · NDA on request',
                          style: Theme.of(context).textTheme.bodyLarge
                              ?.copyWith(color: Colors.white70),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),

          // ---------------------------------------------------- form section
          SliverToBoxAdapter(
            child: SectionWrapper(
              child: ResponsiveContainer(
                child: AnimatedSection(child: ContactSection()),
              ),
            ),
          ),

          // ------------------------------------------------------------- map
          SliverToBoxAdapter(
            child: SectionWrapper(
              verticalPadding: 0,
              backgroundColor: AppColors.surface,
              child: ResponsiveContainer(
                child: Column(
                  children: [
                    const SizedBox(height: AppDimensions.space3xl),
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            'Find us in Dhaka',
                            style: Theme.of(context).textTheme.headlineSmall
                                ?.copyWith(fontWeight: FontWeight.w700),
                          ),
                        ),
                        Text(
                          'Headquarters',
                          style: Theme.of(context).textTheme.labelSmall
                              ?.copyWith(color: AppColors.tealGreen),
                        ),
                      ],
                    ),
                    const SizedBox(height: AppDimensions.spaceLg),
                    Container(
                      clipBehavior: Clip.antiAlias,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(
                          AppDimensions.radiusLg,
                        ),
                        border: Border.all(color: AppColors.border),
                      ),
                      height: Responsive.get(
                        context,
                        mobile: 280.0,
                        tablet: 360.0,
                        desktop: 440.0,
                      ),
                      child: const _MapView(),
                    ),
                    const SizedBox(height: AppDimensions.space3xl),
                  ],
                ),
              ),
            ),
          ),

          // --------------------------------------------------------- socials
          SliverToBoxAdapter(
            child: SectionWrapper(
              verticalPadding: 64,
              child: ResponsiveContainer(
                child: AnimatedSection(
                  alignment: Alignment.center,
                  child: Wrap(
                    spacing: AppDimensions.spaceMd,
                    runSpacing: AppDimensions.spaceMd,
                    alignment: WrapAlignment.center,
                    children: const [
                      _SocialButton(
                        icon: Icons.code_rounded,
                        label: 'GitHub',
                        color: Color(0xFF24292F),
                      ),
                      _SocialButton(
                        icon: Icons.work_outline_rounded,
                        label: 'LinkedIn',
                        color: Color(0xFF0A66C2),
                      ),
                      _SocialButton(
                        icon: Icons.camera_alt_outlined,
                        label: 'Instagram',
                        color: AppColors.magenta,
                      ),
                      _SocialButton(
                        icon: Icons.alternate_email_rounded,
                        label: 'X / Twitter',
                        color: Color(0xFF0F172A),
                      ),
                      _SocialButton(
                        icon: Icons.facebook_rounded,
                        label: 'Facebook',
                        color: Color(0xFF1877F2),
                      ),
                      _SocialButton(
                        icon: Icons.mail_outline_rounded,
                        label: 'Email',
                        color: AppColors.tealGreen,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),

          const SliverToBoxAdapter(child: Footer()),
        ],
      ),
    );
  }
}

class _MapView extends StatelessWidget {
  const _MapView();

  @override
  Widget build(BuildContext context) {
    // iframe-free placeholder keeps web builds lightweight; swap for
    // HtmlElementView(tag: 'map') when the API key is configured.
    return Container(
      color: const Color(0xFFE8EEF9),
      child: Stack(
        fit: StackFit.expand,
        children: [
          CustomPaint(painter: _MapGridPainter()),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.all(14),
                  decoration: const BoxDecoration(
                    color: AppColors.deepBlue,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(color: Color(0x440B3C88), blurRadius: 24),
                    ],
                  ),
                  child: const Icon(
                    Icons.location_on_rounded,
                    color: Colors.white,
                    size: 30,
                  ),
                ),
                const SizedBox(height: 14),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 18,
                    vertical: 10,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(
                      AppDimensions.radiusPill,
                    ),
                    boxShadow: const [
                      BoxShadow(color: Color(0x1A0B3C88), blurRadius: 16),
                    ],
                  ),
                  child: const Text(
                    'SoftKormo HQ · Dhaka, Bangladesh',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  AppStrings.mapEmbedUrl.isEmpty
                      ? ''
                      : 'Google Maps embed loads with your API key',
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppColors.textMuted,
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

class _MapGridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final road = Paint()
      ..color = Colors.white
      ..strokeWidth = 10
      ..strokeCap = StrokeCap.round;
    final minor = Paint()
      ..color = const Color(0xFFD6E0F2)
      ..strokeWidth = 4;

    // pseudo street grid
    canvas.drawLine(
      Offset(0, size.height * 0.35),
      Offset(size.width, size.height * 0.28),
      road,
    );
    canvas.drawLine(
      Offset(0, size.height * 0.72),
      Offset(size.width, size.height * 0.78),
      road,
    );
    canvas.drawLine(
      Offset(size.width * 0.3, 0),
      Offset(size.width * 0.36, size.height),
      road,
    );
    canvas.drawLine(
      Offset(size.width * 0.72, 0),
      Offset(size.width * 0.66, size.height),
      road,
    );

    for (var i = 1; i < 6; i++) {
      final y = size.height * (i / 6);
      canvas.drawLine(Offset(0, y), Offset(size.width, y), minor);
    }

    // park blocks
    final park = Paint()..color = const Color(0xFFCDEBD8);
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(size.width * 0.08, size.height * 0.42, 90, 70),
        const Radius.circular(10),
      ),
      park,
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(size.width * 0.78, size.height * 0.46, 80, 64),
        const Radius.circular(10),
      ),
      park,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _SocialButton extends StatelessWidget {
  const _SocialButton({
    required this.icon,
    required this.label,
    required this.color,
  });

  final IconData icon;
  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {},
      borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
          border: Border.all(color: AppColors.border),
          boxShadow: const [
            BoxShadow(color: Color(0x0A0B3C88), blurRadius: 12),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(icon, size: 18, color: color),
            ),
            const SizedBox(width: 10),
            Text(
              label,
              style: Theme.of(
                context,
              ).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600),
            ),
          ],
        ),
      ),
    );
  }
}
