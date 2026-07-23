import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';

import 'package:address/app/route_paths.dart';
import 'package:address/core/design_system/components/buttons/animated_start_button.dart';
import 'package:address/core/design_system/tokens/app_design_tokens.dart';
import 'package:address/features/auth/application/auth_session_controller.dart';
import 'package:address/features/auth/domain/entities/auth_failure.dart';
import 'package:address/features/auth/domain/entities/auth_user.dart';
import 'package:address/features/auth/domain/entities/otp_challenge.dart';
import 'package:address/features/profile/data/profile_image_picker.dart';
import 'package:address/features/profile/domain/entities/selected_profile_image.dart';
import 'package:address/features/profile/data/profile_phone_change_repository.dart';
import 'package:address/l10n/generated/app_localizations.dart';

// addressProfileJalaliBirthDateV1
class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  static const Color _brandNavy = Color(0xFF072044);
  static const Color _brandNavyLight = Color(0xFF193B72);
  static const double _maximumWidth = 680;

  final AuthSessionController _authSession = AuthSessionController.instance;
  final ProfileImagePicker _imagePicker = ProfileImagePicker();
  final ProfilePhoneChangeRepository _phoneChangeRepository =
      ProfilePhoneChangeRepository();

  DateTime? _birthDate;
  Uint8List? _avatarBytes;
  bool _isLoading = true;
  bool _isAvatarBusy = false;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _birthDate = _authSession.user?.birthDate;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      unawaited(_load());
    });
  }

  Future<void> _load() async {
    if (!_authSession.isAuthenticated) {
      return;
    }

    if (mounted) {
      setState(() {
        _isLoading = true;
      });
    }

    try {
      final user = await _authSession.refreshProfile();
      final avatarBytes = user.hasAvatar
          ? await _authSession.loadAvatarBytes()
          : null;

      if (!mounted) {
        return;
      }

      setState(() {
        _birthDate = user.birthDate;
        _avatarBytes = avatarBytes;
      });
    } on AuthFailure catch (failure) {
      if (mounted) {
        _showMessage(_messageForFailure(failure));
      }
    } catch (_) {
      if (mounted) {
        _showMessage(AppLocalizations.of(context).profileLoadFailed);
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Future<bool> _updateProfile({
    required String firstName,
    required String lastName,
    required String email,
    required DateTime? birthDate,
  }) async {
    if (_isSaving) {
      return false;
    }

    setState(() {
      _isSaving = true;
    });

    try {
      final user = await _authSession.updateProfile(
        firstName: firstName.trim(),
        lastName: lastName.trim(),
        email: email.trim(),
        birthDate: birthDate,
      );

      if (!mounted) {
        return true;
      }

      setState(() {
        _birthDate = user.birthDate;
      });

      _showMessage(AppLocalizations.of(context).profileSaved);
      return true;
    } on AuthFailure catch (failure) {
      if (mounted) {
        _showMessage(_messageForFailure(failure));
      }
      return false;
    } catch (_) {
      if (mounted) {
        _showMessage(AppLocalizations.of(context).profileSaveFailed);
      }
      return false;
    } finally {
      if (mounted) {
        setState(() {
          _isSaving = false;
        });
      }
    }
  }

  Future<void> _editName() async {
    final user = _authSession.user;

    if (user == null) {
      return;
    }

    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      showDragHandle: true,
      backgroundColor: Theme.of(context).colorScheme.surface,
      builder: (_) {
        return _NameEditSheet(
          firstName: user.firstName ?? '',
          lastName: user.lastName ?? '',
          validator: _validateName,
          onSave: (firstName, lastName) {
            return _updateProfile(
              firstName: firstName,
              lastName: lastName,
              email: user.email ?? '',
              birthDate: _birthDate,
            );
          },
        );
      },
    );

    if (mounted) {
      setState(() {});
    }
  }

  Future<void> _editPhone() async {
    final user = _authSession.user;

    if (user == null) {
      return;
    }

    final changed = await showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      showDragHandle: true,
      backgroundColor: Theme.of(context).colorScheme.surface,
      builder: (_) {
        return _PhoneEditSheet(
          currentPhone: user.phone,
          repository: _phoneChangeRepository,
          authSession: _authSession,
        );
      },
    );

    if (changed == true && mounted) {
      setState(() {});
      _showMessage(_ProfileCopy.of(context).phoneChanged);
    }
  }

  Future<void> _editEmail() async {
    final user = _authSession.user;

    if (user == null) {
      return;
    }

    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      showDragHandle: true,
      backgroundColor: Theme.of(context).colorScheme.surface,
      builder: (_) {
        return _EmailEditSheet(
          email: user.email ?? '',
          validator: _validateEmail,
          onSave: (email) {
            return _updateProfile(
              firstName: user.firstName ?? '',
              lastName: user.lastName ?? '',
              email: email,
              birthDate: _birthDate,
            );
          },
        );
      },
    );

    if (mounted) {
      setState(() {});
    }
  }

  Future<void> _editBirthDate() async {
    final user = _authSession.user;

    if (user == null) {
      return;
    }

    final now = DateTime.now();
    final initialDate =
        _birthDate ?? DateTime(now.year - 25, now.month, now.day);

    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      showDragHandle: true,
      backgroundColor: Theme.of(context).colorScheme.surface,
      builder: (_) {
        return _BirthDateEditSheet(
          initialDate: initialDate,
          maximumDate: now,
          onSave: (birthDate) {
            return _updateProfile(
              firstName: user.firstName ?? '',
              lastName: user.lastName ?? '',
              email: user.email ?? '',
              birthDate: birthDate,
            );
          },
        );
      },
    );

    if (mounted) {
      setState(() {});
    }
  }

  Future<void> _chooseAvatar() async {
    if (_isAvatarBusy) {
      return;
    }

    final action = await _showAvatarActions();

    if (action == null) {
      return;
    }

    if (action == _AvatarAction.remove) {
      await _removeAvatar();
      return;
    }

    final source = action == _AvatarAction.camera
        ? ImageSource.camera
        : ImageSource.gallery;

    setState(() {
      _isAvatarBusy = true;
    });

    try {
      final selected = await _imagePicker.pick(source);

      if (selected == null) {
        return;
      }

      await _authSession.uploadAvatar(
        bytes: selected.bytes,
        fileName: selected.fileName,
        mimeType: selected.mimeType,
      );

      if (mounted) {
        setState(() {
          _avatarBytes = selected.bytes;
        });
        _showMessage(AppLocalizations.of(context).profileAvatarSaved);
      }
    } on ProfileImageTooLargeException {
      if (mounted) {
        _showMessage(AppLocalizations.of(context).profileImageTooLarge);
      }
    } on UnsupportedProfileImageException {
      if (mounted) {
        _showMessage(AppLocalizations.of(context).profileUnsupportedImage);
      }
    } on AuthFailure catch (failure) {
      if (mounted) {
        _showMessage(_messageForFailure(failure));
      }
    } catch (_) {
      if (mounted) {
        _showMessage(AppLocalizations.of(context).profileAvatarUploadFailed);
      }
    } finally {
      if (mounted) {
        setState(() {
          _isAvatarBusy = false;
        });
      }
    }
  }

  Future<void> _removeAvatar() async {
    if (_isAvatarBusy) {
      return;
    }

    setState(() {
      _isAvatarBusy = true;
    });

    try {
      await _authSession.deleteAvatar();

      if (mounted) {
        setState(() {
          _avatarBytes = null;
        });
        _showMessage(AppLocalizations.of(context).profileAvatarRemoved);
      }
    } on AuthFailure catch (failure) {
      if (mounted) {
        _showMessage(_messageForFailure(failure));
      }
    } catch (_) {
      if (mounted) {
        _showMessage(AppLocalizations.of(context).profileAvatarUploadFailed);
      }
    } finally {
      if (mounted) {
        setState(() {
          _isAvatarBusy = false;
        });
      }
    }
  }

  Future<_AvatarAction?> _showAvatarActions() {
    final localizations = AppLocalizations.of(context);
    final hasAvatar =
        _avatarBytes != null || (_authSession.user?.hasAvatar ?? false);

    return showModalBottomSheet<_AvatarAction>(
      context: context,
      showDragHandle: true,
      useSafeArea: true,
      builder: (sheetContext) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            ListTile(
              leading: const Icon(Icons.camera_alt_rounded),
              title: Text(localizations.partnerRegistrationImageSourceCamera),
              onTap: () => Navigator.of(sheetContext).pop(_AvatarAction.camera),
            ),
            ListTile(
              leading: const Icon(Icons.photo_library_rounded),
              title: Text(localizations.partnerRegistrationImageSourceGallery),
              onTap: () =>
                  Navigator.of(sheetContext).pop(_AvatarAction.gallery),
            ),
            if (hasAvatar)
              ListTile(
                leading: const Icon(Icons.delete_outline_rounded),
                title: Text(localizations.profileRemoveAvatar),
                onTap: () =>
                    Navigator.of(sheetContext).pop(_AvatarAction.remove),
              ),
            const SizedBox(height: AppSpacingTokens.small),
          ],
        );
      },
    );
  }

  String? _validateName(String? value) {
    return (value?.trim().length ?? 0) < 2
        ? AppLocalizations.of(context).registrationNameValidation
        : null;
  }

  String? _validateEmail(String? value) {
    final normalized = value?.trim() ?? '';

    if (normalized.isEmpty) {
      return null;
    }

    final valid = RegExp(
      r'^[^@\s]+@[^@\s]+\.[^@\s]+$',
      caseSensitive: false,
    ).hasMatch(normalized);

    return valid ? null : AppLocalizations.of(context).profileInvalidEmail;
  }

  String _messageForFailure(AuthFailure failure) {
    final localizations = AppLocalizations.of(context);

    return switch (failure.kind) {
      AuthFailureKind.network => localizations.networkError,
      AuthFailureKind.unauthorized ||
      AuthFailureKind.invalidOtp ||
      AuthFailureKind.expiredOtp => localizations.registrationSessionExpired,
      AuthFailureKind.tooManyRequests =>
        localizations.registrationTryAgainLater,
      AuthFailureKind.invalidResponse ||
      AuthFailureKind.server => localizations.profileSaveFailed,
    };
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(content: Text(message), behavior: SnackBarBehavior.floating),
      );
  }

  String _formattedBirthDate(BuildContext _) {
    final value = _birthDate;

    if (value == null) {
      return '-';
    }

    return _formatJalaliDate(_JalaliDate.fromGregorian(value));
  }

  void _showComingSoon() {
    _showMessage(AppLocalizations.of(context).comingSoon);
  }

  Future<void> _signOut() async {
    final localizations = AppLocalizations.of(context);

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: Text(localizations.logoutConfirmTitle),
          content: Text(localizations.logoutConfirmMessage),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(false),
              child: Text(localizations.cancel),
            ),
            FilledButton(
              onPressed: () => Navigator.of(dialogContext).pop(true),
              child: Text(localizations.confirm),
            ),
          ],
        );
      },
    );

    if (confirmed == true) {
      await _authSession.signOut();
    }
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);
    final user = _authSession.user;
    final displayName = user?.displayName.isNotEmpty == true
        ? user!.displayName
        : localizations.addressUser;
    final phone = user?.phone ?? '';
    final email = user?.email?.trim().isNotEmpty == true ? user!.email! : '-';
    final accountActive = user?.accountStatus == 'active';

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light.copyWith(
        statusBarColor: Colors.transparent,
        systemNavigationBarColor: Theme.of(context).colorScheme.surface,
        systemNavigationBarIconBrightness: Brightness.dark,
      ),
      child: Scaffold(
        backgroundColor: Theme.of(context).colorScheme.surfaceContainerLowest,
        body: RefreshIndicator(
          onRefresh: _load,
          child: ListView(
            padding: EdgeInsets.zero,
            physics: const AlwaysScrollableScrollPhysics(
              parent: BouncingScrollPhysics(),
            ),
            children: <Widget>[
              Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: _maximumWidth),
                  child: Column(
                    children: <Widget>[
                      _ProfileHero(
                        navy: _brandNavy,
                        navyLight: _brandNavyLight,
                        avatarBytes: _avatarBytes,
                        displayName: displayName,
                        phone: _formatPhoneForDisplay(phone),
                        isAccountActive: accountActive,
                        isAvatarBusy: _isAvatarBusy,
                        onBack: () => context.pop(),
                        onAvatarTap: _chooseAvatar,
                        onNameTap: _editName,
                        onPhoneTap: _editPhone,
                      ),
                      Transform.translate(
                        offset: const Offset(0, -76),
                        child: _ProfileBody(
                          user: user,
                          displayName: displayName,
                          email: email,
                          birthDate: _formattedBirthDate(context),
                          isLoading: _isLoading,
                          onEditName: _editName,
                          onEditPhone: _editPhone,
                          onEditEmail: _editEmail,
                          onEditBirthDate: _editBirthDate,
                          onOpenCooperation: () {
                            context.push(AppRoutePaths.partnerApplications);
                          },
                          onComingSoon: _showComingSoon,
                          onLogout: () => unawaited(_signOut()),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _NameEditSheet extends StatefulWidget {
  const _NameEditSheet({
    required this.firstName,
    required this.lastName,
    required this.validator,
    required this.onSave,
  });

  final String firstName;
  final String lastName;
  final String? Function(String?) validator;
  final Future<bool> Function(String firstName, String lastName) onSave;

  @override
  State<_NameEditSheet> createState() => _NameEditSheetState();
}

class _NameEditSheetState extends State<_NameEditSheet> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late final TextEditingController _firstNameController;
  late final TextEditingController _lastNameController;
  bool _isSubmitting = false;

  @override
  void initState() {
    super.initState();
    _firstNameController = TextEditingController(text: widget.firstName);
    _lastNameController = TextEditingController(text: widget.lastName);
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    FocusManager.instance.primaryFocus?.unfocus();

    if (_isSubmitting || !(_formKey.currentState?.validate() ?? false)) {
      return;
    }

    setState(() {
      _isSubmitting = true;
    });

    final saved = await widget.onSave(
      _firstNameController.text,
      _lastNameController.text,
    );

    if (!mounted) {
      return;
    }

    if (saved) {
      Navigator.of(context).pop();
      return;
    }

    setState(() {
      _isSubmitting = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);

    return PopScope(
      canPop: !_isSubmitting,
      child: AnimatedPadding(
        duration: const Duration(milliseconds: 180),
        curve: Curves.easeOut,
        padding: EdgeInsets.fromLTRB(
          AppSpacingTokens.large,
          AppSpacingTokens.small,
          AppSpacingTokens.large,
          MediaQuery.viewInsetsOf(context).bottom + AppSpacingTokens.xxLarge,
        ),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              _SheetTitle(
                icon: Icons.person_outline_rounded,
                title: localizations.profilePersonalInfo,
              ),
              const SizedBox(height: AppSpacingTokens.xLarge),
              TextFormField(
                controller: _firstNameController,
                autofocus: true,
                textInputAction: TextInputAction.next,
                textCapitalization: TextCapitalization.words,
                validator: widget.validator,
                decoration: InputDecoration(
                  labelText: localizations.registrationFirstName,
                ),
              ),
              const SizedBox(height: AppSpacingTokens.large),
              TextFormField(
                controller: _lastNameController,
                textInputAction: TextInputAction.done,
                textCapitalization: TextCapitalization.words,
                validator: widget.validator,
                decoration: InputDecoration(
                  labelText: localizations.registrationLastName,
                ),
                onFieldSubmitted: (_) => unawaited(_submit()),
              ),
              const SizedBox(height: AppSpacingTokens.xxLarge),
              Directionality(
                textDirection: TextDirection.ltr,
                child: AnimatedStartButton(
                  title: localizations.profileSave,
                  icon: Icons.check_rounded,
                  isLoading: _isSubmitting,
                  isEnabled: !_isSubmitting,
                  onTap: () => unawaited(_submit()),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _EmailEditSheet extends StatefulWidget {
  const _EmailEditSheet({
    required this.email,
    required this.validator,
    required this.onSave,
  });

  final String email;
  final String? Function(String?) validator;
  final Future<bool> Function(String email) onSave;

  @override
  State<_EmailEditSheet> createState() => _EmailEditSheetState();
}

class _EmailEditSheetState extends State<_EmailEditSheet> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late final TextEditingController _emailController;
  bool _isSubmitting = false;

  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController(text: widget.email);
  }

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    FocusManager.instance.primaryFocus?.unfocus();

    if (_isSubmitting || !(_formKey.currentState?.validate() ?? false)) {
      return;
    }

    setState(() {
      _isSubmitting = true;
    });

    final saved = await widget.onSave(_emailController.text);

    if (!mounted) {
      return;
    }

    if (saved) {
      Navigator.of(context).pop();
      return;
    }

    setState(() {
      _isSubmitting = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);

    return PopScope(
      canPop: !_isSubmitting,
      child: AnimatedPadding(
        duration: const Duration(milliseconds: 180),
        curve: Curves.easeOut,
        padding: EdgeInsets.fromLTRB(
          AppSpacingTokens.large,
          AppSpacingTokens.small,
          AppSpacingTokens.large,
          MediaQuery.viewInsetsOf(context).bottom + AppSpacingTokens.xxLarge,
        ),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              _SheetTitle(
                icon: Icons.alternate_email_rounded,
                title: localizations.profileEmailOptional,
              ),
              const SizedBox(height: AppSpacingTokens.xLarge),
              TextFormField(
                controller: _emailController,
                autofocus: true,
                keyboardType: TextInputType.emailAddress,
                textInputAction: TextInputAction.done,
                validator: widget.validator,
                decoration: InputDecoration(
                  labelText: localizations.profileEmailOptional,
                ),
                onFieldSubmitted: (_) => unawaited(_submit()),
              ),
              const SizedBox(height: AppSpacingTokens.xxLarge),
              Directionality(
                textDirection: TextDirection.ltr,
                child: AnimatedStartButton(
                  title: localizations.profileSave,
                  icon: Icons.check_rounded,
                  isLoading: _isSubmitting,
                  isEnabled: !_isSubmitting,
                  onTap: () => unawaited(_submit()),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _PhoneEditSheet extends StatefulWidget {
  const _PhoneEditSheet({
    required this.currentPhone,
    required this.repository,
    required this.authSession,
  });

  final String currentPhone;
  final ProfilePhoneChangeRepository repository;
  final AuthSessionController authSession;

  @override
  State<_PhoneEditSheet> createState() => _PhoneEditSheetState();
}

class _PhoneEditSheetState extends State<_PhoneEditSheet> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late final TextEditingController _phoneController;
  late final TextEditingController _otpController;

  OtpChallenge? _challenge;
  bool _isSubmitting = false;
  String? _errorText;

  @override
  void initState() {
    super.initState();
    _phoneController = TextEditingController(
      text: _localPhoneForEditing(widget.currentPhone),
    );
    _otpController = TextEditingController();
  }

  @override
  void dispose() {
    _phoneController.dispose();
    _otpController.dispose();
    super.dispose();
  }

  String? _validatePhone(String? value) {
    final localizations = AppLocalizations.of(context);
    final normalized = _normalizeIranPhone(value ?? '');

    if (normalized == null) {
      return localizations.invalidPrefix;
    }

    if (normalized == _normalizeIranPhone(widget.currentPhone)) {
      return _ProfileCopy.of(context).samePhone;
    }

    return null;
  }

  Future<void> _requestCode() async {
    FocusManager.instance.primaryFocus?.unfocus();

    if (_isSubmitting || !(_formKey.currentState?.validate() ?? false)) {
      return;
    }

    final phone = _normalizeIranPhone(_phoneController.text);

    if (phone == null) {
      return;
    }

    setState(() {
      _isSubmitting = true;
      _errorText = null;
    });

    try {
      final challenge = await widget.repository.request(phone);

      if (!mounted) {
        return;
      }

      setState(() {
        _challenge = challenge;
        _otpController.clear();
        _isSubmitting = false;
      });
    } on AuthFailure catch (failure) {
      if (mounted) {
        setState(() {
          _errorText = _phoneFailureMessage(context, failure);
          _isSubmitting = false;
        });
      }
    } catch (_) {
      if (mounted) {
        setState(() {
          _errorText = AppLocalizations.of(context).profileSaveFailed;
          _isSubmitting = false;
        });
      }
    }
  }

  Future<void> _verifyCode() async {
    FocusManager.instance.primaryFocus?.unfocus();

    final challenge = _challenge;
    final otp = _asciiDigits(_otpController.text);

    if (_isSubmitting || challenge == null) {
      return;
    }

    if (otp.length != 5) {
      setState(() {
        _errorText = AppLocalizations.of(context).enterFullOtpCode;
      });
      return;
    }

    setState(() {
      _isSubmitting = true;
      _errorText = null;
    });

    try {
      final session = await widget.repository.verify(
        challengeId: challenge.challengeId,
        otp: otp,
      );
      await widget.authSession.signIn(session);

      if (!mounted) {
        return;
      }

      Navigator.of(context).pop(true);
    } on AuthFailure catch (failure) {
      if (mounted) {
        setState(() {
          _errorText = _phoneFailureMessage(context, failure);
          _isSubmitting = false;
        });
      }
    } catch (_) {
      if (mounted) {
        setState(() {
          _errorText = AppLocalizations.of(context).profileSaveFailed;
          _isSubmitting = false;
        });
      }
    }
  }

  void _changePhoneAgain() {
    if (_isSubmitting) {
      return;
    }

    setState(() {
      _challenge = null;
      _otpController.clear();
      _errorText = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);
    final copy = _ProfileCopy.of(context);
    final challenge = _challenge;

    return PopScope(
      canPop: !_isSubmitting,
      child: AnimatedPadding(
        duration: const Duration(milliseconds: 180),
        curve: Curves.easeOut,
        padding: EdgeInsets.fromLTRB(
          AppSpacingTokens.large,
          AppSpacingTokens.small,
          AppSpacingTokens.large,
          MediaQuery.viewInsetsOf(context).bottom + AppSpacingTokens.xxLarge,
        ),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              _SheetTitle(
                icon: Icons.phone_android_rounded,
                title: localizations.changeNumber,
              ),
              const SizedBox(height: AppSpacingTokens.xLarge),
              if (challenge == null) ...<Widget>[
                Directionality(
                  textDirection: TextDirection.ltr,
                  child: TextFormField(
                    controller: _phoneController,
                    autofocus: true,
                    keyboardType: TextInputType.phone,
                    textInputAction: TextInputAction.done,
                    inputFormatters: <TextInputFormatter>[
                      FilteringTextInputFormatter.allow(
                        RegExp(r'[0-9۰-۹٠-٩+ ]'),
                      ),
                      LengthLimitingTextInputFormatter(18),
                    ],
                    validator: _validatePhone,
                    decoration: InputDecoration(
                      labelText: copy.newPhone,
                      hintText: '09123456789',
                      prefixIcon: const Icon(Icons.phone_outlined),
                    ),
                    onFieldSubmitted: (_) => unawaited(_requestCode()),
                  ),
                ),
              ] else ...<Widget>[
                Text(
                  localizations.enterOtpCode(
                    _formatPhoneForDisplay(challenge.phone),
                  ),
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                const SizedBox(height: AppSpacingTokens.large),
                Directionality(
                  textDirection: TextDirection.ltr,
                  child: TextField(
                    controller: _otpController,
                    autofocus: true,
                    keyboardType: TextInputType.number,
                    textInputAction: TextInputAction.done,
                    textAlign: TextAlign.center,
                    maxLength: 5,
                    inputFormatters: <TextInputFormatter>[
                      FilteringTextInputFormatter.allow(RegExp(r'[0-9۰-۹٠-٩]')),
                    ],
                    decoration: InputDecoration(
                      labelText: copy.verificationCode,
                      counterText: '',
                      prefixIcon: const Icon(Icons.password_rounded),
                    ),
                    onSubmitted: (_) => unawaited(_verifyCode()),
                  ),
                ),
                if (challenge.developmentOtp != null) ...<Widget>[
                  const SizedBox(height: AppSpacingTokens.small),
                  Directionality(
                    textDirection: TextDirection.ltr,
                    child: Text(
                      'DEV OTP: ${challenge.developmentOtp}',
                      style: Theme.of(context).textTheme.labelMedium?.copyWith(
                        color: Theme.of(context).colorScheme.tertiary,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                ],
                const SizedBox(height: AppSpacingTokens.small),
                TextButton(
                  onPressed: _isSubmitting ? null : _changePhoneAgain,
                  child: Text(localizations.changeNumber),
                ),
              ],
              if (_errorText != null) ...<Widget>[
                const SizedBox(height: AppSpacingTokens.medium),
                Text(
                  _errorText!,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.error,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
              const SizedBox(height: AppSpacingTokens.xxLarge),
              Directionality(
                textDirection: TextDirection.ltr,
                child: AnimatedStartButton(
                  title: challenge == null
                      ? localizations.continueLabel
                      : localizations.profileSave,
                  icon: challenge == null
                      ? Icons.sms_outlined
                      : Icons.check_rounded,
                  isLoading: _isSubmitting,
                  isEnabled: !_isSubmitting,
                  onTap: () => unawaited(
                    challenge == null ? _requestCode() : _verifyCode(),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _BirthDateEditSheet extends StatefulWidget {
  const _BirthDateEditSheet({
    required this.initialDate,
    required this.maximumDate,
    required this.onSave,
  });

  final DateTime initialDate;
  final DateTime maximumDate;
  final Future<bool> Function(DateTime birthDate) onSave;

  @override
  State<_BirthDateEditSheet> createState() => _BirthDateEditSheetState();
}

class _BirthDateEditSheetState extends State<_BirthDateEditSheet> {
  static const List<String> _jalaliMonthNames = <String>[
    'فروردین',
    'اردیبهشت',
    'خرداد',
    'تیر',
    'مرداد',
    'شهریور',
    'مهر',
    'آبان',
    'آذر',
    'دی',
    'بهمن',
    'اسفند',
  ];

  late _JalaliDate _selectedDate;
  late _JalaliDate _minimumDate;
  late _JalaliDate _maximumDate;
  bool _isSubmitting = false;

  @override
  void initState() {
    super.initState();
    _minimumDate = _JalaliDate.fromGregorian(DateTime(1920));
    _maximumDate = _JalaliDate.fromGregorian(widget.maximumDate);
    _selectedDate = _clampJalaliDate(
      _JalaliDate.fromGregorian(widget.initialDate),
    );
  }

  _JalaliDate _clampJalaliDate(_JalaliDate value) {
    if (value.compareTo(_minimumDate) < 0) {
      return _minimumDate;
    }

    if (value.compareTo(_maximumDate) > 0) {
      return _maximumDate;
    }

    return value;
  }

  List<int> get _validYears {
    final count = _maximumDate.year - _minimumDate.year + 1;

    return List<int>.generate(
      count,
      (index) => _maximumDate.year - index,
      growable: false,
    );
  }

  List<int> _validMonths(int year) {
    final firstMonth = year == _minimumDate.year ? _minimumDate.month : 1;
    final lastMonth = year == _maximumDate.year ? _maximumDate.month : 12;

    return List<int>.generate(
      lastMonth - firstMonth + 1,
      (index) => firstMonth + index,
      growable: false,
    );
  }

  List<int> _validDays(int year, int month) {
    final firstDay = year == _minimumDate.year && month == _minimumDate.month
        ? _minimumDate.day
        : 1;
    var lastDay = _daysInJalaliMonth(year, month);

    if (year == _maximumDate.year && month == _maximumDate.month) {
      lastDay = _maximumDate.day;
    }

    return List<int>.generate(
      lastDay - firstDay + 1,
      (index) => firstDay + index,
      growable: false,
    );
  }

  void _changeYear(int year) {
    final months = _validMonths(year);
    var month = _selectedDate.month;

    if (!months.contains(month)) {
      month = month < months.first ? months.first : months.last;
    }

    final days = _validDays(year, month);
    var day = _selectedDate.day;

    if (!days.contains(day)) {
      day = day < days.first ? days.first : days.last;
    }

    setState(() {
      _selectedDate = _JalaliDate(year, month, day);
    });
  }

  void _changeMonth(int month) {
    final days = _validDays(_selectedDate.year, month);
    var day = _selectedDate.day;

    if (!days.contains(day)) {
      day = day < days.first ? days.first : days.last;
    }

    setState(() {
      _selectedDate = _JalaliDate(_selectedDate.year, month, day);
    });
  }

  void _changeDay(int day) {
    setState(() {
      _selectedDate = _JalaliDate(_selectedDate.year, _selectedDate.month, day);
    });
  }

  Future<void> _submit() async {
    if (_isSubmitting) {
      return;
    }

    setState(() {
      _isSubmitting = true;
    });

    final saved = await widget.onSave(_selectedDate.toGregorian());

    if (!mounted) {
      return;
    }

    if (saved) {
      Navigator.of(context).pop();
      return;
    }

    setState(() {
      _isSubmitting = false;
    });
  }

  Widget _selector({
    required String label,
    required int value,
    required List<int> values,
    required String Function(int value) textFor,
    required ValueChanged<int> onChanged,
    int flex = 1,
  }) {
    final colors = Theme.of(context).colorScheme;

    return Expanded(
      flex: flex,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Text(
            label,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.labelLarge?.copyWith(
              color: colors.onSurfaceVariant,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: AppSpacingTokens.xSmall),
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacingTokens.small,
            ),
            decoration: BoxDecoration(
              color: colors.surfaceContainerLow,
              borderRadius: BorderRadius.circular(AppRadiusTokens.medium),
              border: Border.all(
                color: colors.outlineVariant.withValues(alpha: 0.65),
              ),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<int>(
                value: value,
                isExpanded: true,
                borderRadius: BorderRadius.circular(AppRadiusTokens.medium),
                alignment: AlignmentDirectional.center,
                icon: const Icon(Icons.keyboard_arrow_down_rounded),
                items: values
                    .map(
                      (item) => DropdownMenuItem<int>(
                        value: item,
                        alignment: AlignmentDirectional.center,
                        child: FittedBox(
                          fit: BoxFit.scaleDown,
                          child: Text(
                            textFor(item),
                            textAlign: TextAlign.center,
                            style: Theme.of(context).textTheme.bodyLarge
                                ?.copyWith(fontWeight: FontWeight.w800),
                          ),
                        ),
                      ),
                    )
                    .toList(growable: false),
                onChanged: _isSubmitting
                    ? null
                    : (selected) {
                        if (selected != null) {
                          onChanged(selected);
                        }
                      },
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);
    final months = _validMonths(_selectedDate.year);
    final days = _validDays(_selectedDate.year, _selectedDate.month);

    return PopScope(
      canPop: !_isSubmitting,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(
          AppSpacingTokens.large,
          AppSpacingTokens.small,
          AppSpacingTokens.large,
          AppSpacingTokens.xxLarge,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            _SheetTitle(
              icon: Icons.calendar_month_outlined,
              title: localizations.profileBirthDateOptional,
            ),
            const SizedBox(height: AppSpacingTokens.large),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacingTokens.large,
                vertical: AppSpacingTokens.medium,
              ),
              decoration: BoxDecoration(
                color: const Color(0xFF072044).withValues(alpha: 0.07),
                borderRadius: BorderRadius.circular(AppRadiusTokens.medium),
              ),
              child: Text(
                _formatJalaliDate(_selectedDate),
                textAlign: TextAlign.center,
                textDirection: TextDirection.ltr,
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  color: const Color(0xFF072044),
                  fontWeight: FontWeight.w900,
                ),
              ),
            ),
            const SizedBox(height: AppSpacingTokens.large),
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: <Widget>[
                _selector(
                  label: 'روز',
                  value: _selectedDate.day,
                  values: days,
                  textFor: (value) => _persianDigits(value.toString()),
                  onChanged: _changeDay,
                ),
                const SizedBox(width: AppSpacingTokens.small),
                _selector(
                  label: 'ماه',
                  value: _selectedDate.month,
                  values: months,
                  textFor: (value) => _jalaliMonthNames[value - 1],
                  onChanged: _changeMonth,
                  flex: 2,
                ),
                const SizedBox(width: AppSpacingTokens.small),
                _selector(
                  label: 'سال',
                  value: _selectedDate.year,
                  values: _validYears,
                  textFor: (value) => _persianDigits(value.toString()),
                  onChanged: _changeYear,
                  flex: 2,
                ),
              ],
            ),
            const SizedBox(height: AppSpacingTokens.xxLarge),
            Directionality(
              textDirection: TextDirection.ltr,
              child: AnimatedStartButton(
                title: localizations.profileSave,
                icon: Icons.check_rounded,
                isLoading: _isSubmitting,
                isEnabled: !_isSubmitting,
                onTap: () => unawaited(_submit()),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _JalaliDate implements Comparable<_JalaliDate> {
  const _JalaliDate(this.year, this.month, this.day);

  factory _JalaliDate.fromGregorian(DateTime value) {
    return _gregorianToJalali(value.year, value.month, value.day);
  }

  final int year;
  final int month;
  final int day;

  DateTime toGregorian() => _jalaliToGregorian(year, month, day);

  @override
  int compareTo(_JalaliDate other) {
    final yearComparison = year.compareTo(other.year);

    if (yearComparison != 0) {
      return yearComparison;
    }

    final monthComparison = month.compareTo(other.month);

    if (monthComparison != 0) {
      return monthComparison;
    }

    return day.compareTo(other.day);
  }
}

_JalaliDate _gregorianToJalali(int year, int month, int day) {
  const gregorianDaysBeforeMonth = <int>[
    0,
    31,
    59,
    90,
    120,
    151,
    181,
    212,
    243,
    273,
    304,
    334,
  ];

  var gregorianYear = year;
  late int jalaliYear;

  if (gregorianYear > 1600) {
    jalaliYear = 979;
    gregorianYear -= 1600;
  } else {
    jalaliYear = 0;
    gregorianYear -= 621;
  }

  final adjustedYear = month > 2 ? gregorianYear + 1 : gregorianYear;
  var days =
      365 * gregorianYear +
      ((adjustedYear + 3) ~/ 4) -
      ((adjustedYear + 99) ~/ 100) +
      ((adjustedYear + 399) ~/ 400) -
      80 +
      day +
      gregorianDaysBeforeMonth[month - 1];

  jalaliYear += 33 * (days ~/ 12053);
  days %= 12053;
  jalaliYear += 4 * (days ~/ 1461);
  days %= 1461;

  if (days > 365) {
    jalaliYear += (days - 1) ~/ 365;
    days = (days - 1) % 365;
  }

  final jalaliMonth = days < 186 ? 1 + days ~/ 31 : 7 + (days - 186) ~/ 30;
  final jalaliDay = 1 + (days < 186 ? days % 31 : (days - 186) % 30);

  return _JalaliDate(jalaliYear, jalaliMonth, jalaliDay);
}

DateTime _jalaliToGregorian(int year, int month, int day) {
  var jalaliYear = year;
  late int gregorianYear;

  if (jalaliYear > 979) {
    gregorianYear = 1600;
    jalaliYear -= 979;
  } else {
    gregorianYear = 621;
  }

  var days =
      365 * jalaliYear +
      (jalaliYear ~/ 33) * 8 +
      ((jalaliYear % 33) + 3) ~/ 4 +
      78 +
      day +
      (month < 7 ? (month - 1) * 31 : (month - 7) * 30 + 186);

  gregorianYear += 400 * (days ~/ 146097);
  days %= 146097;

  if (days > 36524) {
    days -= 1;
    gregorianYear += 100 * (days ~/ 36524);
    days %= 36524;

    if (days >= 365) {
      days += 1;
    }
  }

  gregorianYear += 4 * (days ~/ 1461);
  days %= 1461;

  if (days > 365) {
    gregorianYear += (days - 1) ~/ 365;
    days = (days - 1) % 365;
  }

  var gregorianDay = days + 1;
  final isLeap =
      (gregorianYear % 4 == 0 && gregorianYear % 100 != 0) ||
      gregorianYear % 400 == 0;
  final monthLengths = <int>[
    0,
    31,
    isLeap ? 29 : 28,
    31,
    30,
    31,
    30,
    31,
    31,
    30,
    31,
    30,
    31,
  ];
  var gregorianMonth = 1;

  while (gregorianDay > monthLengths[gregorianMonth]) {
    gregorianDay -= monthLengths[gregorianMonth];
    gregorianMonth += 1;
  }

  return DateTime(gregorianYear, gregorianMonth, gregorianDay);
}

int _daysInJalaliMonth(int year, int month) {
  if (month <= 6) {
    return 31;
  }

  if (month <= 11) {
    return 30;
  }

  final start = _jalaliToGregorian(year, 1, 1);
  final next = _jalaliToGregorian(year + 1, 1, 1);

  return next.difference(start).inDays == 366 ? 30 : 29;
}

String _formatJalaliDate(_JalaliDate value) {
  final month = value.month.toString().padLeft(2, '0');
  final day = value.day.toString().padLeft(2, '0');

  return _persianDigits('${value.year}/$month/$day');
}

String _persianDigits(String value) {
  const ascii = '0123456789';
  const persian = '۰۱۲۳۴۵۶۷۸۹';
  final buffer = StringBuffer();

  for (final rune in value.runes) {
    final character = String.fromCharCode(rune);
    final index = ascii.indexOf(character);
    buffer.write(index >= 0 ? persian[index] : character);
  }

  return buffer.toString();
}

String _asciiDigits(String value) {
  const persian = '۰۱۲۳۴۵۶۷۸۹';
  const arabic = '٠١٢٣٤٥٦٧٨٩';
  final buffer = StringBuffer();

  for (final rune in value.runes) {
    final character = String.fromCharCode(rune);
    final persianIndex = persian.indexOf(character);
    final arabicIndex = arabic.indexOf(character);

    if (persianIndex >= 0) {
      buffer.write(persianIndex);
    } else if (arabicIndex >= 0) {
      buffer.write(arabicIndex);
    } else if (RegExp(r'[0-9]').hasMatch(character)) {
      buffer.write(character);
    }
  }

  return buffer.toString();
}

String? _normalizeIranPhone(String value) {
  final trimmed = value.trim();
  final hasPlus = trimmed.startsWith('+');
  final digits = _asciiDigits(trimmed);
  String normalized;

  if (hasPlus && digits.startsWith('98')) {
    normalized = '+$digits';
  } else if (digits.startsWith('0098')) {
    normalized = '+${digits.substring(2)}';
  } else if (digits.startsWith('98')) {
    normalized = '+$digits';
  } else if (digits.startsWith('09')) {
    normalized = '+98${digits.substring(1)}';
  } else if (digits.startsWith('9')) {
    normalized = '+98$digits';
  } else {
    return null;
  }

  return RegExp(r'^\+989\d{9}$').hasMatch(normalized) ? normalized : null;
}

String _formatPhoneForDisplay(String value) {
  final normalized = _normalizeIranPhone(value);

  if (normalized == null) {
    return value;
  }

  final national = normalized.substring(3);
  return '+98 ${national.substring(0, 3)} '
      '${national.substring(3, 6)} ${national.substring(6)}';
}

String _localPhoneForEditing(String value) {
  final normalized = _normalizeIranPhone(value);

  if (normalized == null) {
    return value;
  }

  return '0${normalized.substring(3)}';
}

String _phoneFailureMessage(BuildContext context, AuthFailure failure) {
  final localizations = AppLocalizations.of(context);
  final copy = _ProfileCopy.of(context);
  final message = failure.message?.toLowerCase() ?? '';

  if (message.contains('already registered')) {
    return copy.phoneAlreadyUsed;
  }

  if (message.contains('must be different')) {
    return copy.samePhone;
  }

  return switch (failure.kind) {
    AuthFailureKind.network => localizations.networkError,
    AuthFailureKind.invalidOtp => localizations.invalidOtpCode,
    AuthFailureKind.expiredOtp => localizations.expiredOtpCode,
    AuthFailureKind.tooManyRequests => localizations.otpRequestTooSoon,
    AuthFailureKind.unauthorized => localizations.registrationSessionExpired,
    AuthFailureKind.invalidResponse ||
    AuthFailureKind.server => localizations.profileSaveFailed,
  };
}

class _ProfileCopy {
  const _ProfileCopy({
    required this.cooperation,
    required this.addresses,
    required this.wallet,
    required this.security,
    required this.support,
    required this.newPhone,
    required this.verificationCode,
    required this.phoneChanged,
    required this.samePhone,
    required this.phoneAlreadyUsed,
  });

  final String cooperation;
  final String addresses;
  final String wallet;
  final String security;
  final String support;
  final String newPhone;
  final String verificationCode;
  final String phoneChanged;
  final String samePhone;
  final String phoneAlreadyUsed;

  static _ProfileCopy of(BuildContext context) {
    final language = Localizations.localeOf(context).languageCode;

    return switch (language) {
      'fa' => const _ProfileCopy(
        cooperation: 'همکاری با آدرس',
        addresses: 'آدرس‌های من',
        wallet: 'کیف پول',
        security: 'امنیت حساب',
        support: 'پشتیبانی',
        newPhone: 'شماره موبایل جدید',
        verificationCode: 'کد تأیید',
        phoneChanged: 'شماره موبایل با موفقیت تغییر کرد.',
        samePhone: 'شماره جدید باید با شماره فعلی متفاوت باشد.',
        phoneAlreadyUsed: 'این شماره قبلاً برای حساب دیگری ثبت شده است.',
      ),
      'ar' => const _ProfileCopy(
        cooperation: 'التعاون مع آدرس',
        addresses: 'عناويني',
        wallet: 'المحفظة',
        security: 'أمان الحساب',
        support: 'الدعم',
        newPhone: 'رقم الهاتف الجديد',
        verificationCode: 'رمز التحقق',
        phoneChanged: 'تم تغيير رقم الهاتف بنجاح.',
        samePhone: 'يجب أن يختلف الرقم الجديد عن الرقم الحالي.',
        phoneAlreadyUsed: 'هذا الرقم مسجل لحساب آخر.',
      ),
      'zh' => const _ProfileCopy(
        cooperation: '与地址合作',
        addresses: '我的地址',
        wallet: '钱包',
        security: '账户安全',
        support: '支持',
        newPhone: '新手机号码',
        verificationCode: '验证码',
        phoneChanged: '手机号码已成功更改。',
        samePhone: '新号码必须与当前号码不同。',
        phoneAlreadyUsed: '此号码已用于其他账户。',
      ),
      _ => const _ProfileCopy(
        cooperation: 'Work with Address',
        addresses: 'My addresses',
        wallet: 'Wallet',
        security: 'Account security',
        support: 'Support',
        newPhone: 'New mobile number',
        verificationCode: 'Verification code',
        phoneChanged: 'Mobile number changed successfully.',
        samePhone: 'The new number must be different from the current one.',
        phoneAlreadyUsed:
            'This number is already registered to another account.',
      ),
    };
  }
}

enum _AvatarAction { camera, gallery, remove }

class _ProfileHero extends StatelessWidget {
  const _ProfileHero({
    required this.navy,
    required this.navyLight,
    required this.avatarBytes,
    required this.displayName,
    required this.phone,
    required this.isAccountActive,
    required this.isAvatarBusy,
    required this.onBack,
    required this.onAvatarTap,
    required this.onNameTap,
    required this.onPhoneTap,
  });

  final Color navy;
  final Color navyLight;
  final Uint8List? avatarBytes;
  final String displayName;
  final String phone;
  final bool isAccountActive;
  final bool isAvatarBusy;
  final VoidCallback onBack;
  final VoidCallback onAvatarTap;
  final VoidCallback onNameTap;
  final VoidCallback onPhoneTap;

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);

    return ClipPath(
      clipper: const _ProfileHeroWaveClipper(),
      child: SizedBox(
        height: 402,
        width: double.infinity,
        child: Stack(
          fit: StackFit.expand,
          children: <Widget>[
            Material(
              color: navy,
              child: InkWell(
                onTap: onAvatarTap,
                child: avatarBytes == null
                    ? _EmptyHero(navy: navy, navyLight: navyLight)
                    : Image.memory(
                        avatarBytes!,
                        fit: BoxFit.cover,
                        alignment: Alignment.topCenter,
                        gaplessPlayback: true,
                        errorBuilder: (context, error, stackTrace) {
                          return _EmptyHero(navy: navy, navyLight: navyLight);
                        },
                      ),
              ),
            ),
            const DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: <Color>[
                    Color(0x66000000),
                    Color(0x00000000),
                    Color(0x1A000000),
                    Color(0xE6072044),
                  ],
                  stops: <double>[0, 0.34, 0.60, 1],
                ),
              ),
            ),
            SafeArea(
              bottom: false,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(
                  AppSpacingTokens.large,
                  AppSpacingTokens.small,
                  AppSpacingTokens.large,
                  0,
                ),
                child: Align(
                  alignment: AlignmentDirectional.topCenter,
                  child: Row(
                    children: <Widget>[
                      _HeroCircleButton(
                        icon: Icons.arrow_back_rounded,
                        onTap: onBack,
                      ),
                      Expanded(
                        child: Text(
                          localizations.profileTitle,
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.titleLarge
                              ?.copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.w900,
                              ),
                        ),
                      ),
                      const SizedBox(width: 44),
                    ],
                  ),
                ),
              ),
            ),
            PositionedDirectional(
              start: AppSpacingTokens.xLarge,
              bottom: 74,
              child: _HeroCircleButton(
                icon: Icons.camera_alt_rounded,
                onTap: onAvatarTap,
                isBusy: isAvatarBusy,
              ),
            ),
            PositionedDirectional(
              end: AppSpacingTokens.xLarge,
              bottom: 78,
              width: 245,
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacingTokens.small,
                  vertical: AppSpacingTokens.small,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: <Widget>[
                    InkWell(
                      onTap: onNameTap,
                      borderRadius: BorderRadius.circular(
                        AppRadiusTokens.small,
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: AppSpacingTokens.xSmall,
                          vertical: AppSpacingTokens.xSmall,
                        ),
                        child: Text(
                          displayName,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.end,
                          style: Theme.of(context).textTheme.headlineSmall
                              ?.copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.w900,
                                shadows: const <Shadow>[
                                  Shadow(
                                    blurRadius: 12,
                                    color: Color(0x88000000),
                                  ),
                                ],
                              ),
                        ),
                      ),
                    ),
                    const SizedBox(height: AppSpacingTokens.xSmall),
                    InkWell(
                      onTap: onPhoneTap,
                      borderRadius: BorderRadius.circular(
                        AppRadiusTokens.small,
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: AppSpacingTokens.xSmall,
                          vertical: AppSpacingTokens.xSmall,
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            if (isAccountActive) ...<Widget>[
                              const Icon(
                                Icons.verified_rounded,
                                size: 20,
                                color: Color(0xFF7DD3FC),
                              ),
                              const SizedBox(width: AppSpacingTokens.small),
                            ],
                            Directionality(
                              textDirection: TextDirection.ltr,
                              child: Text(
                                phone,
                                textAlign: TextAlign.left,
                                style: Theme.of(context).textTheme.titleMedium
                                    ?.copyWith(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w700,
                                    ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ProfileHeroWaveClipper extends CustomClipper<Path> {
  const _ProfileHeroWaveClipper();

  @override
  Path getClip(Size size) {
    final separatorY = size.height - 76;

    return Path()
      ..lineTo(size.width, 0)
      ..lineTo(size.width, separatorY)
      ..lineTo(0, separatorY)
      ..close();
  }

  @override
  bool shouldReclip(covariant _ProfileHeroWaveClipper oldClipper) => false;
}

class _EmptyHero extends StatelessWidget {
  const _EmptyHero({required this.navy, required this.navyLight});

  final Color navy;
  final Color navyLight;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
          colors: <Color>[navyLight, navy, const Color(0xFF020B19)],
        ),
      ),
      child: const Center(
        child: Icon(Icons.person_rounded, size: 168, color: Color(0x33FFFFFF)),
      ),
    );
  }
}

class _HeroCircleButton extends StatelessWidget {
  const _HeroCircleButton({
    required this.icon,
    required this.onTap,
    this.isBusy = false,
  });

  final IconData icon;
  final VoidCallback onTap;
  final bool isBusy;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: const Color(0x33FFFFFF),
      shape: const CircleBorder(),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: isBusy ? null : onTap,
        child: SizedBox(
          width: 44,
          height: 44,
          child: Center(
            child: isBusy
                ? const SizedBox(
                    width: 22,
                    height: 22,
                    child: CircularProgressIndicator(
                      strokeWidth: 2.5,
                      color: Colors.white,
                    ),
                  )
                : Icon(icon, color: Colors.white, size: 24),
          ),
        ),
      ),
    );
  }
}

class _ProfileBody extends StatelessWidget {
  const _ProfileBody({
    required this.user,
    required this.displayName,
    required this.email,
    required this.birthDate,
    required this.isLoading,
    required this.onEditName,
    required this.onEditPhone,
    required this.onEditEmail,
    required this.onEditBirthDate,
    required this.onOpenCooperation,
    required this.onComingSoon,
    required this.onLogout,
  });

  final AuthUser? user;
  final String displayName;
  final String email;
  final String birthDate;
  final bool isLoading;
  final VoidCallback onEditName;
  final VoidCallback onEditPhone;
  final VoidCallback onEditEmail;
  final VoidCallback onEditBirthDate;
  final VoidCallback onOpenCooperation;
  final VoidCallback onComingSoon;
  final VoidCallback onLogout;

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);
    final colors = Theme.of(context).colorScheme;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(
        AppSpacingTokens.large,
        AppSpacingTokens.xLarge,
        AppSpacingTokens.large,
        56,
      ),
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(34)),
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: colors.shadow.withValues(alpha: 0.08),
            blurRadius: 26,
            offset: const Offset(0, -6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          _ProfileCard(
            title: localizations.profilePersonalInfo,
            child: Column(
              children: <Widget>[
                _EditableProfileRow(
                  icon: Icons.person_outline_rounded,
                  label:
                      '${localizations.registrationFirstName} / '
                      '${localizations.registrationLastName}',
                  value: displayName,
                  onTap: onEditName,
                ),
                _ProfileDivider(colors: colors),
                _EditableProfileRow(
                  icon: Icons.phone_outlined,
                  label: localizations.profileVerifiedPhone,
                  value: _formatPhoneForDisplay(user?.phone ?? ''),
                  valueLtr: true,
                  verified: true,
                  onTap: onEditPhone,
                ),
                _ProfileDivider(colors: colors),
                _EditableProfileRow(
                  icon: Icons.alternate_email_rounded,
                  label: localizations.profileEmailOptional,
                  value: email,
                  valueLtr: true,
                  onTap: onEditEmail,
                ),
                _ProfileDivider(colors: colors),
                _EditableProfileRow(
                  icon: Icons.calendar_month_outlined,
                  label: localizations.profileBirthDateOptional,
                  value: birthDate,
                  valueLtr: true,
                  onTap: onEditBirthDate,
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacingTokens.large),
          _ProfileNavigationCard(
            onOpenCooperation: onOpenCooperation,
            onComingSoon: onComingSoon,
          ),
          const SizedBox(height: AppSpacingTokens.large),
          _ProfileLogoutButton(onTap: onLogout),
          if (isLoading) ...<Widget>[
            const SizedBox(height: AppSpacingTokens.large),
            const LinearProgressIndicator(),
          ],
        ],
      ),
    );
  }
}

class _ProfileCard extends StatelessWidget {
  const _ProfileCard({required this.title, required this.child});

  final String title;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.fromLTRB(
        AppSpacingTokens.large,
        AppSpacingTokens.large,
        AppSpacingTokens.large,
        AppSpacingTokens.small,
      ),
      decoration: BoxDecoration(
        color: colors.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(AppRadiusTokens.card),
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: colors.shadow.withValues(alpha: 0.07),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Text(
            title,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              color: const Color(0xFF072044),
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: AppSpacingTokens.small),
          child,
        ],
      ),
    );
  }
}

class _EditableProfileRow extends StatelessWidget {
  const _EditableProfileRow({
    required this.icon,
    required this.label,
    required this.value,
    required this.onTap,
    this.valueLtr = false,
    this.verified = false,
  });

  final IconData icon;
  final String label;
  final String value;
  final VoidCallback onTap;
  final bool valueLtr;
  final bool verified;

  @override
  Widget build(BuildContext context) {
    return _ProfileRowShell(
      icon: icon,
      label: label,
      value: value,
      valueLtr: valueLtr,
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          if (verified) ...<Widget>[
            const Icon(
              Icons.verified_rounded,
              color: Color(0xFF1D8A5B),
              size: 21,
            ),
            const SizedBox(width: AppSpacingTokens.xSmall),
          ],
          const Icon(Icons.chevron_left_rounded, color: Color(0xFF072044)),
        ],
      ),
      onTap: onTap,
    );
  }
}

class _ProfileRowShell extends StatelessWidget {
  const _ProfileRowShell({
    required this.icon,
    required this.label,
    required this.value,
    required this.valueLtr,
    this.trailing,
    this.onTap,
  });

  final IconData icon;
  final String label;
  final String value;
  final bool valueLtr;
  final Widget? trailing;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppRadiusTokens.small),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: AppSpacingTokens.medium),
        child: Row(
          children: <Widget>[
            Container(
              width: 42,
              height: 42,
              decoration: BoxDecoration(
                color: const Color(0xFF072044).withValues(alpha: 0.07),
                borderRadius: BorderRadius.circular(AppRadiusTokens.small),
              ),
              child: Icon(icon, color: const Color(0xFF072044), size: 22),
            ),
            const SizedBox(width: AppSpacingTokens.medium),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    label,
                    style: Theme.of(context).textTheme.labelMedium?.copyWith(
                      color: colors.onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(height: AppSpacingTokens.xSmall),
                  Directionality(
                    textDirection: valueLtr
                        ? TextDirection.ltr
                        : Directionality.of(context),
                    child: Text(
                      value.isEmpty ? '-' : value,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: colors.onSurface,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            if (trailing != null) ...<Widget>[
              const SizedBox(width: AppSpacingTokens.small),
              trailing!,
            ],
          ],
        ),
      ),
    );
  }
}

class _ProfileDivider extends StatelessWidget {
  const _ProfileDivider({required this.colors});

  final ColorScheme colors;

  @override
  Widget build(BuildContext context) {
    return Divider(
      height: 1,
      color: colors.outlineVariant.withValues(alpha: 0.55),
    );
  }
}

class _ProfileNavigationCard extends StatelessWidget {
  const _ProfileNavigationCard({
    required this.onOpenCooperation,
    required this.onComingSoon,
  });

  final VoidCallback onOpenCooperation;
  final VoidCallback onComingSoon;

  @override
  Widget build(BuildContext context) {
    final copy = _ProfileCopy.of(context);
    final colors = Theme.of(context).colorScheme;
    final items = <({IconData icon, String label, VoidCallback onTap})>[
      (
        icon: Icons.business_center_outlined,
        label: copy.cooperation,
        onTap: onOpenCooperation,
      ),
      (
        icon: Icons.location_on_outlined,
        label: copy.addresses,
        onTap: onComingSoon,
      ),
      (
        icon: Icons.account_balance_wallet_outlined,
        label: copy.wallet,
        onTap: onComingSoon,
      ),
      (icon: Icons.shield_outlined, label: copy.security, onTap: onComingSoon),
      (
        icon: Icons.support_agent_rounded,
        label: copy.support,
        onTap: onComingSoon,
      ),
    ];

    return Container(
      decoration: BoxDecoration(
        color: colors.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(AppRadiusTokens.card),
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: colors.shadow.withValues(alpha: 0.07),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        children: <Widget>[
          for (var index = 0; index < items.length; index++) ...<Widget>[
            ListTile(
              leading: Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  color: const Color(0xFF072044).withValues(alpha: 0.07),
                  borderRadius: BorderRadius.circular(AppRadiusTokens.small),
                ),
                child: Icon(items[index].icon, color: const Color(0xFF072044)),
              ),
              title: Text(
                items[index].label,
                style: const TextStyle(fontWeight: FontWeight.w800),
              ),
              trailing: const Icon(
                Icons.chevron_left_rounded,
                color: Color(0xFF072044),
              ),
              onTap: items[index].onTap,
            ),
            if (index != items.length - 1)
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacingTokens.large,
                ),
                child: _ProfileDivider(colors: colors),
              ),
          ],
        ],
      ),
    );
  }
}

class _ProfileLogoutButton extends StatelessWidget {
  const _ProfileLogoutButton({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);

    return Material(
      color: Theme.of(context).colorScheme.surfaceContainerLowest,
      borderRadius: BorderRadius.circular(AppRadiusTokens.card),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppRadiusTokens.card),
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacingTokens.large,
            vertical: AppSpacingTokens.large,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Icon(
                Icons.logout_rounded,
                color: Theme.of(context).colorScheme.error,
              ),
              const SizedBox(width: AppSpacingTokens.small),
              Text(
                localizations.logOut,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: Theme.of(context).colorScheme.error,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SheetTitle extends StatelessWidget {
  const _SheetTitle({required this.icon, required this.title});

  final IconData icon;
  final String title;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            color: const Color(0xFF072044).withValues(alpha: 0.08),
            borderRadius: BorderRadius.circular(AppRadiusTokens.medium),
          ),
          child: Icon(icon, color: const Color(0xFF072044)),
        ),
        const SizedBox(width: AppSpacingTokens.medium),
        Expanded(
          child: Text(
            title,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              color: const Color(0xFF072044),
              fontWeight: FontWeight.w900,
            ),
          ),
        ),
      ],
    );
  }
}
