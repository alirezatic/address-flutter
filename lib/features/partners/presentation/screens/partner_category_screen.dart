import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:address/core/design_system/components/layout/app_page_scaffold.dart';
import 'package:address/core/design_system/tokens/app_design_tokens.dart';
import 'package:address/features/partner_registration/data/partner_verification_repository.dart';
import 'package:address/features/partner_registration/presentation/controller/partner_registration_start_coordinator.dart';
import 'package:address/features/partners/data/partner_catalog.dart';
import 'package:address/features/partners/domain/models/partner_category.dart';
import 'package:address/features/partners/presentation/controller/partners_controller.dart';
import 'package:address/features/partners/presentation/theme/partner_category_style.dart';
import 'package:address/features/partners/presentation/widgets/partner_category_banner.dart';
import 'package:address/features/partners/presentation/widgets/partner_driver_mode_selector.dart';
import 'package:address/features/partners/presentation/widgets/partner_selection_card.dart';
import 'package:address/l10n/generated/app_localizations.dart';

class PartnerCategoryScreen extends StatefulWidget {
  const PartnerCategoryScreen({super.key, required this.categoryId});

  final PartnerCategoryId categoryId;

  @override
  State<PartnerCategoryScreen> createState() => _PartnerCategoryScreenState();
}

class _PartnerCategoryScreenState extends State<PartnerCategoryScreen> {
  late final PartnerCategoryDefinition _category;
  late final PartnersController _controller;

  bool _isNavigating = false;

  @override
  void initState() {
    super.initState();
    _category = PartnerCatalog.byId(widget.categoryId);
    _controller = PartnersController(category: _category);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);

    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        final palette = _category.id.palette;

        return AppPageScaffold(
          navigationIcon: Icons.arrow_back_ios_new_rounded,
          navigationLabel: localizations.partnersBack,
          onNavigationPressed: () => context.pop(),
          body: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(
                maxWidth: AppLayoutTokens.contentMaxWidth,
              ),
              child: ListView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.fromLTRB(
                  AppLayoutTokens.screenHorizontalPadding,
                  0,
                  AppLayoutTokens.screenHorizontalPadding,
                  AppSpacingTokens.xxLarge,
                ),
                children: <Widget>[
                  PartnerCategoryBanner(
                    category: _category,
                    driverMode: _controller.driverMode,
                  ),
                  if (_category.selectionMode ==
                      PartnerSelectionMode.driver) ...<Widget>[
                    const SizedBox(height: AppSpacingTokens.large),
                    PartnerDriverModeSelector(
                      value: _controller.driverMode,
                      onChanged: _controller.changeDriverMode,
                    ),
                  ],
                  if (_category.selectionMode ==
                      PartnerSelectionMode.primarySecondary) ...<Widget>[
                    const SizedBox(height: AppSpacingTokens.large),
                    Text(
                      '${localizations.partnersPrimaryActivity} '
                      '${localizations.partnersOneItem}',
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ],
                  const SizedBox(height: AppSpacingTokens.medium),
                  for (final item in _category.items) ...<Widget>[
                    PartnerSelectionCard(
                      item: item,
                      accentColor: palette.accent[1],
                      isPrimary: _controller.isPrimary(item.id),
                      isSelected: _controller.isSelected(item.id),
                      onTap: () => _selectActivityAndOpenRegistration(item.id),
                    ),
                    const SizedBox(height: AppSpacingTokens.small),
                  ],
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Future<void> _selectActivityAndOpenRegistration(PartnerItemId itemId) async {
    if (_isNavigating) {
      return;
    }

    _controller.selectItem(itemId);

    if (!_controller.canSubmit) {
      return;
    }

    _isNavigating = true;

    try {
      await PartnerRegistrationStartCoordinator.open(
        context: context,
        selection: _controller.buildResult(),
      );
    } on PartnerVerificationException catch (error) {
      if (mounted) {
        ScaffoldMessenger.of(context)
          ..hideCurrentSnackBar()
          ..showSnackBar(
            SnackBar(
              content: Text(error.message),
              behavior: SnackBarBehavior.floating,
            ),
          );
      }
    } finally {
      if (mounted) {
        _isNavigating = false;
      }
    }
  }
}
