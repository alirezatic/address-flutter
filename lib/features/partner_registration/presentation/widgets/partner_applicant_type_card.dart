import 'package:flutter/material.dart';

import 'package:address/core/design_system/components/card/app_card.dart';

class PartnerApplicantTypeCard extends StatelessWidget {
  const PartnerApplicantTypeCard({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.isSelected,
    required this.onTap,
    super.key,
  });

  final String title;
  final String subtitle;
  final IconData icon;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Stack(
      children: <Widget>[
        AppCard(
          title: title,
          subtitle: subtitle,
          icon: icon,
          type: AppCardType.selectable,
          isSelected: isSelected,
          onTap: onTap,
        ),
        if (isSelected)
          PositionedDirectional(
            top: 0,
            bottom: 0,
            end: 18,
            child: IgnorePointer(
              child: Center(
                child: Container(
                  width: 28,
                  height: 28,
                  decoration: BoxDecoration(
                    color: colorScheme.primary,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.check_rounded,
                    color: colorScheme.onPrimary,
                    size: 19,
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }
}
