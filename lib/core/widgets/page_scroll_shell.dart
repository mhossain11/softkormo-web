import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../constants/app_dimensions.dart';
import '../utils/responsive_utils.dart';
import 'back_to_top_button.dart';

/// Page-scoped scroll UI signals, provided by [PageScrollShell].
///
/// The sliver-based app bar sits *below* the [Scrollable] in the element
/// tree, so it never receives the ScrollNotifications bubbling up from it —
/// this scope hands the same thresholds to every descendant that needs them.
/// Tests that build the bar without a shell get `null` from [maybeOf] and
/// fall back to a static state.
class ScrollUiScope extends InheritedWidget {
  const ScrollUiScope({
    super.key,
    required this.scrolled,
    required this.showBackToTop,
    required super.child,
  });

  /// True once the page has scrolled a few pixels — drives the sticky
  /// navbar's soft shadow.
  final ValueListenable<bool> scrolled;

  /// True past the reveal threshold — drives the BackToTopButton.
  final ValueListenable<bool> showBackToTop;

  static ScrollUiScope? maybeOf(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<ScrollUiScope>();

  @override
  bool updateShouldNotify(ScrollUiScope oldWidget) =>
      scrolled != oldWidget.scrolled ||
      showBackToTop != oldWidget.showBackToTop;
}

/// Owns the page's [CustomScrollView] so scroll-driven chrome works on
/// web/desktop: the [ScrollController] feeds two [ValueNotifier]s — one for
/// the header shadow (>4px), one for the BackToTopButton (>300px).
///
/// [ValueNotifier] only fires on real changes, so the per-frame cost is two
/// double comparisons; widgets rebuild only when a threshold is crossed.
/// The button is a sibling of the scroll view inside this widget, not part
/// of a route — dialogs are separate routes and still paint above it.
class PageScrollShell extends StatefulWidget {
  const PageScrollShell({super.key, required this.slivers});

  /// The page's slivers — rendered inside the shell's own scroll view.
  final List<Widget> slivers;

  @override
  State<PageScrollShell> createState() => _PageScrollShellState();
}

class _PageScrollShellState extends State<PageScrollShell> {
  /// Scroll offset (px) from which the BackToTopButton reveals itself.
  static const double _backToTopThreshold = 300;

  /// Small offset before the navbar shadow appears, so micro-jitter at the
  /// very top doesn't flicker it.
  static const double _scrolledThreshold = 4;

  late final ScrollController _controller;
  late final ValueNotifier<bool> _scrolled;
  late final ValueNotifier<bool> _showBackToTop;

  @override
  void initState() {
    super.initState();
    _scrolled = ValueNotifier<bool>(false);
    _showBackToTop = ValueNotifier<bool>(false);
    // The controller (not scroll notifications) drives both signals: it
    // only sees THIS page's position — nested scrollables and dialogs
    // can't touch it — and it also fires when a restored offset jumps in.
    _controller = ScrollController()..addListener(_syncScrollUi);
  }

  void _syncScrollUi() {
    final pixels = _controller.hasClients ? _controller.offset : 0;
    _scrolled.value = pixels > _scrolledThreshold;
    _showBackToTop.value = pixels > _backToTopThreshold;
  }

  Future<void> _scrollToTop() => _controller.animateTo(
    0,
    duration: AppDimensions.slow,
    curve: Curves.easeOutCubic,
  );

  @override
  void dispose() {
    _controller.dispose();
    _scrolled.dispose();
    _showBackToTop.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Desktop/laptop 30px, tablet 24px, mobile 16px (spec).
    final double offset = Responsive.get<double>(
      context,
      mobile: 16.0,
      tablet: 24.0,
      laptop: 30.0,
    );

    return ScrollUiScope(
      scrolled: _scrolled,
      showBackToTop: _showBackToTop,
      child: Stack(
        children: [
          // Explicit controller: PrimaryScrollController only inherits on
          // mobile platforms, and these pages must work on web/desktop.
          CustomScrollView(controller: _controller, slivers: widget.slivers),
          Positioned(
            left: offset,
            bottom: offset,
            child: BackToTopButton(
              visible: _showBackToTop,
              onTap: _scrollToTop,
            ),
          ),
        ],
      ),
    );
  }
}
