import 'package:flutter/material.dart';

import 'package:address/core/design_system/components/images/app_asset_image.dart';
import 'package:address/core/design_system/tokens/app_design_tokens.dart';

enum AppCardType { horizontal, vertical, compact, selectable }

class AppCard extends StatelessWidget {
  const AppCard({
    super.key,
    required this.title,
    required this.onTap,
    this.subtitle,
    this.imagePath,
    this.icon,
    this.trailing,
    this.child,
    this.type = AppCardType.vertical,
    this.isSelected = false,
    this.isEnabled = true,
    this.width,
    this.height,
    this.backgroundColor,
    this.gradient,
    this.padding,
    this.borderRadius = AppRadiusTokens.card,
    this.borderWidth = 1,
    this.selectedBorderWidth = 1.6,
    this.borderColor,
    this.selectedBorderColor,
    this.boxShadow,
    this.clipBehavior = Clip.antiAlias,
  });

  final String title;
  final String? subtitle;
  final String? imagePath;
  final IconData? icon;
  final Widget? trailing;

  /// Optional custom content. When provided, the common card shell is still
  /// used, while the page controls only the inner layout.
  final Widget? child;

  final AppCardType type;
  final bool isSelected;
  final bool isEnabled;

  final double? width;
  final double? height;

  final Color? backgroundColor;
  final Gradient? gradient;
  final EdgeInsetsGeometry? padding;

  final double borderRadius;
  final double borderWidth;
  final double selectedBorderWidth;
  final Color? borderColor;
  final Color? selectedBorderColor;
  final List<BoxShadow>? boxShadow;
  final Clip clipBehavior;

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    final effectiveBackgroundColor =
        backgroundColor ??
        (isSelected ? colors.primaryContainer : colors.surface);

    final effectiveBorderColor = isSelected
        ? selectedBorderColor ?? colors.primary
        : borderColor ?? colors.outlineVariant.withValues(alpha: 0.55);

    final effectiveBorderWidth = isSelected ? selectedBorderWidth : borderWidth;

    final effectiveShadow =
        boxShadow ??
        <BoxShadow>[
          BoxShadow(
            color: theme.shadowColor.withValues(alpha: 0.08),
            blurRadius: 12,
            offset: const Offset(0, 5),
          ),
        ];

    final radius = BorderRadius.circular(borderRadius);

    return AnimatedOpacity(
      duration: AppMotionTokens.fast,
      opacity: isEnabled ? 1 : 0.5,
      child: SizedBox(
        width: width,
        height: height,
        child: AnimatedContainer(
          duration: AppMotionTokens.fast,
          decoration: BoxDecoration(
            borderRadius: radius,
            boxShadow: effectiveShadow,
          ),
          child: Material(
            color: gradient == null
                ? effectiveBackgroundColor
                : Colors.transparent,
            borderRadius: radius,
            clipBehavior: clipBehavior,
            child: Ink(
              decoration: BoxDecoration(
                color: gradient == null ? effectiveBackgroundColor : null,
                gradient: gradient,
                borderRadius: radius,
                border: Border.all(
                  color: effectiveBorderColor,
                  width: effectiveBorderWidth,
                ),
              ),
              child: InkWell(
                onTap: isEnabled ? onTap : null,
                borderRadius: radius,
                child: Padding(
                  padding: padding ?? _defaultPadding,
                  child: child ?? _buildDefaultContent(context),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  EdgeInsetsGeometry get _defaultPadding {
    return switch (type) {
      AppCardType.horizontal => const EdgeInsets.all(AppSpacingTokens.large),
      AppCardType.vertical => const EdgeInsets.all(AppSpacingTokens.large),
      AppCardType.compact => const EdgeInsets.all(AppSpacingTokens.medium),
      AppCardType.selectable => const EdgeInsets.all(AppSpacingTokens.large),
    };
  }

  Widget _buildDefaultContent(BuildContext context) {
    return switch (type) {
      AppCardType.horizontal => _buildHorizontal(context),
      AppCardType.vertical => _buildVertical(context),
      AppCardType.compact => _buildCompact(context),
      AppCardType.selectable => _buildSelectable(context),
    };
  }

  Widget _buildHorizontal(BuildContext context) {
    return Row(
      children: [
        _buildVisual(context, size: 68),
        const SizedBox(width: 14),
        Expanded(child: _buildText(context)),
        if (trailing != null) ...[const SizedBox(width: 8), trailing!],
      ],
    );
  }

  Widget _buildVertical(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildVisual(context, size: 92),
        const SizedBox(height: 14),
        _buildText(context, textAlign: TextAlign.center),
        if (trailing != null) ...[const SizedBox(height: 10), trailing!],
      ],
    );
  }

  Widget _buildCompact(BuildContext context) {
    return Row(
      children: [
        _buildVisual(context, size: 46),
        const SizedBox(width: 12),
        Expanded(child: _buildText(context)),
        ?trailing,
      ],
    );
  }

  Widget _buildSelectable(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Row(
      children: [
        _buildVisual(context, size: 54),
        const SizedBox(width: 12),
        Expanded(child: _buildText(context)),
        const SizedBox(width: 8),
        AnimatedContainer(
          duration: AppMotionTokens.fast,
          width: 24,
          height: 24,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: isSelected ? colors.primary : colors.surface,
            border: Border.all(
              color: isSelected ? colors.primary : colors.outline,
              width: 1.5,
            ),
          ),
          child: isSelected
              ? Icon(Icons.check_rounded, size: 17, color: colors.onPrimary)
              : null,
        ),
      ],
    );
  }

  Widget _buildVisual(BuildContext context, {required double size}) {
    if (imagePath != null) {
      return SizedBox(
        width: size,
        height: size,
        child: AppAssetImage(
          assetPath: imagePath!,
          fit: BoxFit.contain,
          fallback: _buildFallbackIcon(context, size: size),
        ),
      );
    }

    return _buildFallbackIcon(context, size: size);
  }

  Widget _buildFallbackIcon(BuildContext context, {required double size}) {
    final colors = Theme.of(context).colorScheme;

    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: colors.primaryContainer,
        borderRadius: BorderRadius.circular(size * 0.28),
      ),
      child: Icon(
        icon ?? Icons.widgets_rounded,
        size: size * 0.48,
        color: colors.onPrimaryContainer,
      ),
    );
  }

  Widget _buildText(
    BuildContext context, {
    TextAlign textAlign = TextAlign.start,
  }) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: textAlign == TextAlign.center
          ? CrossAxisAlignment.center
          : CrossAxisAlignment.start,
      children: [
        Text(
          title,
          textAlign: textAlign,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w700,
            color: colors.onSurface,
          ),
        ),
        if (subtitle != null && subtitle!.trim().isNotEmpty) ...[
          const SizedBox(height: 5),
          Text(
            subtitle!,
            textAlign: textAlign,
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: colors.onSurfaceVariant,
              height: 1.45,
            ),
          ),
        ],
      ],
    );
  }
}
