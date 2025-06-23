import 'package:flutter/material.dart';

import '../models/device.dart';
import '../utils/auth_service.dart';

class AuthController extends ChangeNotifier {
  Device? _device;
  final AuthService _authService = AuthService();

  Device? get device => _device;

  bool get isAuthenticated => _device != null;
  bool get isDeviceActive => _device?.active ?? false;

  Future<void> login(String email, String password) async {
    await _authService.login(email, password);
    _device = _authService.currentDevice;
    notifyListeners();
  }

  Future<void> logout() async {
    await _authService.logout();
    _device = null;
    notifyListeners();
  }

  Future<void> checkSession() async {
    
    bool isValid = await _authService.checkSessionToken();
    if (isValid) {
      _device = _authService.currentDevice;
    } else {
      _device = null;
    }
    notifyListeners();
  }
}
