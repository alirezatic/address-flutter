import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:address/app/route_paths.dart';
import 'package:address/core/design_system/components/layout/app_page_scaffold.dart';
import 'package:address/core/design_system/tokens/app_design_tokens.dart';
import 'package:address/features/partners/data/partner_catalog.dart';
import 'package:address/features/partners/presentation/widgets/partner_category_card.dart';
import 'package:address/features/partners/presentation/widgets/partner_support_card.dart';
import 'package:address/l10n/generated/app_localizations.dart';

class AddressPartnersScreen extends StatelessWidget {
  const AddressPartnersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    return AppPageScaffold(
      navigationIcon: Icons.home_rounded,
      navigationLabel: localizations.home,
      onNavigationPressed: () => context.go(AppRoutePaths.home),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(
            maxWidth: AppLayoutTokens.compactContentMaxWidth,
          ),
          child: CustomScrollView(
            physics: const BouncingScrollPhysics(),
            slivers: <Widget>[
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(
                    AppLayoutTokens.screenHorizontalPadding,
                    0,
                    AppLayoutTokens.screenHorizontalPadding,
                    AppSpacingTokens.xLarge,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        localizations.partnersBrandTitle,
                        style: theme.textTheme.headlineSmall?.copyWith(
                          color: colors.onSurface,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                      const SizedBox(height: AppSpacingTokens.small),
                      Text(
                        localizations.partnersQuestionSubtitle,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: colors.onSurfaceVariant,
                          height: 1.5,
                        ),
                      ),
                      const SizedBox(height: AppSpacingTokens.medium),
                      OutlinedButton.icon(
                        onPressed: () {
                          context.push(AppRoutePaths.partnerApplications);
                        },
                        icon: const Icon(Icons.assignment_rounded),
                        label: Text(
                          localizations.partnerApplicationViewMyApplications,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(
                  AppLayoutTokens.screenHorizontalPadding,
                  0,
                  AppLayoutTokens.screenHorizontalPadding,
                  AppSpacingTokens.xxLarge,
                ),
                sliver: SliverLayoutBuilder(
                  builder: (context, constraints) {
                    final columns = constraints.crossAxisExtent < 340 ? 1 : 2;

                    return SliverGrid(
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: columns,
                        mainAxisSpacing: AppSpacingTokens.medium,
                        crossAxisSpacing: AppSpacingTokens.medium,
                        mainAxisExtent:
                            AppComponentTokens.partnerGridCardHeight,
                      ),
                      delegate: SliverChildBuilderDelegate((context, index) {
                        if (index == PartnerCatalog.categories.length) {
                          return PartnerSupportCard(
                            onTap: () {
                              ScaffoldMessenger.of(context)
                                ..hideCurrentSnackBar()
                                ..showSnackBar(
                                  SnackBar(
                                    content: Text(localizations.comingSoon),
                                  ),
                                );
                            },
                          );
                        }

                        final category = PartnerCatalog.categories[index];
                        return PartnerCategoryCard(
                          category: category,
                          onTap: () => context.push(
                            AppRoutePaths.addressPartnerCategoryLocation(
                              category.id.name,
                            ),
                          ),
                        );
                      }, childCount: PartnerCatalog.categories.length + 1),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
