import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:address/app/route_paths.dart';
import 'package:address/core/design_system/components/layout/app_page_scaffold.dart';
import 'package:address/core/design_system/tokens/app_design_tokens.dart';
import 'package:address/features/partner_registration/domain/models/partner_registration_draft.dart';
import 'package:address/features/partner_registration/presentation/controller/partner_registration_controller.dart';
import 'package:address/features/partner_registration/presentation/widgets/partner_applicant_type_card.dart';
import 'package:address/features/partners/domain/models/partner_category.dart';
import 'package:address/l10n/generated/app_localizations.dart';

class PartnerApplicantTypeScreen extends StatefulWidget {
  const PartnerApplicantTypeScreen({required this.selection, super.key});

  final PartnerSelectionResult selection;

  @override
  State<PartnerApplicantTypeScreen> createState() =>
      _PartnerApplicantTypeScreenState();
}

class _PartnerApplicantTypeScreenState
    extends State<PartnerApplicantTypeScreen> {
  late final PartnerRegistrationController _controller;

  PartnerApplicantType? _selectedType;
  bool _isNavigating = false;

  @override
  void initState() {
    super.initState();

    _controller = PartnerRegistrationController.fromSelection(
      selection: widget.selection,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);

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
              AppSpacingTokens.small,
              AppLayoutTokens.screenHorizontalPadding,
              AppSpacingTokens.xxLarge,
            ),
            children: <Widget>[
              Text(
                localizations.partnerRegistrationApplicantTypeTitle,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.w900,
                ),
              ),
              const SizedBox(height: AppSpacingTokens.small),
              Text(
                localizations.partnerRegistrationApplicantTypeSubtitle,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                  height: 1.5,
                ),
              ),
              const SizedBox(height: AppSpacingTokens.xxLarge),
              PartnerApplicantTypeCard(
                title: localizations.partnerRegistrationIndividual,
                subtitle:
                    localizations.partnerRegistrationIndividualDescription,
                icon: Icons.person_rounded,
                isSelected: _selectedType == PartnerApplicantType.individual,
                onTap: () =>
                    _selectAndOpenForm(PartnerApplicantType.individual),
              ),
              const SizedBox(height: AppSpacingTokens.medium),
              PartnerApplicantTypeCard(
                title: localizations.partnerRegistrationLegalEntity,
                subtitle:
                    localizations.partnerRegistrationLegalEntityDescription,
                icon: Icons.apartment_rounded,
                isSelected: _selectedType == PartnerApplicantType.legalEntity,
                onTap: () =>
                    _selectAndOpenForm(PartnerApplicantType.legalEntity),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _selectAndOpenForm(PartnerApplicantType applicantType) async {
    if (_isNavigating) {
      return;
    }

    setState(() {
      _selectedType = applicantType;
      _isNavigating = true;
    });

    _controller.selectApplicantType(applicantType);

    await Future<void>.delayed(const Duration(milliseconds: 320));

    if (!mounted) {
      return;
    }

    await context.push(
      AppRoutePaths.partnerRegistrationBasicInfo,
      extra: _controller.draft,
    );

    if (mounted) {
      setState(() {
        _isNavigating = false;
      });
    }
  }
}
