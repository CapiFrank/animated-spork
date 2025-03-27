import 'package:flutter/material.dart';

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
              borderSide:
                  BorderSide(color: Theme.of(context).colorScheme.error)),
          errorBorder: OutlineInputBorder(
              borderSide: BorderSide(
                  color: Theme.of(context).colorScheme.errorContainer)),
          labelText: labelText,
          enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(
                  color: Theme.of(context).colorScheme.outlineVariant)),
          focusedBorder: OutlineInputBorder(
              borderSide:
                  BorderSide(color: Theme.of(context).colorScheme.outline)),
          fillColor: Theme.of(context).colorScheme.onPrimary,
          filled: true),
      validator: validator,
    );
  }
}
