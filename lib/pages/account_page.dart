import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Tour Booking App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: UserProfileScreen(),
    );
  }
}

class UserProfileScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Hồ sơ của tôi'),
        backgroundColor: Colors.blue,
        actions: [
          IconButton(
            icon: Icon(Icons.help_outline),
            onPressed: () {              // Hành động khi nhấn vào nút trợ giúp
            },
          ),
        ],
      ),

      body: ListView(
        padding: EdgeInsets.all(16.0),
        children: [
          // Phần avatar và thông tin người dùng
          Container(
            color: Colors.blue,
            padding: EdgeInsets.symmetric(vertical: 20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircleAvatar(
                  radius: 50,
                  backgroundImage: NetworkImage('https://picsum.photos/200'), // Thay thế bằng ảnh thực tế
                ),
                SizedBox(height: 10),
                Text(
                  'User Name',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),

          SizedBox(height: 16.0),
          buildSectionTitle('Tài khoản'),
          buildMenuItem(Icons.person, 'Quản lý tài khoản'),
          buildMenuItem(Icons.account_balance_wallet, 'Tặng thưởng & Ví'),
          buildMenuItem(Icons.card_membership, 'Chương trình khách hàng thân thiết Genius'),
          buildMenuItem(Icons.rate_review, 'Đánh giá'),
          buildMenuItem(Icons.help, 'Câu hỏi cho chỗ nghỉ'),

          SizedBox(height: 16.0),
          buildSectionTitle('Trợ giúp'),
          buildMenuItem(Icons.contact_support, 'Liên hệ Dịch vụ Khách hàng'),
          buildMenuItem(Icons.lock, 'Trung tâm thông tin bảo mật'),
          buildMenuItem(Icons.handshake, 'Giải quyết tranh chấp'),

          SizedBox(height: 16.0),
          buildSectionTitle('Khám phá'),
          buildMenuItem(Icons.percent, 'Ưu đãi'),
          buildMenuItem(Icons.local_taxi, 'Taxi sân bay'),
          buildMenuItem(Icons.article, 'Bài viết về du lịch'),

          SizedBox(height: 16.0),
          buildSectionTitle('Cài đặt và pháp lý'),
          buildMenuItem(Icons.settings, 'Cài đặt'),

          SizedBox(height: 16.0),
          buildSectionTitle('Đối tác'),
          buildMenuItem(Icons.add_home, 'Đăng chỗ nghỉ'),
          buildMenuItem(Icons.logout, 'Đăng xuất')

        ],
      ),

      //Thanh điều hướng ngang
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: 'Tìm kiếm',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite_outline),
            label: 'Đã lưu',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.luggage),
            label: 'Đặt chỗ',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Hồ sơ của tôi',
          ),
        ],
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.grey,
      ),
      //kết thúc thanh điê hướng ngang


    );
  }

  Widget buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Text(
        title,
        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16.0),
      ),
    );
  }

  Widget buildMenuItem(IconData icon, String title) {
    return ListTile(
      leading: Icon(icon),
      title: Text(title),
      onTap: () {
        // Thêm hành động khi nhấn vào menu
      },
    );
  }
}
