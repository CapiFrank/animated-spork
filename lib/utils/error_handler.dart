import 'package:flutter/material.dart';

import '../main.dart';

class ErrorHandler {
  static void handleError(dynamic error) {
    final message = _mapErrorToMessage(error);
    // Usamos el GlobalKey para acceder al ScaffoldMessenger y mostrar el SnackBar
    scaffoldMessengerKey.currentState?.showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
      ),
    );
  }

  static String _mapErrorToMessage(dynamic error) {
    final parts = error.toString().split(": ");
    return parts.length > 1 ? parts[1] : error.toString();
  }
}
