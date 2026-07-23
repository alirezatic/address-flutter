import 'package:flutter/material.dart';

import 'package:address/core/design_system/tokens/app_design_tokens.dart';

class SideMenuItem extends StatelessWidget {
  const SideMenuItem({
    super.key,
    required this.icon,
    required this.label,
    required this.onTap,
    this.isSelected = false,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final bool isSelected;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    return Material(
      color: isSelected ? colors.primary : Colors.transparent,
      borderRadius: BorderRadius.circular(AppRadiusTokens.small),
      child: InkWell(
        onTap: onTap,
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
                  icon,
                  color: isSelected
                      ? colors.onPrimary
                      : colors.onSurfaceVariant,
                  size: AppComponentTokens.menuIconSize,
                ),
                const SizedBox(width: AppSpacingTokens.large),
                Expanded(
                  child: Text(
                    label,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.bodyLarge?.copyWith(
                      color: isSelected ? colors.onPrimary : colors.onSurface,
                      fontWeight: FontWeight.w700,
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
