import 'package:dio/dio.dart';

class AuthRepository {
  final Dio _dio = Dio(BaseOptions(baseUrl: 'http://80.90.191.66'));

  /// Регистрация
  /// POST /account/register
  /// Тело: { "userName": "...", "password": "...", "role": "..." }
  Future<void> register(String userName, String password, String role) async {
    try {
      final response = await _dio.post(
        '/account/register',
        data: {
          "userName": userName,
          "password": password,
          "role": role,
        },
      );
      if (response.statusCode != 200) {
        throw Exception('Ошибка регистрации. Код: ${response.statusCode}');
      }
      // Если нужно, обработайте response.data (например, токен или сообщение).
    } on DioException catch (e) {
      throw Exception('Ошибка при регистрации: ${e.message}');
    }
  }

  /// Логин
  /// POST /account/login
  /// Тело: { "userName": "...", "password": "..." }
  Future<Map<String, dynamic>> login(String userName, String password) async {
    try {
      final response = await _dio.post(
        '/account/login',
        data: {
          "userName": userName,
          "password": password,
        },
      );

      if (response.statusCode != 200) {
        throw Exception('Ошибка логина. Код: ${response.statusCode}');
      }

      // Предположим, что сервер возвращает JSON: { "role": "seller" }
      return response.data;
    } on DioException catch (e) {
      throw Exception('Ошибка при логине: ${e.message}');
    }
  }

  /// Сброс пароля (если поддерживается)
  /// POST /account/forgotPassword
  /// Тело: { "email": "..." } — или что требует ваш сервер
  Future<void> forgotPassword(String email) async {
    try {
      final response = await _dio.post(
        '/account/forgotPassword',
        data: {"email": email},
      );
      if (response.statusCode != 200) {
        throw Exception('Сервер вернул код ${response.statusCode}');
      }
    } on DioException catch (e) {
      throw Exception(
          'Ошибка при запросе /account/forgotPassword: ${e.message}');
    }
  }
}
