import 'package:country_picker/country_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:address/core/extensions/digit_extensions.dart';
import 'package:address/features/auth/presentation/controllers/login_controller.dart';
import 'package:address/features/auth/presentation/widgets/or_divider.dart';
import 'package:address/features/onboarding/presentation/widgets/animated_start_button.dart';
import 'package:address/features/onboarding/presentation/widgets/circular_action_button.dart';
import 'package:address/l10n/generated/app_localizations.dart';

class LoginSheet extends StatefulWidget {
  const LoginSheet({
    required this.onClose,
    required this.onLoginSuccess,
    super.key,
  });

  final VoidCallback onClose;
  final ValueChanged<String> onLoginSuccess;

  @override
  State<LoginSheet> createState() => _LoginSheetState();
}

class _LoginSheetState extends State<LoginSheet> {
  static const double _maximumCardWidth = 520;

  final TextEditingController _mobileNumberController = TextEditingController();
  final LoginController _loginController = LoginController();

  String _selectedCountryCode = 'IR';
  String _countryDialCode = '+98';
  OverlayEntry? _errorOverlay;

  String _emojiFlag(String countryCode) {
    const flagOffset = 0x1F1E6;
    const asciiOffset = 0x41;

    return String.fromCharCode(
          countryCode.codeUnitAt(0) - asciiOffset + flagOffset,
        ) +
        String.fromCharCode(
          countryCode.codeUnitAt(1) - asciiOffset + flagOffset,
        );
  }

  Future<void> _handleLogin() async {
    FocusScope.of(context).unfocus();

    final rawPhone = _mobileNumberController.text.toEnglishDigit().trim();

    final result = await _loginController.validateAndLogin(
      rawPhone,
      _countryDialCode,
    );

    if (!mounted) {
      return;
    }

    if (result != null) {
      widget.onLoginSuccess(result);
      return;
    }

    final error = _loginController.currentError;

    if (error != null) {
      _handleErrorMessage(error);
    }
  }

  void _handleErrorMessage(LoginError error) {
    final localizations = AppLocalizations.of(context);

    final message = switch (error) {
      LoginError.empty => localizations.enterMobileError,
      LoginError.notDigits => localizations.notDigits,
      LoginError.invalidPrefix => localizations.invalidPrefix,
      LoginError.invalidLength11 => localizations.enterMobileErrorWithZero,
      LoginError.invalidLength10 => localizations.enterMobileErrorWithoutZero,
      LoginError.tooShort => localizations.tooShort,
      LoginError.networkError => localizations.networkError,
    };

    _showError(message);
  }

  void _showError(String message) {
    _removeErrorOverlay();

    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    _errorOverlay = OverlayEntry(
      builder: (context) {
        return Positioned(
          top: MediaQuery.paddingOf(context).top + 16,
          left: 20,
          right: 20,
          child: Material(
            color: Colors.transparent,
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: _maximumCardWidth),
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 14,
                  ),
                  decoration: BoxDecoration(
                    color: colorScheme.errorContainer,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.15),
                        blurRadius: 15,
                        offset: const Offset(0, 6),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          message,
                          style: textTheme.bodyMedium?.copyWith(
                            color: colorScheme.onErrorContainer,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      GestureDetector(
                        onTap: _removeErrorOverlay,
                        child: Icon(
                          Icons.cancel,
                          color: colorScheme.onErrorContainer,
                          size: 26,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );

    Overlay.of(context).insert(_errorOverlay!);

    Future<void>.delayed(const Duration(seconds: 3), _removeErrorOverlay);
  }

  void _removeErrorOverlay() {
    if (_errorOverlay?.mounted ?? false) {
      _errorOverlay?.remove();
    }

    _errorOverlay = null;
  }

  @override
  void dispose() {
    _removeErrorOverlay();
    _loginController.dispose();
    _mobileNumberController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final bottomInset = MediaQuery.viewInsetsOf(context).bottom;
    final localizations = AppLocalizations.of(context);

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        resizeToAvoidBottomInset: false,
        body: SafeArea(
          child: LayoutBuilder(
            builder: (context, constraints) {
              final isNarrow = constraints.maxWidth < 430;
              final horizontalMargin = isNarrow ? 16.0 : 28.0;
              final cardPadding = isNarrow ? 20.0 : 28.0;

              return AnimatedPadding(
                duration: const Duration(milliseconds: 250),
                curve: Curves.fastOutSlowIn,
                padding: EdgeInsets.only(bottom: bottomInset),
                child: Center(
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(
                      parent: AlwaysScrollableScrollPhysics(),
                    ),
                    padding: EdgeInsets.symmetric(
                      horizontal: horizontalMargin,
                      vertical: 28,
                    ),
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(
                        maxWidth: _maximumCardWidth,
                      ),
                      child: Stack(
                        clipBehavior: Clip.none,
                        children: [
                          Container(
                            width: double.infinity,
                            padding: EdgeInsets.fromLTRB(
                              cardPadding,
                              cardPadding,
                              cardPadding,
                              cardPadding + 16,
                            ),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(24),
                              color: colorScheme.surface,
                              boxShadow: [
                                BoxShadow(
                                  color: colorScheme.shadow.withValues(
                                    alpha: 0.35,
                                  ),
                                  blurRadius: 24,
                                  offset: const Offset(0, 10),
                                ),
                              ],
                            ),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  localizations.login,
                                  style: textTheme.headlineSmall?.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: colorScheme.primary,
                                  ),
                                ),
                                const SizedBox(height: 12),
                                Text(
                                  localizations.enteryourmobilenumber,
                                  style: textTheme.titleMedium?.copyWith(
                                    color: colorScheme.onSurfaceVariant,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                                const SizedBox(height: 24),
                                _buildPhoneInputField(localizations),
                                const SizedBox(height: 28),
                                Directionality(
                                  textDirection: TextDirection.ltr,
                                  child: ListenableBuilder(
                                    listenable: _loginController,
                                    builder: (context, child) {
                                      return AnimatedStartButton(
                                        onTap: _handleLogin,
                                        isLoading: _loginController.isLoading,
                                      );
                                    },
                                  ),
                                ),
                                const SizedBox(height: 28),
                                const OrDivider(),
                                const SizedBox(height: 24),
                                Row(
                                  children: [
                                    Expanded(
                                      child: _buildSocialButton(
                                        Icons.email_outlined,
                                        localizations.email,
                                      ),
                                    ),
                                    const SizedBox(width: 10),
                                    Expanded(
                                      child: _buildSocialButton(
                                        Icons.g_mobiledata_rounded,
                                        'Google',
                                      ),
                                    ),
                                    const SizedBox(width: 10),
                                    Expanded(
                                      child: _buildSocialButton(
                                        Icons.apple,
                                        'Apple',
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          Positioned(
                            bottom: -20,
                            left: 0,
                            right: 0,
                            child: Center(
                              child: CircularActionButton(
                                size: 40,
                                icon: Icons.close,
                                onPressed: () {
                                  _mobileNumberController.clear();
                                  _removeErrorOverlay();
                                  widget.onClose();
                                },
                              ),
                            ),
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

  Widget _buildPhoneInputField(AppLocalizations localizations) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final isRtl = const [
      'fa',
      'ar',
    ].contains(Localizations.localeOf(context).languageCode);

    return Container(
      height: 58,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
        color: colorScheme.surface,
        boxShadow: [
          BoxShadow(
            color: colorScheme.shadow.withValues(alpha: 0.09),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Directionality(
        textDirection: TextDirection.ltr,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            InkWell(
              onTap: () {
                showCountryPicker(
                  context: context,
                  showPhoneCode: true,
                  onSelect: (country) {
                    setState(() {
                      _selectedCountryCode = country.countryCode;
                      _countryDialCode = '+${country.phoneCode}';
                    });
                  },
                );
              },
              borderRadius: const BorderRadius.horizontal(
                left: Radius.circular(14),
              ),
              child: SizedBox(
                width: 84,
                child: Center(
                  child: Text(
                    '${_emojiFlag(_selectedCountryCode)} '
                    '$_selectedCountryCode',
                    style: textTheme.bodyMedium,
                  ),
                ),
              ),
            ),
            Container(
              height: 26,
              width: 1.5,
              color: colorScheme.shadow.withValues(alpha: 0.2),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 8, right: 4),
              child: Text(
                isRtl ? _countryDialCode.toPersianDigit() : _countryDialCode,
                style: textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w800,
                  fontSize: 18,
                  color: colorScheme.primary,
                ),
              ),
            ),
            Expanded(
              child: TextField(
                controller: _mobileNumberController,
                keyboardType: TextInputType.phone,
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'[0-9۰-۹٠-٩]')),
                  if (isRtl) PersianDigitFormatter(),
                ],
                style: textTheme.titleMedium?.copyWith(
                  letterSpacing: 1.5,
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
                decoration: InputDecoration(
                  isDense: true,
                  filled: false,
                  hintText: localizations.mobileNumber,
                  hintStyle: textTheme.titleMedium?.copyWith(
                    color: colorScheme.shadow.withValues(alpha: 0.3),
                    fontSize: 16,
                  ),
                  border: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  focusedBorder: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 4,
                    vertical: 17,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSocialButton(IconData icon, String label) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return InkWell(
      onTap: () {},
      borderRadius: BorderRadius.circular(12),
      child: Container(
        height: 44,
        padding: const EdgeInsets.symmetric(horizontal: 8),
        decoration: BoxDecoration(
          color: colorScheme.surface,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: colorScheme.shadow.withValues(alpha: 0.25),
              blurRadius: 7,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: FittedBox(
          fit: BoxFit.scaleDown,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: colorScheme.onSurface, size: 18),
              const SizedBox(width: 6),
              Text(
                label,
                style: textTheme.labelMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: colorScheme.primary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
