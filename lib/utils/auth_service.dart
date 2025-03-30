import 'package:project_cipher/utils/hash.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:project_cipher/utils/secure_storage.dart';
import 'package:project_cipher/utils/time_sync.dart';

import '../models/device.dart';
import 'model.dart';

class AuthService {
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

      String? localToken = await SecureStorage.getToken();

      if (localToken == null || localToken != device.token) {
        String newToken = await Hash.secureToken(device.id!);
        device.token = newToken;

        await device.save();

        await SecureStorage.saveToken(newToken);
      }
      currentDevice = device;
    } catch (e) {
      print("❌ Error al iniciar sesión: $e");
    }
  }

  Future<void> logout() async {
    await SecureStorage.deleteToken();
    currentDevice?.token = '';
    await currentDevice?.save();
    currentDevice = null;
  }

  Future<bool> checkSessionToken() async {
    try {
      String? token = await SecureStorage.getToken();
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
    await TimeValidator.syncWithServer();
    if (TimeValidator.isExpired(device.expiresAt!)) {
      device.active = false;
      await device.save();
      throw Exception("Licencia expirada, dispositivo desactivado.");
    }
  }
}
