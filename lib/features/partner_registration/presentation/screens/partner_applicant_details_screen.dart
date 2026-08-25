import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:address/app/route_paths.dart';
import 'package:address/core/design_system/components/buttons/animated_start_button.dart';
import 'package:address/core/design_system/components/layout/app_page_scaffold.dart';
import 'package:address/core/design_system/tokens/app_design_tokens.dart';
import 'package:address/features/partner_registration/data/partner_media_repository.dart';
import 'package:address/features/partner_registration/domain/models/partner_registration_draft.dart';
import 'package:address/features/partner_registration/presentation/controller/partner_registration_controller.dart';
import 'package:address/features/partner_registration/presentation/screens/partner_document_camera_screen.dart';
import 'package:address/features/partner_registration/presentation/validation/partner_registration_validators.dart';
import 'package:address/features/partner_registration/presentation/widgets/partner_image_picker_field.dart';
import 'package:address/features/partner_registration/presentation/widgets/partner_registration_text_field.dart';
import 'package:address/l10n/generated/app_localizations.dart';

class PartnerApplicantDetailsScreen extends StatefulWidget {
  const PartnerApplicantDetailsScreen({required this.draft, super.key});

  final PartnerRegistrationDraft draft;

  @override
  State<PartnerApplicantDetailsScreen> createState() =>
      _PartnerApplicantDetailsScreenState();
}

class _PartnerApplicantDetailsScreenState
    extends State<PartnerApplicantDetailsScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  late final PartnerRegistrationController _controller;
  late final PartnerMediaRepository _mediaRepository;
  late final TextEditingController _companyNameController;
  late final TextEditingController _companyNationalIdController;

  String _nationalCardImagePath = '';
  String _nationalCardImageName = '';
  String? _nationalCardImageError;
  String? _errorMessage;
  bool _isSubmitting = false;

  bool get _isLegalEntity =>
      widget.draft.applicantType == PartnerApplicantType.legalEntity;

  @override
  void initState() {
    super.initState();

    _controller = PartnerRegistrationController.fromDraft(draft: widget.draft);
    _mediaRepository = PartnerMediaRepository();
    _companyNameController = TextEditingController(
      text: widget.draft.companyName,
    );
    _companyNationalIdController = TextEditingController(
      text: widget.draft.companyNationalId,
    );
    _nationalCardImagePath = widget.draft.nationalCardImagePath;
    _nationalCardImageName = widget.draft.nationalCardImageName;
  }

  @override
  void dispose() {
    _controller.dispose();
    _companyNameController.dispose();
    _companyNationalIdController.dispose();
    super.dispose();
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
                  localizations.partnerApplicationDocumentsSection,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: AppSpacingTokens.small),
                Text(
                  _isLegalEntity
                      ? localizations.partnerRegistrationLegalEntityDescription
                      : localizations
                            .partnerIdentityNationalCardImageRequiredSubtitle,
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
                    textInputAction: TextInputAction.done,
                    inputFormatters:
                        PartnerRegistrationValidators.digitFormatters(
                          maxLength: 11,
                        ),
                    validator: companyNationalIdValidator,
                  ),
                  const SizedBox(height: AppSpacingTokens.medium),
                ],
                PartnerImagePickerField(
                  title: localizations.partnerIdentityNationalCardImage,
                  emptySubtitle: localizations
                      .partnerIdentityNationalCardImageRequiredSubtitle,
                  selectedName: _nationalCardImageName,
                  errorText: _nationalCardImageError,
                  onTap: _captureNationalCard,
                ),
                if (_errorMessage != null) ...<Widget>[
                  const SizedBox(height: AppSpacingTokens.medium),
                  _ApplicantDetailsErrorBanner(message: _errorMessage!),
                ],
                const SizedBox(height: AppSpacingTokens.xxLarge),
                Center(
                  child: AnimatedStartButton(
                    title: localizations.partnerRegistrationContinueToStore,
                    icon: Icons.arrow_back_rounded,
                    isEnabled: !_isSubmitting,
                    isLoading: _isSubmitting,
                    onTap: _continueToStore,
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
    if (_isSubmitting) {
      return;
    }

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
      _errorMessage = null;
    });
  }

  Future<void> _continueToStore() async {
    FocusManager.instance.primaryFocus?.unfocus();

    final localizations = AppLocalizations.of(context);
    final formIsValid = _formKey.currentState?.validate() ?? false;
    final hasNationalCard = _nationalCardImagePath.trim().isNotEmpty;

    setState(() {
      _nationalCardImageError = hasNationalCard
          ? null
          : localizations.partnerIdentityNationalCardImageValidation;
      _errorMessage = null;
    });

    if (_isSubmitting || !formIsValid || !hasNationalCard) {
      return;
    }

    setState(() {
      _isSubmitting = true;
    });

    try {
      var secureReference = _nationalCardImagePath.trim();
      var secureFileName = _nationalCardImageName.trim();

      if (!PartnerMediaRepository.isSecureReference(secureReference)) {
        final uploaded = await _mediaRepository.upload(
          kind: PartnerMediaKind.nationalCard,
          path: secureReference,
          fileName: secureFileName.isEmpty
              ? 'national-card.jpg'
              : secureFileName,
        );

        secureReference = uploaded.reference;
        secureFileName = uploaded.fileName;
      }

      _controller.updateApplicantDetails(
        companyName: _companyNameController.text,
        companyNationalId: PartnerRegistrationValidators.normalizeDigits(
          _companyNationalIdController.text,
        ),
        nationalCardImagePath: secureReference,
        nationalCardImageName: secureFileName,
      );

      if (!mounted) {
        return;
      }

      context.pushReplacement(
        AppRoutePaths.partnerRegistrationStoreInfo,
        extra: _controller.draft,
      );
    } on PartnerMediaUploadException catch (error) {
      if (!mounted) {
        return;
      }

      setState(() {
        _errorMessage = error.message;
      });
    } finally {
      if (mounted) {
        setState(() {
          _isSubmitting = false;
        });
      }
    }
  }
}

class _ApplicantDetailsErrorBanner extends StatelessWidget {
  const _ApplicantDetailsErrorBanner({required this.message});

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
