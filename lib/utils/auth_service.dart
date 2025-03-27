import 'package:project_cipher/utils/hash.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../models/device.dart';
import 'model.dart';

class AuthService {
  final FlutterSecureStorage _storage = FlutterSecureStorage();
  Device? currentDevice;

  Future<void> login(String email, String password) async {
    try {
      var devices = await Model.where<Device>(
          collectionName: 'devices',
          field: 'email',
          value: email,
          fromJson: Device.fromDoc);
      if (devices.isEmpty) {
        throw Exception("Correo no encontrado.");
      }
      var foundDevices =
          devices.where((device) => Hash.check(password, device.password));
      if (foundDevices.isEmpty) {
        throw Exception("Contraseña incorrecta.");
      } else if (foundDevices.length > 1) {
        throw Exception(
            "Error: Más de un dispositivo con las mismas credenciales.");
      }
      Device device = foundDevices.first;

      await checkAndUpdateExpiration(device);

      if (!device.active) {
        throw Exception("Dispositivo bloqueado por falta de pago.");
      }

      String? localToken = await _storage.read(key: 'session_token');

      if (localToken == null || localToken != device.token) {
        String newToken = Hash.token();
        device.token = newToken;

        await device.save();

        await _storage.write(key: 'session_token', value: newToken);
      }
      currentDevice = device;
    } catch (e) {
      print("❌ Error al iniciar sesión: $e");
    }
  }

  Future<void> logout() async {
    await _storage.delete(key: 'session_token');
    currentDevice?.token = '';
    await currentDevice?.save();
    currentDevice = null;
  }

  Future<bool> checkSessionToken() async {
    try {
      String? token = await _storage.read(key: 'session_token');
      if (token == null) return false;
      var devices = await Model.where<Device>(
          collectionName: 'devices',
          field: 'token',
          value: token,
          fromJson: Device.fromDoc);
      if (devices.isEmpty) return false;
      Device device = devices.first;
      await checkAndUpdateExpiration(device);
      if (!device.active) return false;
      currentDevice = device;
      return true;
    } catch (e) {
      print("❌ Error al iniciar sesión: $e");
      return false;
    }
  }

  Future<void> checkAndUpdateExpiration(Device device) async {
    if (device.expiresAt!.toDate().isBefore(DateTime.now())) {
      device.active = false;
      await device.save();
      throw Exception("Licencia expirada, dispositivo desactivado.");
    }
  }
}
