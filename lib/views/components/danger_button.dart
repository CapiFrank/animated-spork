import 'package:flutter/material.dart';
import 'package:project_cipher/utils/palette.dart';

class DangerButton extends StatelessWidget {
  const DangerButton(
      {super.key, required this.labelText, required this.onPressed});
  final String labelText;
  final Function() onPressed;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        padding: EdgeInsets.all(15),
        margin: EdgeInsets.symmetric(horizontal: 45),
        decoration: BoxDecoration(
            color: Palette(context).error,
            borderRadius: BorderRadius.circular(8)),
        child: Center(
          child: Text(
            labelText,
            style: TextStyle(
                color: Palette(context).onError,
                fontWeight: FontWeight.bold,
                fontSize: 18),
          ),
        ),
      ),
    );
  }
}
