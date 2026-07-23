import 'package:flutter/material.dart';

import 'package:address/core/design_system/components/card/app_card.dart';
import 'package:address/core/design_system/components/images/app_asset_image.dart';
import 'package:address/core/design_system/tokens/app_design_tokens.dart';
import 'package:address/features/partners/domain/models/partner_category.dart';
import 'package:address/features/partners/presentation/localization/partner_localizations.dart';
import 'package:address/features/partners/presentation/theme/partner_category_style.dart';
import 'package:address/l10n/generated/app_localizations.dart';

class PartnerCategoryCard extends StatelessWidget {
  const PartnerCategoryCard({
    super.key,
    required this.category,
    required this.onTap,
  });

  final PartnerCategoryDefinition category;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final colors = theme.colorScheme;
    final palette = category.id.palette;

    return AppCard(
      title: category.id.title(localizations),
      subtitle: category.id.subtitle(localizations),
      onTap: onTap,
      gradient: LinearGradient(
        begin: Alignment.topRight,
        end: Alignment.bottomLeft,
        colors: palette.soft,
      ),
      borderRadius: AppRadiusTokens.xLarge,
      borderColor: colors.outlineVariant.withValues(alpha: 0.6),
      padding: const EdgeInsets.all(AppSpacingTokens.medium),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                width: AppComponentTokens.partnerCategoryImage,
                height: AppComponentTokens.partnerCategoryImage,
                padding: const EdgeInsets.all(AppSpacingTokens.xSmall),
                decoration: BoxDecoration(
                  color: colors.surface,
                  borderRadius: BorderRadius.circular(AppRadiusTokens.medium),
                  border: Border.all(color: colors.outlineVariant),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(AppRadiusTokens.small),
                  child: AppAssetImage(
                    assetPath: category.imagePath,
                    fit: BoxFit.cover,
                    fallbackIcon: Icons.storefront_rounded,
                  ),
                ),
              ),
              const SizedBox(width: AppSpacingTokens.small),
              Flexible(
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacingTokens.small,
                    vertical: AppSpacingTokens.xSmall,
                  ),
                  decoration: BoxDecoration(
                    color: colors.surface.withValues(alpha: 0.85),
                    borderRadius: BorderRadius.circular(AppRadiusTokens.pill),
                    border: Border.all(color: colors.outlineVariant),
                  ),
                  child: Text(
                    localizations.partnersSubcategoryCount(
                      category.items.length,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.labelSmall?.copyWith(
                      color: colors.onSurfaceVariant,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
            ],
          ),
          const Spacer(),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: <Widget>[
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      category.id.title(localizations),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.titleSmall?.copyWith(
                        color: colors.onSurface,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    const SizedBox(height: AppSpacingTokens.xSmall),
                    Text(
                      category.id.subtitle(localizations),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.labelMedium?.copyWith(
                        color: colors.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
