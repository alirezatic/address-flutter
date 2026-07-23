import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:address/l10n/generated/app_localizations.dart';

class SideMenu extends StatefulWidget {
  const SideMenu({
    required this.width,
    required this.onLanguageTap,
    required this.onSignOut,
    super.key,
  });

  final double width;
  final VoidCallback onLanguageTap;
  final Future<void> Function() onSignOut;

  @override
  State<SideMenu> createState() => _SideMenuState();
}

class _SideMenuState extends State<SideMenu> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);
    final colors = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    final items = <_MenuItem>[
      _MenuItem(
        icon: CupertinoIcons.circle_grid_3x3_fill,
        label: localizations.services,
      ),
      _MenuItem(
        icon: CupertinoIcons.square_list_fill,
        label: localizations.activity,
      ),
      _MenuItem(
        icon: CupertinoIcons.gift_fill,
        label: localizations.sendGift,
      ),
      _MenuItem(
        icon: CupertinoIcons.gear_alt_fill,
        label: localizations.settings,
      ),
      _MenuItem(
        icon: CupertinoIcons.envelope_fill,
        label: localizations.messages,
      ),
      _MenuItem(
        icon: CupertinoIcons.briefcase_fill,
        label: localizations.businessHub,
      ),
      _MenuItem(
        icon: CupertinoIcons.person_fill,
        label: localizations.manageAddressAccount,
      ),
      _MenuItem(
        icon: CupertinoIcons.globe,
        label: localizations.language,
        action: _MenuAction.language,
      ),
      _MenuItem(
        icon: CupertinoIcons.power,
        label: localizations.logOut,
        action: _MenuAction.signOut,
      ),
    ];

    return Scaffold(
      backgroundColor:
          colors.surfaceContainerLowest.withValues(alpha: 0),
      body: SafeArea(
        child: Align(
          alignment: AlignmentDirectional.topStart,
          child: SizedBox(
            width: widget.width,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      CircleAvatar(
                        backgroundColor:
                            colors.surfaceContainerHighest,
                        foregroundColor: colors.primary,
                        child: const Icon(Icons.person_outline),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment:
                              CrossAxisAlignment.start,
                          children: [
                            Text(
                              localizations.addressUser,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: colors.onSurface,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              localizations.manageAddressAccount,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: textTheme.bodyMedium?.copyWith(
                                color: colors.onSurfaceVariant,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 72),
                    ],
                  ),
                ),
                Expanded(
                  child: ListView.separated(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                    ),
                    itemCount: items.length,
                    separatorBuilder: (context, index) {
                      return Divider(
                        color: colors.outlineVariant.withValues(
                          alpha: 0.3,
                        ),
                        thickness: 1,
                        height: 8,
                        indent: 16,
                        endIndent: 16,
                      );
                    },
                    itemBuilder: (context, index) {
                      final item = items[index];
                      final isSelected = index == _selectedIndex;

                      return GestureDetector(
                        behavior: HitTestBehavior.opaque,
                        onTap: () async {
                          switch (item.action) {
                            case _MenuAction.language:
                              widget.onLanguageTap();
                              return;
                            case _MenuAction.signOut:
                              await widget.onSignOut();
                              return;
                            case _MenuAction.none:
                              setState(() {
                                _selectedIndex = index;
                              });

                              if (index != 0 && context.mounted) {
                                ScaffoldMessenger.of(context)
                                  ..hideCurrentSnackBar()
                                  ..showSnackBar(
                                    SnackBar(
                                      content: Text(
                                        localizations.comingSoon,
                                      ),
                                    ),
                                  );
                              }
                          }
                        },
                        child: Stack(
                          alignment:
                              AlignmentDirectional.centerStart,
                          children: [
                            AnimatedContainer(
                              duration:
                                  const Duration(milliseconds: 300),
                              curve: Curves.easeInOut,
                              width: isSelected
                                  ? widget.width - 32
                                  : 0,
                              height: 56,
                              decoration: BoxDecoration(
                                color: isSelected
                                    ? colors.primary
                                    : Colors.transparent,
                                borderRadius:
                                    BorderRadius.circular(12),
                              ),
                            ),
                            SizedBox(
                              height: 58,
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(
                                  horizontal: 16,
                                ),
                                child: Row(
                                  children: [
                                    Icon(
                                      item.icon,
                                      color: isSelected
                                          ? colors.onPrimary
                                          : colors.onSurfaceVariant,
                                      size: 28,
                                    ),
                                    const SizedBox(width: 16),
                                    Expanded(
                                      child: Text(
                                        item.label,
                                        maxLines: 1,
                                        overflow:
                                            TextOverflow.ellipsis,
                                        style:
                                            textTheme.bodyLarge?.copyWith(
                                          fontWeight: FontWeight.bold,
                                          color: isSelected
                                              ? colors.onPrimary
                                              : colors.onSurface,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
                Divider(
                  color: colors.outlineVariant.withValues(alpha: 0.5),
                  thickness: 0.5,
                  height: 0,
                  indent: 9,
                  endIndent: 124,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

enum _MenuAction {
  none,
  language,
  signOut,
}

class _MenuItem {
  const _MenuItem({
    required this.icon,
    required this.label,
    this.action = _MenuAction.none,
  });

  final IconData icon;
  final String label;
  final _MenuAction action;
}
