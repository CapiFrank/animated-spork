import 'package:cloud_firestore/cloud_firestore.dart';

class TimeValidator {
  static Duration? _serverTimeOffset;

  static Future<void> syncWithServer() async {
    final docRef =
        FirebaseFirestore.instance.collection('metadata').doc('server_time');
    await docRef.set(
        {'timestamp': FieldValue.serverTimestamp()}, SetOptions(merge: true));
    final snapshot = await docRef.get();
    final Timestamp serverTime = snapshot['timestamp'];
    final DateTime serverDateTime = serverTime.toDate();
    _serverTimeOffset = serverDateTime.difference(DateTime.now());
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
