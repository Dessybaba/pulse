class ApiConstants {
  ApiConstants._();

  static const String baseUrl =
      'https://pebblescore-api.dev.pebblescore.com/api/desmond/expenses';

  static const Duration connectTimeout = Duration(seconds: 10);
  static const Duration receiveTimeout = Duration(seconds: 10);
}
