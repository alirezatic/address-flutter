import 'package:flutter/material.dart';

import 'package:address/core/design_system/components/images/app_asset_image.dart';
import 'package:address/core/design_system/tokens/app_design_tokens.dart';
import 'package:address/features/partners/domain/models/partner_category.dart';
import 'package:address/features/partners/presentation/localization/partner_localizations.dart';
import 'package:address/features/partners/presentation/theme/partner_category_style.dart';
import 'package:address/l10n/generated/app_localizations.dart';

class PartnerCategoryBanner extends StatelessWidget {
  const PartnerCategoryBanner({
    super.key,
    required this.category,
    required this.driverMode,
  });

  final PartnerCategoryDefinition category;
  final PartnerDriverMode driverMode;

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final colors = theme.colorScheme;
    final palette = category.id.palette;

    return Container(
      padding: const EdgeInsets.all(AppSpacingTokens.large),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
          colors: palette.accent,
        ),
        borderRadius: BorderRadius.circular(AppRadiusTokens.large),
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: palette.accent.last.withValues(alpha: 0.25),
            blurRadius: 22,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Row(
        children: <Widget>[
          Container(
            width: AppComponentTokens.partnerBannerImage,
            height: AppComponentTokens.partnerBannerImage,
            padding: const EdgeInsets.all(AppSpacingTokens.xSmall),
            decoration: BoxDecoration(
              color: colors.surface,
              borderRadius: BorderRadius.circular(AppRadiusTokens.medium),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(AppRadiusTokens.small),
              child: AppAssetImage(
                assetPath: category.imagePath,
                fit: BoxFit.cover,
                fallbackIcon: Icons.category_rounded,
              ),
            ),
          ),
          const SizedBox(width: AppSpacingTokens.medium),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  category.id.title(localizations),
                  style: theme.textTheme.titleMedium?.copyWith(
                    color: colors.onPrimary,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: AppSpacingTokens.xSmall),
                Text(
                  category.selectionHint(localizations, driverMode),
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: colors.onPrimary.withValues(alpha: 0.9),
                    height: 1.45,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
