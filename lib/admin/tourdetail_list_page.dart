import 'package:flutter/material.dart';
import '../services/tour_detail_service.dart';
import '../models/tourdetail.dart';
import 'tourdetail/tourdetail_detail_page.dart';
import 'tourdetail/tourdetail_add_page.dart';
import 'tourdetail/tourdetail_edit_page.dart';

class TourDetailPage extends StatefulWidget {
  @override
  _TourDetailPageState createState() => _TourDetailPageState();
}

class _TourDetailPageState extends State<TourDetailPage> {
  final TourDetailApiService apiService = TourDetailApiService();
  late Future<List<TourDetail>> _tourDetails;

  @override
  void initState() {
    super.initState();
    _tourDetails = apiService.fetchTourDetails();
  }

  // Hàm gọi lại API để lấy dữ liệu mới
  void _refreshTourDetails() {
    setState(() {
      _tourDetails = apiService.fetchTourDetails(); // Cập nhật lại danh sách khi có thay đổi
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Danh sách TourDetail'),
      ),
      body: FutureBuilder<List<TourDetail>>(
        future: _tourDetails,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (snapshot.hasData) {
            final tourDetails = snapshot.data!;
            return ListView.builder(
              itemCount: tourDetails.length,
              itemBuilder: (context, index) {
                final tourDetail = tourDetails[index];
                return ListTile(
                  title: Text(tourDetail.tour?.tourName ?? 'No Tour Name'),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Hotel: ${tourDetail.hotel?.name ?? 'No Hotel'}'),
                      Text('Vehicle: ${tourDetail.vehicle?.vehicleName ?? 'No Vehicle'}'),
                    ],
                  ),
                  onTap: () async {
                    // Điều hướng đến trang chi tiết
                    await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => TourDetailInfoPage(tourDetail: tourDetail),
                      ),
                    );
                  },
                  trailing: IconButton(
                    icon: Icon(Icons.edit),
                    onPressed: () async {
                      // Mở trang chỉnh sửa TourDetail và chờ khi chỉnh sửa xong
                      await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => EditTourDetailPage(tourDetail: tourDetail),
                        ),
                      );
                      _refreshTourDetails(); // Làm mới danh sách sau khi chỉnh sửa
                    },
                  ),
                );
              },
            );
          } else {
            return Center(child: Text('Không có dữ liệu'));
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          // Mở trang thêm mới TourDetail và chờ khi thêm xong
          await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddTourDetailPage()),
          );
          _refreshTourDetails(); // Làm mới danh sách sau khi thêm
        },
        child: Icon(Icons.add),
        backgroundColor: Colors.blue, // Màu nền của nút
      ),
    );
  }
}
