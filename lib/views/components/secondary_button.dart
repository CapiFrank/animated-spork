import 'package:flutter/material.dart';
import 'package:project_cipher/utils/palette.dart';

class SecondaryButton extends StatelessWidget {
  const SecondaryButton(
      {super.key,
      required this.labelText,
      required this.onPressed,
      this.decoration,
      this.color});
  final String labelText;
  final Function() onPressed;
  final BoxDecoration? decoration;
  final Color? color;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        padding: EdgeInsets.all(15),
        margin: EdgeInsets.symmetric(horizontal: 0),
        decoration: decoration ??
            BoxDecoration(
              color: Colors.transparent,
              borderRadius: BorderRadius.zero,
              border: Border.all(
                color: Palette(context).onPrimary,
              ),
            ),
        child: Center(
          child: Text(
            labelText,
            style: TextStyle(
                color: color ?? Palette(context).onPrimary,
                fontWeight: FontWeight.bold,
                fontSize: 18),
          ),
        ),
      ),
    );
  }
}
