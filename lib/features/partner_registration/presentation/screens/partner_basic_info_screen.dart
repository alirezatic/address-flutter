import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';

import 'package:address/app/route_paths.dart';
import 'package:address/core/design_system/components/buttons/animated_start_button.dart';
import 'package:address/core/design_system/components/layout/app_page_scaffold.dart';
import 'package:address/core/design_system/tokens/app_design_tokens.dart';
import 'package:address/features/partner_registration/data/partner_verification_repository.dart';
import 'package:address/features/partner_registration/domain/models/partner_registration_draft.dart';
import 'package:address/features/partner_registration/presentation/screens/partner_document_camera_screen.dart';
import 'package:address/features/partner_registration/presentation/screens/partner_identity_result_screen.dart';
import 'package:address/features/partner_registration/presentation/validation/partner_registration_validators.dart';
import 'package:address/features/partner_registration/presentation/widgets/partner_image_picker_field.dart';
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
  late final TextEditingController _companyNameController;
  late final TextEditingController _companyNationalIdController;
  late final TextEditingController _nationalIdController;
  late final TextEditingController _mobileController;

  bool _consentAccepted = false;
  bool _mobileKeyboardDismissed = false;
  bool _isChecking = false;
  String _nationalCardImagePath = '';
  String _nationalCardImageName = '';
  String? _nationalCardImageError;
  String? _errorMessage;

  bool get _isLegalEntity =>
      widget.draft.applicantType == PartnerApplicantType.legalEntity;

  @override
  void initState() {
    super.initState();

    _repository = PartnerVerificationRepository();

    _companyNameController = TextEditingController(
      text: widget.draft.companyName,
    );
    _companyNationalIdController = TextEditingController(
      text: widget.draft.companyNationalId,
    );

    final identityNationalId = _isLegalEntity
        ? widget.draft.representativeNationalId
        : widget.draft.nationalId;

    _nationalIdController = TextEditingController(text: identityNationalId);
    _mobileController = TextEditingController(text: widget.draft.mobile);
    _mobileController.addListener(_handleMobileChanged);

    _nationalCardImagePath = widget.draft.nationalCardImagePath;
    _nationalCardImageName = widget.draft.nationalCardImageName;
  }

  @override
  void dispose() {
    _companyNameController.dispose();
    _companyNationalIdController.dispose();
    _nationalIdController.dispose();
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

    String? companyNationalIdValidator(String? value) {
      final requiredError = requiredValidator(value);
      if (requiredError != null) {
        return requiredError;
      }

      if (!PartnerRegistrationValidators.hasExactDigits(value ?? '', 11)) {
        return localizations.partnerRegistrationInvalidCompanyNationalId;
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
                if (_isLegalEntity) ...<Widget>[
                  PartnerRegistrationTextField(
                    controller: _companyNameController,
                    label: localizations.partnerRegistrationCompanyName,
                    textInputAction: TextInputAction.next,
                    validator: requiredValidator,
                  ),
                  const SizedBox(height: AppSpacingTokens.medium),
                  PartnerRegistrationTextField(
                    controller: _companyNationalIdController,
                    label: localizations.partnerRegistrationCompanyNationalId,
                    keyboardType: TextInputType.number,
                    textInputAction: TextInputAction.next,
                    inputFormatters:
                        PartnerRegistrationValidators.digitFormatters(
                          maxLength: 11,
                        ),
                    validator: companyNationalIdValidator,
                  ),
                  const SizedBox(height: AppSpacingTokens.medium),
                ],
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
                  label: localizations.partnerVerificationOwnerMobile,
                  keyboardType: TextInputType.phone,
                  textInputAction: TextInputAction.done,
                  inputFormatters:
                      PartnerRegistrationValidators.digitFormatters(
                        maxLength: 11,
                      ),
                  autofillHints: const <String>[AutofillHints.telephoneNumber],
                  validator: mobileValidator,
                ),
                const SizedBox(height: AppSpacingTokens.medium),
                PartnerImagePickerField(
                  title: localizations.partnerIdentityNationalCardImage,
                  emptySubtitle: localizations
                      .partnerIdentityNationalCardImageRequiredSubtitle,
                  selectedName: _nationalCardImageName,
                  errorText: _nationalCardImageError,
                  onTap: _captureNationalCard,
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

  Future<void> _captureNationalCard() async {
    FocusManager.instance.primaryFocus?.unfocus();
    final localizations = AppLocalizations.of(context);

    final result = await Navigator.of(context)
        .push<PartnerDocumentCaptureResult>(
          MaterialPageRoute<PartnerDocumentCaptureResult>(
            builder: (context) {
              return PartnerDocumentCameraScreen(
                args: PartnerDocumentCameraArgs(
                  title: localizations.partnerIdentityNationalCardCameraTitle,
                  instruction: localizations
                      .partnerIdentityNationalCardCameraInstruction,
                  guideAspectRatio: 1.586,
                ),
              );
            },
          ),
        );

    if (!mounted || result == null) {
      return;
    }

    setState(() {
      _nationalCardImagePath = result.path;
      _nationalCardImageName = result.name;
      _nationalCardImageError = null;
    });
  }

  Future<void> _checkIdentity() async {
    FocusManager.instance.primaryFocus?.unfocus();
    TextInput.finishAutofillContext();

    final localizations = AppLocalizations.of(context);
    final formIsValid = _formKey.currentState?.validate() ?? false;
    final hasNationalCard = _nationalCardImagePath.isNotEmpty;

    setState(() {
      _nationalCardImageError = hasNationalCard
          ? null
          : localizations.partnerIdentityNationalCardImageValidation;
    });

    if (_isChecking || !formIsValid || !hasNationalCard) {
      return;
    }

    if (!_consentAccepted) {
      setState(() {
        _errorMessage = localizations.partnerVerificationConsentRequired;
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
      final companyNationalId = PartnerRegistrationValidators.normalizeDigits(
        _companyNationalIdController.text,
      );

      final verification = await _repository.checkIdentity(
        mobile: mobile,
        nationalId: nationalId,
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
          companyName: _companyNameController.text.trim(),
          companyNationalId: companyNationalId,
          nationalCardImagePath: _nationalCardImagePath,
          nationalCardImageName: _nationalCardImageName,
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
