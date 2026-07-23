import 'package:flutter/material.dart';

import 'package:address/features/home/data/models/service_model.dart';
import 'package:address/l10n/generated/app_localizations.dart';

class ServiceBannerCard extends StatefulWidget {
  const ServiceBannerCard({
    required this.service,
    super.key,
  });

  final ServiceModel service;

  @override
  State<ServiceBannerCard> createState() => _ServiceBannerCardState();
}

class _ServiceBannerCardState extends State<ServiceBannerCard>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _floatingAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2600),
    )..repeat(reverse: true);

    _floatingAnimation = Tween<double>(
      begin: 0,
      end: -8,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInOut,
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);
    final textTheme = Theme.of(context).textTheme;
    final isRtl = Directionality.of(context) == TextDirection.rtl;

    return AnimatedBuilder(
      animation: _floatingAnimation,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(0, _floatingAnimation.value),
          child: child,
        );
      },
      child: LayoutBuilder(
        builder: (context, constraints) {
          final width = constraints.maxWidth;
          final height = constraints.maxHeight;
          final compact = width < 420;

          final horizontalPadding = compact ? 18.0 : 24.0;
          final mainImageWidth =
              (width * (compact ? 0.66 : 0.60)).clamp(190, 430).toDouble();
          final mainImageHeight =
              (height * 0.38).clamp(82, 132).toDouble();
          final vehicleWidth =
              (width * 0.23).clamp(70, 150).toDouble();

          return Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: isRtl ? Alignment.topRight : Alignment.topLeft,
                end: isRtl ? Alignment.bottomLeft : Alignment.bottomRight,
                colors: [
                  widget.service.color,
                  widget.service.secondaryColor ??
                      widget.service.color.withValues(alpha: 0.55),
                ],
              ),
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(
                  color: widget.service.color.withValues(alpha: 0.28),
                  blurRadius: 24,
                  offset: const Offset(0, 12),
                ),
              ],
            ),
            clipBehavior: Clip.antiAlias,
            child: Stack(
              children: [
                PositionedDirectional(
                  top: -height * 0.16,
                  end: -width * 0.10,
                  child: Container(
                    width: width * 0.55,
                    height: width * 0.55,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white.withValues(alpha: 0.08),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(
                    horizontalPadding,
                    22,
                    horizontalPadding,
                    18,
                  ),
                  child: Align(
                    alignment: AlignmentDirectional.topStart,
                    child: ConstrainedBox(
                      constraints: BoxConstraints(
                        maxWidth: compact ? width * 0.62 : width * 0.55,
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.service.title(localizations),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: textTheme.titleLarge?.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            widget.service.subtitle(localizations),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: textTheme.bodyLarge?.copyWith(
                              color: Colors.white.withValues(alpha: 0.94),
                              fontWeight: FontWeight.w600,
                              height: 1.25,
                            ),
                          ),
                          const SizedBox(height: 5),
                          Text(
                            widget.service.caption(localizations),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: textTheme.bodySmall?.copyWith(
                              color: Colors.white.withValues(alpha: 0.82),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                PositionedDirectional(
                  start: horizontalPadding,
                  end: horizontalPadding,
                  bottom: 16,
                  child: Center(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(28),
                      child: Image.asset(
                        widget.service.image,
                        width: mainImageWidth,
                        height: mainImageHeight,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
                if (widget.service.secondaryImage.isNotEmpty)
                  PositionedDirectional(
                    top: compact ? 22 : 18,
                    end: compact ? 12 : 20,
                    child: AnimatedBuilder(
                      animation: _floatingAnimation,
                      builder: (context, child) {
                        return Transform.translate(
                          offset: Offset(
                            0,
                            _floatingAnimation.value * 0.45,
                          ),
                          child: child,
                        );
                      },
                      child: Image.asset(
                        widget.service.secondaryImage,
                        width: vehicleWidth,
                        height: vehicleWidth * 0.72,
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }
}
