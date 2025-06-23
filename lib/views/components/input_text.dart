import 'package:flutter/material.dart';
import 'package:project_cipher/utils/palette.dart';

class InputText extends StatelessWidget {
  const InputText(
      {super.key,
      required TextEditingController textEditingController,
      required this.validator,
      this.keyboardType = TextInputType.text,
      required this.labelText,
      this.obscureText = false})
      : _textEditingController = textEditingController;

  final TextEditingController _textEditingController;
  final String? Function(String?)? validator;
  final TextInputType? keyboardType;
  final String labelText;
  final bool obscureText;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: _textEditingController,
      keyboardType: keyboardType,
      obscureText: obscureText,
      decoration: InputDecoration(
          focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(0.0),
              borderSide: BorderSide(color: Palette(context).error)),
          errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(0.0),
              borderSide: BorderSide(color: Palette(context).errorContainer)),
          labelText: labelText,
          enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(0.0),
              borderSide: BorderSide(color: Palette(context).outlineVariant)),
          focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(0.0),
              borderSide: BorderSide(color: Palette(context).outline)),
          fillColor: Palette(context).onPrimary,
          filled: true),
      validator: validator,
    );
  }
}
