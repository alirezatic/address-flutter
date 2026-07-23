import 'package:flutter/material.dart';

import 'package:address/core/design_system/components/card/app_card.dart';
import 'package:address/core/design_system/tokens/app_design_tokens.dart';
import 'package:address/features/partners/domain/models/partner_category.dart';
import 'package:address/features/partners/presentation/localization/partner_localizations.dart';
import 'package:address/l10n/generated/app_localizations.dart';

class PartnerSelectionCard extends StatelessWidget {
  const PartnerSelectionCard({
    super.key,
    required this.item,
    required this.accentColor,
    required this.isPrimary,
    required this.isSelected,
    required this.onTap,
  });

  final PartnerItemDefinition item;
  final Color accentColor;
  final bool isPrimary;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final colors = theme.colorScheme;
    final highlighted = isPrimary || isSelected;
    final indicatorRadius = isPrimary
        ? AppComponentTokens.partnerSelectionIndicator / 2
        : AppRadiusTokens.small / 2;

    return AppCard(
      title: item.id.title(localizations),
      subtitle: item.id.description(localizations),
      onTap: onTap,
      isSelected: highlighted,
      backgroundColor: colors.surface,
      borderRadius: AppRadiusTokens.medium,
      borderWidth: 1.5,
      selectedBorderWidth: 2,
      borderColor: colors.outlineVariant,
      selectedBorderColor: accentColor,
      padding: const EdgeInsets.all(AppSpacingTokens.medium),
      boxShadow: <BoxShadow>[
        BoxShadow(
          color: highlighted
              ? accentColor.withValues(alpha: 0.14)
              : theme.shadowColor.withValues(alpha: 0.06),
          blurRadius: highlighted ? 16 : 9,
          offset: const Offset(0, 5),
        ),
      ],
      child: Row(
        children: <Widget>[
          AnimatedContainer(
            duration: AppMotionTokens.standard,
            width: AppComponentTokens.partnerSelectionImage,
            height: AppComponentTokens.partnerSelectionImage,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: highlighted
                  ? accentColor.withValues(alpha: 0.12)
                  : colors.surfaceContainerHighest,
              borderRadius: BorderRadius.circular(AppRadiusTokens.small),
            ),
            child: Text(item.emoji, style: theme.textTheme.titleLarge),
          ),
          const SizedBox(width: AppSpacingTokens.medium),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Expanded(
                      child: Text(
                        item.id.title(localizations),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: theme.textTheme.titleSmall?.copyWith(
                          color: highlighted ? accentColor : colors.onSurface,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ),
                    const SizedBox(width: AppSpacingTokens.small),
                    SizedBox(
                      width: AppComponentTokens.partnerPrimaryBadgeWidth,
                      height: AppComponentTokens.partnerPrimaryBadgeHeight,
                      child: AnimatedOpacity(
                        duration: AppMotionTokens.fast,
                        opacity: isPrimary ? 1 : 0,
                        child: IgnorePointer(
                          ignoring: !isPrimary,
                          child: FittedBox(
                            fit: BoxFit.scaleDown,
                            alignment: AlignmentDirectional.centerEnd,
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: AppSpacingTokens.small,
                                vertical: AppSpacingTokens.xSmall,
                              ),
                              decoration: BoxDecoration(
                                color: accentColor,
                                borderRadius: BorderRadius.circular(
                                  AppRadiusTokens.pill,
                                ),
                              ),
                              child: Text(
                                localizations.partnersPrimaryBadge,
                                maxLines: 1,
                                style: theme.textTheme.labelSmall?.copyWith(
                                  color: colors.onPrimary,
                                  fontWeight: FontWeight.w900,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                if (item.id.description(localizations)
                    case final description?) ...<Widget>[
                  const SizedBox(height: AppSpacingTokens.xSmall),
                  Text(
                    description,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: colors.onSurfaceVariant,
                    ),
                  ),
                ],
              ],
            ),
          ),
          const SizedBox(width: AppSpacingTokens.small),
          AnimatedContainer(
            duration: AppMotionTokens.standard,
            width: AppComponentTokens.partnerSelectionIndicator,
            height: AppComponentTokens.partnerSelectionIndicator,
            decoration: BoxDecoration(
              color: highlighted ? accentColor : Colors.transparent,
              shape: BoxShape.rectangle,
              borderRadius: BorderRadius.circular(indicatorRadius),
              border: highlighted
                  ? null
                  : Border.all(color: colors.outline, width: 2),
            ),
            child: highlighted
                ? Icon(
                    isPrimary ? Icons.star_rounded : Icons.check_rounded,
                    color: colors.onPrimary,
                    size: 15,
                  )
                : null,
          ),
        ],
      ),
    );
  }
}
