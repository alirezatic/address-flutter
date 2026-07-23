import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:latlong2/latlong.dart';

import 'package:address/app/route_paths.dart';
import 'package:address/core/design_system/components/buttons/animated_start_button.dart';
import 'package:address/core/design_system/components/layout/app_page_scaffold.dart';
import 'package:address/core/design_system/tokens/app_design_tokens.dart';
import 'package:address/features/partner_registration/data/models/partner_postal_lookup.dart';
import 'package:address/features/partner_registration/data/partner_applications_repository.dart';
import 'package:address/features/partner_registration/data/partner_verification_repository.dart';
import 'package:address/features/partner_registration/domain/models/partner_registration_draft.dart';
import 'package:address/features/partner_registration/presentation/controller/partner_registration_controller.dart';
import 'package:address/features/partner_registration/presentation/screens/partner_applications_screen.dart';
import 'package:address/features/partner_registration/presentation/screens/partner_document_camera_screen.dart';
import 'package:address/features/partner_registration/presentation/screens/partner_map_confirmation_screen.dart';
import 'package:address/features/partner_registration/presentation/validation/partner_registration_validators.dart';
import 'package:address/features/partner_registration/presentation/widgets/partner_image_picker_field.dart';
import 'package:address/features/partner_registration/presentation/widgets/partner_registration_text_field.dart';
import 'package:address/l10n/generated/app_localizations.dart';

// addressPartnerApplicationResubmissionV1
class PartnerStoreInfoScreen extends StatefulWidget {
  const PartnerStoreInfoScreen({required this.draft, super.key});

  final PartnerRegistrationDraft draft;

  @override
  State<PartnerStoreInfoScreen> createState() => _PartnerStoreInfoScreenState();
}

class _PartnerStoreInfoScreenState extends State<PartnerStoreInfoScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final ImagePicker _imagePicker = ImagePicker();

  late final PartnerRegistrationController _controller;
  late final PartnerVerificationRepository _repository;
  late final PartnerApplicationsRepository _applicationsRepository;
  late final String _clientRequestId;
  late final TextEditingController _storeNameController;
  late final TextEditingController _storePhoneController;
  late final TextEditingController _storeAreaController;
  late final TextEditingController _postalCodeController;
  late final TextEditingController _storeAddressController;

  PartnerStoreOwnership? _ownership;
  PartnerPostalLookup? _postalLookup;

  String _signboardImagePath = '';
  String _signboardImageName = '';
  String _licenseImagePath = '';
  String _licenseImageName = '';
  String _ownershipDocumentImagePath = '';
  String _ownershipDocumentImageName = '';

  String? _signboardImageError;
  String? _ownershipDocumentImageError;
  String? _postalError;
  String? _mapError;
  String? _submissionError;

  bool _isPostalLoading = false;
  bool _isSubmitting = false;
  bool _mapConfirmed = false;
  double? _mapLatitude;
  double? _mapLongitude;

  @override
  void initState() {
    super.initState();

    _controller = PartnerRegistrationController.fromDraft(draft: widget.draft);
    _repository = PartnerVerificationRepository();
    _applicationsRepository = PartnerApplicationsRepository();
    _clientRequestId = _applicationsRepository.createClientRequestId();

    _storeNameController = TextEditingController(text: widget.draft.storeName);
    _storePhoneController = TextEditingController(
      text: widget.draft.storePhone,
    );
    _storeAreaController = TextEditingController(
      text: widget.draft.storeAreaSquareMeters,
    );
    _postalCodeController = TextEditingController(
      text: widget.draft.postalCode,
    );
    _storeAddressController = TextEditingController(
      text: widget.draft.storeAddress,
    );

    _ownership = widget.draft.storeOwnership;
    _signboardImagePath = widget.draft.signboardImagePath;
    _signboardImageName = widget.draft.signboardImageName;
    _licenseImagePath = widget.draft.licenseImagePath;
    _licenseImageName = widget.draft.licenseImageName;
    _ownershipDocumentImagePath = widget.draft.ownershipDocumentImagePath;
    _ownershipDocumentImageName = widget.draft.ownershipDocumentImageName;

    _mapConfirmed = widget.draft.mapConfirmed;
    _mapLatitude = widget.draft.mapLatitude ?? widget.draft.postalLatitude;
    _mapLongitude = widget.draft.mapLongitude ?? widget.draft.postalLongitude;

    if (widget.draft.postalVerified) {
      _postalLookup = PartnerPostalLookup(
        postalCode: widget.draft.postalCode,
        province: widget.draft.postalProvince,
        city: widget.draft.postalCity,
        district: widget.draft.postalDistrict,
        street: '',
        buildingNumber: '',
        unit: '',
        fullAddress: widget.draft.storeAddress,
        latitude: widget.draft.postalLatitude,
        longitude: widget.draft.postalLongitude,
        requiresMapConfirmation: true,
      );
    }

    _postalCodeController.addListener(_invalidatePostalLookup);
  }

  @override
  void dispose() {
    _postalCodeController.removeListener(_invalidatePostalLookup);

    _controller.dispose();
    _storeNameController.dispose();
    _storePhoneController.dispose();
    _storeAreaController.dispose();
    _postalCodeController.dispose();
    _storeAddressController.dispose();
    super.dispose();
  }

  void _invalidatePostalLookup() {
    final currentCode = PartnerRegistrationValidators.normalizeDigits(
      _postalCodeController.text,
    );

    if (_postalLookup == null || _postalLookup!.postalCode == currentCode) {
      return;
    }

    setState(() {
      _postalLookup = null;
      _postalError = null;
      _mapConfirmed = false;
      _mapLatitude = null;
      _mapLongitude = null;
      _mapError = null;
      _storeAddressController.clear();
    });
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

    String? storePhoneValidator(String? value) {
      final requiredError = requiredValidator(value);
      if (requiredError != null) {
        return requiredError;
      }

      if (!PartnerRegistrationValidators.isIranianLandline(value ?? '')) {
        return localizations.partnerRegistrationInvalidLandline;
      }

      return null;
    }

    String? areaValidator(String? value) {
      final requiredError = requiredValidator(value);
      if (requiredError != null) {
        return requiredError;
      }

      if (!PartnerRegistrationValidators.isPositiveNumber(value ?? '')) {
        return localizations.partnerRegistrationInvalidStoreArea;
      }

      return null;
    }

    String? postalCodeValidator(String? value) {
      final requiredError = requiredValidator(value);
      if (requiredError != null) {
        return requiredError;
      }

      if (!PartnerRegistrationValidators.hasExactDigits(value ?? '', 10)) {
        return localizations.partnerRegistrationInvalidPostalCode;
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
                  localizations.partnerRegistrationStoreInformationTitle,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: AppSpacingTokens.small),
                Text(
                  localizations.partnerRegistrationStoreInformationSubtitle,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                    height: 1.5,
                  ),
                ),
                if (widget.draft.isResubmission) ...<Widget>[
                  const SizedBox(height: AppSpacingTokens.large),
                  Card(
                    margin: EdgeInsets.zero,
                    child: Padding(
                      padding: const EdgeInsets.all(AppSpacingTokens.medium),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Icon(
                            Icons.rule_folder_rounded,
                            color: Theme.of(context).colorScheme.error,
                          ),
                          const SizedBox(width: AppSpacingTokens.small),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: <Widget>[
                                Text(
                                  localizations
                                      .partnerApplicationCorrectionNoteTitle,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w900,
                                  ),
                                ),
                                const SizedBox(height: AppSpacingTokens.xSmall),
                                Text(
                                  widget.draft.resubmissionCorrectionNote
                                          .trim()
                                          .isEmpty
                                      ? localizations
                                            .partnerApplicationCorrectionInstructions
                                      : widget.draft.resubmissionCorrectionNote,
                                  style: const TextStyle(height: 1.6),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
                if (widget.draft.identityReused) ...<Widget>[
                  const SizedBox(height: AppSpacingTokens.large),
                  Card(
                    margin: EdgeInsets.zero,
                    child: Padding(
                      padding: const EdgeInsets.all(AppSpacingTokens.medium),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Icon(
                            Icons.verified_user_rounded,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                          const SizedBox(width: AppSpacingTokens.small),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: <Widget>[
                                Text(
                                  localizations
                                      .partnerReusableIdentityBannerTitle,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w800,
                                  ),
                                ),
                                const SizedBox(height: AppSpacingTokens.xSmall),
                                Text(
                                  localizations
                                      .partnerReusableIdentityBannerSubtitle,
                                  style: Theme.of(
                                    context,
                                  ).textTheme.bodySmall?.copyWith(height: 1.5),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
                const SizedBox(height: AppSpacingTokens.xxLarge),

                // 1. Store name
                PartnerRegistrationTextField(
                  controller: _storeNameController,
                  label: localizations.partnerRegistrationStoreName,
                  textInputAction: TextInputAction.next,
                  validator: requiredValidator,
                ),
                const SizedBox(height: AppSpacingTokens.medium),

                // 2. Ownership type
                DropdownButtonFormField<PartnerStoreOwnership>(
                  initialValue: _ownership,
                  decoration: InputDecoration(
                    labelText: localizations.partnerRegistrationStoreOwnership,
                  ),
                  items: <DropdownMenuItem<PartnerStoreOwnership>>[
                    DropdownMenuItem<PartnerStoreOwnership>(
                      value: PartnerStoreOwnership.owner,
                      child: Text(
                        localizations.partnerRegistrationOwnershipOwner,
                      ),
                    ),
                    DropdownMenuItem<PartnerStoreOwnership>(
                      value: PartnerStoreOwnership.tenant,
                      child: Text(
                        localizations.partnerRegistrationOwnershipTenant,
                      ),
                    ),
                    DropdownMenuItem<PartnerStoreOwnership>(
                      value: PartnerStoreOwnership.goodwill,
                      child: Text(
                        localizations.partnerRegistrationOwnershipGoodwill,
                      ),
                    ),
                    DropdownMenuItem<PartnerStoreOwnership>(
                      value: PartnerStoreOwnership.other,
                      child: Text(
                        localizations.partnerRegistrationOwnershipOther,
                      ),
                    ),
                  ],
                  onChanged: (value) {
                    setState(() {
                      _ownership = value;
                    });
                  },
                  validator: (value) {
                    return value == null
                        ? localizations.partnerRegistrationRequiredField
                        : null;
                  },
                ),
                const SizedBox(height: AppSpacingTokens.medium),

                // 3. Store landline
                PartnerRegistrationTextField(
                  controller: _storePhoneController,
                  label: localizations.partnerRegistrationStorePhone,
                  keyboardType: TextInputType.phone,
                  textInputAction: TextInputAction.next,
                  inputFormatters:
                      PartnerRegistrationValidators.digitFormatters(
                        maxLength: 11,
                      ),
                  validator: storePhoneValidator,
                ),
                const SizedBox(height: AppSpacingTokens.medium),

                // 4. Store area
                PartnerRegistrationTextField(
                  controller: _storeAreaController,
                  label: localizations.partnerRegistrationStoreArea,
                  keyboardType: const TextInputType.numberWithOptions(
                    decimal: true,
                  ),
                  textInputAction: TextInputAction.next,
                  validator: areaValidator,
                ),
                const SizedBox(height: AppSpacingTokens.medium),

                // 5. Postal code
                PartnerRegistrationTextField(
                  controller: _postalCodeController,
                  label: localizations.partnerRegistrationPostalCode,
                  keyboardType: TextInputType.number,
                  textInputAction: TextInputAction.done,
                  inputFormatters:
                      PartnerRegistrationValidators.digitFormatters(
                        maxLength: 10,
                      ),
                  validator: postalCodeValidator,
                ),
                const SizedBox(height: AppSpacingTokens.small),

                // 6. Lookup address
                Align(
                  alignment: AlignmentDirectional.centerEnd,
                  child: OutlinedButton.icon(
                    onPressed: _isPostalLoading ? null : _lookupPostalAddress,
                    icon: _isPostalLoading
                        ? const SizedBox(
                            width: 18,
                            height: 18,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Icon(Icons.markunread_mailbox_rounded),
                    label: Text(localizations.partnerVerificationPostalLookup),
                  ),
                ),
                if (_postalError != null) ...<Widget>[
                  const SizedBox(height: AppSpacingTokens.small),
                  _StoreErrorBanner(message: _postalError!),
                ],
                if (_postalLookup != null) ...<Widget>[
                  const SizedBox(height: AppSpacingTokens.medium),
                  _PostalResultCard(
                    lookup: _postalLookup!,
                    title: localizations.partnerVerificationPostalResultTitle,
                    mapStatusText: _mapConfirmed
                        ? localizations.partnerMapConfirmed
                        : localizations
                              .partnerVerificationMapConfirmationPending,
                  ),
                  const SizedBox(height: AppSpacingTokens.small),

                  // 7. Confirm location
                  Align(
                    alignment: AlignmentDirectional.centerEnd,
                    child: OutlinedButton.icon(
                      onPressed: _openMapConfirmation,
                      icon: Icon(
                        _mapConfirmed
                            ? Icons.check_circle_rounded
                            : Icons.map_rounded,
                      ),
                      label: Text(
                        _mapConfirmed
                            ? localizations.partnerMapConfirmed
                            : localizations.partnerMapOpen,
                      ),
                    ),
                  ),
                ],
                if (_mapError != null) ...<Widget>[
                  const SizedBox(height: AppSpacingTokens.small),
                  _StoreErrorBanner(message: _mapError!),
                ],
                const SizedBox(height: AppSpacingTokens.large),

                // 8. Signboard image
                PartnerImagePickerField(
                  title: localizations.partnerRegistrationSignboardImage,
                  emptySubtitle:
                      localizations.partnerRegistrationSignboardImageRequired,
                  selectedName: _signboardImageName,
                  errorText: _signboardImageError,
                  onTap: _pickSignboardImage,
                ),
                const SizedBox(height: AppSpacingTokens.medium),

                // 9. Activity license
                PartnerImagePickerField(
                  title: localizations.partnerRegistrationLicenseImage,
                  emptySubtitle:
                      localizations.partnerRegistrationLicenseImageOptional,
                  selectedName: _licenseImageName,
                  onTap: _pickLicenseImage,
                ),
                const SizedBox(height: AppSpacingTokens.medium),

                // 10. Ownership / lease / goodwill document
                PartnerImagePickerField(
                  title: localizations.partnerOwnershipDocumentImage,
                  emptySubtitle:
                      localizations.partnerOwnershipDocumentImageRequired,
                  selectedName: _ownershipDocumentImageName,
                  errorText: _ownershipDocumentImageError,
                  onTap: _pickOwnershipDocumentImage,
                ),
                const SizedBox(height: AppSpacingTokens.xxLarge),
                if (_submissionError != null) ...<Widget>[
                  _StoreErrorBanner(message: _submissionError!),
                  const SizedBox(height: AppSpacingTokens.medium),
                ],
                Center(
                  child: AnimatedStartButton(
                    title: widget.draft.isResubmission
                        ? localizations.partnerApplicationResubmitFinal
                        : localizations.partnerRegistrationFinalConfirm,
                    isEnabled: !_isSubmitting && !_isPostalLoading,
                    isLoading: _isSubmitting,
                    onTap: _submit,
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

  Future<void> _lookupPostalAddress() async {
    FocusManager.instance.primaryFocus?.unfocus();

    final localizations = AppLocalizations.of(context);
    final postalCode = PartnerRegistrationValidators.normalizeDigits(
      _postalCodeController.text,
    );

    if (!PartnerRegistrationValidators.hasExactDigits(postalCode, 10)) {
      setState(() {
        _postalError = localizations.partnerRegistrationInvalidPostalCode;
      });
      return;
    }

    setState(() {
      _isPostalLoading = true;
      _postalError = null;
    });

    try {
      final lookup = await _repository.lookupPostalAddress(
        postalCode: postalCode,
      );

      _controller.updatePostalLookup(lookup);

      if (!mounted) {
        return;
      }

      _storeAddressController.text = lookup.fullAddress;

      setState(() {
        _postalLookup = lookup;
        _mapLatitude = lookup.latitude;
        _mapLongitude = lookup.longitude;
        _mapConfirmed = false;
        _mapError = null;
      });
    } on PartnerVerificationException catch (error) {
      if (!mounted) {
        return;
      }

      setState(() {
        _postalError = error.message;
      });
    } finally {
      if (mounted) {
        setState(() {
          _isPostalLoading = false;
        });
      }
    }
  }

  Future<void> _openMapConfirmation() async {
    final localizations = AppLocalizations.of(context);
    final latitude = _mapLatitude ?? _postalLookup?.latitude;
    final longitude = _mapLongitude ?? _postalLookup?.longitude;

    if (latitude == null || longitude == null) {
      setState(() {
        _mapError = localizations.partnerMapCoordinatesUnavailable;
      });
      return;
    }

    final selectedLocation = await context.push<LatLng>(
      AppRoutePaths.partnerRegistrationMapConfirmation,
      extra: PartnerMapConfirmationArgs(
        initialLatitude: latitude,
        initialLongitude: longitude,
      ),
    );

    if (!mounted || selectedLocation == null) {
      return;
    }

    _controller.confirmStoreLocation(
      latitude: selectedLocation.latitude,
      longitude: selectedLocation.longitude,
    );

    setState(() {
      _mapLatitude = selectedLocation.latitude;
      _mapLongitude = selectedLocation.longitude;
      _mapConfirmed = true;
      _mapError = null;
    });
  }

  Future<ImageSource?> _selectImageSource() {
    final localizations = AppLocalizations.of(context);

    return showModalBottomSheet<ImageSource>(
      context: context,
      showDragHandle: true,
      builder: (sheetContext) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(
              AppSpacingTokens.medium,
              0,
              AppSpacingTokens.medium,
              AppSpacingTokens.medium,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Text(
                  localizations.partnerRegistrationImageSourceTitle,
                  textAlign: TextAlign.center,
                  style: Theme.of(sheetContext).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: AppSpacingTokens.medium),
                ListTile(
                  leading: const Icon(Icons.photo_camera_rounded),
                  title: Text(
                    localizations.partnerRegistrationImageSourceCamera,
                  ),
                  onTap: () {
                    Navigator.of(sheetContext).pop(ImageSource.camera);
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.photo_library_rounded),
                  title: Text(
                    localizations.partnerRegistrationImageSourceGallery,
                  ),
                  onTap: () {
                    Navigator.of(sheetContext).pop(ImageSource.gallery);
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<PartnerDocumentCaptureResult?> _pickStoreImage({
    required String cameraTitle,
    required String cameraInstruction,
    required double guideAspectRatio,
  }) async {
    final source = await _selectImageSource();

    if (!mounted || source == null) {
      return null;
    }

    if (source == ImageSource.camera) {
      return Navigator.of(context).push<PartnerDocumentCaptureResult>(
        MaterialPageRoute<PartnerDocumentCaptureResult>(
          builder: (context) {
            return PartnerDocumentCameraScreen(
              args: PartnerDocumentCameraArgs(
                title: cameraTitle,
                instruction: cameraInstruction,
                guideAspectRatio: guideAspectRatio,
              ),
            );
          },
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

  Future<void> _pickSignboardImage() async {
    final localizations = AppLocalizations.of(context);
    final image = await _pickStoreImage(
      cameraTitle: localizations.partnerRegistrationSignboardImage,
      cameraInstruction: localizations.partnerSignboardCameraInstruction,
      guideAspectRatio: 4 / 3,
    );

    if (!mounted || image == null) {
      return;
    }

    setState(() {
      _signboardImagePath = image.path;
      _signboardImageName = image.name;
      _signboardImageError = null;
    });
  }

  Future<void> _pickLicenseImage() async {
    final localizations = AppLocalizations.of(context);
    final image = await _pickStoreImage(
      cameraTitle: localizations.partnerRegistrationLicenseImage,
      cameraInstruction: localizations.partnerLicenseCameraInstruction,
      guideAspectRatio: 0.707,
    );

    if (!mounted || image == null) {
      return;
    }

    setState(() {
      _licenseImagePath = image.path;
      _licenseImageName = image.name;
    });
  }

  Future<void> _pickOwnershipDocumentImage() async {
    final localizations = AppLocalizations.of(context);
    final image = await _pickStoreImage(
      cameraTitle: localizations.partnerOwnershipDocumentImage,
      cameraInstruction:
          localizations.partnerOwnershipDocumentCameraInstruction,
      guideAspectRatio: 0.707,
    );

    if (!mounted || image == null) {
      return;
    }

    setState(() {
      _ownershipDocumentImagePath = image.path;
      _ownershipDocumentImageName = image.name;
      _ownershipDocumentImageError = null;
    });
  }

  Future<void> _submit() async {
    // addressPartnerDirectSubmissionVisibleErrorsV1
    FocusManager.instance.primaryFocus?.unfocus();

    final localizations = AppLocalizations.of(context);
    final formIsValid = _formKey.currentState?.validate() ?? false;
    final hasSignboard = _signboardImagePath.isNotEmpty;
    final hasOwnershipDocument = _ownershipDocumentImagePath.isNotEmpty;
    final hasPostalLookup = _postalLookup != null;
    final hasMapConfirmation = _mapConfirmed;
    final hasIdentityVerification =
        _controller.draft.identityVerified &&
        _controller.draft.identityVerificationId.isNotEmpty;
    final hasLivenessVerification =
        _controller.draft.livenessVerified &&
        _controller.draft.livenessSessionId.isNotEmpty &&
        _controller.draft.livenessVideoPath.isNotEmpty;

    final blockers = <String>[
      if (!formIsValid) localizations.partnerApplicationFormIncomplete,
      if (!hasSignboard)
        localizations.partnerRegistrationSignboardImageValidation,
      if (!hasOwnershipDocument)
        localizations.partnerOwnershipDocumentImageValidation,
      if (!hasPostalLookup)
        localizations.partnerVerificationPostalLookupRequired,
      if (!hasMapConfirmation) localizations.partnerMapConfirmationRequired,
      if (!hasIdentityVerification || !hasLivenessVerification)
        localizations.partnerApplicationVerificationExpired,
    ];

    final blockerMessage = blockers.map((message) => '• $message').join('\n');

    setState(() {
      _signboardImageError = hasSignboard
          ? null
          : localizations.partnerRegistrationSignboardImageValidation;
      _ownershipDocumentImageError = hasOwnershipDocument
          ? null
          : localizations.partnerOwnershipDocumentImageValidation;
      _postalError = hasPostalLookup
          ? null
          : localizations.partnerVerificationPostalLookupRequired;
      _mapError = hasMapConfirmation
          ? null
          : localizations.partnerMapConfirmationRequired;
      _submissionError = blockers.isEmpty ? null : blockerMessage;
    });

    if (_isSubmitting || blockers.isNotEmpty) {
      if (blockers.isNotEmpty) {
        _showSubmissionMessage(blockerMessage);
      }
      return;
    }

    _controller.updateStoreInformation(
      storeName: _storeNameController.text,
      storePhone: _storePhoneController.text,
      storeOwnership: _ownership!,
      postalCode: PartnerRegistrationValidators.normalizeDigits(
        _postalCodeController.text,
      ),
      storeAreaSquareMeters: _storeAreaController.text,
      storeAddress: _storeAddressController.text,
      licenseImagePath: _licenseImagePath,
      licenseImageName: _licenseImageName,
      signboardImagePath: _signboardImagePath,
      signboardImageName: _signboardImageName,
      ownershipDocumentImagePath: _ownershipDocumentImagePath,
      ownershipDocumentImageName: _ownershipDocumentImageName,
    );

    setState(() {
      _isSubmitting = true;
      _submissionError = null;
    });

    try {
      final result = _controller.draft.isResubmission
          ? await _applicationsRepository.resubmit(
              draft: _controller.draft,
              clientRequestId: _clientRequestId,
            )
          : await _applicationsRepository.submit(
              draft: _controller.draft,
              clientRequestId: _clientRequestId,
            );

      if (!mounted) {
        return;
      }

      if (result.application.id.isEmpty ||
          result.application.trackingCode.isEmpty) {
        throw PartnerApplicationException(
          localizations.partnerApplicationUnexpectedFailure,
        );
      }

      context.go(
        AppRoutePaths.partnerApplications,
        extra: PartnerApplicationsScreenArgs(
          application: result.application,
          idempotent: result.idempotent,
          resubmitted: _controller.draft.isResubmission,
        ),
      );
    } on PartnerApplicationException catch (error) {
      if (!mounted) {
        return;
      }

      setState(() {
        _submissionError = error.message;
      });
      _showSubmissionMessage(error.message);
    } catch (error, stackTrace) {
      debugPrint('Unexpected partner application submission error: $error');
      debugPrintStack(stackTrace: stackTrace);

      if (!mounted) {
        return;
      }

      final message = localizations.partnerApplicationUnexpectedFailure;

      setState(() {
        _submissionError = message;
      });
      _showSubmissionMessage(message);
    } finally {
      if (mounted) {
        setState(() {
          _isSubmitting = false;
        });
      }
    }
  }

  void _showSubmissionMessage(String message) {
    if (!mounted) {
      return;
    }

    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(message),
          behavior: SnackBarBehavior.floating,
          duration: const Duration(seconds: 6),
        ),
      );
  }
}

class _PostalResultCard extends StatelessWidget {
  const _PostalResultCard({
    required this.lookup,
    required this.title,
    required this.mapStatusText,
  });

  final PartnerPostalLookup lookup;
  final String title;
  final String mapStatusText;

  @override
  Widget build(BuildContext context) {
    final coordinates = lookup.latitude == null || lookup.longitude == null
        ? ''
        : '${lookup.latitude}, '
              '${lookup.longitude}';

    return Card(
      margin: EdgeInsets.zero,
      child: Padding(
        padding: const EdgeInsets.all(AppSpacingTokens.large),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Row(
              children: <Widget>[
                Icon(
                  Icons.location_on_rounded,
                  color: Theme.of(context).colorScheme.primary,
                ),
                const SizedBox(width: AppSpacingTokens.small),
                Expanded(
                  child: Text(
                    title,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacingTokens.medium),
            Text(lookup.fullAddress, style: const TextStyle(height: 1.6)),
            if (coordinates.isNotEmpty) ...<Widget>[
              const SizedBox(height: 8),
              Directionality(
                textDirection: TextDirection.ltr,
                child: Text(
                  coordinates,
                  textAlign: TextAlign.end,
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ),
            ],
            const SizedBox(height: 8),
            Text(
              mapStatusText,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _StoreErrorBanner extends StatelessWidget {
  const _StoreErrorBanner({required this.message});

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
