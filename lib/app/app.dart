import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'package:address/app/router.dart';
import 'package:address/core/localization/app_locale_controller.dart';
import 'package:address/design_system/theme/app_theme.dart';
import 'package:address/l10n/generated/app_localizations.dart';

ThemeData _applyGlobalTypography(ThemeData theme) {
  return theme.copyWith(
    textTheme: theme.textTheme.apply(fontFamily: 'Vazirmatn'),
    primaryTextTheme: theme.primaryTextTheme.apply(fontFamily: 'Vazirmatn'),
  );
}

class AddressApp extends StatelessWidget {
  const AddressApp({super.key});

  @override
  Widget build(BuildContext context) {
    final localeController = AppLocaleController.instance;

    return AnimatedBuilder(
      animation: localeController,
      builder: (context, child) {
        final languageCode = localeController.locale.languageCode;
        final isRtl = const {'fa', 'ar'}.contains(languageCode);

        return MaterialApp.router(
          debugShowCheckedModeBanner: false,
          title: 'آدرس',
          locale: localeController.locale,
          supportedLocales: AppLocalizations.supportedLocales,
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          theme: _applyGlobalTypography(AppTheme.light),
          darkTheme: _applyGlobalTypography(AppTheme.dark),
          themeMode: ThemeMode.system,
          routerConfig: AppRouter.router,
          builder: (context, child) {
            return Directionality(
              textDirection: isRtl ? TextDirection.rtl : TextDirection.ltr,
              child: MediaQuery.withClampedTextScaling(
                minScaleFactor: 1.12,
                maxScaleFactor: 1.40,
                child: child ?? const SizedBox.shrink(),
              ),
            );
          },
        );
      },
    );
  }
}
