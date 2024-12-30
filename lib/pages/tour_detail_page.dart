import 'package:flutter/material.dart';
import '../models/tour.dart';
import '../services/tour_service.dart';
import '../screens/book_tour_screen.dart';

class TourDetailPage extends StatelessWidget {
  final int tourId;

  const TourDetailPage({super.key, required this.tourId});

  @override
  Widget build(BuildContext context) {
    final tourService = ApiService(); // Thay bookingService bằng tourService

    return Scaffold(
      appBar: AppBar(
        title: Text('Chi tiết tour'),
      ),
      body: FutureBuilder<Tour>(
        future: tourService.fetchTourById(tourId), // Sử dụng fetchTourById từ tourService
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Lỗi: ${snapshot.error}'));
          } else if (!snapshot.hasData) {
            return const Center(child: Text('Không tìm thấy dữ liệu tour'));
          } else {
            final tour = snapshot.data!;
            return SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Hiển thị hình ảnh tour
                    Container(
                      height: 250,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage(
                            'assets/images${tour.img.toLowerCase().replaceAll(' ', '_')}',
                          ),
                          fit: BoxFit.cover,
                        ),
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    const SizedBox(height: 10),
                    // Hiển thị tên tour
                    Container(
                      alignment: Alignment.center,
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      width: double.infinity,
                      color: Colors.deepPurple,
                      child: Text(
                        tour.tourName,
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    const SizedBox(height: 20),
                    // Hiển thị mô tả tour
                    Text(
                      tour.description,
                      style: const TextStyle(fontSize: 16, color: Colors.black87),
                      textAlign: TextAlign.justify,
                    ),
                    const SizedBox(height: 20),
                    // Hiển thị chi tiết tour
                    Row(
                      children: [
                        Icon(Icons.attach_money, color: Colors.green),
                        const SizedBox(width: 8),
                        Text(
                          'Giá: ${tour.price} VND',
                          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        Icon(Icons.add_circle_outline, color: Colors.orange),
                        const SizedBox(width: 8),
                        Text(
                          'Số lượng: ${tour.quantity}',
                          style: const TextStyle(fontSize: 16, color: Colors.grey),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        Icon(Icons.date_range, color: Colors.blue),
                        const SizedBox(width: 8),
                        Text(
                          'Thời gian: ${tour.startDate.toString().split(' ')[0]} - ${tour.endDate.toString().split(' ')[0]}',
                          style: const TextStyle(fontSize: 16, color: Colors.grey),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    // Nút đặt tour
                    ElevatedButton(
                      onPressed: () {
                        // Chuyển hướng đến BookTourScreen với tourId
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => BookTourScreen(tourId: tourId),
                          ),
                        );
                      },
                      child: Text('Đặt Ngay'),
                    ),
                  ],
                ),
              ),
            );
          }
        },
      ),
    );
  }
}

