import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:go_router/go_router.dart';

import 'package:address/app/route_paths.dart';
import 'package:address/core/extensions/digit_extensions.dart';
import 'package:address/features/auth/application/auth_session_controller.dart';
import 'package:address/features/auth/domain/entities/auth_failure.dart';
import 'package:address/features/auth/domain/entities/auth_user.dart';
import 'package:address/core/design_system/components/buttons/animated_start_button.dart';
import 'package:address/core/design_system/components/layout/app_page_scaffold.dart';
import 'package:address/features/profile/data/profile_image_picker.dart';
import 'package:address/features/profile/domain/entities/selected_profile_image.dart';
import 'package:address/features/profile/presentation/widgets/profile_avatar.dart';
import 'package:address/l10n/generated/app_localizations.dart';

// addressGeneralRegistrationV1
class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({super.key});

  @override
  State<RegistrationScreen> createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  static const double _maximumWidth = 620;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final AuthSessionController _authSession = AuthSessionController.instance;
  final ProfileImagePicker _imagePicker = ProfileImagePicker();

  bool _termsAccepted = false;
  SelectedProfileImage? _avatar;
  bool _isPickingAvatar = false;
  bool _isSubmitting = false;

  bool _isExitDialogVisible = false;
  @override
  void initState() {
    super.initState();

    final user = _authSession.user;
    _firstNameController.text = user?.firstName ?? '';
    _lastNameController.text = user?.lastName ?? '';

    if (user?.profileComplete ?? false) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          context.go(AppRoutePaths.home);
        }
      });
    }
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    super.dispose();
  }

  Future<void> _chooseAvatar() async {
    if (_isPickingAvatar || _isSubmitting) {
      return;
    }

    final localizations = AppLocalizations.of(context);
    final action = await showModalBottomSheet<_RegistrationAvatarAction>(
      context: context,
      showDragHandle: true,
      builder: (sheetContext) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              ListTile(
                leading: const Icon(Icons.camera_alt_rounded),
                title: Text(localizations.partnerRegistrationImageSourceCamera),
                onTap: () => Navigator.of(
                  sheetContext,
                ).pop(_RegistrationAvatarAction.camera),
              ),
              ListTile(
                leading: const Icon(Icons.photo_library_rounded),
                title: Text(
                  localizations.partnerRegistrationImageSourceGallery,
                ),
                onTap: () => Navigator.of(
                  sheetContext,
                ).pop(_RegistrationAvatarAction.gallery),
              ),
              if (_avatar != null)
                ListTile(
                  leading: const Icon(Icons.delete_outline_rounded),
                  title: Text(localizations.profileRemoveAvatar),
                  onTap: () => Navigator.of(
                    sheetContext,
                  ).pop(_RegistrationAvatarAction.remove),
                ),
            ],
          ),
        );
      },
    );

    if (action == null) {
      return;
    }

    if (action == _RegistrationAvatarAction.remove) {
      setState(() {
        _avatar = null;
      });
      return;
    }

    setState(() {
      _isPickingAvatar = true;
    });

    try {
      final selected = await _imagePicker.pick(
        action == _RegistrationAvatarAction.camera
            ? ImageSource.camera
            : ImageSource.gallery,
      );

      if (selected != null && mounted) {
        setState(() {
          _avatar = selected;
        });
      }
    } on ProfileImageTooLargeException {
      if (mounted) {
        _showMessage(localizations.profileImageTooLarge);
      }
    } on UnsupportedProfileImageException {
      if (mounted) {
        _showMessage(localizations.profileUnsupportedImage);
      }
    } catch (_) {
      if (mounted) {
        _showMessage(localizations.profileAvatarUploadFailed);
      }
    } finally {
      if (mounted) {
        setState(() {
          _isPickingAvatar = false;
        });
      }
    }
  }

  Future<void> _submit() async {
    FocusManager.instance.primaryFocus?.unfocus();

    if (_isSubmitting || !(_formKey.currentState?.validate() ?? false)) {
      return;
    }

    final localizations = AppLocalizations.of(context);

    if (!_termsAccepted) {
      _showMessage(localizations.registrationTermsRequired);
      return;
    }

    setState(() {
      _isSubmitting = true;
    });

    try {
      await _authSession.completeRegistration(
        firstName: _firstNameController.text.trim(),
        lastName: _lastNameController.text.trim(),
        startIntent: RegistrationIntent.services,
        termsAccepted: true,
      );

      var avatarUploadFailed = false;
      final avatar = _avatar;

      if (avatar != null) {
        try {
          await _authSession.uploadAvatar(
            bytes: avatar.bytes,
            fileName: avatar.fileName,
            mimeType: avatar.mimeType,
          );
        } catch (_) {
          avatarUploadFailed = true;
        }
      }

      if (!mounted) {
        return;
      }

      if (avatarUploadFailed) {
        _showMessage(localizations.registrationAvatarUploadSkipped);
      }

      context.go(AppRoutePaths.home);
    } on AuthFailure catch (failure) {
      if (!mounted) {
        return;
      }

      final message = switch (failure.kind) {
        AuthFailureKind.network => localizations.networkError,
        AuthFailureKind.unauthorized ||
        AuthFailureKind.invalidOtp ||
        AuthFailureKind.expiredOtp => localizations.registrationSessionExpired,
        AuthFailureKind.tooManyRequests =>
          localizations.registrationTryAgainLater,
        AuthFailureKind.invalidResponse ||
        AuthFailureKind.server => localizations.registrationSubmitFailed,
      };

      _showMessage(message);
    } catch (_) {
      if (mounted) {
        _showMessage(localizations.registrationSubmitFailed);
      }
    } finally {
      if (mounted) {
        setState(() {
          _isSubmitting = false;
        });
      }
    }
  }

  Future<void> _requestExitRegistration() async {
    if (_isSubmitting || _isExitDialogVisible) {
      return;
    }

    FocusManager.instance.primaryFocus?.unfocus();
    _isExitDialogVisible = true;

    final localizations = AppLocalizations.of(context);
    final shouldExit = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) {
        return AlertDialog(
          icon: const Icon(Icons.logout_rounded),
          title: Text(localizations.registrationExitTitle),
          content: Text(localizations.registrationExitMessage),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(false),
              child: Text(localizations.registrationExitContinue),
            ),
            FilledButton(
              onPressed: () => Navigator.of(dialogContext).pop(true),
              child: Text(localizations.registrationExitConfirm),
            ),
          ],
        );
      },
    );

    if (shouldExit != true) {
      _isExitDialogVisible = false;
      return;
    }

    try {
      await _authSession.signOut();

      if (mounted) {
        context.go(AppRoutePaths.onboarding);
      }
    } finally {
      _isExitDialogVisible = false;
    }
  }

  Future<void> _changePhone() {
    return _requestExitRegistration();
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(content: Text(message), behavior: SnackBarBehavior.floating),
      );
  }

  String? _validateName(String? value) {
    final localizations = AppLocalizations.of(context);
    final normalized = value?.trim() ?? '';

    if (normalized.length < 2) {
      return localizations.registrationNameValidation;
    }

    return null;
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final locale = Localizations.localeOf(context).languageCode;
    final isPersian = locale == 'fa';
    final phone = _authSession.user?.phone ?? '';
    final displayPhone = isPersian ? phone.toPersianDigit() : phone;

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (!didPop) {
          _requestExitRegistration();
        }
      },
      child: AppPageScaffold(
        backgroundColor: colorScheme.surface,
        navigationIcon: Icons.close_rounded,
        navigationLabel: localizations.registrationExitAction,
        onNavigationPressed: _requestExitRegistration,
        body: SafeArea(
          top: false,
          child: LayoutBuilder(
            builder: (context, constraints) {
              final horizontalPadding = constraints.maxWidth < 430
                  ? 16.0
                  : 28.0;

              return SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: EdgeInsets.fromLTRB(
                  horizontalPadding,
                  8,
                  horizontalPadding,
                  20,
                ),
                child: Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: _maximumWidth),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Center(
                            child: Stack(
                              alignment: Alignment.center,
                              children: <Widget>[
                                ProfileAvatar(
                                  size: 88,
                                  imageBytes: _avatar?.bytes,
                                  displayName:
                                      '${_firstNameController.text} '
                                      '${_lastNameController.text}',
                                  onTap: _chooseAvatar,
                                ),
                                if (_isPickingAvatar)
                                  const SizedBox(
                                    width: 38,
                                    height: 38,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 3,
                                    ),
                                  ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            localizations.registrationAvatarOptional,
                            textAlign: TextAlign.center,
                            style: textTheme.bodySmall?.copyWith(
                              color: colorScheme.onSurfaceVariant,
                            ),
                          ),
                          const SizedBox(height: 12),
                          Text(
                            localizations.registrationTitle,
                            style: textTheme.headlineSmall?.copyWith(
                              color: colorScheme.primary,
                              fontWeight: FontWeight.w800,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            localizations.registrationSubtitle,
                            style: textTheme.bodyLarge?.copyWith(
                              color: colorScheme.onSurfaceVariant,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 12),
                          _RegistrationTextField(
                            controller: _firstNameController,
                            label: localizations.registrationFirstName,
                            textInputAction: TextInputAction.next,
                            validator: _validateName,
                          ),
                          const SizedBox(height: 10),
                          _RegistrationTextField(
                            controller: _lastNameController,
                            label: localizations.registrationLastName,
                            textInputAction: TextInputAction.done,
                            validator: _validateName,
                            onSubmitted: (_) => _submit(),
                          ),
                          const SizedBox(height: 10),
                          _VerifiedPhoneCard(
                            label: localizations.registrationVerifiedPhone,
                            phone: displayPhone,
                          ),
                          const SizedBox(height: 10),
                          CheckboxListTile(
                            value: _termsAccepted,
                            contentPadding: EdgeInsets.zero,
                            controlAffinity: ListTileControlAffinity.leading,
                            title: Text(
                              localizations.registrationTermsAcceptance,
                              style: textTheme.bodyMedium,
                            ),
                            onChanged: _isSubmitting
                                ? null
                                : (value) {
                                    setState(() {
                                      _termsAccepted = value ?? false;
                                    });
                                  },
                          ),
                          const SizedBox(height: 10),
                          Center(
                            child: Directionality(
                              textDirection: TextDirection.ltr,
                              child: AnimatedStartButton(
                                title: localizations.registrationAction,
                                icon: Icons.check_rounded,
                                isLoading: _isSubmitting,
                                isEnabled: _termsAccepted && !_isSubmitting,
                                onTap: _submit,
                              ),
                            ),
                          ),
                          const SizedBox(height: 6),
                          TextButton(
                            onPressed: _isSubmitting ? null : _changePhone,
                            child: Text(localizations.registrationChangePhone),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

enum _RegistrationAvatarAction { camera, gallery, remove }

class _RegistrationTextField extends StatelessWidget {
  const _RegistrationTextField({
    required this.controller,
    required this.label,
    required this.textInputAction,
    required this.validator,
    this.onSubmitted,
  });

  final TextEditingController controller;
  final String label;
  final TextInputAction textInputAction;
  final String? Function(String?) validator;
  final ValueChanged<String>? onSubmitted;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      textInputAction: textInputAction,
      textCapitalization: TextCapitalization.words,
      autofillHints: const [AutofillHints.name],
      validator: validator,
      onFieldSubmitted: onSubmitted,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
      ),
    );
  }
}

class _VerifiedPhoneCard extends StatelessWidget {
  const _VerifiedPhoneCard({required this.label, required this.phone});

  final String label;
  final String phone;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: colorScheme.secondaryContainer.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: colorScheme.secondary.withValues(alpha: 0.35),
        ),
      ),
      child: Row(
        children: [
          Icon(Icons.verified_rounded, color: colorScheme.secondary),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label, style: textTheme.labelMedium),
                const SizedBox(height: 2),
                Directionality(
                  textDirection: TextDirection.ltr,
                  child: Text(
                    phone,
                    style: textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
