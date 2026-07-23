import 'package:flutter/material.dart';

import 'package:address/features/home/data/models/service_model.dart';
import 'package:address/l10n/generated/app_localizations.dart';

class ServiceSectionCard extends StatelessWidget {
  const ServiceSectionCard({
    required this.service,
    required this.onTap,
    super.key,
  });

  final ServiceModel service;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: service.color.withValues(alpha: 0.08),
            blurRadius: 13,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Material(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(18),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onTap,
          child: Ink(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: AlignmentDirectional.topStart,
                end: AlignmentDirectional.bottomEnd,
                colors: [
                  service.color.withValues(alpha: 0.13),
                  service.color.withValues(alpha: 0.03),
                ],
              ),
              border: Border.all(
                color: service.color.withValues(alpha: 0.17),
              ),
            ),
            child: LayoutBuilder(
              builder: (context, constraints) {
                final imageSize =
                    (constraints.maxHeight * 0.58).clamp(56, 84).toDouble();

                final fontSize = switch (constraints.maxWidth) {
                  < 260 => 15.0,
                  < 360 => 17.0,
                  _ => 20.0,
                };

                return Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 18,
                    vertical: 12,
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          service.title(localizations),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: textTheme.titleMedium?.copyWith(
                            color: colorScheme.onSurface,
                            fontSize: fontSize,
                            fontWeight: FontWeight.w800,
                            height: 1.25,
                          ),
                        ),
                      ),
                      const SizedBox(width: 14),
                      DecoratedBox(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: colorScheme.surface,
                          boxShadow: [
                            BoxShadow(
                              color:
                                  service.color.withValues(alpha: 0.16),
                              blurRadius: 9,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: SizedBox.square(
                          dimension: imageSize + 14,
                          child: Padding(
                            padding: const EdgeInsets.all(7),
                            child: ClipOval(
                              child: Image.asset(
                                service.image,
                                fit: BoxFit.contain,
                                filterQuality: FilterQuality.medium,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
