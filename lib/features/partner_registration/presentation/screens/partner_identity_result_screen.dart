import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:address/app/route_paths.dart';
import 'package:address/core/design_system/components/buttons/animated_start_button.dart';
import 'package:address/core/design_system/components/layout/app_page_scaffold.dart';
import 'package:address/core/design_system/tokens/app_design_tokens.dart';
import 'package:address/features/partner_registration/data/models/partner_identity_verification.dart';
import 'package:address/features/partner_registration/data/partner_verification_repository.dart';
import 'package:address/features/partner_registration/domain/models/partner_registration_draft.dart';
import 'package:address/features/partner_registration/presentation/controller/partner_registration_controller.dart';
import 'package:address/l10n/generated/app_localizations.dart';

class PartnerIdentityResultArgs {
  const PartnerIdentityResultArgs({
    required this.draft,
    required this.verification,
    required this.mobile,
    required this.birthDateInput,
  });

  final PartnerRegistrationDraft draft;
  final PartnerIdentityVerification verification;
  final String mobile;
  final String birthDateInput;
}

class PartnerIdentityResultScreen extends StatefulWidget {
  const PartnerIdentityResultScreen({required this.args, super.key});

  final PartnerIdentityResultArgs args;

  @override
  State<PartnerIdentityResultScreen> createState() =>
      _PartnerIdentityResultScreenState();
}

class _PartnerIdentityResultScreenState
    extends State<PartnerIdentityResultScreen> {
  late final PartnerVerificationRepository _repository;
  late final PartnerRegistrationController _controller;

  bool _accuracyConfirmed = false;
  bool _isConfirming = false;
  String? _errorMessage;

  PartnerIdentityVerification get _verification => widget.args.verification;

  @override
  void initState() {
    super.initState();
    _repository = PartnerVerificationRepository();
    _controller = PartnerRegistrationController.fromDraft(
      draft: widget.args.draft,
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
    final matched = _verification.mobileOwnershipMatched;

    return AppPageScaffold(
      navigationIcon: Icons.arrow_back_ios_new_rounded,
      navigationLabel: localizations.partnersBack,
      onNavigationPressed: () => context.pop(),
      body: Align(
        alignment: Alignment.topCenter,
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
                localizations.partnerIdentityResultPageTitle,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.w900,
                ),
              ),
              const SizedBox(height: AppSpacingTokens.small),
              Text(
                matched
                    ? localizations.partnerIdentityResultMatchedSubtitle
                    : localizations.partnerIdentityResultMismatchSubtitle,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: matched
                      ? Theme.of(context).colorScheme.onSurfaceVariant
                      : Theme.of(context).colorScheme.error,
                  height: 1.5,
                  fontWeight: matched ? FontWeight.w500 : FontWeight.w800,
                ),
              ),
              const SizedBox(height: AppSpacingTokens.large),
              _IdentityResultCard(
                verification: _verification,
                mobile: widget.args.mobile,
                nationalIdLabel: localizations.partnerRegistrationNationalId,
                mobileLabel: localizations.partnerVerificationOwnerMobile,
                fatherNameLabel: localizations.partnerVerificationFatherName,
                birthDateLabel: localizations.partnerVerificationBirthDate,
                matchedText: localizations.partnerVerificationMobileMatched,
                mismatchText: localizations.partnerVerificationMobileMismatch,
              ),
              if (_errorMessage != null) ...<Widget>[
                const SizedBox(height: AppSpacingTokens.medium),
                _ResultErrorBanner(message: _errorMessage!),
              ],
              const SizedBox(height: AppSpacingTokens.medium),
              if (matched)
                CheckboxListTile(
                  value: _accuracyConfirmed,
                  contentPadding: EdgeInsets.zero,
                  controlAffinity: ListTileControlAffinity.leading,
                  title: Text(localizations.partnerVerificationConfirmAccuracy),
                  onChanged: _isConfirming
                      ? null
                      : (value) {
                          FocusManager.instance.primaryFocus?.unfocus();
                          setState(() {
                            _accuracyConfirmed = value ?? false;
                            _errorMessage = null;
                          });
                        },
                )
              else
                OutlinedButton.icon(
                  onPressed: _isConfirming ? null : () => context.pop(),
                  icon: const Icon(Icons.edit_rounded),
                  label: Text(localizations.partnerIdentityEditInformation),
                ),
              const SizedBox(height: AppSpacingTokens.xxLarge),
              if (matched)
                Center(
                  child: AnimatedStartButton(
                    icon: Icons.arrow_back_rounded,
                    isEnabled: !_isConfirming && _accuracyConfirmed,
                    isLoading: _isConfirming,
                    onTap: _confirmAndContinue,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _confirmAndContinue() async {
    final localizations = AppLocalizations.of(context);

    if (_isConfirming || !_accuracyConfirmed) {
      setState(() {
        _errorMessage = localizations.partnerVerificationAccuracyRequired;
      });
      return;
    }

    setState(() {
      _isConfirming = true;
      _errorMessage = null;
    });

    try {
      await _repository.confirmIdentity(
        verificationId: _verification.verificationId,
        confirmed: true,
      );

      _controller.updateVerifiedApplicant(
        verification: _verification,
        mobile: widget.args.mobile,
        birthDateInput: widget.args.birthDateInput,
      );

      if (!mounted) {
        return;
      }

      context.pushReplacement(
        AppRoutePaths.partnerRegistrationLiveness,
        extra: _controller.draft,
      );
    } on PartnerVerificationException catch (error) {
      if (!mounted) {
        return;
      }

      setState(() {
        _errorMessage = error.message;
      });
    } finally {
      if (mounted) {
        setState(() {
          _isConfirming = false;
        });
      }
    }
  }
}

class _IdentityResultCard extends StatelessWidget {
  const _IdentityResultCard({
    required this.verification,
    required this.mobile,
    required this.nationalIdLabel,
    required this.mobileLabel,
    required this.fatherNameLabel,
    required this.birthDateLabel,
    required this.matchedText,
    required this.mismatchText,
  });

  final PartnerIdentityVerification verification;
  final String mobile;
  final String nationalIdLabel;
  final String mobileLabel;
  final String fatherNameLabel;
  final String birthDateLabel;
  final String matchedText;
  final String mismatchText;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final matched = verification.mobileOwnershipMatched;

    return Card(
      margin: EdgeInsets.zero,
      child: Padding(
        padding: const EdgeInsets.all(AppSpacingTokens.large),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Text(
              verification.fullName,
              textAlign: TextAlign.center,
              style: Theme.of(
                context,
              ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w900),
            ),
            const SizedBox(height: AppSpacingTokens.medium),
            _ResultRow(label: nationalIdLabel, value: verification.nationalId),
            _ResultRow(label: mobileLabel, value: mobile),
            _ResultRow(label: fatherNameLabel, value: verification.fatherName),
            _ResultRow(label: birthDateLabel, value: verification.birthDate),
            const SizedBox(height: AppSpacingTokens.small),
            Container(
              padding: const EdgeInsets.all(AppSpacingTokens.medium),
              decoration: BoxDecoration(
                color: matched
                    ? colors.primaryContainer
                    : colors.errorContainer,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                children: <Widget>[
                  Icon(
                    matched ? Icons.check_circle_rounded : Icons.error_rounded,
                    color: matched
                        ? colors.onPrimaryContainer
                        : colors.onErrorContainer,
                  ),
                  const SizedBox(width: AppSpacingTokens.small),
                  Expanded(
                    child: Text(
                      matched ? matchedText : mismatchText,
                      style: TextStyle(
                        color: matched
                            ? colors.onPrimaryContainer
                            : colors.onErrorContainer,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ResultRow extends StatelessWidget {
  const _ResultRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacingTokens.small),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text('$label: '),
          Expanded(
            child: Directionality(
              textDirection: TextDirection.ltr,
              child: Text(
                value,
                textAlign: TextAlign.end,
                style: const TextStyle(fontWeight: FontWeight.w700),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ResultErrorBanner extends StatelessWidget {
  const _ResultErrorBanner({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.all(AppSpacingTokens.medium),
      decoration: BoxDecoration(
        color: colors.errorContainer,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Text(
        message,
        style: TextStyle(
          color: colors.onErrorContainer,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}
