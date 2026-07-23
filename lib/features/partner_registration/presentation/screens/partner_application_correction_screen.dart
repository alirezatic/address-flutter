import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:latlong2/latlong.dart';

import 'package:address/app/route_paths.dart';
import 'package:address/core/design_system/components/buttons/animated_start_button.dart';
import 'package:address/core/design_system/components/layout/app_page_scaffold.dart';
import 'package:address/core/design_system/tokens/app_design_tokens.dart';
import 'package:address/features/partner_registration/data/models/partner_identity_verification.dart';
import 'package:address/features/partner_registration/data/partner_applications_repository.dart';
import 'package:address/features/partner_registration/data/partner_verification_repository.dart';
import 'package:address/features/partner_registration/domain/models/partner_correction_item.dart';
import 'package:address/features/partner_registration/domain/models/partner_registration_draft.dart';
import 'package:address/features/partner_registration/presentation/screens/partner_applications_screen.dart';
import 'package:address/features/partner_registration/presentation/screens/partner_document_camera_screen.dart';
import 'package:address/features/partner_registration/presentation/screens/partner_map_confirmation_screen.dart';
import 'package:address/features/partner_registration/presentation/validation/partner_registration_validators.dart';
import 'package:address/features/partner_registration/presentation/widgets/partner_image_picker_field.dart';
import 'package:address/features/partner_registration/presentation/widgets/partner_registration_text_field.dart';
import 'package:address/features/partners/domain/models/partner_category.dart';
import 'package:address/features/partner_registration/presentation/localization/partner_api_error_localizer.dart';
import 'package:address/features/partners/presentation/localization/partner_localizations.dart';
import 'package:address/l10n/generated/app_localizations.dart';

// addressPartnerSelectiveCorrectionV1
class PartnerApplicationCorrectionScreen extends StatefulWidget {
  const PartnerApplicationCorrectionScreen({required this.draft, super.key});

  final PartnerRegistrationDraft draft;

  @override
  State<PartnerApplicationCorrectionScreen> createState() =>
      _PartnerApplicationCorrectionScreenState();
}

class _PartnerApplicationCorrectionScreenState
    extends State<PartnerApplicationCorrectionScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final ImagePicker _imagePicker = ImagePicker();

  late final PartnerApplicationsRepository _applicationsRepository;
  late final PartnerVerificationRepository _verificationRepository;
  late final String _clientRequestId;

  late final PartnerRegistrationDraft _originalDraft;
  late PartnerRegistrationDraft _draft;
  late PartnerCategoryId _categoryId;
  late PartnerDriverMode _driverMode;
  late Set<PartnerItemId> _selectedItemIds;

  late final TextEditingController _companyNameController;
  late final TextEditingController _companyNationalIdController;
  late final TextEditingController _nationalIdController;
  late final TextEditingController _mobileController;
  late final TextEditingController _storeNameController;
  late final TextEditingController _storePhoneController;
  late final TextEditingController _storeAreaController;
  late final TextEditingController _businessDescriptionController;
  late final TextEditingController _experienceYearsController;
  late final TextEditingController _postalCodeController;
  late final TextEditingController _storeAddressController;

  PartnerStoreOwnership? _ownership;
  String _nationalCardPath = '';
  String _nationalCardName = '';
  String _licensePath = '';
  String _licenseName = '';
  String _signboardPath = '';
  String _signboardName = '';
  String _ownershipDocumentPath = '';
  String _ownershipDocumentName = '';

  bool _identityConsentAccepted = false;
  bool _identityVerificationUpdated = false;
  bool _livenessUpdated = false;
  bool _mapUpdated = false;
  bool _isBusy = false;
  bool _isPostalLoading = false;
  String? _postalLookupCode;
  String? _errorMessage;

  bool get _isLegalEntity =>
      _draft.applicantType == PartnerApplicantType.legalEntity;

  bool get _otherSelected => _draft.correctionItems.any(
    (item) => item.field == PartnerCorrectionField.other,
  );

  bool _isExplicit(PartnerCorrectionField field) {
    return _draft.correctionItems.any((item) => item.field == field);
  }

  bool _showField(PartnerCorrectionField field) {
    return _otherSelected || _isExplicit(field);
  }

  @override
  void initState() {
    super.initState();

    _originalDraft = widget.draft;
    _draft = widget.draft;
    _applicationsRepository = PartnerApplicationsRepository();
    _verificationRepository = PartnerVerificationRepository();
    _clientRequestId = _applicationsRepository.createClientRequestId();

    _categoryId = _draft.selection.categoryId;
    _driverMode = _draft.selection.driverMode;
    _selectedItemIds = <PartnerItemId>{
      if (_draft.selection.primaryItemId != null)
        _draft.selection.primaryItemId!,
      ..._draft.selection.selectedItemIds,
    };

    _companyNameController = TextEditingController(text: _draft.companyName);
    _companyNationalIdController = TextEditingController(
      text: _draft.companyNationalId,
    );
    _nationalIdController = TextEditingController(
      text: _isLegalEntity
          ? _draft.representativeNationalId
          : _draft.nationalId,
    );
    _mobileController = TextEditingController(text: _draft.mobile);
    _storeNameController = TextEditingController(text: _draft.storeName);
    _storePhoneController = TextEditingController(text: _draft.storePhone);
    _storeAreaController = TextEditingController(
      text: _draft.storeAreaSquareMeters,
    );
    _businessDescriptionController = TextEditingController(
      text: _draft.businessDescription,
    );
    _experienceYearsController = TextEditingController(
      text: _draft.experienceYears,
    );
    _postalCodeController = TextEditingController(text: _draft.postalCode);
    _storeAddressController = TextEditingController(text: _draft.storeAddress);
    _ownership = _draft.storeOwnership;
    _postalLookupCode = _draft.postalCode;
  }

  @override
  void dispose() {
    _companyNameController.dispose();
    _companyNationalIdController.dispose();
    _nationalIdController.dispose();
    _mobileController.dispose();
    _storeNameController.dispose();
    _storePhoneController.dispose();
    _storeAreaController.dispose();
    _businessDescriptionController.dispose();
    _experienceYearsController.dispose();
    _postalCodeController.dispose();
    _storeAddressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);

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
                  localizations.partnerSelectiveCorrectionTitle,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: AppSpacingTokens.small),
                Text(
                  localizations.partnerSelectiveCorrectionSubtitle,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                    height: 1.6,
                  ),
                ),
                const SizedBox(height: AppSpacingTokens.large),
                _CorrectionItemsCard(items: _draft.correctionItems),
                if (_otherSelected) ...<Widget>[
                  const SizedBox(height: AppSpacingTokens.medium),
                  _NoticeCard(
                    icon: Icons.info_outline_rounded,
                    message:
                        localizations.partnerSelectiveCorrectionOtherNotice,
                  ),
                ],
                if (_showField(PartnerCorrectionField.selection)) ...<Widget>[
                  const SizedBox(height: AppSpacingTokens.medium),
                  _buildSelectionSection(localizations),
                ],
                if (_showField(PartnerCorrectionField.applicantIdentity) ||
                    _showField(
                      PartnerCorrectionField.applicantContact,
                    )) ...<Widget>[
                  const SizedBox(height: AppSpacingTokens.medium),
                  _buildApplicantSection(localizations),
                ],
                if (_showField(
                  PartnerCorrectionField.nationalCard,
                )) ...<Widget>[
                  const SizedBox(height: AppSpacingTokens.medium),
                  _CorrectionSection(
                    title: _titleFor(
                      PartnerCorrectionField.nationalCard,
                      localizations.partnerIdentityNationalCardImage,
                    ),
                    note: _noteFor(PartnerCorrectionField.nationalCard),
                    icon: Icons.badge_rounded,
                    child: PartnerImagePickerField(
                      title: localizations.partnerIdentityNationalCardImage,
                      emptySubtitle: localizations
                          .partnerSelectiveCorrectionNewFileRequired,
                      selectedName: _nationalCardName,
                      onTap: _captureNationalCard,
                    ),
                  ),
                ],
                if (_showField(
                  PartnerCorrectionField.livenessVideo,
                )) ...<Widget>[
                  const SizedBox(height: AppSpacingTokens.medium),
                  _buildLivenessSection(localizations),
                ],
                if (_showField(
                  PartnerCorrectionField.storeDetails,
                )) ...<Widget>[
                  const SizedBox(height: AppSpacingTokens.medium),
                  _buildStoreDetailsSection(localizations),
                ],
                if (_showField(
                  PartnerCorrectionField.storeAddress,
                )) ...<Widget>[
                  const SizedBox(height: AppSpacingTokens.medium),
                  _buildAddressSection(localizations),
                ],
                if (_showField(PartnerCorrectionField.storeMap)) ...<Widget>[
                  const SizedBox(height: AppSpacingTokens.medium),
                  _buildMapSection(localizations),
                ],
                if (_showField(PartnerCorrectionField.license) ||
                    _showField(PartnerCorrectionField.signboard) ||
                    _showField(
                      PartnerCorrectionField.ownershipDocument,
                    )) ...<Widget>[
                  const SizedBox(height: AppSpacingTokens.medium),
                  _buildStoreDocumentsSection(localizations),
                ],
                if (_errorMessage != null) ...<Widget>[
                  const SizedBox(height: AppSpacingTokens.medium),
                  _ErrorBanner(message: _errorMessage!),
                ],
                const SizedBox(height: AppSpacingTokens.xxLarge),
                Center(
                  child: AnimatedStartButton(
                    title: localizations.partnerApplicationResubmitFinal,
                    isEnabled: !_isBusy && !_isPostalLoading,
                    isLoading: _isBusy,
                    onTap: _resubmit,
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

  Widget _buildSelectionSection(AppLocalizations localizations) {
    final availableItems = PartnerItemId.values
        .where((item) => _belongsToCategory(item, _categoryId))
        .toList(growable: false);

    return _CorrectionSection(
      title: _titleFor(
        PartnerCorrectionField.selection,
        localizations.partnerApplicationActivitySection,
      ),
      note: _noteFor(PartnerCorrectionField.selection),
      icon: Icons.category_rounded,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          DropdownButtonFormField<PartnerCategoryId>(
            initialValue: _categoryId,
            decoration: InputDecoration(
              labelText: localizations.partnerApplicationCategory,
            ),
            items: PartnerCategoryId.values
                .map(
                  (category) => DropdownMenuItem<PartnerCategoryId>(
                    value: category,
                    child: Text(category.title(localizations)),
                  ),
                )
                .toList(growable: false),
            onChanged: _isBusy
                ? null
                : (value) {
                    if (value == null || value == _categoryId) {
                      return;
                    }

                    setState(() {
                      _categoryId = value;
                      _selectedItemIds = <PartnerItemId>{};
                    });
                  },
          ),
          if (_categoryId == PartnerCategoryId.drivers) ...<Widget>[
            const SizedBox(height: AppSpacingTokens.medium),
            DropdownButtonFormField<PartnerDriverMode>(
              initialValue: _driverMode,
              decoration: InputDecoration(
                labelText: localizations.partnerApplicationApplicantType,
              ),
              items: <DropdownMenuItem<PartnerDriverMode>>[
                DropdownMenuItem<PartnerDriverMode>(
                  value: PartnerDriverMode.personal,
                  child: Text(localizations.partnersDriverPersonal),
                ),
                DropdownMenuItem<PartnerDriverMode>(
                  value: PartnerDriverMode.company,
                  child: Text(localizations.partnersDriverCompany),
                ),
              ],
              onChanged: _isBusy
                  ? null
                  : (value) {
                      if (value != null) {
                        setState(() {
                          _driverMode = value;
                        });
                      }
                    },
            ),
          ],
          const SizedBox(height: AppSpacingTokens.medium),
          Wrap(
            spacing: AppSpacingTokens.small,
            runSpacing: AppSpacingTokens.small,
            children: availableItems
                .map(
                  (item) => FilterChip(
                    label: Text(item.title(localizations)),
                    selected: _selectedItemIds.contains(item),
                    onSelected: _isBusy
                        ? null
                        : (selected) {
                            setState(() {
                              if (selected) {
                                _selectedItemIds.add(item);
                              } else {
                                _selectedItemIds.remove(item);
                              }
                            });
                          },
                  ),
                )
                .toList(growable: false),
          ),
        ],
      ),
    );
  }

  Widget _buildApplicantSection(AppLocalizations localizations) {
    return _CorrectionSection(
      title: _titleFor(
        _showField(PartnerCorrectionField.applicantIdentity)
            ? PartnerCorrectionField.applicantIdentity
            : PartnerCorrectionField.applicantContact,
        localizations.partnerApplicationIdentitySection,
      ),
      note: _combinedNotes(<PartnerCorrectionField>[
        PartnerCorrectionField.applicantIdentity,
        PartnerCorrectionField.applicantContact,
      ]),
      icon: Icons.person_search_rounded,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          if (_showField(PartnerCorrectionField.applicantIdentity)) ...<Widget>[
            if (_isLegalEntity) ...<Widget>[
              PartnerRegistrationTextField(
                controller: _companyNameController,
                label: localizations.partnerRegistrationCompanyName,
                validator: _requiredValidator,
              ),
              const SizedBox(height: AppSpacingTokens.medium),
              PartnerRegistrationTextField(
                controller: _companyNationalIdController,
                label: localizations.partnerRegistrationCompanyNationalId,
                keyboardType: TextInputType.number,
                inputFormatters: PartnerRegistrationValidators.digitFormatters(
                  maxLength: 11,
                ),
                validator: _companyNationalIdValidator,
              ),
              const SizedBox(height: AppSpacingTokens.medium),
            ],
            PartnerRegistrationTextField(
              controller: _nationalIdController,
              label: _isLegalEntity
                  ? localizations.partnerRegistrationRepresentativeNationalId
                  : localizations.partnerRegistrationNationalId,
              keyboardType: TextInputType.number,
              inputFormatters: PartnerRegistrationValidators.digitFormatters(
                maxLength: 10,
              ),
              validator: _nationalIdValidator,
            ),
          ],
          if (_showField(PartnerCorrectionField.applicantIdentity) &&
              _showField(PartnerCorrectionField.applicantContact))
            const SizedBox(height: AppSpacingTokens.medium),
          if (_showField(PartnerCorrectionField.applicantContact))
            PartnerRegistrationTextField(
              controller: _mobileController,
              label: localizations.partnerVerificationOwnerMobile,
              keyboardType: TextInputType.phone,
              inputFormatters: PartnerRegistrationValidators.digitFormatters(
                maxLength: 11,
              ),
              validator: _mobileValidator,
            ),
          const SizedBox(height: AppSpacingTokens.small),
          CheckboxListTile(
            value: _identityConsentAccepted,
            contentPadding: EdgeInsets.zero,
            controlAffinity: ListTileControlAffinity.leading,
            title: Text(localizations.partnerVerificationConsent),
            onChanged: _isBusy
                ? null
                : (value) {
                    setState(() {
                      _identityConsentAccepted = value ?? false;
                    });
                  },
          ),
        ],
      ),
    );
  }

  Widget _buildLivenessSection(AppLocalizations localizations) {
    return _CorrectionSection(
      title: _titleFor(
        PartnerCorrectionField.livenessVideo,
        localizations.partnerLivenessTitle,
      ),
      note: _noteFor(PartnerCorrectionField.livenessVideo),
      icon: Icons.videocam_rounded,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          _StatusRow(
            completed: _livenessUpdated,
            completedText: localizations.partnerSelectiveCorrectionLivenessDone,
            pendingText:
                localizations.partnerSelectiveCorrectionLivenessRequired,
          ),
          const SizedBox(height: AppSpacingTokens.medium),
          OutlinedButton.icon(
            onPressed: _isBusy ? null : _openLivenessCorrection,
            icon: const Icon(Icons.video_camera_front_rounded),
            label: Text(localizations.partnerSelectiveCorrectionLivenessAction),
          ),
        ],
      ),
    );
  }

  Widget _buildStoreDetailsSection(AppLocalizations localizations) {
    return _CorrectionSection(
      title: _titleFor(
        PartnerCorrectionField.storeDetails,
        localizations.partnerRegistrationStoreInformationTitle,
      ),
      note: _noteFor(PartnerCorrectionField.storeDetails),
      icon: Icons.storefront_rounded,
      child: Column(
        children: <Widget>[
          PartnerRegistrationTextField(
            controller: _storeNameController,
            label: localizations.partnerRegistrationStoreName,
            validator: _requiredValidator,
          ),
          const SizedBox(height: AppSpacingTokens.medium),
          PartnerRegistrationTextField(
            controller: _storePhoneController,
            label: localizations.partnerRegistrationStorePhone,
            keyboardType: TextInputType.phone,
            inputFormatters: PartnerRegistrationValidators.digitFormatters(
              maxLength: 11,
            ),
            validator: _storePhoneValidator,
          ),
          const SizedBox(height: AppSpacingTokens.medium),
          DropdownButtonFormField<PartnerStoreOwnership>(
            initialValue: _ownership,
            decoration: InputDecoration(
              labelText: localizations.partnerRegistrationStoreOwnership,
            ),
            items: PartnerStoreOwnership.values
                .map(
                  (ownership) => DropdownMenuItem<PartnerStoreOwnership>(
                    value: ownership,
                    child: Text(_ownershipTitle(ownership, localizations)),
                  ),
                )
                .toList(growable: false),
            validator: (value) => value == null
                ? localizations.partnerRegistrationRequiredField
                : null,
            onChanged: _isBusy
                ? null
                : (value) {
                    setState(() {
                      _ownership = value;
                    });
                  },
          ),
          const SizedBox(height: AppSpacingTokens.medium),
          PartnerRegistrationTextField(
            controller: _storeAreaController,
            label: localizations.partnerRegistrationStoreArea,
            keyboardType: TextInputType.number,
            inputFormatters: PartnerRegistrationValidators.digitFormatters(
              maxLength: 6,
            ),
            validator: _requiredValidator,
          ),
          const SizedBox(height: AppSpacingTokens.medium),
          PartnerRegistrationTextField(
            controller: _businessDescriptionController,
            label: localizations.partnerRegistrationBusinessDescriptionOptional,
            minLines: 3,
            maxLines: 5,
          ),
          const SizedBox(height: AppSpacingTokens.medium),
          PartnerRegistrationTextField(
            controller: _experienceYearsController,
            label: localizations.partnerRegistrationExperienceYears,
            keyboardType: TextInputType.number,
            inputFormatters: PartnerRegistrationValidators.digitFormatters(
              maxLength: 2,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAddressSection(AppLocalizations localizations) {
    final normalizedPostalCode = PartnerRegistrationValidators.normalizeDigits(
      _postalCodeController.text,
    );
    final lookupIsCurrent =
        normalizedPostalCode.isNotEmpty &&
        normalizedPostalCode == _postalLookupCode;

    return _CorrectionSection(
      title: _titleFor(
        PartnerCorrectionField.storeAddress,
        localizations.partnerRegistrationStoreAddress,
      ),
      note: _noteFor(PartnerCorrectionField.storeAddress),
      icon: Icons.location_on_rounded,
      child: Column(
        children: <Widget>[
          PartnerRegistrationTextField(
            controller: _postalCodeController,
            label: localizations.partnerRegistrationPostalCode,
            keyboardType: TextInputType.number,
            inputFormatters: PartnerRegistrationValidators.digitFormatters(
              maxLength: 10,
            ),
            validator: _postalCodeValidator,
          ),
          const SizedBox(height: AppSpacingTokens.small),
          Align(
            alignment: AlignmentDirectional.centerStart,
            child: OutlinedButton.icon(
              onPressed: _isBusy || _isPostalLoading
                  ? null
                  : _lookupPostalAddress,
              icon: _isPostalLoading
                  ? const SizedBox.square(
                      dimension: 18,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Icon(Icons.travel_explore_rounded),
              label: Text(localizations.partnerVerificationPostalLookup),
            ),
          ),
          const SizedBox(height: AppSpacingTokens.medium),
          PartnerRegistrationTextField(
            controller: _storeAddressController,
            label: localizations.partnerRegistrationStoreAddress,
            minLines: 3,
            maxLines: 5,
            validator: _requiredValidator,
          ),
          const SizedBox(height: AppSpacingTokens.small),
          _StatusRow(
            completed: lookupIsCurrent,
            completedText: localizations.partnerMapConfirmed,
            pendingText:
                localizations.partnerSelectiveCorrectionPostalLookupRequired,
          ),
        ],
      ),
    );
  }

  Widget _buildMapSection(AppLocalizations localizations) {
    return _CorrectionSection(
      title: _titleFor(
        PartnerCorrectionField.storeMap,
        localizations.partnerMapTitle,
      ),
      note: _noteFor(PartnerCorrectionField.storeMap),
      icon: Icons.map_rounded,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          _StatusRow(
            completed: _mapUpdated,
            completedText: localizations.partnerSelectiveCorrectionMapDone,
            pendingText: localizations.partnerSelectiveCorrectionMapRequired,
          ),
          const SizedBox(height: AppSpacingTokens.medium),
          OutlinedButton.icon(
            onPressed: _isBusy ? null : _openMapCorrection,
            icon: const Icon(Icons.edit_location_alt_rounded),
            label: Text(localizations.partnerSelectiveCorrectionMapAction),
          ),
        ],
      ),
    );
  }

  Widget _buildStoreDocumentsSection(AppLocalizations localizations) {
    return _CorrectionSection(
      title: localizations.partnerApplicationDocumentsSection,
      note: _combinedNotes(<PartnerCorrectionField>[
        PartnerCorrectionField.license,
        PartnerCorrectionField.signboard,
        PartnerCorrectionField.ownershipDocument,
      ]),
      icon: Icons.folder_copy_rounded,
      child: Column(
        children: <Widget>[
          if (_showField(PartnerCorrectionField.license))
            PartnerImagePickerField(
              title: _titleFor(
                PartnerCorrectionField.license,
                localizations.partnerRegistrationLicenseImage,
              ),
              emptySubtitle:
                  localizations.partnerSelectiveCorrectionNewFileRequired,
              selectedName: _licenseName,
              onTap: _pickLicense,
            ),
          if (_showField(PartnerCorrectionField.license) &&
              (_showField(PartnerCorrectionField.signboard) ||
                  _showField(PartnerCorrectionField.ownershipDocument)))
            const SizedBox(height: AppSpacingTokens.medium),
          if (_showField(PartnerCorrectionField.signboard))
            PartnerImagePickerField(
              title: _titleFor(
                PartnerCorrectionField.signboard,
                localizations.partnerRegistrationSignboardImage,
              ),
              emptySubtitle:
                  localizations.partnerSelectiveCorrectionNewFileRequired,
              selectedName: _signboardName,
              onTap: _pickSignboard,
            ),
          if (_showField(PartnerCorrectionField.signboard) &&
              _showField(PartnerCorrectionField.ownershipDocument))
            const SizedBox(height: AppSpacingTokens.medium),
          if (_showField(PartnerCorrectionField.ownershipDocument))
            PartnerImagePickerField(
              title: _titleFor(
                PartnerCorrectionField.ownershipDocument,
                localizations.partnerOwnershipDocumentImage,
              ),
              emptySubtitle:
                  localizations.partnerSelectiveCorrectionNewFileRequired,
              selectedName: _ownershipDocumentName,
              onTap: _pickOwnershipDocument,
            ),
        ],
      ),
    );
  }

  String? _requiredValidator(String? value) {
    if (value == null || value.trim().isEmpty) {
      return AppLocalizations.of(context).partnerRegistrationRequiredField;
    }

    return null;
  }

  String? _nationalIdValidator(String? value) {
    final requiredError = _requiredValidator(value);
    if (requiredError != null) {
      return requiredError;
    }

    if (!PartnerRegistrationValidators.hasExactDigits(value ?? '', 10)) {
      return AppLocalizations.of(context).partnerRegistrationInvalidNationalId;
    }

    return null;
  }

  String? _companyNationalIdValidator(String? value) {
    final requiredError = _requiredValidator(value);
    if (requiredError != null) {
      return requiredError;
    }

    if (!PartnerRegistrationValidators.hasExactDigits(value ?? '', 11)) {
      return AppLocalizations.of(
        context,
      ).partnerRegistrationInvalidCompanyNationalId;
    }

    return null;
  }

  String? _mobileValidator(String? value) {
    final requiredError = _requiredValidator(value);
    if (requiredError != null) {
      return requiredError;
    }

    if (!PartnerRegistrationValidators.isIranianMobile(value ?? '')) {
      return AppLocalizations.of(
        context,
      ).partnerRegistrationInvalidIranianMobile;
    }

    return null;
  }

  String? _storePhoneValidator(String? value) {
    final requiredError = _requiredValidator(value);
    if (requiredError != null) {
      return requiredError;
    }

    if (!PartnerRegistrationValidators.isIranianLandline(value ?? '')) {
      return AppLocalizations.of(context).partnerRegistrationInvalidLandline;
    }

    return null;
  }

  String? _postalCodeValidator(String? value) {
    final requiredError = _requiredValidator(value);
    if (requiredError != null) {
      return requiredError;
    }

    if (!PartnerRegistrationValidators.hasExactDigits(value ?? '', 10)) {
      return AppLocalizations.of(context).partnerRegistrationInvalidPostalCode;
    }

    return null;
  }

  Future<void> _captureNationalCard() async {
    final localizations = AppLocalizations.of(context);
    final result = await Navigator.of(context)
        .push<PartnerDocumentCaptureResult>(
          MaterialPageRoute<PartnerDocumentCaptureResult>(
            builder: (context) => PartnerDocumentCameraScreen(
              args: PartnerDocumentCameraArgs(
                title: localizations.partnerIdentityNationalCardCameraTitle,
                instruction:
                    localizations.partnerIdentityNationalCardCameraInstruction,
                guideAspectRatio: 1.586,
              ),
            ),
          ),
        );

    if (!mounted || result == null) {
      return;
    }

    setState(() {
      _nationalCardPath = result.path;
      _nationalCardName = result.name;
    });
  }

  Future<ImageSource?> _selectImageSource() {
    final localizations = AppLocalizations.of(context);

    return showModalBottomSheet<ImageSource>(
      context: context,
      showDragHandle: true,
      builder: (sheetContext) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(
            AppSpacingTokens.medium,
            0,
            AppSpacingTokens.medium,
            AppSpacingTokens.medium,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              ListTile(
                leading: const Icon(Icons.photo_camera_rounded),
                title: Text(localizations.partnerRegistrationImageSourceCamera),
                onTap: () => Navigator.of(sheetContext).pop(ImageSource.camera),
              ),
              ListTile(
                leading: const Icon(Icons.photo_library_rounded),
                title: Text(
                  localizations.partnerRegistrationImageSourceGallery,
                ),
                onTap: () =>
                    Navigator.of(sheetContext).pop(ImageSource.gallery),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<PartnerDocumentCaptureResult?> _pickStoreImage({
    required String title,
    required String instruction,
    required double aspectRatio,
  }) async {
    final source = await _selectImageSource();

    if (!mounted || source == null) {
      return null;
    }

    if (source == ImageSource.camera) {
      return Navigator.of(context).push<PartnerDocumentCaptureResult>(
        MaterialPageRoute<PartnerDocumentCaptureResult>(
          builder: (context) => PartnerDocumentCameraScreen(
            args: PartnerDocumentCameraArgs(
              title: title,
              instruction: instruction,
              guideAspectRatio: aspectRatio,
            ),
          ),
        ),
      );
    }

    final image = await _imagePicker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 85,
      maxWidth: 1800,
    );

    if (image == null) {
      return null;
    }

    return PartnerDocumentCaptureResult(path: image.path, name: image.name);
  }

  Future<void> _pickLicense() async {
    final localizations = AppLocalizations.of(context);
    final result = await _pickStoreImage(
      title: localizations.partnerRegistrationLicenseImage,
      instruction: localizations.partnerLicenseCameraInstruction,
      aspectRatio: 1.5,
    );

    if (!mounted || result == null) {
      return;
    }

    setState(() {
      _licensePath = result.path;
      _licenseName = result.name;
    });
  }

  Future<void> _pickSignboard() async {
    final localizations = AppLocalizations.of(context);
    final result = await _pickStoreImage(
      title: localizations.partnerRegistrationSignboardImage,
      instruction: localizations.partnerSignboardCameraInstruction,
      aspectRatio: 16 / 9,
    );

    if (!mounted || result == null) {
      return;
    }

    setState(() {
      _signboardPath = result.path;
      _signboardName = result.name;
    });
  }

  Future<void> _pickOwnershipDocument() async {
    final localizations = AppLocalizations.of(context);
    final result = await _pickStoreImage(
      title: localizations.partnerOwnershipDocumentImage,
      instruction: localizations.partnerOwnershipDocumentCameraInstruction,
      aspectRatio: 1.414,
    );

    if (!mounted || result == null) {
      return;
    }

    setState(() {
      _ownershipDocumentPath = result.path;
      _ownershipDocumentName = result.name;
    });
  }

  Future<void> _lookupPostalAddress() async {
    final postalCode = PartnerRegistrationValidators.normalizeDigits(
      _postalCodeController.text,
    );

    if (!PartnerRegistrationValidators.hasExactDigits(postalCode, 10)) {
      setState(() {
        _errorMessage = AppLocalizations.of(
          context,
        ).partnerRegistrationInvalidPostalCode;
      });
      return;
    }

    setState(() {
      _isPostalLoading = true;
      _errorMessage = null;
    });

    try {
      final lookup = await _verificationRepository.lookupPostalAddress(
        postalCode: postalCode,
      );

      if (!mounted) {
        return;
      }

      _storeAddressController.text = lookup.fullAddress;
      setState(() {
        _postalLookupCode = lookup.postalCode;
        _draft = _draft.copyWith(
          postalCode: lookup.postalCode,
          postalProvince: lookup.province,
          postalCity: lookup.city,
          postalDistrict: lookup.district,
          postalLatitude: lookup.latitude,
          postalLongitude: lookup.longitude,
          postalVerified: true,
          mapLatitude: _showField(PartnerCorrectionField.storeMap)
              ? lookup.latitude
              : _draft.mapLatitude,
          mapLongitude: _showField(PartnerCorrectionField.storeMap)
              ? lookup.longitude
              : _draft.mapLongitude,
          mapConfirmed: _showField(PartnerCorrectionField.storeMap)
              ? false
              : _draft.mapConfirmed,
          storeAddress: lookup.fullAddress,
        );
        if (_showField(PartnerCorrectionField.storeMap)) {
          _mapUpdated = false;
        }
      });
    } on PartnerVerificationException catch (error) {
      if (!mounted) {
        return;
      }

      setState(() {
        _errorMessage = localizePartnerApiError(
          AppLocalizations.of(context),
          message: error.message,
          code: error.code,
        );
      });
    } finally {
      if (mounted) {
        setState(() {
          _isPostalLoading = false;
        });
      }
    }
  }

  Future<void> _openMapCorrection() async {
    final latitude = _draft.mapLatitude ?? _draft.postalLatitude;
    final longitude = _draft.mapLongitude ?? _draft.postalLongitude;

    if (latitude == null || longitude == null) {
      setState(() {
        _errorMessage = AppLocalizations.of(
          context,
        ).partnerMapCoordinatesUnavailable;
      });
      return;
    }

    final result = await context.push<LatLng>(
      AppRoutePaths.partnerRegistrationMapConfirmation,
      extra: PartnerMapConfirmationArgs(
        initialLatitude: latitude,
        initialLongitude: longitude,
      ),
    );

    if (!mounted || result == null) {
      return;
    }

    setState(() {
      _draft = _draft.copyWith(
        mapLatitude: result.latitude,
        mapLongitude: result.longitude,
        mapConfirmed: true,
      );
      _mapUpdated = true;
      _errorMessage = null;
    });
  }

  Future<void> _openLivenessCorrection() async {
    final result = await context.push<PartnerRegistrationDraft>(
      AppRoutePaths.partnerRegistrationLiveness,
      extra: _draft,
    );

    if (!mounted || result == null) {
      return;
    }

    setState(() {
      _draft = result;
      _livenessUpdated = true;
      _errorMessage = null;
    });
  }

  bool get _applicantFieldsChanged {
    final mobile = PartnerRegistrationValidators.normalizeDigits(
      _mobileController.text,
    );
    final nationalId = PartnerRegistrationValidators.normalizeDigits(
      _nationalIdController.text,
    );
    final companyNationalId = PartnerRegistrationValidators.normalizeDigits(
      _companyNationalIdController.text,
    );
    final originalNationalId = _isLegalEntity
        ? _originalDraft.representativeNationalId
        : _originalDraft.nationalId;

    return mobile != _originalDraft.mobile ||
        nationalId != originalNationalId ||
        (_isLegalEntity &&
            (_companyNameController.text.trim() != _originalDraft.companyName ||
                companyNationalId != _originalDraft.companyNationalId));
  }

  Future<PartnerRegistrationDraft?> _verifyApplicantIfNeeded(
    PartnerRegistrationDraft draft, {
    bool force = false,
  }) async {
    final applicantCorrectionIsExplicit =
        _isExplicit(PartnerCorrectionField.applicantIdentity) ||
        _isExplicit(PartnerCorrectionField.applicantContact);
    final mobile = PartnerRegistrationValidators.normalizeDigits(
      _mobileController.text,
    );
    final nationalId = PartnerRegistrationValidators.normalizeDigits(
      _nationalIdController.text,
    );
    final companyNationalId = PartnerRegistrationValidators.normalizeDigits(
      _companyNationalIdController.text,
    );
    final currentNationalId = _isLegalEntity
        ? draft.representativeNationalId
        : draft.nationalId;
    final currentIdentityMatchesInputs =
        _identityVerificationUpdated &&
        draft.identityVerified &&
        draft.identityVerificationId.trim().isNotEmpty &&
        draft.mobile == mobile &&
        currentNationalId == nationalId &&
        (!_isLegalEntity ||
            (draft.companyName == _companyNameController.text.trim() &&
                draft.companyNationalId == companyNationalId));

    if (currentIdentityMatchesInputs) {
      return _ensureLivenessAfterIdentity(draft);
    }

    if (!force && !applicantCorrectionIsExplicit && !_applicantFieldsChanged) {
      return draft;
    }

    final localizations = AppLocalizations.of(context);

    if (!_identityConsentAccepted) {
      throw PartnerApplicationException(
        localizations.partnerVerificationConsentRequired,
      );
    }

    final verification = await _verificationRepository.checkIdentity(
      mobile: mobile,
      nationalId: nationalId,
      consentAccepted: true,
    );

    if (!mounted) {
      return null;
    }

    if (!verification.mobileOwnershipMatched) {
      throw PartnerApplicationException(
        localizations.partnerVerificationMobileMismatch,
      );
    }

    final confirmed = await _confirmVerification(verification, mobile);

    if (!confirmed) {
      return null;
    }

    await _verificationRepository.confirmIdentity(
      verificationId: verification.verificationId,
      confirmed: true,
    );

    final verifiedDraft = draft.copyWith(
      fullName: _isLegalEntity ? draft.fullName : verification.fullName,
      companyName: _companyNameController.text.trim(),
      representativeName: _isLegalEntity
          ? verification.fullName
          : draft.representativeName,
      nationalId: _isLegalEntity ? draft.nationalId : verification.nationalId,
      companyNationalId: companyNationalId,
      representativeNationalId: _isLegalEntity ? verification.nationalId : '',
      mobile: mobile,
      identityVerificationId: verification.verificationId,
      identityVerified: true,
      identityReused: false,
      verifiedFatherName: verification.fatherName,
      verifiedBirthDate: verification.birthDate,
      livenessSessionId: '',
      livenessPhrase: '',
      livenessVideoPath: '',
      livenessVerified: false,
    );

    if (!mounted) {
      return null;
    }

    setState(() {
      _draft = verifiedDraft;
      _identityConsentAccepted = true;
      _identityVerificationUpdated = true;
      _livenessUpdated = false;
      _errorMessage = null;
    });

    return _ensureLivenessAfterIdentity(verifiedDraft);
  }

  Future<PartnerRegistrationDraft?> _ensureLivenessAfterIdentity(
    PartnerRegistrationDraft draft,
  ) async {
    final livenessIsCurrent =
        draft.livenessVerified &&
        draft.livenessSessionId.trim().isNotEmpty &&
        draft.livenessVideoPath.trim().isNotEmpty;

    if (livenessIsCurrent) {
      return draft;
    }

    final result = await context.push<PartnerRegistrationDraft>(
      AppRoutePaths.partnerRegistrationLiveness,
      extra: draft,
    );

    if (!mounted) {
      return null;
    }

    if (result == null ||
        !result.livenessVerified ||
        result.livenessSessionId.trim().isEmpty ||
        result.livenessVideoPath.trim().isEmpty) {
      setState(() {
        _errorMessage = AppLocalizations.of(
          context,
        ).partnerSelectiveCorrectionLivenessRequired;
      });
      return null;
    }

    setState(() {
      _draft = result;
      _livenessUpdated = true;
      _identityConsentAccepted = true;
      _errorMessage = null;
    });

    return result;
  }

  Future<PartnerRegistrationDraft?>
  _reuseOrReverifyIdentityForUnchangedApplicant(
    PartnerRegistrationDraft draft,
  ) async {
    final identityRelatedCorrectionSelected =
        _otherSelected ||
        _isExplicit(PartnerCorrectionField.applicantIdentity) ||
        _isExplicit(PartnerCorrectionField.applicantContact) ||
        _isExplicit(PartnerCorrectionField.livenessVideo);

    if (identityRelatedCorrectionSelected) {
      return draft;
    }

    final reusable = await _verificationRepository.findReusableIdentity();

    if (!mounted) {
      return null;
    }

    if (reusable != null) {
      final draftNationalId = _isLegalEntity
          ? draft.representativeNationalId
          : draft.nationalId;
      final reusableNationalId =
          reusable.applicantType == PartnerApplicantType.legalEntity
          ? reusable.representativeNationalId
          : reusable.nationalId;
      final draftMobile = PartnerRegistrationValidators.normalizeDigits(
        draft.mobile,
      );
      final reusableMobile = PartnerRegistrationValidators.normalizeDigits(
        reusable.mobile,
      );

      final reusableMatchesApplicant =
          reusable.applicantType == draft.applicantType &&
          draftNationalId == reusableNationalId &&
          draftMobile == reusableMobile;

      if (reusableMatchesApplicant) {
        return draft.copyWith(
          identityVerificationId: reusable.verificationId,
          identityVerified: true,
          identityReused: true,
          verifiedFatherName: reusable.verifiedFatherName,
          verifiedBirthDate: reusable.verifiedBirthDate,
          livenessSessionId: reusable.livenessSessionId,
          livenessPhrase: '',
          livenessVideoPath: reusable.livenessVideoReference,
          livenessVerified: true,
        );
      }
    }

    final accepted = await _confirmSecurityReverification();

    if (!mounted || !accepted) {
      return null;
    }

    setState(() {
      _identityConsentAccepted = true;
      _errorMessage = null;
    });

    return _verifyApplicantIfNeeded(draft, force: true);
  }

  Future<bool> _confirmSecurityReverification() async {
    final localizations = AppLocalizations.of(context);

    return await showDialog<bool>(
          context: context,
          barrierDismissible: false,
          builder: (dialogContext) => AlertDialog(
            title: Text(localizations.partnerVerificationConsent),
            content: Text(localizations.partnerApplicationVerificationExpired),
            actions: <Widget>[
              TextButton(
                onPressed: () => Navigator.of(dialogContext).pop(false),
                child: Text(localizations.partnersBack),
              ),
              FilledButton(
                onPressed: () => Navigator.of(dialogContext).pop(true),
                child: Text(
                  localizations.partnerVerificationConfirmAndContinue,
                ),
              ),
            ],
          ),
        ) ??
        false;
  }

  Future<bool> _confirmVerification(
    PartnerIdentityVerification verification,
    String mobile,
  ) async {
    final localizations = AppLocalizations.of(context);

    return await showDialog<bool>(
          context: context,
          barrierDismissible: false,
          builder: (dialogContext) => AlertDialog(
            title: Text(localizations.partnerIdentityResultPageTitle),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Text(
                  verification.fullName,
                  style: const TextStyle(fontWeight: FontWeight.w900),
                ),
                const SizedBox(height: AppSpacingTokens.small),
                Directionality(
                  textDirection: TextDirection.ltr,
                  child: Text(verification.nationalId),
                ),
                const SizedBox(height: AppSpacingTokens.xSmall),
                Directionality(
                  textDirection: TextDirection.ltr,
                  child: Text(mobile),
                ),
                const SizedBox(height: AppSpacingTokens.medium),
                Text(localizations.partnerVerificationConfirmAccuracy),
              ],
            ),
            actions: <Widget>[
              TextButton(
                onPressed: () => Navigator.of(dialogContext).pop(false),
                child: Text(localizations.partnersBack),
              ),
              FilledButton(
                onPressed: () => Navigator.of(dialogContext).pop(true),
                child: Text(
                  localizations.partnerVerificationConfirmAndContinue,
                ),
              ),
            ],
          ),
        ) ??
        false;
  }

  Future<void> _resubmit() async {
    FocusManager.instance.primaryFocus?.unfocus();
    TextInput.finishAutofillContext();

    if (_isBusy) {
      return;
    }

    final localizations = AppLocalizations.of(context);
    final formIsValid = _formKey.currentState?.validate() ?? false;

    if (!formIsValid) {
      setState(() {
        _errorMessage = localizations.partnerApplicationFormIncomplete;
      });
      return;
    }

    if (_isExplicit(PartnerCorrectionField.selection) &&
        _selectedItemIds.isEmpty) {
      setState(() {
        _errorMessage =
            localizations.partnerSelectiveCorrectionSelectionRequired;
      });
      return;
    }

    final missingDocument = <String>[];

    if (_isExplicit(PartnerCorrectionField.nationalCard) &&
        _nationalCardPath.isEmpty) {
      missingDocument.add(
        _titleFor(
          PartnerCorrectionField.nationalCard,
          localizations.partnerIdentityNationalCardImage,
        ),
      );
    }
    if (_isExplicit(PartnerCorrectionField.license) && _licensePath.isEmpty) {
      missingDocument.add(
        _titleFor(
          PartnerCorrectionField.license,
          localizations.partnerRegistrationLicenseImage,
        ),
      );
    }
    if (_isExplicit(PartnerCorrectionField.signboard) &&
        _signboardPath.isEmpty) {
      missingDocument.add(
        _titleFor(
          PartnerCorrectionField.signboard,
          localizations.partnerRegistrationSignboardImage,
        ),
      );
    }
    if (_isExplicit(PartnerCorrectionField.ownershipDocument) &&
        _ownershipDocumentPath.isEmpty) {
      missingDocument.add(
        _titleFor(
          PartnerCorrectionField.ownershipDocument,
          localizations.partnerOwnershipDocumentImage,
        ),
      );
    }

    if (missingDocument.isNotEmpty) {
      setState(() {
        _errorMessage =
            '${localizations.partnerSelectiveCorrectionNewFileRequired}\n'
            '${missingDocument.join('، ')}';
      });
      return;
    }

    if (_isExplicit(PartnerCorrectionField.livenessVideo) &&
        !_livenessUpdated) {
      setState(() {
        _errorMessage =
            localizations.partnerSelectiveCorrectionLivenessRequired;
      });
      return;
    }

    if (_isExplicit(PartnerCorrectionField.storeMap) && !_mapUpdated) {
      setState(() {
        _errorMessage = localizations.partnerSelectiveCorrectionMapRequired;
      });
      return;
    }

    final normalizedPostalCode = PartnerRegistrationValidators.normalizeDigits(
      _postalCodeController.text,
    );

    if (_isExplicit(PartnerCorrectionField.storeAddress) &&
        normalizedPostalCode != _postalLookupCode) {
      setState(() {
        _errorMessage =
            localizations.partnerSelectiveCorrectionPostalLookupRequired;
      });
      return;
    }

    setState(() {
      _isBusy = true;
      _errorMessage = null;
    });

    try {
      var updatedDraft = _draft;

      if (_showField(PartnerCorrectionField.selection)) {
        final sortedItems = PartnerItemId.values
            .where(_selectedItemIds.contains)
            .toList(growable: false);
        final primary = sortedItems.isEmpty ? null : sortedItems.first;
        final secondary = sortedItems.skip(1).toSet();

        updatedDraft = updatedDraft.copyWith(
          selection: PartnerSelectionResult(
            categoryId: _categoryId,
            driverMode: _driverMode,
            primaryItemId: primary,
            selectedItemIds: secondary,
          ),
        );
      }

      final verifiedDraft = await _verifyApplicantIfNeeded(updatedDraft);

      if (verifiedDraft == null) {
        return;
      }

      final identityReadyDraft =
          await _reuseOrReverifyIdentityForUnchangedApplicant(verifiedDraft);

      if (!mounted || identityReadyDraft == null) {
        return;
      }

      updatedDraft = identityReadyDraft;

      if (_showField(PartnerCorrectionField.nationalCard) &&
          _nationalCardPath.isNotEmpty) {
        updatedDraft = updatedDraft.copyWith(
          nationalCardImagePath: _nationalCardPath,
          nationalCardImageName: _nationalCardName,
        );
      }

      if (_showField(PartnerCorrectionField.storeDetails)) {
        updatedDraft = updatedDraft.copyWith(
          storeName: _storeNameController.text.trim(),
          storePhone: PartnerRegistrationValidators.normalizeDigits(
            _storePhoneController.text,
          ),
          storeOwnership: _ownership,
          storeAreaSquareMeters: PartnerRegistrationValidators.normalizeDigits(
            _storeAreaController.text,
          ),
          businessDescription: _businessDescriptionController.text.trim(),
          experienceYears: PartnerRegistrationValidators.normalizeDigits(
            _experienceYearsController.text,
          ),
        );
      }

      if (_showField(PartnerCorrectionField.storeAddress)) {
        updatedDraft = updatedDraft.copyWith(
          postalCode: normalizedPostalCode,
          storeAddress: _storeAddressController.text.trim(),
        );
      }

      if (_showField(PartnerCorrectionField.license) &&
          _licensePath.isNotEmpty) {
        updatedDraft = updatedDraft.copyWith(
          licenseImagePath: _licensePath,
          licenseImageName: _licenseName,
        );
      }
      if (_showField(PartnerCorrectionField.signboard) &&
          _signboardPath.isNotEmpty) {
        updatedDraft = updatedDraft.copyWith(
          signboardImagePath: _signboardPath,
          signboardImageName: _signboardName,
        );
      }
      if (_showField(PartnerCorrectionField.ownershipDocument) &&
          _ownershipDocumentPath.isNotEmpty) {
        updatedDraft = updatedDraft.copyWith(
          ownershipDocumentImagePath: _ownershipDocumentPath,
          ownershipDocumentImageName: _ownershipDocumentName,
        );
      }

      final result = await _applicationsRepository.resubmit(
        draft: updatedDraft,
        clientRequestId: _clientRequestId,
      );

      if (!mounted) {
        return;
      }

      context.go(
        AppRoutePaths.partnerApplications,
        extra: PartnerApplicationsScreenArgs(
          application: result.application,
          idempotent: result.idempotent,
          resubmitted: true,
        ),
      );
    } on PartnerApplicationException catch (error) {
      if (!mounted) {
        return;
      }

      setState(() {
        _errorMessage = localizePartnerApiError(
          AppLocalizations.of(context),
          message: error.message,
          code: error.code,
        );
      });
    } on PartnerVerificationException catch (error) {
      if (!mounted) {
        return;
      }

      setState(() {
        _errorMessage = localizePartnerApiError(
          AppLocalizations.of(context),
          message: error.message,
          code: error.code,
        );
      });
    } finally {
      if (mounted) {
        setState(() {
          _isBusy = false;
        });
      }
    }
  }

  bool _belongsToCategory(PartnerItemId item, PartnerCategoryId category) {
    final prefix = switch (category) {
      PartnerCategoryId.stores => 'store',
      PartnerCategoryId.companies => 'company',
      PartnerCategoryId.drivers => 'driver',
      PartnerCategoryId.food => 'food',
      PartnerCategoryId.other => 'other',
    };

    return item.name.startsWith(prefix);
  }

  String _titleFor(PartnerCorrectionField field, String fallback) {
    for (final item in _draft.correctionItems) {
      if (item.field == field && item.title.trim().isNotEmpty) {
        return item.title.trim();
      }
    }

    return fallback;
  }

  String? _noteFor(PartnerCorrectionField field) {
    return _draft.correctionNoteFor(field);
  }

  String? _combinedNotes(List<PartnerCorrectionField> fields) {
    final notes = <String>[];

    for (final field in fields) {
      final note = _noteFor(field);
      if (note != null && note.trim().isNotEmpty) {
        notes.add(note.trim());
      }
    }

    return notes.isEmpty ? null : notes.join('\n');
  }

  String _ownershipTitle(
    PartnerStoreOwnership ownership,
    AppLocalizations localizations,
  ) {
    return switch (ownership) {
      PartnerStoreOwnership.owner =>
        localizations.partnerRegistrationOwnershipOwner,
      PartnerStoreOwnership.tenant =>
        localizations.partnerRegistrationOwnershipTenant,
      PartnerStoreOwnership.goodwill =>
        localizations.partnerRegistrationOwnershipGoodwill,
      PartnerStoreOwnership.other =>
        localizations.partnerRegistrationOwnershipOther,
    };
  }
}

class _CorrectionItemsCard extends StatelessWidget {
  const _CorrectionItemsCard({required this.items});

  final List<PartnerCorrectionItem> items;

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);

    return Card(
      margin: EdgeInsets.zero,
      child: Padding(
        padding: const EdgeInsets.all(AppSpacingTokens.large),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Text(
              localizations.partnerSelectiveCorrectionSelectedItems,
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w900),
            ),
            const SizedBox(height: AppSpacingTokens.medium),
            for (var index = 0; index < items.length; index++) ...<Widget>[
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Icon(
                    Icons.check_circle_rounded,
                    size: 20,
                    color: Theme.of(context).colorScheme.error,
                  ),
                  const SizedBox(width: AppSpacingTokens.small),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>[
                        Text(
                          items[index].title,
                          style: const TextStyle(fontWeight: FontWeight.w800),
                        ),
                        if (items[index].note != null) ...<Widget>[
                          const SizedBox(height: 4),
                          Text(
                            items[index].note!,
                            style: const TextStyle(height: 1.5),
                          ),
                        ],
                      ],
                    ),
                  ),
                ],
              ),
              if (index != items.length - 1)
                const Divider(height: AppSpacingTokens.large),
            ],
          ],
        ),
      ),
    );
  }
}

class _CorrectionSection extends StatelessWidget {
  const _CorrectionSection({
    required this.title,
    required this.icon,
    required this.child,
    this.note,
  });

  final String title;
  final String? note;
  final IconData icon;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.zero,
      child: Padding(
        padding: const EdgeInsets.all(AppSpacingTokens.large),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Row(
              children: <Widget>[
                Icon(icon, color: Theme.of(context).colorScheme.primary),
                const SizedBox(width: AppSpacingTokens.small),
                Expanded(
                  child: Text(
                    title,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ),
              ],
            ),
            if (note != null && note!.trim().isNotEmpty) ...<Widget>[
              const SizedBox(height: AppSpacingTokens.small),
              Text(
                note!,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Theme.of(context).colorScheme.error,
                  height: 1.5,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
            const SizedBox(height: AppSpacingTokens.medium),
            child,
          ],
        ),
      ),
    );
  }
}

class _StatusRow extends StatelessWidget {
  const _StatusRow({
    required this.completed,
    required this.completedText,
    required this.pendingText,
  });

  final bool completed;
  final String completedText;
  final String pendingText;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Row(
      children: <Widget>[
        Icon(
          completed ? Icons.check_circle_rounded : Icons.pending_rounded,
          color: completed ? colors.primary : colors.error,
        ),
        const SizedBox(width: AppSpacingTokens.small),
        Expanded(
          child: Text(
            completed ? completedText : pendingText,
            style: const TextStyle(fontWeight: FontWeight.w700),
          ),
        ),
      ],
    );
  }
}

class _NoticeCard extends StatelessWidget {
  const _NoticeCard({required this.icon, required this.message});

  final IconData icon;
  final String message;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.zero,
      child: Padding(
        padding: const EdgeInsets.all(AppSpacingTokens.medium),
        child: Row(
          children: <Widget>[
            Icon(icon, color: Theme.of(context).colorScheme.primary),
            const SizedBox(width: AppSpacingTokens.small),
            Expanded(child: Text(message, style: const TextStyle(height: 1.5))),
          ],
        ),
      ),
    );
  }
}

class _ErrorBanner extends StatelessWidget {
  const _ErrorBanner({required this.message});

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
          height: 1.5,
        ),
      ),
    );
  }
}
