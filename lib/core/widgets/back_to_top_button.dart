import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../constants/app_colors.dart';
import '../constants/app_dimensions.dart';

/// Floating circular "Back to top" control.
///
/// The PageScrollShell renders it at the bottom-left of the viewport and
/// feeds it [visible]: the button fades in past the scroll threshold and
/// fades out again, staying inert (and untappable) while hidden.
class BackToTopButton extends StatefulWidget {
  const BackToTopButton({
    super.key,
    required this.visible,
    required this.onTap,
  });

  /// Whether the button should be shown — owned by the shell, which flips
  /// it at the 300px threshold.
  final ValueListenable<bool> visible;

  /// Smooth-scrolls the page back to the top.
  final VoidCallback onTap;

  @override
  State<BackToTopButton> createState() => _BackToTopButtonState();
}

class _BackToTopButtonState extends State<BackToTopButton> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: widget.visible,
      builder: (context, visible, _) => AnimatedOpacity(
        // Fade rather than pop: opacity 0 + IgnorePointer also guarantees
        // the hidden button can't swallow taps meant for content behind it.
        opacity: visible ? 1.0 : 0.0,
        duration: AppDimensions.normal,
        curve: Curves.easeOut,
        child: IgnorePointer(
          ignoring: !visible,
          child: ExcludeSemantics(
            excluding: !visible,
            child: Semantics(
              button: true,
              label: 'Back to top',
              child: MouseRegion(
                cursor: SystemMouseCursors.click,
                onEnter: (_) => setState(() => _hovered = true),
                onExit: (_) => setState(() => _hovered = false),
                child: GestureDetector(
                  onTap: visible ? widget.onTap : null,
                  behavior: HitTestBehavior.opaque,
                  child: AnimatedScale(
                    // Hover: a small springy lift (300ms).
                    scale: _hovered ? 1.08 : 1.0,
                    duration: AppDimensions.fast,
                    curve: Curves.easeOut,
                    child: AnimatedContainer(
                      duration: AppDimensions.fast,
                      curve: Curves.easeOut,
                      width: 52,
                      height: 52,
                      decoration: BoxDecoration(
                        gradient: AppColors.brandGradient,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.deepBlue.withValues(
                              alpha: _hovered ? 0.45 : 0.25,
                            ),
                            blurRadius: _hovered ? 24 : 16,
                            offset: const Offset(0, 6),
                          ),
                        ],
                      ),
                      child: const Icon(
                        Icons.arrow_upward_rounded,
                        color: Colors.white,
                        size: 24,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
