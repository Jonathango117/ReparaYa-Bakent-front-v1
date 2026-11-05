
import 'dart:convert';

import 'package:http/http.dart' as http;

class AuthService {
  static const String baseUrl = 'http://127.0.0.1:8000';
  static const Duration _timeout = Duration(seconds: 15);

  Future<bool> register({
    required String email,
    required String password,
    required String confirmPassword,
    required String name,
    required String phone,
    required String role,
  }) async {
    try {
      final response = await http
          .post(
            Uri.parse('$baseUrl/auth/register'),
            headers: {
              'Content-Type': 'application/json',
              'Accept': 'application/json',
            },
            body: jsonEncode({
              'full_name': name.trim(),
              'email': email.trim(),
              'phone': phone.trim(),
              'password': password,
              'confirm_password': confirmPassword,
              'role': role,
            }),
          )
          .timeout(_timeout);

      print('[REGISTRO] Estado HTTP: ${response.statusCode}');

      if (response.statusCode == 200 ||
          response.statusCode == 201) {
        return true;
      }

      print('[REGISTRO] Respuesta: ${response.body}');
      return false;
    } catch (e) {
      print('[REGISTRO] Error: $e');
      return false;
    }
  }

  Future<bool> login({
    required String email,
    required String password,
  }) async {
    try {
      final response = await http
          .post(
            Uri.parse('$baseUrl/login'),
            headers: {
              'Content-Type': 'application/json',
              'Accept': 'application/json',
            },
            body: jsonEncode({
              'email': email.trim(),
              'password': password,
            }),
          )
          .timeout(_timeout);

      print('[LOGIN] Estado HTTP: ${response.statusCode}');

      if (response.statusCode != 200) {
        print('[LOGIN] Respuesta: ${response.body}');
      }

      return response.statusCode == 200;
    } catch (e) {
      print('[LOGIN] Error: $e');
      return false;
    }
  }

  Future<void> logout() async {
    // No hay un endpoint de cierre de sesión configurado todavía.
  }
}
