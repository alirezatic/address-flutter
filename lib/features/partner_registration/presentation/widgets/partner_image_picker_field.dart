import 'package:flutter/material.dart';

import 'package:address/core/design_system/components/card/app_card.dart';

class PartnerImagePickerField extends StatelessWidget {
  const PartnerImagePickerField({
    required this.title,
    required this.emptySubtitle,
    required this.selectedName,
    required this.onTap,
    this.errorText,
    super.key,
  });

  final String title;
  final String emptySubtitle;
  final String selectedName;
  final VoidCallback onTap;
  final String? errorText;

  bool get _hasImage => selectedName.trim().isNotEmpty;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        AppCard(
          title: title,
          subtitle: _hasImage ? selectedName : emptySubtitle,
          icon: _hasImage
              ? Icons.check_circle_rounded
              : Icons.add_photo_alternate_rounded,
          onTap: onTap,
        ),
        if (errorText != null) ...<Widget>[
          const SizedBox(height: 6),
          Padding(
            padding: const EdgeInsetsDirectional.only(start: 12),
            child: Text(
              errorText!,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: colorScheme.error,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ],
    );
  }
}
