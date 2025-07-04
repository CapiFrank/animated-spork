import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorage {
  static final FlutterSecureStorage _storage = FlutterSecureStorage();

  static Future<void> saveToken(String token) async {
    await _storage.write(key: 'session_token', value: token);
  }

  static Future<String?> getToken() async {
    return await _storage.read(key: 'session_token');
  }

  static Future<void> deleteToken() async {
    await _storage.delete(key: 'session_token');
  }
}
