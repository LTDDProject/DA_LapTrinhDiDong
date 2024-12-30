import 'package:flutter/material.dart';
import 'pages/home_page.dart';
import 'pages/admin_page.dart';
import '../screens/payment_screen.dart'; // Import màn hình thanh toán

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Quản Lý Đặt Tour',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      initialRoute: '/home',
      routes: {
        '/home': (context) => const HomePage(),
        '/admin': (context) => const AdminPage(),
        '/payment': (context) => PaymentScreen(), // Thêm route này
      },
    );
  }
}
