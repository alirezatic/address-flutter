import 'package:flutter/material.dart';

import 'package:address/features/home/data/models/service_model.dart';
import 'package:address/l10n/generated/app_localizations.dart';

class ServiceBannerCard extends StatelessWidget {
  const ServiceBannerCard({required this.service, super.key});

  final ServiceModel service;

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);
    final textTheme = Theme.of(context).textTheme;
    final isRtl = Directionality.of(context) == TextDirection.rtl;

    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;
        final height = constraints.maxHeight;
        final compact = width < 520;

        final horizontalPadding = compact ? 20.0 : 30.0;
        final titleSize = compact ? 22.0 : 27.0;
        final subtitleSize = compact ? 15.0 : 18.0;
        final captionSize = compact ? 12.0 : 14.0;

        final mainImageWidth = (width * (compact ? 0.72 : 0.66))
            .clamp(220, 520)
            .toDouble();

        final mainImageHeight = (height * 0.44).clamp(110, 170).toDouble();

        final vehicleWidth = (width * (compact ? 0.25 : 0.22))
            .clamp(92, 175)
            .toDouble();

        return DecoratedBox(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: isRtl ? Alignment.topRight : Alignment.topLeft,
              end: isRtl ? Alignment.bottomLeft : Alignment.bottomRight,
              colors: [
                service.color,
                service.secondaryColor ?? service.color.withValues(alpha: 0.58),
              ],
            ),
            borderRadius: BorderRadius.circular(26),
            boxShadow: [
              BoxShadow(
                color: service.color.withValues(alpha: 0.22),
                blurRadius: 20,
                offset: const Offset(0, 9),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(26),
            child: Stack(
              children: [
                PositionedDirectional(
                  top: -height * 0.18,
                  end: -width * 0.10,
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white.withValues(alpha: 0.08),
                    ),
                    child: SizedBox.square(dimension: width * 0.58),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(
                    horizontalPadding,
                    compact ? 22 : 26,
                    horizontalPadding,
                    18,
                  ),
                  child: Align(
                    alignment: AlignmentDirectional.topStart,
                    child: ConstrainedBox(
                      constraints: BoxConstraints(
                        maxWidth: compact ? width * 0.62 : width * 0.58,
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            service.title(localizations),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: textTheme.titleLarge?.copyWith(
                              color: Colors.white,
                              fontSize: titleSize,
                              fontWeight: FontWeight.w800,
                              height: 1.15,
                            ),
                          ),
                          const SizedBox(height: 7),
                          Text(
                            service.subtitle(localizations),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: textTheme.bodyLarge?.copyWith(
                              color: Colors.white.withValues(alpha: 0.96),
                              fontSize: subtitleSize,
                              fontWeight: FontWeight.w600,
                              height: 1.35,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            service.caption(localizations),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: textTheme.bodySmall?.copyWith(
                              color: Colors.white.withValues(alpha: 0.84),
                              fontSize: captionSize,
                              fontWeight: FontWeight.w500,
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
                  bottom: compact ? 14 : 18,
                  child: Center(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(30),
                      child: Image.asset(
                        service.image,
                        width: mainImageWidth,
                        height: mainImageHeight,
                        fit: BoxFit.cover,
                        filterQuality: FilterQuality.medium,
                      ),
                    ),
                  ),
                ),
                if (service.secondaryImage.isNotEmpty)
                  PositionedDirectional(
                    top: compact ? 22 : 24,
                    end: compact ? 14 : 24,
                    child: Image.asset(
                      service.secondaryImage,
                      width: vehicleWidth,
                      height: vehicleWidth * 0.72,
                      fit: BoxFit.contain,
                      filterQuality: FilterQuality.medium,
                    ),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }
}
