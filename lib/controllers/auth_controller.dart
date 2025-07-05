import 'package:flutter/material.dart';
import 'package:project_cipher/models/company.dart';
import 'package:project_cipher/utils/model.dart';
import '../models/device.dart';
import '../utils/auth_service.dart';

class AuthController extends ChangeNotifier {
  Device? _device;
  Company? _company;
  final AuthService _authService = AuthService();

  bool _isLoading = true;
  bool get isLoading => _isLoading;

  Device? get device => _device;
  Company? get company => _company;
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

  Future<void> loadCompany() async {
    if (_company != null) return; // Ya cargada

    final companyId = _device?.companyId;
    if (companyId == null) throw Exception("No hay empresa activa.");

    final company = await Model.find<Company>(
      collectionName: 'companies',
      id: companyId,
      fromJson: Company.fromDoc,
    );

    _company = company;
    notifyListeners();
  }

  Future<void> logout() async {
    _isLoading = true;
    notifyListeners();

    await _authService.logout();
    _device = null;
    _company = null;

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
