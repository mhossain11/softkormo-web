import 'dart:async';

import 'package:flutter/material.dart';

import '../constants/app_dimensions.dart';

/// Scroll-reveal wrapper: fades + slides its child in the first time it
/// enters the viewport. Duration stays inside the 300–600ms brand window.
class AnimatedSection extends StatefulWidget {
  const AnimatedSection({
    super.key,
    required this.child,
    this.slideOffset = const Offset(0, 28),
    this.duration = AppDimensions.normal,
    this.delay = Duration.zero,
    this.alignment = Alignment.centerLeft,
  });

  final Widget child;
  final Offset slideOffset;
  final Duration duration;
  final Duration delay;
  final Alignment alignment;

  @override
  State<AnimatedSection> createState() => _AnimatedSectionState();
}

class _AnimatedSectionState extends State<AnimatedSection>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _opacity;
  late final Animation<Offset> _offset;

  Timer? _visibilityPoll;
  bool _revealed = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: widget.duration);
    _opacity = CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic);
    _offset = Tween<Offset>(
      begin: widget.slideOffset,
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic));

    // Reveal in-viewport content on the very first frame…
    WidgetsBinding.instance.addPostFrameCallback((_) => _checkVisibility());
    // …and keep re-checking cheaply until revealed. A LayoutBuilder
    // post-frame check alone is not enough: on the web, scrolling does not
    // always rebuild descendants, which used to leave sections stuck at
    // opacity 0 — large blank areas that still occupied layout space.
    _visibilityPoll = Timer.periodic(
      const Duration(milliseconds: 250),
      (_) => _checkVisibility(),
    );
  }

  void _checkVisibility() {
    if (!mounted || _revealed) {
      _visibilityPoll?.cancel();
      return;
    }
    final box = context.findRenderObject();
    if (box is! RenderBox || !box.hasSize) return;
    final screen = MediaQuery.sizeOf(context);
    final offset = box.localToGlobal(Offset.zero);
    final visible =
        offset.dy < screen.height * 0.92 && offset.dy + box.size.height > 0;
    if (!visible) return;
    _revealed = true;
    _visibilityPoll?.cancel();
    Future.delayed(widget.delay, () {
      if (mounted) _controller.forward();
    });
  }

  @override
  void dispose() {
    _visibilityPoll?.cancel();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _opacity,
      child: SlideTransition(position: _offset, child: widget.child),
    );
  }
}

/// Stagger helper: delays each child by [step] * index for list reveals.
class StaggeredList extends StatelessWidget {
  const StaggeredList({
    super.key,
    required this.children,
    this.spacing = AppDimensions.spaceLg,
    this.step = const Duration(milliseconds: 90),
    this.axis = Axis.vertical,
    this.runs = 1,
  });

  final List<Widget> children;
  final double spacing;
  final Duration step;
  final Axis axis;
  final int runs;

  @override
  Widget build(BuildContext context) {
    if (axis == Axis.horizontal && runs > 1) {
      // Wrapped grid: rows of [runs] items with sequential delays.
      final rows = <Widget>[];
      for (var i = 0; i < children.length; i += runs) {
        final slice = children.sublist(
          i,
          (i + runs) > children.length ? children.length : (i + runs),
        );
        rows.add(
          Wrap(
            spacing: spacing,
            runSpacing: spacing,
            children: [
              for (var j = 0; j < slice.length; j++)
                AnimatedSection(
                  delay: step * (i + j),
                  slideOffset: const Offset(0, 32),
                  child: slice[j],
                ),
            ],
          ),
        );
      }
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          for (var r = 0; r < rows.length; r++) ...[
            rows[r],
            if (r != rows.length - 1) SizedBox(height: spacing),
          ],
        ],
      );
    }

    return Flex(
      direction: axis,
      mainAxisAlignment: axis == Axis.vertical
          ? MainAxisAlignment.start
          : MainAxisAlignment.center,
      children: [
        for (var i = 0; i < children.length; i++) ...[
          if (axis == Axis.vertical && i > 0) SizedBox(height: spacing),
          if (axis == Axis.horizontal) ...[
            if (i > 0) SizedBox(width: spacing),
            Expanded(child: children[i]),
          ] else
            children[i],
        ],
      ],
    );
  }
}
