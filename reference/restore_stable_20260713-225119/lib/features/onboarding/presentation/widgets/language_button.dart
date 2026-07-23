import 'package:flutter/material.dart';

import 'package:address/core/localization/app_locale_controller.dart';

class LanguageButton extends StatelessWidget {
  const LanguageButton({super.key});

  static const List<_LanguageOption> _languages = [
    _LanguageOption(code: 'en', name: 'English', flag: '🇺🇸'),
    _LanguageOption(code: 'fa', name: 'فارسی', flag: '🇮🇷'),
    _LanguageOption(code: 'ar', name: 'العربية', flag: '🇸🇦'),
    _LanguageOption(code: 'zh', name: '中文', flag: '🇨🇳'),
  ];

  Future<void> _showLanguagePicker(BuildContext context) async {
    final theme = Theme.of(context);
    final controller = AppLocaleController.instance;

    await showModalBottomSheet<void>(
      context: context,
      backgroundColor: theme.colorScheme.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'انتخاب زبان',
                  style: theme.textTheme.titleMedium?.copyWith(
                    color: theme.colorScheme.onSurface,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const Divider(),
                for (final language in _languages)
                  ListTile(
                    leading: Text(
                      language.flag,
                      style: const TextStyle(fontSize: 24),
                    ),
                    title: Text(language.name),
                    trailing: controller.locale.languageCode == language.code
                        ? Icon(
                            Icons.check_rounded,
                            color: theme.colorScheme.primary,
                          )
                        : null,
                    onTap: () async {
                      Navigator.of(context).pop();
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
    final theme = Theme.of(context);
    final controller = AppLocaleController.instance;

    return AnimatedBuilder(
      animation: controller,
      builder: (context, child) {
        final selected = _languages.firstWhere(
          (language) => language.code == controller.locale.languageCode,
          orElse: () => _languages[1],
        );

        return Material(
          color: theme.primaryColor.withValues(alpha: 0.3),
          borderRadius: BorderRadius.circular(22),
          child: InkWell(
            onTap: () => _showLanguagePicker(context),
            borderRadius: BorderRadius.circular(22),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.language, color: Colors.white),
                  const SizedBox(width: 8),
                  Text(
                    selected.name,
                    style: theme.textTheme.labelLarge?.copyWith(
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(width: 8),
                  const Icon(Icons.keyboard_arrow_down, color: Colors.white),
                ],
              ),
            ),
          ),
        );
      },
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
