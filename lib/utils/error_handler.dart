import 'package:flutter/material.dart';

class ErrorHandler {
  static void handleError(BuildContext context, dynamic error) {
    final message = _mapErrorToMessage(error);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
          content: Text(message),
          backgroundColor: Theme.of(context).colorScheme.error),
    );
  }

  static String _mapErrorToMessage(dynamic error) {
    if (error.toString().contains('device')) return 'Dispositivo no encontrado';
    return 'Error desconocido';
  }
}
