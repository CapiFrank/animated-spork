import 'package:flutter/material.dart';
import 'package:project_cipher/views/components/numeric_keyboard.dart';
import 'package:project_cipher/views/layouts/base_layout.dart';

class KeyboardContainer extends StatelessWidget {
  const KeyboardContainer({super.key, required this.child});
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return BaseLayout(  // Envuelve todo dentro de un SingleChildScrollView
          child: Row(
            children: [
              Expanded(child: child),
              NumericKeyboard(
                onKeyPressed: (String value) {
                  debugPrint('Valor ingresado: $value');
                },
              ),
            ],
          ),
    );
  }
}
