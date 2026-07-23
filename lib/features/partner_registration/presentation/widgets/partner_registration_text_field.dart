import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class PartnerRegistrationTextField extends StatelessWidget {
  const PartnerRegistrationTextField({
    required this.controller,
    required this.label,
    this.keyboardType,
    this.textInputAction,
    this.validator,
    this.autofillHints,
    this.inputFormatters,
    this.maxLines = 1,
    this.minLines,
    this.maxLength,
    this.hintText,
    super.key,
  });

  final TextEditingController controller;
  final String label;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final String? Function(String?)? validator;
  final Iterable<String>? autofillHints;
  final List<TextInputFormatter>? inputFormatters;
  final int maxLines;
  final int? minLines;
  final int? maxLength;
  final String? hintText;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      keyboardType:
          keyboardType ??
          (maxLines > 1 ? TextInputType.multiline : TextInputType.text),
      textInputAction: textInputAction,
      validator: validator,
      autofillHints: autofillHints,
      inputFormatters: inputFormatters,
      maxLines: maxLines,
      minLines: minLines,
      maxLength: maxLength,
      textAlign: TextAlign.start,
      textDirection: Directionality.of(context),
      textCapitalization: TextCapitalization.sentences,
      enableSuggestions: true,
      autocorrect: true,
      decoration: InputDecoration(
        labelText: label,
        hintText: hintText,
        alignLabelWithHint: maxLines > 1,
      ),
    );
  }
}
