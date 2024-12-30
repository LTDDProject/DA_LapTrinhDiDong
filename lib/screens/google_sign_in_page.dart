import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class GoogleSignInPage extends StatefulWidget {
  @override
  _GoogleSignInPageState createState() => _GoogleSignInPageState();
}

class _GoogleSignInPageState extends State<GoogleSignInPage> {
  // Thêm clientId vào GoogleSignIn
  final GoogleSignIn _googleSignIn = GoogleSignIn(
    clientId: '704620693402-9ags4133ml9ve65kflrm3hoo7kpt637t.apps.googleusercontent.com',
    scopes: ['email'],
  );

  GoogleSignInAccount? _currentUser;

  @override
  void initState() {
    super.initState();
    _googleSignIn.onCurrentUserChanged.listen((account) {
      setState(() {
        _currentUser = account;
      });
    });
    _googleSignIn.signInSilently();
  }

  Future<void> _signInWithGoogle() async {
    try {
      // Đăng nhập người dùng bằng Google
      GoogleSignInAccount? account = await _googleSignIn.signIn();

      if (account != null) {
        // Lấy thông tin xác thực từ Google sign-in
        final GoogleSignInAuthentication googleAuth = await account.authentication;

        // Gửi Google ID token đến backend để lấy JWT
        final response = await http.get(
          Uri.parse("http://192.168.1.107:5001/GoogleResponse?returnUrl=/"),
          headers: {
            'Authorization': 'Bearer ${googleAuth.idToken}',
          },
        );

        if (response.statusCode == 200) {
          final responseBody = json.decode(response.body);
          String token = responseBody['token'];

          // Lưu JWT token (ví dụ: sử dụng shared preferences hoặc giải pháp lưu trữ bảo mật)
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
      appBar: AppBar(title: Text("Google Sign-In")),
      body: Center(
        child: _currentUser == null
            ? ElevatedButton(
          onPressed: _signInWithGoogle,
          child: Text('Sign in with Google'),
        )
            : Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Welcome, ${_currentUser!.displayName}'),
            ElevatedButton(
              onPressed: () async {
                await _googleSignIn.signOut();
                setState(() {
                  _currentUser = null;
                });
              },
              child: Text('Sign out'),
            ),
          ],
        ),
      ),
    );
  }
}
