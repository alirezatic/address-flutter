import 'package:flutter/material.dart';

import 'package:address/features/home/data/models/service_model.dart';
import 'package:address/l10n/generated/app_localizations.dart';

class ServiceBannerCard extends StatelessWidget {
  const ServiceBannerCard({
    required this.service,
    super.key,
  });

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
        final desktop = width >= 760;

        final horizontalPadding = switch (width) {
          < 520 => 20.0,
          < 760 => 28.0,
          _ => 36.0,
        };

        final titleSize = switch (width) {
          < 520 => 23.0,
          < 760 => 29.0,
          _ => 34.0,
        };

        final subtitleSize = switch (width) {
          < 520 => 16.0,
          < 760 => 19.0,
          _ => 22.0,
        };

        final captionSize = switch (width) {
          < 520 => 13.0,
          < 760 => 15.0,
          _ => 17.0,
        };

        final mainImageWidth = (width * (compact ? 0.72 : 0.67))
            .clamp(230, 560)
            .toDouble();

        final mainImageHeight =
            (height * (desktop ? 0.47 : 0.44)).clamp(118, 185).toDouble();

        final vehicleWidth =
            (width * (compact ? 0.25 : 0.23)).clamp(98, 190).toDouble();

        return DecoratedBox(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: isRtl ? Alignment.topRight : Alignment.topLeft,
              end: isRtl ? Alignment.bottomLeft : Alignment.bottomRight,
              colors: [
                service.color,
                service.secondaryColor ??
                    service.color.withValues(alpha: 0.58),
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
                    child: SizedBox.square(
                      dimension: width * 0.58,
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(
                    horizontalPadding,
                    desktop ? 30 : 24,
                    horizontalPadding,
                    18,
                  ),
                  child: Align(
                    alignment: AlignmentDirectional.topStart,
                    child: ConstrainedBox(
                      constraints: BoxConstraints(
                        maxWidth: compact ? width * 0.64 : width * 0.60,
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
                          const SizedBox(height: 8),
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
                          const SizedBox(height: 7),
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
                  bottom: desktop ? 20 : 14,
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
                    top: desktop ? 28 : 22,
                    end: desktop ? 28 : 14,
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
