import 'package:flutter/material.dart';
import 'package:ql_tours/admin/hotel/hotel_detail_page.dart';
import 'package:ql_tours/admin/hotel/hotel_list_page.dart';
import '../admin/category/category_list_page.dart';
import '../admin/tour/tour_list_page.dart';
import '../admin/user/user_list_page.dart';
import '../admin/manage/manage_list_page.dart';
import '../admin/booking/booking_list_page.dart';
import '../admin/tourdetail/tourdetail_list_page.dart';
import '../admin/vehicle/vehicle_list_page.dart';


class AdminPage extends StatelessWidget {
  const AdminPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Quản lý Admin'),
        backgroundColor: Colors.deepPurple,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView(
          children: [
            // Mục Quản lý Tour
            Card(
              margin: const EdgeInsets.symmetric(vertical: 8.0),
              elevation: 5,
              child: ExpansionTile(
                leading: const Icon(Icons.tour, color: Colors.deepPurple),
                title: const Text('Quản lý Tour', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                children: [
                  ListTile(
                    leading: const Icon(Icons.view_list, color: Colors.green),
                    title: const Text('Danh Sách Tour'),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => TourListPage()),
                      );
                    },
                  ),
                ],
              ),
            ),
            // Mục Quản lý Chi Tiết Tour (Mới thêm)
            Card(
              margin: const EdgeInsets.symmetric(vertical: 8.0),
              elevation: 5,
              child: ListTile(
                leading: const Icon(Icons.details, color: Colors.orange),
                title: const Text('Quản lý Chi Tiết Tour'),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => TourDetailPage()), // Điều hướng đến trang quản lý chi tiết tour
                  );
                },
              ),
            ),
            //Quản lý khách sạn
            Card(
              margin: const EdgeInsets.symmetric(vertical: 8.0),
              elevation: 5,
              child: ListTile(
                leading: const Icon(Icons.hotel, color: Colors.orange),
                title: const Text('Quản lý Khách sạn'),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => HotelListPage()), // Điều hướng đến trang quản lý khách sạn
                  );
                },
              ),
            ),
            //Quản lý Phương tiện
            Card(
              margin: const EdgeInsets.symmetric(vertical: 8.0),
              elevation: 5,
              child: ListTile(
                leading: const Icon(Icons.directions_car, color: Colors.blue),
                title: const Text('Quản lý Phương tiện'),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => VehicleListPage()), // Điều hướng đến trang quản lý phương tiện
                  );
                },
              ),
            ),
            // Mục Quản lý Danh Mục
            Card(
              margin: const EdgeInsets.symmetric(vertical: 8.0),
              elevation: 5,
              child: ListTile(
                leading: const Icon(Icons.category, color: Colors.blue),
                title: const Text('Quản lý Danh Mục'),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => CategoryListPage()),
                  );
                },
              ),
            ),
            // Mục Quản lý Người Dùng
            Card(
              margin: const EdgeInsets.symmetric(vertical: 8.0),
              elevation: 5,
              child: ListTile(
                leading: const Icon(Icons.person, color: Colors.blue),
                title: const Text('Quản lý Người Dùng'),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const UserListPage()),
                  );
                },
              ),
            ),
            // Mục Quản lý Booking
            Card(
              margin: const EdgeInsets.symmetric(vertical: 8.0),
              elevation: 5,
              child: ListTile(
                leading: const Icon(Icons.book_online, color: Colors.orange),
                title: const Text('Quản lý Booking'),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => BookingListPage()),
                  );
                },
              ),
            ),
            // Mục Quản lý Tài Khoản (Manage)
            Card(
              margin: const EdgeInsets.symmetric(vertical: 8.0),
              elevation: 5,
              child: ListTile(
                leading: const Icon(Icons.account_circle, color: Colors.deepPurple),
                title: const Text('Quản lý Tài Khoản'),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => ManagePage()),
                  );
                },
              ),
            ),
            // Mục Cài Đặt
            Card(
              margin: const EdgeInsets.symmetric(vertical: 8.0),
              elevation: 5,
              child: ListTile(
                leading: const Icon(Icons.settings, color: Colors.grey),
                title: const Text('Cài Đặt'),
                onTap: () {
                  // Điều hướng đến trang cài đặt
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
