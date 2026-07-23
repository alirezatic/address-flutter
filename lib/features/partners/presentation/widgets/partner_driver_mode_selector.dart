import 'package:flutter/material.dart';

import 'package:address/core/design_system/tokens/app_design_tokens.dart';
import 'package:address/features/partners/domain/models/partner_category.dart';
import 'package:address/l10n/generated/app_localizations.dart';

class PartnerDriverModeSelector extends StatelessWidget {
  const PartnerDriverModeSelector({
    super.key,
    required this.value,
    required this.onChanged,
  });

  final PartnerDriverMode value;
  final ValueChanged<PartnerDriverMode> onChanged;

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);
    final colors = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.all(AppSpacingTokens.xSmall),
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(AppRadiusTokens.medium),
        border: Border.all(color: colors.outlineVariant),
      ),
      child: Row(
        children: <Widget>[
          _buildOption(
            context: context,
            mode: PartnerDriverMode.personal,
            icon: Icons.person_rounded,
            label: localizations.partnersDriverPersonal,
          ),
          const SizedBox(width: AppSpacingTokens.small),
          _buildOption(
            context: context,
            mode: PartnerDriverMode.company,
            icon: Icons.apartment_rounded,
            label: localizations.partnersDriverCompany,
          ),
        ],
      ),
    );
  }

  Widget _buildOption({
    required BuildContext context,
    required PartnerDriverMode mode,
    required IconData icon,
    required String label,
  }) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;
    final selected = value == mode;

    return Expanded(
      child: Material(
        color: selected ? colors.primary : Colors.transparent,
        borderRadius: BorderRadius.circular(AppRadiusTokens.small),
        child: InkWell(
          onTap: () => onChanged(mode),
          borderRadius: BorderRadius.circular(AppRadiusTokens.small),
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacingTokens.small,
              vertical: AppSpacingTokens.medium,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Icon(
                  icon,
                  color: selected ? colors.onPrimary : colors.onSurfaceVariant,
                ),
                const SizedBox(width: AppSpacingTokens.small),
                Flexible(
                  child: Text(
                    label,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.labelMedium?.copyWith(
                      color: selected
                          ? colors.onPrimary
                          : colors.onSurfaceVariant,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
