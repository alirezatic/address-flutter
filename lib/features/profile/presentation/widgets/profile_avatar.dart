import 'dart:typed_data';

import 'package:flutter/material.dart';

class ProfileAvatar extends StatelessWidget {
  const ProfileAvatar({
    required this.size,
    required this.onTap,
    this.imageBytes,
    this.displayName = '',
    this.editable = true,
    super.key,
  });

  final double size;
  final VoidCallback? onTap;
  final Uint8List? imageBytes;
  final String displayName;
  final bool editable;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final initials = _initials(displayName);

    return Semantics(
      button: editable,
      child: InkWell(
        onTap: editable ? onTap : null,
        customBorder: const CircleBorder(),
        child: SizedBox(
          width: size + 12,
          height: size + 12,
          child: Stack(
            alignment: Alignment.center,
            children: <Widget>[
              Container(
                width: size,
                height: size,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: colors.primaryContainer,
                  border: Border.all(
                    color: colors.primary.withValues(alpha: 0.28),
                    width: 2,
                  ),
                  boxShadow: <BoxShadow>[
                    BoxShadow(
                      color: colors.shadow.withValues(alpha: 0.12),
                      blurRadius: 20,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                clipBehavior: Clip.antiAlias,
                child: imageBytes == null
                    ? Center(
                        child: initials.isEmpty
                            ? Icon(
                                Icons.person_rounded,
                                size: size * 0.48,
                                color: colors.onPrimaryContainer,
                              )
                            : Text(
                                initials,
                                style: Theme.of(context).textTheme.headlineSmall
                                    ?.copyWith(
                                      color: colors.onPrimaryContainer,
                                      fontWeight: FontWeight.w900,
                                    ),
                              ),
                      )
                    : Image.memory(
                        imageBytes!,
                        fit: BoxFit.cover,
                        gaplessPlayback: true,
                        errorBuilder: (context, error, stackTrace) {
                          return Icon(
                            Icons.person_rounded,
                            size: size * 0.48,
                            color: colors.onPrimaryContainer,
                          );
                        },
                      ),
              ),
              if (editable)
                PositionedDirectional(
                  end: 0,
                  bottom: 0,
                  child: Container(
                    width: 38,
                    height: 38,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: colors.primary,
                      border: Border.all(color: colors.surface, width: 3),
                    ),
                    child: Icon(
                      Icons.camera_alt_rounded,
                      color: colors.onPrimary,
                      size: 20,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  String _initials(String value) {
    final parts = value
        .trim()
        .split(RegExp(r'\s+'))
        .where((part) => part.isNotEmpty)
        .toList(growable: false);

    if (parts.isEmpty) {
      return '';
    }

    String firstCharacter(String part) {
      return String.fromCharCode(part.runes.first);
    }

    if (parts.length == 1) {
      return firstCharacter(parts.first).toUpperCase();
    }

    return '${firstCharacter(parts.first)}${firstCharacter(parts.last)}'
        .toUpperCase();
  }
}
