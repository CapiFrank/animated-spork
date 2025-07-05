import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:project_cipher/utils/palette.dart';

class InputText extends StatelessWidget {
  const InputText(
      {super.key,
      required TextEditingController textEditingController,
      required this.validator,
      this.keyboardType = TextInputType.text,
      required this.labelText,
      this.decoration,
      this.style,
      this.inputFormatters = const [],
      this.textInputAction = TextInputAction.done,
      this.obscureText = false,
      this.onFieldSubmitted,
      this.cursorColor})
      : _textEditingController = textEditingController;

  final TextEditingController _textEditingController;
  final String? Function(String?)? validator;
  final TextInputType? keyboardType;
  final String labelText;
  final bool obscureText;
  final InputDecoration? decoration;
  final TextStyle? style;
  final List<TextInputFormatter>? inputFormatters;
  final Color? cursorColor;
  final TextInputAction textInputAction;
  final Function(String)? onFieldSubmitted;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      textInputAction: textInputAction,
      inputFormatters: inputFormatters,
      onFieldSubmitted: onFieldSubmitted,
      style: style,
      controller: _textEditingController,
      keyboardType: keyboardType,
      obscureText: obscureText,
      cursorColor: cursorColor,
      decoration: decoration?.copyWith(labelText: labelText) ??
          defaultDecoration(context, labelText),
      validator: validator,
    );
  }
}

InputDecoration defaultDecoration(BuildContext context, String labelText) {
  return InputDecoration(
    labelText: labelText,
    filled: true,
    fillColor: Palette(context).onPrimary,
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(0.0),
      borderSide: BorderSide(color: Palette(context).outlineVariant),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(0.0),
      borderSide: BorderSide(color: Palette(context).outline),
    ),
    errorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(0.0),
      borderSide: BorderSide(color: Palette(context).errorContainer),
    ),
    focusedErrorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(0.0),
      borderSide: BorderSide(color: Palette(context).error),
    ),
  );
}
