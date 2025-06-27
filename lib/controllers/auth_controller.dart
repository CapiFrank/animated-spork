import 'package:flutter/material.dart';
import '../models/device.dart';
import '../utils/auth_service.dart';

class AuthController extends ChangeNotifier {
  Device? _device;
  final AuthService _authService = AuthService();

  bool _isLoading = true;
  bool get isLoading => _isLoading;

  Device? get device => _device;
  bool get isAuthenticated => _device != null;
  bool get isDeviceActive => _device?.active ?? false;

  Future<void> login(String email, String password) async {
    _isLoading = true;
    notifyListeners();

    await _authService.login(email, password);
    _device = _authService.currentDevice;

    _isLoading = false;
    notifyListeners();
  }

  Future<void> logout() async {
    _isLoading = true;
    notifyListeners();

    await _authService.logout();
    _device = null;

    _isLoading = false;
    notifyListeners();
  }

  Future<void> checkSession() async {
    _isLoading = true;
    notifyListeners();

    bool isValid = await _authService.checkSessionToken();
    if (isValid) {
      _device = _authService.currentDevice;
    } else {
      _device = null;
    }

    _isLoading = false;
    notifyListeners();
  }
}
