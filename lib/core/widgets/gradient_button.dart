import 'package:flutter/material.dart';

import '../constants/app_colors.dart';
import '../constants/app_dimensions.dart';

/// Primary brand CTA. Renders a gradient surface with a hover/press
/// lift animation; falls back to a flat gradient when [gradient] is null.
class GradientButton extends StatefulWidget {
  const GradientButton({
    super.key,
    required this.label,
    this.onPressed,
    this.icon,
    this.gradient = AppColors.brandGradient,
    this.outlined = false,
    this.expanded = false,
    this.padding,
    this.fontSize = 15,
  });

  final String label;
  final VoidCallback? onPressed;
  final IconData? icon;
  final Gradient gradient;
  final bool outlined;
  final bool expanded;
  final EdgeInsetsGeometry? padding;
  final double fontSize;

  @override
  State<GradientButton> createState() => _GradientButtonState();
}

class _GradientButtonState extends State<GradientButton> {
  bool _hovering = false;
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    final disabled = widget.onPressed == null;

    final child = AnimatedScale(
      scale: _pressed ? 0.97 : (_hovering ? 1.03 : 1.0),
      duration: AppDimensions.fast,
      curve: Curves.easeOut,
      child: Container(
        padding:
            widget.padding ??
            const EdgeInsets.symmetric(
              horizontal: AppDimensions.spaceXl,
              vertical: AppDimensions.spaceMd + 4,
            ),
        decoration: BoxDecoration(
          gradient: widget.outlined ? null : widget.gradient,
          borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
          border: widget.outlined
              ? Border.all(color: widget.gradient.colors.first, width: 1.5)
              : null,
          boxShadow: widget.outlined || disabled
              ? null
              : [
                  BoxShadow(
                    color: widget.gradient.colors.first.withValues(
                      alpha: _hovering ? 0.45 : 0.28,
                    ),
                    blurRadius: _hovering ? 24 : 14,
                    offset: Offset(0, _hovering ? 8 : 5),
                  ),
                ],
        ),
        child: Row(
          mainAxisSize: widget.expanded ? MainAxisSize.max : MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (widget.icon != null) ...[
              Icon(widget.icon, size: widget.fontSize + 5, color: Colors.white),
              const SizedBox(width: AppDimensions.spaceSm),
            ],
            Flexible(
              child: Text(
                widget.label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: widget.outlined
                      ? widget.gradient.colors.first
                      : Colors.white,
                  fontSize: widget.fontSize,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.2,
                ),
              ),
            ),
          ],
        ),
      ),
    );

    return MouseRegion(
      cursor: disabled ? SystemMouseCursors.basic : SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hovering = true),
      onExit: (_) => setState(() => _hovering = false),
      child: GestureDetector(
        onTapDown: disabled ? null : (_) => setState(() => _pressed = true),
        onTapUp: (_) => setState(() => _pressed = false),
        onTapCancel: () => setState(() => _pressed = false),
        onTap: widget.onPressed,
        child: Opacity(opacity: disabled ? 0.55 : 1, child: child),
      ),
    );
  }
}
