import 'dart:async';
import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:address/core/design_system/components/buttons/language_button.dart';
import 'package:address/features/auth/application/auth_session_controller.dart';
import 'package:address/core/design_system/tokens/app_design_tokens.dart';
import 'package:address/features/home/presentation/widgets/side_menu_item.dart';
import 'package:address/features/profile/presentation/widgets/profile_avatar.dart';
import 'package:address/l10n/generated/app_localizations.dart';

// addressSideMenuExactProfileHeaderV2
class SideMenu extends StatefulWidget {
  const SideMenu({
    required this.width,
    required this.onSignOut,
    required this.showAdminShopAccess,
    required this.onAdminShopAccessTap,
    required this.onProfileTap,
    super.key,
  });

  final double width;
  final Future<void> Function() onSignOut;
  final bool showAdminShopAccess;
  final VoidCallback onAdminShopAccessTap;
  final VoidCallback onProfileTap;

  @override
  State<SideMenu> createState() => _SideMenuState();
}

class _SideMenuState extends State<SideMenu> {
  final AuthSessionController _authSession = AuthSessionController.instance;

  String _selectedId = 'services';
  Uint8List? _avatarBytes;
  int _avatarLoadGeneration = 0;

  @override
  void initState() {
    super.initState();
    _authSession.addListener(_handleAuthChanged);
    unawaited(_loadAvatar());
  }

  @override
  void dispose() {
    _authSession.removeListener(_handleAuthChanged);
    super.dispose();
  }

  void _handleAuthChanged() {
    if (mounted) {
      setState(() {});
    }

    unawaited(_loadAvatar());
  }

  Future<void> _loadAvatar() async {
    final generation = ++_avatarLoadGeneration;
    final user = _authSession.user;

    if (user?.hasAvatar != true) {
      if (mounted && generation == _avatarLoadGeneration) {
        setState(() {
          _avatarBytes = null;
        });
      }
      return;
    }

    try {
      final bytes = await _authSession.loadAvatarBytes();

      if (mounted && generation == _avatarLoadGeneration) {
        setState(() {
          _avatarBytes = bytes;
        });
      }
    } catch (_) {
      if (mounted && generation == _avatarLoadGeneration) {
        setState(() {
          _avatarBytes = null;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);
    final colors = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final user = _authSession.user;
    final displayName = user?.displayName.isNotEmpty == true
        ? user!.displayName
        : localizations.addressUser;
    final phone = _formatMenuPhone(user?.phone ?? '');

    final entries = <_SideMenuEntry>[
      _SideMenuEntry(
        id: 'services',
        icon: CupertinoIcons.circle_grid_3x3_fill,
        label: localizations.services,
      ),
      _SideMenuEntry(
        id: 'activity',
        icon: CupertinoIcons.square_list_fill,
        label: localizations.activity,
      ),
      _SideMenuEntry(
        id: 'gift',
        icon: CupertinoIcons.gift_fill,
        label: localizations.sendGift,
      ),
      _SideMenuEntry(
        id: 'settings',
        icon: CupertinoIcons.gear_alt_fill,
        label: localizations.settings,
      ),
      _SideMenuEntry(
        id: 'messages',
        icon: CupertinoIcons.envelope_fill,
        label: localizations.messages,
      ),
      _SideMenuEntry(
        id: 'business',
        icon: CupertinoIcons.briefcase_fill,
        label: localizations.businessHub,
      ),
    ];

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SafeArea(
        child: Align(
          alignment: AlignmentDirectional.topStart,
          child: SizedBox(
            width: widget.width,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Material(
                  color: Colors.transparent,
                  borderRadius: BorderRadius.circular(AppRadiusTokens.card),
                  child: InkWell(
                    onTap: widget.onProfileTap,
                    borderRadius: BorderRadius.circular(AppRadiusTokens.card),
                    child: Padding(
                      padding: const EdgeInsetsDirectional.fromSTEB(
                        AppSpacingTokens.medium,
                        AppSpacingTokens.large,
                        AppSpacingTokens.medium,
                        AppSpacingTokens.large,
                      ),
                      child: Row(
                        children: <Widget>[
                          ProfileAvatar(
                            size: 60,
                            imageBytes: _avatarBytes,
                            displayName: displayName,
                            editable: false,
                            onTap: null,
                          ),
                          const SizedBox(width: AppSpacingTokens.small),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                SizedBox(
                                  width: double.infinity,
                                  child: FittedBox(
                                    fit: BoxFit.scaleDown,
                                    alignment: AlignmentDirectional.centerStart,
                                    child: Text(
                                      displayName,
                                      maxLines: 1,
                                      textAlign: TextAlign.start,
                                      style: textTheme.titleMedium?.copyWith(
                                        fontWeight: FontWeight.w900,
                                        color: colors.onSurface,
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: AppSpacingTokens.xSmall),
                                Directionality(
                                  textDirection: TextDirection.ltr,
                                  child: Align(
                                    alignment: AlignmentDirectional.centerStart,
                                    child: SizedBox(
                                      width: double.infinity,
                                      child: FittedBox(
                                        fit: BoxFit.scaleDown,
                                        alignment:
                                            AlignmentDirectional.centerStart,
                                        child: Text(
                                          phone,
                                          maxLines: 1,
                                          textAlign: TextAlign.left,
                                          style: textTheme.bodyMedium?.copyWith(
                                            color: colors.onSurfaceVariant,
                                            fontWeight: FontWeight.w700,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Icon(
                            Icons.chevron_left_rounded,
                            color: colors.onSurfaceVariant,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: ListView(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacingTokens.large,
                    ),
                    children: <Widget>[
                      for (final entry in entries) ...<Widget>[
                        SideMenuItem(
                          icon: entry.icon,
                          label: entry.label,
                          isSelected: _selectedId == entry.id,
                          onTap: () => _selectEntry(entry.id),
                        ),
                        _divider(colors),
                      ],
                      if (widget.showAdminShopAccess) ...<Widget>[
                        SideMenuItem(
                          icon: Icons.admin_panel_settings_rounded,
                          label: localizations.adminShopAccess,
                          onTap: widget.onAdminShopAccessTap,
                        ),
                        _divider(colors),
                      ],
                      const LanguageButton.menuItem(),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _divider(ColorScheme colors) {
    return Divider(
      color: colors.outlineVariant.withValues(alpha: 0.3),
      thickness: 1,
      height: AppSpacingTokens.small,
      indent: AppSpacingTokens.large,
      endIndent: AppSpacingTokens.large,
    );
  }

  void _selectEntry(String id) {
    setState(() {
      _selectedId = id;
    });

    if (id != 'services') {
      final localizations = AppLocalizations.of(context);
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(SnackBar(content: Text(localizations.comingSoon)));
    }
  }
}

String _menuAsciiDigits(String value) {
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

String _formatMenuPhone(String value) {
  final trimmed = value.trim();
  final digits = _menuAsciiDigits(trimmed);
  String? normalized;

  if (digits.startsWith('98')) {
    normalized = '+$digits';
  } else if (digits.startsWith('09')) {
    normalized = '+98${digits.substring(1)}';
  } else if (digits.startsWith('9')) {
    normalized = '+98$digits';
  }

  if (normalized == null || !RegExp(r'^\+989\d{9}$').hasMatch(normalized)) {
    return value;
  }

  final national = normalized.substring(3);
  return '+98 ${national.substring(0, 3)} '
      '${national.substring(3, 6)} ${national.substring(6)}';
}

class _SideMenuEntry {
  const _SideMenuEntry({
    required this.id,
    required this.icon,
    required this.label,
  });

  final String id;
  final IconData icon;
  final String label;
}
