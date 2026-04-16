import 'dart:convert';
import 'package:http/http.dart' as http;

class AuthService {
  static const String baseUrl = 'http://127.0.0.1:8000';

  Future<bool> register({
    required String email,
    required String password,  // ← Contraseña en texto plano
    required String name,
    required String phone,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/register'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'email': email,
          'password': password,  // ← Se envía PLANA, el backend la hashea
          'full_name': name,
          'phone': phone,
        }),
      );

      print('=== REGISTRO ===');
      print('Status: ${response.statusCode}');
      print('Respuesta: ${response.body}');

      return response.statusCode == 200;
    } catch (e) {
      print('❌ Error: $e');
      return false;
    }
  }

  Future<bool> login({
    required String email,
    required String password,  // ← Contraseña en texto plano
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/login'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'email': email,
          'password': password,  // ← Se envía PLANA, el backend la verifica
        }),
      );

      print('=== LOGIN ===');
      print('Status: ${response.statusCode}');
      print('Respuesta: ${response.body}');

      return response.statusCode == 200;
    } catch (e) {
      print('❌ Error: $e');
      return false;
    }
  }

  Future<void> logout() async => null;
}