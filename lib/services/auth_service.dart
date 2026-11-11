
import 'dart:convert';

import 'package:http/http.dart' as http;

class AuthService {
  static const String baseUrl = 'http://127.0.0.1:8000';
  static const Duration _timeout = Duration(seconds: 15);

  // ==========================================
  // REGISTRO DE USUARIOS
  // ==========================================

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
        print('[REGISTRO] Usuario registrado correctamente');
        return true;
      }

      print('[REGISTRO] Respuesta: ${response.body}');
      return false;
    } catch (e) {
      print('[REGISTRO] Error: $e');
      return false;
    }
  }

  // ==========================================
  // INICIO DE SESIÓN
  // ==========================================

  Future<bool> login({
    required String email,
    required String password,
  }) async {
    try {
      final response = await http
          .post(
            Uri.parse('$baseUrl/auth/login'),
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

      if (response.statusCode == 200) {
        final Map<String, dynamic> data =
            jsonDecode(response.body);

        // Obtener información del usuario
        final user = data['user'];

        print('[LOGIN] Inicio de sesión exitoso');
        print('[LOGIN] Usuario: ${user['full_name']}');
        print('[LOGIN] Rol: ${user['role']}');

        // Obtener JWT
        final String token = data['access_token'];

        print('[LOGIN] Token recibido correctamente');

        // TODO: Guardar token de forma segura
        return token.isNotEmpty;
      }

      print('[LOGIN] Respuesta: ${response.body}');
      return false;
    } catch (e) {
      print('[LOGIN] Error: $e');
      return false;
    }
  }

  // ==========================================
  // CIERRE DE SESIÓN
  // ==========================================

  Future<void> logout() async {
    // Próximamente eliminaremos el token
    // cuando implementemos almacenamiento seguro.
    print('[LOGOUT] Sesión cerrada localmente');
  }
}
