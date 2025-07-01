import 'package:flutter/material.dart';
import 'package:project_cipher/utils/palette.dart';

class PrimaryButton extends StatelessWidget {
  const PrimaryButton(
      {super.key, required this.labelText, required this.onPressed});
  final String labelText;
  final Function() onPressed;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        padding: EdgeInsets.all(15),
        margin: EdgeInsets.symmetric(horizontal: 0),
        decoration: BoxDecoration(
            color: Palette(context).primary,
            borderRadius: BorderRadius.circular(0),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.5),
                blurRadius: 5.0,
                offset: Offset(0, 2), // changes position of shadow
              ),
            ]),
        child: Center(
          child: Text(
            labelText,
            style: TextStyle(
                color: Palette(context).onPrimary,
                fontWeight: FontWeight.bold,
                fontSize: 18),
          ),
        ),
      ),
    );
  }
}
