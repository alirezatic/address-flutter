import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';

import 'package:address/app/route_paths.dart';
import 'package:address/core/design_system/components/buttons/animated_start_button.dart';
import 'package:address/core/design_system/components/layout/app_page_scaffold.dart';
import 'package:address/core/design_system/tokens/app_design_tokens.dart';
import 'package:address/features/partner_registration/data/models/partner_application.dart';
import 'package:address/features/partner_registration/presentation/localization/partner_application_localizations.dart';
import 'package:address/l10n/generated/app_localizations.dart';

class PartnerApplicationSuccessArgs {
  const PartnerApplicationSuccessArgs({
    required this.application,
    required this.idempotent,
  });

  final PartnerApplicationSummary application;
  final bool idempotent;
}

class PartnerApplicationSuccessScreen extends StatelessWidget {
  const PartnerApplicationSuccessScreen({required this.args, super.key});

  final PartnerApplicationSuccessArgs args;

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);
    final application = args.application;

    return AppPageScaffold(
      navigationIcon: Icons.home_rounded,
      navigationLabel: localizations.home,
      onNavigationPressed: () => context.go(AppRoutePaths.home),
      bottomNavigationBar: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(
            AppLayoutTokens.screenHorizontalPadding,
            AppSpacingTokens.small,
            AppLayoutTokens.screenHorizontalPadding,
            AppSpacingTokens.medium,
          ),
          child: Center(
            child: AnimatedStartButton(
              title: localizations.partnerApplicationViewMyApplications,
              onTap: () {
                context.go(AppRoutePaths.partnerApplications);
              },
            ),
          ),
        ),
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(
            maxWidth: AppLayoutTokens.contentMaxWidth,
          ),
          child: ListView(
            shrinkWrap: true,
            padding: const EdgeInsets.all(
              AppLayoutTokens.screenHorizontalPadding,
            ),
            children: <Widget>[
              Icon(
                Icons.task_alt_rounded,
                color: Theme.of(context).colorScheme.primary,
                size: 84,
              ),
              const SizedBox(height: AppSpacingTokens.large),
              Text(
                localizations.partnerApplicationSuccessTitle,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.w900,
                ),
              ),
              const SizedBox(height: AppSpacingTokens.small),
              Text(
                args.idempotent
                    ? localizations.partnerApplicationAlreadySubmittedMessage
                    : localizations.partnerApplicationSuccessMessage,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                  height: 1.6,
                ),
              ),
              const SizedBox(height: AppSpacingTokens.xLarge),
              Card(
                margin: EdgeInsets.zero,
                child: Padding(
                  padding: const EdgeInsets.all(AppSpacingTokens.large),
                  child: Column(
                    children: <Widget>[
                      Text(
                        localizations.partnerApplicationTrackingCode,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
                      ),
                      const SizedBox(height: AppSpacingTokens.small),
                      Directionality(
                        textDirection: TextDirection.ltr,
                        child: SelectableText(
                          application.trackingCode,
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.titleLarge
                              ?.copyWith(
                                fontWeight: FontWeight.w900,
                                letterSpacing: 0.8,
                              ),
                        ),
                      ),
                      const SizedBox(height: AppSpacingTokens.small),
                      TextButton.icon(
                        onPressed: () {
                          Clipboard.setData(
                            ClipboardData(text: application.trackingCode),
                          );
                          ScaffoldMessenger.of(context)
                            ..hideCurrentSnackBar()
                            ..showSnackBar(
                              SnackBar(
                                content: Text(
                                  localizations
                                      .partnerApplicationTrackingCodeCopied,
                                ),
                              ),
                            );
                        },
                        icon: const Icon(Icons.copy_rounded),
                        label: Text(
                          localizations.partnerApplicationCopyTrackingCode,
                        ),
                      ),
                      const Divider(height: AppSpacingTokens.large),
                      Text(
                        application.status.title(localizations),
                        style: Theme.of(context).textTheme.titleMedium
                            ?.copyWith(
                              color: Theme.of(context).colorScheme.primary,
                              fontWeight: FontWeight.w900,
                            ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: AppSpacingTokens.xxLarge),
            ],
          ),
        ),
      ),
    );
  }
}
