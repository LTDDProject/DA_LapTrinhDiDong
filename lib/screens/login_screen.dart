import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert'; // Để xử lý JSON
import 'register_screen.dart'; // Import trang đăng ký
import 'package:google_sign_in/google_sign_in.dart'; // Import Google Sign-In package

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  String _email = '';
  String _password = '';
  bool _isLoading = false;

  // Hàm gọi API đăng nhập
  Future<void> _login() async {
    setState(() {
      _isLoading = true;
    });

    const String apiUrl = "https://localhost:5001/api/login"; // Thay URL backend của bạn

    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'Email': _email,
          'Password': _password,
        }),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        // Xử lý khi đăng nhập thành công
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Đăng nhập thành công')),
        );

        // Điều hướng đến màn hình khác (ví dụ: HomeScreen)
        Navigator.pushReplacementNamed(context, '/home');
      } else {
        final data = json.decode(response.body);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(data['message'] ?? 'Đăng nhập thất bại')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Lỗi: $e')),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  // Google sign-in method
  final GoogleSignIn _googleSignIn = GoogleSignIn(scopes: ['email']);
  GoogleSignInAccount? _currentUser;

  Future<void> _signInWithGoogle() async {
    try {
      GoogleSignInAccount? account = await _googleSignIn.signIn();
      if (account != null) {
        final GoogleSignInAuthentication googleAuth = await account.authentication;

        final response = await http.get(
          Uri.parse("https://localhost:5001/GoogleResponse?returnUrl=/"),
          headers: {
            'Authorization': 'Bearer ${googleAuth.idToken}',
          },
        );

        if (response.statusCode == 200) {
          final responseBody = json.decode(response.body);
          String token = responseBody['token'];
          // Store the JWT token as needed
          print('Received JWT Token: $token');
        } else {
          print('Failed to authenticate with the backend');
        }
      }
    } catch (error) {
      print('Error during Google Sign-In: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Đăng Nhập'),
        backgroundColor: Colors.deepPurple,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Form đăng nhập
            Form(
              key: _formKey,
              child: Column(
                children: [
                  TextFormField(
                    decoration: const InputDecoration(
                      labelText: 'Email',
                      border: OutlineInputBorder(),
                    ),
                    onSaved: (value) {
                      _email = value!;
                    },
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Vui lòng nhập email';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    obscureText: true,
                    decoration: const InputDecoration(
                      labelText: 'Mật khẩu',
                      border: OutlineInputBorder(),
                    ),
                    onSaved: (value) {
                      _password = value!;
                    },
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Vui lòng nhập mật khẩu';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  _isLoading
                      ? CircularProgressIndicator()
                      : ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        _formKey.currentState!.save();
                        _login(); // Gọi API đăng nhập
                      }
                    },
                    child: const Text('Đăng Nhập'),
                  ),
                  const SizedBox(height: 16),
                  // Google Sign-In button
                  ElevatedButton(
                    onPressed: _signInWithGoogle,
                    child: const Text('Đăng nhập với Google'),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            // Link đến trang đăng ký
            TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => RegisterScreen()),
                );
              },
              child: const Text(
                'Chưa có tài khoản? Đăng ký ngay!',
                style: TextStyle(color: Colors.deepPurple),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
