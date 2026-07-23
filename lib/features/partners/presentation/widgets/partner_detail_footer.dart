import 'package:flutter/material.dart';

import 'package:address/core/design_system/tokens/app_design_tokens.dart';
import 'package:address/l10n/generated/app_localizations.dart';

class PartnerDetailFooter extends StatelessWidget {
  const PartnerDetailFooter({
    super.key,
    required this.canSubmit,
    required this.selectionCount,
    required this.onSubmit,
  });

  final bool canSubmit;
  final int selectionCount;
  final VoidCallback onSubmit;

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    if (!canSubmit) {
      return const SizedBox.shrink();
    }

    return SafeArea(
      top: false,
      child: Container(
        padding: const EdgeInsets.fromLTRB(
          AppLayoutTokens.screenHorizontalPadding,
          AppSpacingTokens.medium,
          AppLayoutTokens.screenHorizontalPadding,
          AppSpacingTokens.medium,
        ),
        decoration: BoxDecoration(
          color: colors.surface,
          border: Border(top: BorderSide(color: colors.outlineVariant)),
        ),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(
              maxWidth: AppLayoutTokens.contentMaxWidth,
            ),
            child: FilledButton.icon(
              onPressed: canSubmit ? onSubmit : null,
              icon: const Icon(Icons.check_rounded),
              label: Text(
                canSubmit
                    ? localizations.partnersSelectionCount(selectionCount)
                    : localizations.partnersNothingSelected,
              ),
              style: FilledButton.styleFrom(
                minimumSize: const Size.fromHeight(
                  AppComponentTokens.primaryActionHeight,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppRadiusTokens.pill),
                ),
                textStyle: theme.textTheme.labelLarge?.copyWith(
                  fontWeight: FontWeight.w900,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
