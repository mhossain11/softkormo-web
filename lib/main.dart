import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'app.dart';
import 'core/services/injection_container.dart';
import 'core/themes/app_theme.dart';

/// SoftKormo — corporate website entry point.
///
/// Order matters:
/// 1. Ensure Flutter bindings are ready.
/// 2. Preload Google Fonts — building both themes queues every Poppins/Inter
///    variant they use, so frame 1 measures text with the FINAL metrics.
///    Layouts that freeze intrinsic heights (IntrinsicHeight service,
///    pricing and project cards) would otherwise overflow when the
///    asynchronous web-font swap arrives after the first frame.
/// 3. Initialize Firebase + service locator (GetIt) and seed GetX
///    controllers — started in parallel with the font wait.
/// 4. Run the app shell (GetX routing + SEO). If fonts were still in
///    flight after the budget, a root epoch bump rebuilds the whole tree
///    once they land so every frozen height re-measures correctly.
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Queue all font variants used by the light and dark themes.
  AppTheme.light();
  AppTheme.dark();

  var fontProblems = false;

  // Wait (bounded) for the queued fonts; never let a slow or offline CDN
  // block booting or surface an unhandled error.
  final fontWait = GoogleFonts.pendingFonts()
      .timeout(
        const Duration(seconds: 3),
        onTimeout: () {
          fontProblems = true;
          return <void>[];
        },
      )
      .catchError((Object e) {
        fontProblems = true;
        debugPrint('[main] font preload: $e');
        return <void>[];
      });

  // The site must still boot if Firebase config is missing locally —
  // attach the handler immediately so an early failure is never unhandled.
  final diWait = InjectionContainer.init().catchError((Object e) {
    debugPrint('[main] DI init warning: $e');
  });

  await fontWait;
  await diWait;

  // Fonts still in flight (timeout above): rebuild the entire tree once
  // they land so intrinsic-height layouts re-measure with final metrics.
  final fontEpoch = ValueNotifier<int>(0);
  if (fontProblems) {
    GoogleFonts.pendingFonts().whenComplete(() {
      fontEpoch.value += 1;
    }).ignore();
  }

  runApp(
    ValueListenableBuilder<int>(
      valueListenable: fontEpoch,
      builder: (_, epoch, _) => SoftKormoApp(key: ValueKey<int>(epoch)),
    ),
  );
}
