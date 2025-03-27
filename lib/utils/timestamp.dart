import 'package:cloud_firestore/cloud_firestore.dart';

Timestamp setExpiresAt() {
  DateTime now = DateTime.now();
  DateTime nextMonth = DateTime(now.year, now.month + 1);

  DateTime lastDayOfNextMonth =
      DateTime(nextMonth.year, nextMonth.month + 1, 0, 23, 59, 59, 999);

  return Timestamp.fromDate(lastDayOfNextMonth);
}
