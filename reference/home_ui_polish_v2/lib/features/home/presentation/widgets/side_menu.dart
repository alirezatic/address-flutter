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
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    final isDesktopMenu = widget.width >= 340;
    final itemHeight = isDesktopMenu ? 60.0 : 54.0;
    final itemFontSize = isDesktopMenu ? 18.0 : 16.0;
    final headerTitleSize = isDesktopMenu ? 20.0 : 17.0;

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

    return Material(
      color: colorScheme.surface,
      child: SafeArea(
        child: SizedBox(
          width: widget.width,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Padding(
                padding: EdgeInsets.fromLTRB(
                  isDesktopMenu ? 22 : 18,
                  24,
                  isDesktopMenu ? 22 : 18,
                  20,
                ),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: isDesktopMenu ? 29 : 25,
                      backgroundColor: colorScheme.primaryContainer,
                      foregroundColor: colorScheme.onPrimaryContainer,
                      child: Icon(
                        Icons.person_outline_rounded,
                        size: isDesktopMenu ? 31 : 28,
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            localizations.addressUser,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: textTheme.titleMedium?.copyWith(
                              color: colorScheme.onSurface,
                              fontSize: headerTitleSize,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            localizations.manageAddressAccount,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: textTheme.bodySmall?.copyWith(
                              color: colorScheme.onSurfaceVariant,
                              fontSize: isDesktopMenu ? 14 : 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Divider(
                height: 1,
                color: colorScheme.outlineVariant.withValues(alpha: 0.6),
              ),
              Expanded(
                child: ListView.separated(
                  padding: const EdgeInsets.fromLTRB(14, 14, 14, 20),
                  itemCount: items.length,
                  separatorBuilder: (context, index) {
                    return const SizedBox(height: 5);
                  },
                  itemBuilder: (context, index) {
                    final item = items[index];
                    final selected = index == _selectedIndex;
                    final isSignOut = item.action == _MenuAction.signOut;

                    final foreground = isSignOut
                        ? colorScheme.error
                        : selected
                            ? colorScheme.onPrimary
                            : colorScheme.onSurfaceVariant;

                    final background = selected && !isSignOut
                        ? colorScheme.primary
                        : isSignOut
                            ? colorScheme.errorContainer.withValues(alpha: 0.45)
                            : Colors.transparent;

                    return Material(
                      color: Colors.transparent,
                      child: InkWell(
                        borderRadius: BorderRadius.circular(14),
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
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 220),
                          curve: Curves.easeOutCubic,
                          height: itemHeight,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                          ),
                          decoration: BoxDecoration(
                            color: background,
                            borderRadius: BorderRadius.circular(14),
                          ),
                          child: Row(
                            children: [
                              Icon(
                                item.icon,
                                color: foreground,
                                size: isDesktopMenu ? 27 : 25,
                              ),
                              const SizedBox(width: 15),
                              Expanded(
                                child: Text(
                                  item.label,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: textTheme.bodyLarge?.copyWith(
                                    color: foreground,
                                    fontSize: itemFontSize,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
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
