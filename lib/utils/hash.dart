import 'dart:convert';
import 'package:crypto/crypto.dart' as crypto;
import 'package:bcrypt/bcrypt.dart';

class Hash {
  /// Genera un hash usando bcrypt (igual que Laravel)
  static String make(String value, {int rounds = 10}) {
    return BCrypt.hashpw(value, BCrypt.gensalt(logRounds: rounds));
  }

  /// Verifica si una contraseña coincide con un hash
  static bool check(String value, String hash) {
    return BCrypt.checkpw(value, hash);
  }

  /// Genera un hash SHA-256
  static String sha256(String value) {
    return crypto.sha256.convert(utf8.encode(value)).toString();
  }

  /// Genera un hash SHA-512
  static String sha512(String value) {
    return crypto.sha512.convert(utf8.encode(value)).toString();
  }

  /// Verifica si un hash bcrypt necesita ser actualizado
  static bool needsRehash(String hash, {int rounds = 10}) {
    return BCrypt.gensalt(logRounds: rounds) != hash.substring(0, 29);
  }
}
