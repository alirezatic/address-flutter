import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:address/app/route_paths.dart';
import 'package:address/core/design_system/components/buttons/animated_start_button.dart';
import 'package:address/core/design_system/components/layout/app_page_scaffold.dart';
import 'package:address/core/design_system/tokens/app_design_tokens.dart';
import 'package:address/features/partner_registration/data/partner_verification_repository.dart';
import 'package:address/features/partner_registration/presentation/controller/partner_registration_start_coordinator.dart';
import 'package:address/features/partners/domain/models/partner_category.dart';
import 'package:address/features/partners/presentation/widgets/partner_summary_content.dart';
import 'package:address/l10n/generated/app_localizations.dart';

class PartnerSummaryScreen extends StatefulWidget {
  const PartnerSummaryScreen({super.key, required this.result});

  final PartnerSelectionResult result;

  @override
  State<PartnerSummaryScreen> createState() => _PartnerSummaryScreenState();
}

class _PartnerSummaryScreenState extends State<PartnerSummaryScreen> {
  bool _isStarting = false;

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);

    return AppPageScaffold(
      navigationIcon: Icons.arrow_back_ios_new_rounded,
      navigationLabel: localizations.partnersBack,
      onNavigationPressed: () => context.pop(),
      bottomNavigationBar: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(
            AppLayoutTokens.screenHorizontalPadding,
            AppSpacingTokens.small,
            AppLayoutTokens.screenHorizontalPadding,
            AppSpacingTokens.medium,
          ),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(
                maxWidth: AppLayoutTokens.contentMaxWidth,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  AnimatedStartButton(
                    title: localizations.partnerRegistrationStart,
                    isLoading: _isStarting,
                    onTap: _isStarting ? () {} : _startRegistration,
                  ),
                  const SizedBox(height: AppSpacingTokens.xSmall),
                  TextButton.icon(
                    onPressed: _isStarting
                        ? null
                        : () => context.go(AppRoutePaths.addressPartners),
                    icon: const Icon(Icons.restart_alt_rounded),
                    label: Text(localizations.partnersStartOver),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(
            maxWidth: AppLayoutTokens.contentMaxWidth,
          ),
          child: PartnerSummaryContent(result: widget.result),
        ),
      ),
    );
  }

  Future<void> _startRegistration() async {
    if (_isStarting) {
      return;
    }

    setState(() {
      _isStarting = true;
    });

    try {
      await PartnerRegistrationStartCoordinator.open(
        context: context,
        selection: widget.result,
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
        setState(() {
          _isStarting = false;
        });
      }
    }
  }
}
