import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  static const String _baseUrl = 'http://192.168.1.107:5001/api'; // URL API

  // Đăng nhập người dùng và lưu trữ token cùng userId
  static Future<void> loginUser(String email, String password) async {
    final url = Uri.parse('$_baseUrl/login');

    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'Email': email, 'Password': password}),
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = jsonDecode(response.body);
      await _saveToken(data['accessToken'], data['userId']); // Lưu token và userId từ phản hồi
    } else {
      try {
        final errorResponse = jsonDecode(response.body);
        throw Exception(errorResponse['message'] ?? 'Lỗi không xác định');
      } catch (e) {
        throw Exception('Lỗi từ server: ${response.body}');
      }
    }
  }

  // Lưu token và userId trong SharedPreferences
  static Future<void> _saveToken(String token, int userId) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('authToken', token);
    await prefs.setInt('userId', userId); // Lưu userId
  }

  // Lấy token từ SharedPreferences
  static Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('authToken');
  }

  // Lấy userId từ SharedPreferences
  static Future<int?> getUserId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt('userId');
  }

  // Xóa token và userId
  static Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();

    // Gửi yêu cầu logout đến API
    final url = Uri.parse('$_baseUrl/logout');
    final response = await http.post(
      url,
      headers: {'Authorization': 'Bearer ${await getToken()}'},
    );

    if (response.statusCode == 200) {
      await prefs.remove('authToken');
      await prefs.remove('userId'); // Xóa userId
    } else {
      try {
        final errorResponse = jsonDecode(response.body);
        throw Exception(errorResponse['message'] ?? 'Lỗi từ server khi logout');
      } catch (e) {
        throw Exception('Lỗi từ server: ${response.body}');
      }
    }
  }

  // Kiểm tra token và userId đã tồn tại và hợp lệ hay chưa
  static Future<bool> isLoggedIn() async {
    final token = await getToken();
    final userId = await getUserId();
    return token != null && token.isNotEmpty && userId != null;
  }

}
