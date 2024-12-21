import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../pages/admin_page.dart'; // Import trang AdminPage

class AdminLoginScreen extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<AdminLoginScreen> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  // Biến lưu trữ thông báo lỗi
  String _errorMessage = '';

  // Hàm gửi yêu cầu đăng nhập tới API
  Future<Map<String, dynamic>> login(String username, String password) async {
    final url = Uri.parse('https://localhost:5001/api/Account/login');  // Thay thế URL của API

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

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        // Nếu API trả về lỗi, ví dụ tài khoản bị khóa, bạn có thể xử lý chi tiết ở đây
        final responseData = json.decode(response.body);
        return {'message': responseData['message'] ?? 'Đăng nhập không thành công'};
      }
    } catch (e) {
      return {'message': 'Lỗi kết nối'};
    }
  }

  void _handleLogin() async {
    final username = _usernameController.text;
    final password = _passwordController.text;

    // Kiểm tra tên đăng nhập và mật khẩu không rỗng
    if (username.isEmpty || password.isEmpty) {
      setState(() {
        _errorMessage = 'Vui lòng nhập tên đăng nhập và mật khẩu.';
      });
      return;
    }

    final response = await login(username, password);

    // In chi tiết thông báo lỗi nếu có
    if (response.containsKey('message') && response['message'] != 'Đăng nhập thành công!') {
      setState(() {
        _errorMessage = response['message'];  // Hiển thị thông báo lỗi từ API
      });
    } else if (response['message'] == 'Đăng nhập thành công!') {
      // Chuyển trang AdminPage khi đăng nhập thành công
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => AdminPage()),  // Navigate to AdminPage
      );
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Đăng nhập')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _usernameController,
              decoration: InputDecoration(
                labelText: 'Tên đăng nhập',
                errorText: _errorMessage.isNotEmpty ? _errorMessage : null,
              ),
            ),
            TextField(
              controller: _passwordController,
              obscureText: true,
              decoration: InputDecoration(
                labelText: 'Mật khẩu',
                errorText: _errorMessage.isNotEmpty ? _errorMessage : null,
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _handleLogin,
              child: Text('Đăng nhập'),
            ),
            if (_errorMessage.isNotEmpty) ...[
              SizedBox(height: 10),
              Text(
                _errorMessage,
                style: TextStyle(color: Colors.red),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
