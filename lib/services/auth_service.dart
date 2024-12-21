import 'dart:convert';
import 'package:http/http.dart' as http;

class AuthService {
  static const String _baseUrl = 'https://localhost:5001/api'; // URL API

  // Đăng ký người dùng
  static Future<Map<String, dynamic>> registerUser({
    required String username,
    required String email,
    required String phone,
    required String password,
    required String confirmPassword,
  }) async {
    final url = Uri.parse('$_baseUrl/register');

    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'username': username,
        'email': email,
        'phone': phone,
        'password': password,
        'confirmPassword': confirmPassword,
      }),
    );

    if (response.statusCode == 200) {
      try {
        return jsonDecode(response.body); // Phân tích JSON thành Map
      } catch (e) {
        throw Exception('Phản hồi không hợp lệ: ${response.body}');
      }
    } else {
      try {
        final errorResponse = jsonDecode(response.body);
        throw Exception(errorResponse['message'] ?? 'Lỗi không xác định');
      } catch (e) {
        throw Exception('Lỗi từ server: ${response.body}');
      }
    }
  }
}
