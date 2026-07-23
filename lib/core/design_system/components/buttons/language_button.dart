import 'package:flutter/material.dart';

import 'package:address/core/design_system/tokens/app_design_tokens.dart';
import 'package:address/core/localization/app_locale_controller.dart';
import 'package:address/l10n/generated/app_localizations.dart';

enum LanguageButtonVariant { pill, menuItem }

class LanguageButton extends StatelessWidget {
  const LanguageButton({super.key}) : variant = LanguageButtonVariant.pill;

  const LanguageButton.menuItem({super.key})
    : variant = LanguageButtonVariant.menuItem;

  final LanguageButtonVariant variant;

  static const List<_LanguageOption> _languages = <_LanguageOption>[
    _LanguageOption(code: 'fa', name: 'فارسی', flag: '🇮🇷'),
    _LanguageOption(code: 'en', name: 'English', flag: '🇺🇸'),
    _LanguageOption(code: 'ar', name: 'العربية', flag: '🇸🇦'),
    _LanguageOption(code: 'zh', name: '中文', flag: '🇨🇳'),
  ];

  Future<void> _showLanguagePicker(BuildContext context) async {
    final theme = Theme.of(context);
    final localizations = AppLocalizations.of(context);
    final controller = AppLocaleController.instance;

    await showModalBottomSheet<void>(
      context: context,
      backgroundColor: theme.colorScheme.surface,
      showDragHandle: true,
      builder: (sheetContext) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(
              AppSpacingTokens.large,
              AppSpacingTokens.xSmall,
              AppSpacingTokens.large,
              AppSpacingTokens.large,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Text(
                  localizations.changeLanguage,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                    color: theme.colorScheme.onSurface,
                  ),
                ),
                const SizedBox(height: AppSpacingTokens.small),
                for (final language in _languages)
                  ListTile(
                    leading: Text(language.flag),
                    title: Text(language.name),
                    trailing: controller.locale.languageCode == language.code
                        ? Icon(
                            Icons.check_rounded,
                            color: theme.colorScheme.primary,
                          )
                        : null,
                    onTap: () async {
                      Navigator.of(sheetContext).pop();
                      await controller.changeLocale(language.code);
                    },
                  ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final controller = AppLocaleController.instance;

    return AnimatedBuilder(
      animation: controller,
      builder: (context, child) {
        final selected = _languages.firstWhere(
          (language) => language.code == controller.locale.languageCode,
          orElse: () => _languages.first,
        );

        return switch (variant) {
          LanguageButtonVariant.pill => _buildPill(context, selected),
          LanguageButtonVariant.menuItem => _buildMenuItem(context, selected),
        };
      },
    );
  }

  Widget _buildPill(BuildContext context, _LanguageOption selected) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    return Material(
      color: colors.primary.withValues(alpha: 0.30),
      borderRadius: BorderRadius.circular(AppRadiusTokens.pill),
      child: InkWell(
        onTap: () => _showLanguagePicker(context),
        borderRadius: BorderRadius.circular(AppRadiusTokens.pill),
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacingTokens.medium,
            vertical: AppSpacingTokens.small,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Icon(Icons.language_rounded, color: colors.onPrimary),
              const SizedBox(width: AppSpacingTokens.small),
              Text(
                selected.name,
                style: theme.textTheme.labelLarge?.copyWith(
                  color: colors.onPrimary,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(width: AppSpacingTokens.small),
              Icon(Icons.keyboard_arrow_down_rounded, color: colors.onPrimary),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMenuItem(BuildContext context, _LanguageOption selected) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;
    final localizations = AppLocalizations.of(context);

    return Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(AppRadiusTokens.small),
      child: InkWell(
        onTap: () => _showLanguagePicker(context),
        borderRadius: BorderRadius.circular(AppRadiusTokens.small),
        child: SizedBox(
          height: AppComponentTokens.menuItemHeight,
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacingTokens.large,
            ),
            child: Row(
              children: <Widget>[
                Icon(
                  Icons.language_rounded,
                  color: colors.onSurfaceVariant,
                  size: AppComponentTokens.menuIconSize,
                ),
                const SizedBox(width: AppSpacingTokens.large),
                Expanded(
                  child: Text(
                    localizations.language,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.bodyLarge?.copyWith(
                      color: colors.onSurface,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                Text(selected.flag, style: theme.textTheme.titleMedium),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _LanguageOption {
  const _LanguageOption({
    required this.code,
    required this.name,
    required this.flag,
  });

  final String code;
  final String name;
  final String flag;
}
