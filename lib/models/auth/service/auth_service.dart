import 'dart:convert';
import 'package:finonex_task/models/auth/_auth.dart';
import 'package:http/http.dart' as http;

class AuthService {
  final http.Client _httpClient;
  final String baseUrl;

  AuthService(
    this._httpClient, {
    required this.baseUrl,
  });

  Future<LoginResponse> login(String username, String password) async {
    final response = await _httpClient.post(
      Uri.parse('$baseUrl/login'),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'username': username,
        'password': password,
      }),
    );

    if (response.statusCode == 200) {
      return LoginResponse.fromJson(jsonDecode(response.body) as Map<String, dynamic>);
    } else {
      final data = jsonDecode(response.body);
      final message = data['message'] ?? 'Failed to login: ${response.statusCode}';
      throw Exception(message);
    }
  }
}
