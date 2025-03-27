import 'package:flutter/material.dart';

import '../models/device.dart';
import '../utils/auth_service.dart';
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
    return _device != null;
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

  Future<bool> checkSession() async {
    bool isValid = await _authService.checkSessionToken();
    if (isValid) {
      _device = _authService.currentDevice;
      notifyListeners();
    }
    return isValid;
  }
}
