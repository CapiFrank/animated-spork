class CircuitBreaker {
  static Future<T> retry<T>(Future<T> Function() action,
      {int retries = 3,
      Duration delay = const Duration(milliseconds: 500)}) async {
    int attempt = 0;
    while (attempt < retries) {
      try {
        return await action();
      } catch (e) {
        attempt++;
        if (attempt == retries) rethrow;
      }
      await Future.delayed(delay);
    }
    throw Exception('Max retries reached');
  }
}
