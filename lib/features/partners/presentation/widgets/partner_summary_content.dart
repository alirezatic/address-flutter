import 'package:flutter/material.dart';

import 'package:address/core/design_system/components/card/app_card.dart';
import 'package:address/core/design_system/tokens/app_design_tokens.dart';
import 'package:address/features/partners/data/partner_catalog.dart';
import 'package:address/features/partners/domain/models/partner_category.dart';
import 'package:address/features/partners/presentation/localization/partner_localizations.dart';
import 'package:address/features/partners/presentation/theme/partner_category_style.dart';
import 'package:address/l10n/generated/app_localizations.dart';

class PartnerSummaryContent extends StatelessWidget {
  const PartnerSummaryContent({super.key, required this.result});

  final PartnerSelectionResult result;

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final colors = theme.colorScheme;
    final category = PartnerCatalog.byId(result.categoryId);
    final palette = category.id.palette;
    final primary = _findItem(category, result.primaryItemId);
    final selected = category.items
        .where((item) => result.selectedItemIds.contains(item.id))
        .toList(growable: false);

    return ListView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(
        AppLayoutTokens.screenHorizontalPadding,
        0,
        AppLayoutTokens.screenHorizontalPadding,
        AppSpacingTokens.xxLarge,
      ),
      children: <Widget>[
        Container(
          padding: const EdgeInsets.all(AppSpacingTokens.xLarge),
          decoration: BoxDecoration(
            gradient: LinearGradient(colors: palette.accent),
            borderRadius: BorderRadius.circular(AppRadiusTokens.large),
          ),
          child: Column(
            children: <Widget>[
              Icon(Icons.verified_rounded, color: colors.onPrimary, size: 48),
              const SizedBox(height: AppSpacingTokens.small),
              Text(
                localizations.partnersSummaryReadyTitle,
                textAlign: TextAlign.center,
                style: theme.textTheme.titleLarge?.copyWith(
                  color: colors.onPrimary,
                  fontWeight: FontWeight.w900,
                ),
              ),
              const SizedBox(height: AppSpacingTokens.xSmall),
              Text(
                localizations.partnersSummaryReadySubtitle,
                textAlign: TextAlign.center,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: colors.onPrimary.withValues(alpha: 0.9),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: AppSpacingTokens.large),
        AppCard(
          title: category.id.title(localizations),
          subtitle: localizations.partnersMainCategory,
          onTap: () {},
          type: AppCardType.horizontal,
          imagePath: category.imagePath,
          icon: Icons.category_rounded,
        ),
        if (primary != null) ...<Widget>[
          const SizedBox(height: AppSpacingTokens.large),
          Text(
            category.selectionMode == PartnerSelectionMode.driver
                ? localizations.partnersMainVehicle
                : localizations.partnersPrimaryActivity,
            style: theme.textTheme.titleSmall?.copyWith(
              color: colors.onSurface,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: AppSpacingTokens.small),
          AppCard(
            title: primary.id.title(localizations),
            subtitle: primary.id.description(localizations),
            icon: Icons.star_rounded,
            onTap: () {},
            type: AppCardType.compact,
            isSelected: true,
            selectedBorderColor: palette.accent[1],
          ),
        ],
        if (selected.isNotEmpty) ...<Widget>[
          const SizedBox(height: AppSpacingTokens.large),
          Text(
            _secondaryTitle(localizations, category.selectionMode),
            style: theme.textTheme.titleSmall?.copyWith(
              color: colors.onSurface,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: AppSpacingTokens.small),
          Wrap(
            spacing: AppSpacingTokens.small,
            runSpacing: AppSpacingTokens.small,
            children: <Widget>[
              for (final item in selected)
                Chip(
                  avatar: Text(item.emoji),
                  label: Text(item.id.title(localizations)),
                  backgroundColor: palette.accent[1].withValues(alpha: 0.10),
                  side: BorderSide.none,
                ),
            ],
          ),
        ],
      ],
    );
  }

  PartnerItemDefinition? _findItem(
    PartnerCategoryDefinition category,
    PartnerItemId? id,
  ) {
    if (id == null) {
      return null;
    }

    for (final item in category.items) {
      if (item.id == id) {
        return item;
      }
    }
    return null;
  }

  String _secondaryTitle(
    AppLocalizations localizations,
    PartnerSelectionMode mode,
  ) {
    return switch (mode) {
      PartnerSelectionMode.primarySecondary =>
        localizations.partnersSecondaryActivities,
      PartnerSelectionMode.multiple => localizations.partnersSelectedOptions,
      PartnerSelectionMode.driver => localizations.partnersFleetTypes,
    };
  }
}
