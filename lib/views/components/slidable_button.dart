import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class SlidableButton extends StatelessWidget {
  final VoidCallback onPressed;
  final IconData icon;
  final String label;
  final Color color;
  final Color textColor;
  final Color iconColor;

  const SlidableButton({
    super.key,
    required this.onPressed,
    required this.icon,
    required this.label,
    this.color = Colors.green,
    this.textColor = Colors.white,
    this.iconColor = Colors.white,
  });

  @override
  Widget build(BuildContext context) {
    return CustomSlidableAction(
      flex: 1,
      backgroundColor: Colors.transparent,
      padding: const EdgeInsets.all(0),
      onPressed: (_) => onPressed(),
      child: Container(
        width: MediaQuery.of(context).size.width,
        margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 4),
        decoration: BoxDecoration(
          color: color,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withAlpha(70),
              blurRadius: 1.5,
              offset: const Offset(1, 2),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 28, color: iconColor),
            const SizedBox(height: 4),
            Text(label, style: TextStyle(color: textColor)),
          ],
        ),
      ),
    );
  }
}
