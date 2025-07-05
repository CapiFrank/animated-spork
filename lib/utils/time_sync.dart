import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:project_cipher/utils/error_handler.dart';

class TimeValidator {
  static Duration? _serverTimeOffset;

  static Future<bool> hasInternetConnection() async {
    final results = await Connectivity().checkConnectivity();
    return !results.contains(ConnectivityResult.none);
  }

  static Future<void> syncWithServer() async {
    final docRef =
        FirebaseFirestore.instance.collection('metadata').doc('server_time');

    final useCache = !(await hasInternetConnection());
    final options = useCache
        ? const GetOptions(source: Source.cache)
        : const GetOptions(source: Source.serverAndCache);

    // Intenta actualizar el timestamp si hay conexión
    if (!useCache) {
      try {
        await docRef.set(
          {'timestamp': FieldValue.serverTimestamp()},
          SetOptions(merge: true),
        );
      } catch (_) {
        // Ignorar errores de red al hacer set
      }
    }

    try {
      final snapshot = await docRef.get(options);
      final Timestamp serverTime = snapshot['timestamp'];
      final DateTime serverDateTime = serverTime.toDate();
      _serverTimeOffset = serverDateTime.difference(DateTime.now());
    } catch (e) {
      ErrorHandler.handleError('Error al obtener el tiempo del servidor o caché: $e');
      _serverTimeOffset = null;
    }
  }

  static bool isExpired(Timestamp expiresAt) {
    if (_serverTimeOffset == null) return true;
    final adjustedTime = DateTime.now().add(_serverTimeOffset!);
    return expiresAt.toDate().isBefore(adjustedTime);
  }

  static Timestamp setExpiresAt() {
    DateTime now = DateTime.now();
    DateTime nextMonth = DateTime(now.year, now.month + 1);

    DateTime lastDayOfNextMonth =
        DateTime(nextMonth.year, nextMonth.month + 1, 0, 23, 59, 59, 999);

    return Timestamp.fromDate(lastDayOfNextMonth);
  }
}
