import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'register_screen.dart';
import '../services/auth_service.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  String _email = '';
  String _password = '';
  bool _isLoading = false;
  bool _isLoggedIn = false;
  bool _isPasswordVisible = false; // Thêm trạng thái hiển thị mật khẩu

  final GoogleSignIn _googleSignIn = GoogleSignIn(
    clientId: '704620693402-9ags4133ml9ve65kflrm3hoo7kpt637t.apps.googleusercontent.com',
    scopes: ['email'],
  );

  Future<void> _signInWithGoogle() async {
    setState(() {
      _isLoading = true;
    });
    try {
      GoogleSignInAccount? account = await _googleSignIn.signIn();

      if (account != null) {
        final GoogleSignInAuthentication googleAuth = await account.authentication;

        final response = await http.get(
          Uri.parse("http://192.168.1.107:5001/GoogleResponse?returnUrl=/"),
          headers: {
            'Authorization': 'Bearer ${googleAuth.idToken}',
          },
        );

        if (response.statusCode == 200) {
          final responseBody = json.decode(response.body);
          String token = responseBody['token'];

          print('Received JWT Token: $token');
        } else {
          print('Failed to authenticate with the backend');
        }
      }
    } catch (error) {
      print('Error during Google Sign-In: $error');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _login() async {
    setState(() {
      _isLoading = true;
    });

    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      try {
        await AuthService.loginUser(_email, _password);

        setState(() {
          _isLoggedIn = true;
        });

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Đăng nhập thành công')),
        );

        Navigator.pushReplacementNamed(context, '/home');
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.toString())),
        );
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _signOut() async {
    await AuthService.logout();
    setState(() {
      _isLoggedIn = false;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Đăng xuất thành công')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Đăng Nhập'),
        backgroundColor: Colors.deepPurple,
        actions: _isLoggedIn
            ? [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: _signOut,
          ),
        ]
            : null,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              if (!_isLoggedIn) ...[
                Column(
                  children: [
                    const SizedBox(height: 20),
                    Image.asset('assets/images/logo.jpg', height: 100),
                    const SizedBox(height: 20),
                    Text(
                      'Chào mừng bạn trở lại!',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.deepPurple,
                      ),
                    ),
                    const SizedBox(height: 40),
                    Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          TextFormField(
                            decoration: InputDecoration(
                              prefixIcon: const Icon(Icons.email),
                              labelText: 'Email',
                              filled: true,
                              fillColor: Colors.grey[200],
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: BorderSide.none,
                              ),
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
                            obscureText: !_isPasswordVisible,
                            decoration: InputDecoration(
                              prefixIcon: const Icon(Icons.lock),
                              labelText: 'Mật khẩu',
                              suffixIcon: IconButton(
                                icon: Icon(_isPasswordVisible
                                    ? Icons.visibility
                                    : Icons.visibility_off),
                                onPressed: () {
                                  setState(() {
                                    _isPasswordVisible = !_isPasswordVisible;
                                  });
                                },
                              ),
                              filled: true,
                              fillColor: Colors.grey[200],
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: BorderSide.none,
                              ),
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
                          const SizedBox(height: 24),
                          _isLoading
                              ? const CircularProgressIndicator()
                              : ElevatedButton(
                            onPressed: _login,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.deepPurple,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 100, vertical: 15),
                            ),
                            child: const Text(
                              'Đăng Nhập',
                              style: TextStyle(fontSize: 16),
                            ),
                          ),
                          const SizedBox(height: 16),
                          TextButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => RegisterScreen()),
                              );
                            },
                            child: const Text(
                              'Chưa có tài khoản? Đăng ký ngay!',
                              style: TextStyle(color: Colors.deepPurple),
                            ),
                          ),
                          const SizedBox(height: 16),
                          if (_isLoading)
                            const CircularProgressIndicator()
                          else
                            TextButton(
                              onPressed: _signInWithGoogle,
                              child: const Text(
                                'Đăng nhập bằng Google',
                                style: TextStyle(color: Colors.white),
                              ),
                              style: TextButton.styleFrom(
                                backgroundColor: Colors.deepPurple,
                                padding:
                                const EdgeInsets.symmetric(vertical: 12),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ],
                ),
              ] else ...[
                Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Icon(
                        Icons.check_circle,
                        size: 80,
                        color: Colors.green,
                      ),
                      SizedBox(height: 16),
                      Text(
                        'Bạn đã đăng nhập',
                        style: TextStyle(fontSize: 18, color: Colors.green),
                      ),
                    ],
                  ),
                ),
              ]
            ],
          ),
        ),
      ),
    );
  }
}
