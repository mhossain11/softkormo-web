import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'core/constants/app_colors.dart';
import 'core/constants/app_strings.dart';
import 'core/routes/app_routes.dart';
import 'core/services/seo_service.dart';
import 'core/services/seo_service_stub.dart'
    if (dart.library.js_interop) 'core/services/seo_service_web.dart';
import 'core/services/seo_tags.dart';
import 'core/themes/app_theme.dart';

/// Root widget: GetX app shell with theme control and route-aware SEO.
class SoftKormoApp extends StatefulWidget {
  const SoftKormoApp({super.key});

  @override
  State<SoftKormoApp> createState() => _SoftKormoAppState();
}

class _SoftKormoAppState extends State<SoftKormoApp> {
  @override
  void initState() {
    super.initState();
    // Bind platform SEO implementation (no-op off the web).
    unawaited(initSeo());
    WidgetsBinding.instance.addPostFrameCallback((_) => _applySeo());
  }

  /// Rewrites title / meta / OG / canonical tags for the active route.
  Future<void> _applySeo([String? routeName]) async {
    final path = (routeName == null || routeName.isEmpty)
        ? (Get.currentRoute.isEmpty ? '/' : Get.currentRoute)
        : routeName;

    final page =
        SeoTags.pages[path] ?? [AppStrings.seoTitle, AppStrings.seoDescription];

    await SeoService.update(path: path, title: page[0], description: page[1]);
  }

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: AppStrings.seoTitle,
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light(),
      darkTheme: AppTheme.dark(),
      themeMode: ThemeMode.light,
      getPages: AppRoutes.pages,
      initialRoute: AppRoutes.home,
      defaultTransition: Transition.fadeIn,
      transitionDuration: const Duration(milliseconds: 350),
      // Runs after GetX updates its routing state on every navigation.
      navigatorObservers: [
        GetObserver((routing) {
          WidgetsBinding.instance.addPostFrameCallback((_) => _applySeo());
        }),
      ],
      builder: (context, child) {
        // Clamp text scaling for accessibility without breaking layout.
        return MediaQuery.withClampedTextScaling(
          minScaleFactor: 0.9,
          maxScaleFactor: 1.3,
          child: child ?? const SizedBox.shrink(),
        );
      },
      unknownRoute: GetPage(
        name: '/not-found',
        page: () => const _NotFoundPage(),
      ),
    );
  }
}

class _NotFoundPage extends StatelessWidget {
  const _NotFoundPage();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              '404',
              style: Theme.of(context).textTheme.displayLarge?.copyWith(
                color: AppColors.deepBlue,
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'This page went off-script.',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: () => Get.toNamed(AppRoutes.home),
              icon: const Icon(Icons.home_rounded),
              label: const Text('Back to Home'),
            ),
          ],
        ),
      ),
    );
  }
}
