import 'dart:convert';
import 'package:http/http.dart' as http;

Future<Map<String, dynamic>> login(String username, String password) async {
  final url = Uri.parse('hhttp://192.168.1.107:5001/api/Account/login');  // Thay thế bằng URL của bạn

  final payload = {
    'username': username,
    'password': password,
  };

  try {
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: json.encode(payload),
    );

    // In chi tiết phản hồi từ server để dễ dàng kiểm tra nguyên nhân
    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      // Trả về chi tiết lỗi nếu không thành công
      return {'message': 'Đăng nhập không thành công', 'error_details': response.body};
    }
  } catch (error) {
    // Xử lý lỗi nếu có
    print('Error: $error');
    return {'message': 'Lỗi kết nối', 'error_details': error.toString()};
  }
}
