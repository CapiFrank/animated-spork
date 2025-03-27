import 'package:flutter/material.dart';
import 'package:project_cipher/views/login_view.dart';

import 'components/numeric_keyboard.dart';

class MyScreen extends StatelessWidget {
  const MyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          LoginView(), // Contenido principal
          NumericKeyboard(
            onKeyPressed: (value) {
              print("Tecla presionada: $value");
            },
          ),
        ],
      ),
    );
  }
}
