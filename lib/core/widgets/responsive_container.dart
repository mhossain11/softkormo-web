import 'package:flutter/material.dart';

import '../utils/responsive_utils.dart';

/// Centered, max-width page content. Pass [child] anything and it will be
/// clamped to the breakpoint-appropriate width — no hardcoded widths.
class ResponsiveContainer extends StatelessWidget {
  const ResponsiveContainer({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.symmetric(horizontal: 24),
    this.maxWidth,
    this.backgroundColor,
    this.background,
  });

  final Widget child;
  final EdgeInsetsGeometry padding;
  final double? maxWidth;
  final Color? backgroundColor;
  final Decoration? background;

  @override
  Widget build(BuildContext context) {
    final width = maxWidth ?? Responsive.contentMaxWidth(context);

    final content = Container(
      width: double.infinity,
      constraints: BoxConstraints(maxWidth: width),
      padding: padding,
      child: child,
    );

    Widget result = Align(alignment: Alignment.topCenter, child: content);

    if (backgroundColor != null || background != null) {
      result = Container(
        color: backgroundColor,
        decoration: background,
        width: double.infinity,
        child: result,
      );
    }
    return result;
  }
}

/// Vertical section wrapper providing the standard rhythm between sections.
class SectionWrapper extends StatelessWidget {
  const SectionWrapper({
    super.key,
    required this.child,
    this.verticalPadding = 96,
    this.backgroundColor,
    this.background,
    this.clip = false,
  });

  final Widget child;
  final double verticalPadding;
  final Color? backgroundColor;
  final Decoration? background;
  final bool clip;

  @override
  Widget build(BuildContext context) {
    // Slightly tighter rhythm on small screens.
    final pad = Responsive.get(
      context,
      mobile: verticalPadding * 0.55,
      tablet: verticalPadding * 0.8,
      desktop: verticalPadding,
    );

    // Apply the caller's decoration verbatim. The previous logic only
    // accepted raw Gradients, so every `BoxDecoration(gradient: …)` passed
    // here was silently dropped — sections rendered as blank white bands
    // instead of their intended background.
    final Decoration? decoration =
        background ??
        (backgroundColor != null
            ? BoxDecoration(color: backgroundColor)
            : null);

    return Container(
      clipBehavior: clip ? Clip.antiAlias : Clip.none,
      decoration: decoration,
      width: double.infinity,
      padding: EdgeInsets.symmetric(vertical: pad),
      child: child,
    );
  }
}
