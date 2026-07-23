import 'package:flutter/material.dart';

import 'package:address/core/design_system/components/card/app_card.dart';
import 'package:address/core/design_system/tokens/app_design_tokens.dart';
import 'package:address/l10n/generated/app_localizations.dart';

class PartnerSupportCard extends StatelessWidget {
  const PartnerSupportCard({super.key, required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final colors = theme.colorScheme;
    final palette = AppFeaturePalettes.support;

    return AppCard(
      title: localizations.partnersSupport,
      subtitle: localizations.partnersSupportSubtitle,
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
          Align(
            alignment: AlignmentDirectional.topStart,
            child: Container(
              width: AppComponentTokens.partnerCategoryImage,
              height: AppComponentTokens.partnerCategoryImage,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: colors.surface,
                borderRadius: BorderRadius.circular(AppRadiusTokens.medium),
                border: Border.all(color: colors.outlineVariant),
              ),
              child: Icon(
                Icons.headset_mic_rounded,
                color: palette.accent[1],
                size: 30,
              ),
            ),
          ),
          const Spacer(),
          Text(
            localizations.partnersSupport,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: theme.textTheme.titleSmall?.copyWith(
              color: colors.onSurface,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: AppSpacingTokens.xSmall),
          Text(
            localizations.partnersSupportSubtitle,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: theme.textTheme.labelMedium?.copyWith(
              color: colors.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }
}
