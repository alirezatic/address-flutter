import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';

import 'package:address/app/route_paths.dart';
import 'package:address/core/design_system/components/buttons/animated_start_button.dart';
import 'package:address/core/design_system/components/layout/app_page_scaffold.dart';
import 'package:address/core/design_system/tokens/app_design_tokens.dart';
import 'package:address/features/partner_registration/data/partner_verification_repository.dart';
import 'package:address/features/partner_registration/domain/models/partner_registration_draft.dart';
import 'package:address/features/partner_registration/presentation/screens/partner_identity_result_screen.dart';
import 'package:address/features/partner_registration/presentation/validation/partner_registration_validators.dart';
import 'package:address/features/partner_registration/presentation/widgets/partner_registration_text_field.dart';
import 'package:address/l10n/generated/app_localizations.dart';

class PartnerBasicInfoScreen extends StatefulWidget {
  const PartnerBasicInfoScreen({required this.draft, super.key});

  final PartnerRegistrationDraft draft;

  @override
  State<PartnerBasicInfoScreen> createState() => _PartnerBasicInfoScreenState();
}

class _PartnerBasicInfoScreenState extends State<PartnerBasicInfoScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  late final PartnerVerificationRepository _repository;
  late final TextEditingController _nationalIdController;
  late final TextEditingController _mobileController;
  late final TextEditingController _birthDateController;

  bool _consentAccepted = false;
  bool _mobileKeyboardDismissed = false;
  bool _isChecking = false;
  String? _errorMessage;

  bool get _isLegalEntity =>
      widget.draft.applicantType == PartnerApplicantType.legalEntity;

  @override
  void initState() {
    super.initState();

    _repository = PartnerVerificationRepository();

    final identityNationalId = _isLegalEntity
        ? widget.draft.representativeNationalId
        : widget.draft.nationalId;

    _nationalIdController = TextEditingController(text: identityNationalId);
    _mobileController = TextEditingController(text: widget.draft.mobile);
    _birthDateController = TextEditingController(
      text: widget.draft.birthDateInput,
    );

    _mobileController.addListener(_handleMobileChanged);
  }

  @override
  void dispose() {
    _nationalIdController.dispose();
    _birthDateController.dispose();
    _mobileController
      ..removeListener(_handleMobileChanged)
      ..dispose();
    super.dispose();
  }

  void _handleMobileChanged() {
    final mobile = PartnerRegistrationValidators.normalizeDigits(
      _mobileController.text,
    );
    final hasElevenDigits = mobile.length == 11;

    if (hasElevenDigits && !_mobileKeyboardDismissed) {
      _mobileKeyboardDismissed = true;
      FocusManager.instance.primaryFocus?.unfocus();
      TextInput.finishAutofillContext();
      return;
    }

    if (!hasElevenDigits) {
      _mobileKeyboardDismissed = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);

    String? requiredValidator(String? value) {
      if (value == null || value.trim().isEmpty) {
        return localizations.partnerRegistrationRequiredField;
      }

      return null;
    }

    String? nationalIdValidator(String? value) {
      final requiredError = requiredValidator(value);
      if (requiredError != null) {
        return requiredError;
      }

      if (!PartnerRegistrationValidators.hasExactDigits(value ?? '', 10)) {
        return localizations.partnerRegistrationInvalidNationalId;
      }

      return null;
    }

    String? mobileValidator(String? value) {
      final requiredError = requiredValidator(value);
      if (requiredError != null) {
        return requiredError;
      }

      if (!PartnerRegistrationValidators.isIranianMobile(value ?? '')) {
        return localizations.partnerRegistrationInvalidIranianMobile;
      }

      return null;
    }

    String? birthDateValidator(String? value) {
      final requiredError = requiredValidator(value);
      if (requiredError != null) {
        return requiredError;
      }

      if (!PartnerRegistrationValidators.isValidJalaliDate(value ?? '')) {
        return MaterialLocalizations.of(context).invalidDateFormatLabel;
      }

      return null;
    }

    return AppPageScaffold(
      navigationIcon: Icons.arrow_back_ios_new_rounded,
      navigationLabel: localizations.partnersBack,
      onNavigationPressed: () => context.pop(),
      resizeToAvoidBottomInset: true,
      body: Align(
        alignment: Alignment.topCenter,
        child: ConstrainedBox(
          constraints: const BoxConstraints(
            maxWidth: AppLayoutTokens.contentMaxWidth,
          ),
          child: Form(
            key: _formKey,
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
                  _isLegalEntity
                      ? localizations.partnerVerificationLegalOwnerTitle
                      : localizations.partnerVerificationOwnerTitle,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: AppSpacingTokens.small),
                Text(
                  localizations.partnerVerificationOwnerSubtitle,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                    height: 1.5,
                  ),
                ),
                const SizedBox(height: AppSpacingTokens.xxLarge),
                PartnerRegistrationTextField(
                  controller: _nationalIdController,
                  label: _isLegalEntity
                      ? localizations
                            .partnerRegistrationRepresentativeNationalId
                      : localizations.partnerRegistrationNationalId,
                  keyboardType: TextInputType.number,
                  textInputAction: TextInputAction.next,
                  inputFormatters:
                      PartnerRegistrationValidators.digitFormatters(
                        maxLength: 10,
                      ),
                  validator: nationalIdValidator,
                ),
                const SizedBox(height: AppSpacingTokens.medium),
                PartnerRegistrationTextField(
                  controller: _mobileController,
                  label: localizations.partnerRegistrationMobile,
                  keyboardType: TextInputType.phone,
                  textInputAction: TextInputAction.next,
                  inputFormatters:
                      PartnerRegistrationValidators.digitFormatters(
                        maxLength: 11,
                      ),
                  autofillHints: const <String>[AutofillHints.telephoneNumber],
                  validator: mobileValidator,
                ),
                const SizedBox(height: AppSpacingTokens.medium),
                PartnerRegistrationTextField(
                  controller: _birthDateController,
                  label: localizations.partnerVerificationBirthDate,
                  keyboardType: TextInputType.datetime,
                  textInputAction: TextInputAction.done,
                  inputFormatters:
                      PartnerRegistrationValidators.jalaliDateFormatters(),
                  validator: birthDateValidator,
                ),
                const SizedBox(height: AppSpacingTokens.medium),
                CheckboxListTile(
                  value: _consentAccepted,
                  contentPadding: EdgeInsets.zero,
                  controlAffinity: ListTileControlAffinity.leading,
                  title: Text(localizations.partnerVerificationConsent),
                  onChanged: _isChecking
                      ? null
                      : (value) {
                          FocusManager.instance.primaryFocus?.unfocus();
                          TextInput.finishAutofillContext();

                          setState(() {
                            _consentAccepted = value ?? false;
                            _errorMessage = null;
                          });
                        },
                ),
                if (_errorMessage != null) ...<Widget>[
                  const SizedBox(height: AppSpacingTokens.small),
                  _ErrorBanner(message: _errorMessage!),
                ],
                const SizedBox(height: AppSpacingTokens.xxLarge),
                Center(
                  child: AnimatedStartButton(
                    title: localizations.partnerVerificationLookupIdentity,
                    icon: Icons.arrow_back_rounded,
                    isEnabled: !_isChecking && _consentAccepted,
                    isLoading: _isChecking,
                    onTap: _checkIdentity,
                  ),
                ),
                const SizedBox(height: AppSpacingTokens.xxLarge),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _checkIdentity() async {
    FocusManager.instance.primaryFocus?.unfocus();
    TextInput.finishAutofillContext();

    final localizations = AppLocalizations.of(context);
    final formIsValid = _formKey.currentState?.validate() ?? false;

    if (_isChecking || !formIsValid) {
      return;
    }

    if (!_consentAccepted) {
      setState(() {
        _errorMessage = localizations.partnerVerificationConsentRequired;
      });
      return;
    }

    final birthDate = PartnerRegistrationValidators.normalizeJalaliDate(
      _birthDateController.text,
    );

    if (birthDate == null) {
      setState(() {
        _errorMessage = MaterialLocalizations.of(
          context,
        ).invalidDateFormatLabel;
      });
      return;
    }

    setState(() {
      _isChecking = true;
      _errorMessage = null;
    });

    try {
      final mobile = PartnerRegistrationValidators.normalizeDigits(
        _mobileController.text,
      );
      final nationalId = PartnerRegistrationValidators.normalizeDigits(
        _nationalIdController.text,
      );

      final verification = await _repository.checkIdentity(
        mobile: mobile,
        nationalId: nationalId,
        birthDate: birthDate,
        consentAccepted: true,
      );

      if (!mounted) {
        return;
      }

      setState(() {
        _isChecking = false;
      });

      await context.push<void>(
        AppRoutePaths.partnerRegistrationIdentityResult,
        extra: PartnerIdentityResultArgs(
          draft: widget.draft,
          verification: verification,
          mobile: mobile,
          birthDateInput: birthDate,
        ),
      );
    } on PartnerVerificationException catch (error) {
      if (!mounted) {
        return;
      }

      setState(() {
        _isChecking = false;
        _errorMessage = error.message;
      });
    }
  }
}

class _ErrorBanner extends StatelessWidget {
  const _ErrorBanner({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.all(AppSpacingTokens.medium),
      decoration: BoxDecoration(
        color: colorScheme.errorContainer,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Text(
        message,
        style: TextStyle(
          color: colorScheme.onErrorContainer,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}
