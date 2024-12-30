import '../models/user.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class UserService {
  final String baseUrl = "http://192.168.1.107:5001/api/Users";

  // Lấy toàn bộ danh sách người dùng
  Future<List<User>> fetchUsers() async {
    final url = Uri.parse(baseUrl);
    final response = await http.get(url);

    if (response.statusCode == 200) {
      // Parse JSON trả về
      final Map<String, dynamic> jsonData = json.decode(response.body);

      // Kiểm tra và lấy dữ liệu từ "$values" nếu tồn tại
      if (jsonData.containsKey('\$values')) {
        final List<dynamic> users = jsonData['\$values'];
        return users.map((user) => User.fromJson(user)).toList();
      } else {
        throw Exception("Unexpected JSON structure");
      }
    } else {
      throw Exception("Failed to fetch users");
    }
  }

  // Lấy chi tiết người dùng
  Future<User> fetchUserDetails(int id) async {
    final url = Uri.parse('$baseUrl/$id');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      // Parse JSON trả về
      final Map<String, dynamic> jsonData = json.decode(response.body);

      // Trả về đối tượng User
      return User.fromJson(jsonData);
    } else {
      throw Exception("Failed to fetch user details");
    }
  }
}
