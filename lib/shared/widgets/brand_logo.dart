import 'package:flutter/material.dart';

import '../../core/constants/app_colors.dart';

/// SoftKormo brand lockup: the official logo emblem (extracted from
/// `assets/logo/kormosoft_s.png`) + the "SoftKormo" wordmark.
///
/// Falls back to a gradient-drawn mark if the asset ever fails to load,
/// so branding never breaks mid-integration.
class BrandLogo extends StatelessWidget {
  const BrandLogo({
    super.key,
    this.assetPath = 'assets/logo/kormosoft_mark.png',
    this.height = 40,
    this.light = false,
    this.showTagline = false,
    this.useAsset = true,
  });

  final String assetPath;
  final double height;
  final bool light;
  final bool showTagline;
  final bool useAsset;

  @override
  Widget build(BuildContext context) {
    final markSize = height;

    final mark = useAsset
        ? Padding(
            padding: const EdgeInsets.only(top: 2, bottom: 2),
            child: Image.asset(
              assetPath,
              height: markSize,
              fit: BoxFit.contain,
              errorBuilder: (_, _, _) => _drawMark(markSize),
            ),
          )
        : _drawMark(markSize);

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        mark,
        const SizedBox(width: 10),
        Flexible(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text.rich(
                TextSpan(
                  style: TextStyle(
                    fontSize: height * 0.55,
                    fontWeight: FontWeight.w700,
                    height: 1.1,
                    letterSpacing: -0.5,
                  ),
                  children: [
                    TextSpan(
                      text: 'Soft',
                      style: TextStyle(
                        color: light ? Colors.white : AppColors.deepBlue,
                      ),
                    ),
                    const TextSpan(
                      text: 'Kormo',
                      style: TextStyle(color: AppColors.tealGreen),
                    ),
                  ],
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              if (showTagline)
                Text(
                  'Smart Software, Reliable Service',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: height * 0.24,
                    fontWeight: FontWeight.w500,
                    color: light
                        ? AppColors.textOnDarkMuted
                        : AppColors.textMuted,
                    letterSpacing: 0.3,
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }

  /// Gradient rounded-square mark echoing the logo's multi-hue style.
  Widget _drawMark(double size) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        gradient: AppColors.brandGradient,
        borderRadius: BorderRadius.circular(size * 0.26),
        boxShadow: [
          BoxShadow(
            color: AppColors.deepBlue.withValues(alpha: 0.30),
            blurRadius: size * 0.3,
            offset: Offset(0, size * 0.1),
          ),
        ],
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          // accent arcs from the secondary brand hues
          Positioned(
            right: size * 0.08,
            top: size * 0.08,
            child: Container(
              width: size * 0.26,
              height: size * 0.26,
              decoration: const BoxDecoration(
                color: AppColors.tealGreen,
                shape: BoxShape.circle,
              ),
            ),
          ),
          Positioned(
            left: size * 0.1,
            bottom: size * 0.1,
            child: Container(
              width: size * 0.2,
              height: size * 0.2,
              decoration: const BoxDecoration(
                color: AppColors.orange,
                shape: BoxShape.circle,
              ),
            ),
          ),
          Icon(Icons.bolt_rounded, size: size * 0.44, color: Colors.white),
        ],
      ),
    );
  }
}
