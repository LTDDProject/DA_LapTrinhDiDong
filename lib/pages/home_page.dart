import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'tour_list_page.dart';
import 'account_page.dart';
import '../screens/login_screen.dart';
import '../screens/admin_login_screen.dart';
import '../services/auth_service.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;
  bool _isLoggedIn = false; // Trạng thái đăng nhập

  @override
  void initState() {
    super.initState();
    _checkLoginStatus(); // Kiểm tra trạng thái đăng nhập khi bắt đầu
  }

  // Kiểm tra xem người dùng có đang đăng nhập không
  Future<void> _checkLoginStatus() async {
    bool loggedIn = await AuthService.isLoggedIn();
    setState(() {
      _isLoggedIn = loggedIn;
    });
  }

  // Đăng xuất
  Future<void> _signOut() async {
    await AuthService.logout();
    _checkLoginStatus(); // Kiểm tra lại trạng thái sau khi đăng xuất
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Đăng xuất thành công')),
    );
  }

  final List<Widget> _pages = [
    const TourListPage(),
    UserProfileScreen(),
  ];

  final List<Map<String, String>> featuredTours = [
    {
      'image': 'assets/images/vanhoa.jpg',
      'title': 'Khám phá nền văn hóa lâu đời',
    },
    {
      'image': 'assets/images/trongnuoc.jpg',
      'title': 'Những chuyến du lịch trong nước đáng nhớ',
    },
    {
      'image': 'assets/images/quocte.jpg',
      'title': 'Khám phá thế giới rộng lớn',
    },
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Trang Quản Lý Đặt Tour'),
        backgroundColor: Colors.deepPurple,
        actions: _isLoggedIn
            ? [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: _signOut,
          ),
        ]
            : [], // Không hiển thị nút logout nếu chưa đăng nhập
      ),
      body: Column(
        children: [
          // Hiển thị carousel chỉ khi ở trang chủ (_selectedIndex == 0)
          if (_selectedIndex == 0) ...[
            // Thanh tìm kiếm
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                decoration: InputDecoration(
                  labelText: 'Tìm kiếm tour',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  prefixIcon: const Icon(Icons.search),
                ),
                onChanged: (value) {
                  // Xử lý tìm kiếm (search)
                },
              ),
            ),
            // Thanh cuộn ảnh nổi bật với caption
            CarouselSlider(
              options: CarouselOptions(
                height: 220.0,
                autoPlay: true,
                enlargeCenterPage: true,
                autoPlayAnimationDuration: const Duration(milliseconds: 800),
              ),
              items: featuredTours.map((tour) {
                return Builder(
                  builder: (BuildContext context) {
                    return Stack(
                      children: [
                        Container(
                          margin: const EdgeInsets.symmetric(horizontal: 5.0),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                            image: DecorationImage(
                              image: AssetImage(tour['image']!),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        Positioned(
                          bottom: 10,
                          left: 10,
                          child: Container(
                            color: Colors.black54,
                            padding: const EdgeInsets.all(5),
                            child: Text(
                              tour['title']!,
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                );
              }).toList(),
            ),
          ],
          // Danh sách tour hoặc các trang khác
          Expanded(
            child: _pages[_selectedIndex],
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.tour),
            label: 'Tour',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.payment),
            label: 'Thanh toán',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_circle),
            label: 'Tài khoản',
          ),
        ],
      ),
      floatingActionButton: !_isLoggedIn // Chỉ hiển thị nút login khi chưa đăng nhập
          ? FloatingActionButton(
        onPressed: () {
          // Hiển thị hộp thoại để chọn giữa đăng nhập user hoặc admin
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: const Text('Chọn loại đăng nhập'),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        // Điều hướng đến trang đăng nhập user
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => LoginScreen()),
                        );
                      },
                      child: const Text('Đăng nhập User'),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        // Điều hướng đến trang đăng nhập admin
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  AdminLoginScreen()),
                        );
                      },
                      child: const Text('Đăng nhập Admin'),
                    ),
                  ],
                ),
              );
            },
          );
        },
        child: const Icon(Icons.login),
        backgroundColor: Colors.deepPurple,
      )
          : SizedBox.shrink(), // Không hiển thị nút login khi đã đăng nhập
    );
  }
}

