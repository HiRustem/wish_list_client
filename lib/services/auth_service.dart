import 'dart:convert';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:wish_list_client/utils/shared_prefs.dart';
import 'package:http/http.dart' as http;

class AuthService {
  final String baseUrl = dotenv.get('BASE_URL');

  Future<Map<String, dynamic>> login(String email, String password) async {
    final response = await http.post(
      Uri.parse('$baseUrl/auth/login'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email, 'password': password}),
    );

    if (response.statusCode == 201) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to login');
    }
  }

  Future<Map<String, dynamic>> register(
    String email,
    String password,
    String? nickname,
  ) async {
    final response = await http.post(
      Uri.parse('$baseUrl/auth/register'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'email': email,
        'password': password,
        'nickname': nickname,
      }),
    );

    if (response.statusCode == 201) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to register');
    }
  }

  Future<bool> checkTokenValidity() async {
    final token = await SharedPrefs.getToken();

    if (token == null) return false;

    final response = await http.get(
      Uri.parse('$baseUrl/auth/validate-token'),
      headers: {'Authorization': 'Bearer $token'},
    );

    return response.statusCode == 200;
  }
}
