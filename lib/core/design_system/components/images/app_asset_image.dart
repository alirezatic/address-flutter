import 'package:flutter/material.dart';

/// Shared asset-image widget for the whole app.
///
/// Invalid, missing, or undecodable image assets are replaced by a stable
/// fallback instead of leaving an error widget in the interface.
class AppAssetImage extends StatelessWidget {
  const AppAssetImage({
    super.key,
    required this.assetPath,
    this.width,
    this.height,
    this.fit = BoxFit.contain,
    this.alignment = Alignment.center,
    this.filterQuality = FilterQuality.high,
    this.fallback,
    this.fallbackIcon = Icons.image_not_supported_rounded,
    this.fallbackBackgroundColor,
    this.fallbackIconColor,
  });

  final String assetPath;
  final double? width;
  final double? height;
  final BoxFit fit;
  final AlignmentGeometry alignment;
  final FilterQuality filterQuality;

  final Widget? fallback;
  final IconData fallbackIcon;
  final Color? fallbackBackgroundColor;
  final Color? fallbackIconColor;

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      assetPath,
      width: width,
      height: height,
      fit: fit,
      alignment: alignment,
      filterQuality: filterQuality,
      gaplessPlayback: true,
      errorBuilder: (context, error, stackTrace) {
        return fallback ?? _buildDefaultFallback(context);
      },
    );
  }

  Widget _buildDefaultFallback(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return ColoredBox(
      color: fallbackBackgroundColor ?? colors.surfaceContainerHighest,
      child: Center(
        child: Icon(
          fallbackIcon,
          color: fallbackIconColor ?? colors.onSurfaceVariant,
          size: 24,
        ),
      ),
    );
  }
}
