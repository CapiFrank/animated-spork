import 'package:flutter/material.dart';
import 'package:project_cipher/views/payment_blocked_view.dart';

import '../models/device.dart';
import '../utils/auth_service.dart';
import '../views/device_view.dart';
import '../views/login_view.dart';

class AuthController extends ChangeNotifier {
  Device? _device;
  final AuthService _authService = AuthService();

  Device? get device => _device;

  bool get isAuthenticated => _device != null;

  Future<bool> login(String email, String password) async {
    await _authService.login(email, password);
    _device = _authService.currentDevice;
    notifyListeners();

    if (_device == null) return false;

    if (!_device!.active) {
      return false;
    }

    return true;
  }

  Future<void> logout(BuildContext context) async {
    await _authService.logout();
    _device = null;
    notifyListeners();

    // Mostrar la notificación de logout
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("Has cerrado sesión exitosamente."),
        duration: Duration(seconds: 2),
      ),
    );

    // Redirigir a la pantalla de login
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => LoginView()),
    );
  }

  Future<void> checkSession(BuildContext context) async {
    bool isValid = await _authService.checkSessionToken();
    if (isValid) {
      _device = _authService.currentDevice;
      notifyListeners();

      if (_device!.active) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => DeviceView()),
        );
      } else {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => PaymentBlockedView()),
        );
      }
    } else {
      _device = null;
      notifyListeners();
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => LoginView()),
      );
    }
  }
}
