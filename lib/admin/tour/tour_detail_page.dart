import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../models/tour.dart';

class TourDetailPage extends StatelessWidget {
  final Tour tour;

  TourDetailPage({required this.tour});

  @override
  Widget build(BuildContext context) {
    // Định dạng ngày tháng
    String startDateFormatted = DateFormat('dd/MM/yyyy').format(tour.startDate);
    String endDateFormatted = DateFormat('dd/MM/yyyy').format(tour.endDate);

    return Scaffold(
      appBar: AppBar(
        title: Text('Chi tiết Tour'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Hiển thị ảnh của tour
            Center(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.asset(
                  'assets/images${tour.img}', // Đảm bảo đường dẫn ảnh chính xác
                  width: double.infinity, // Chiếm toàn bộ chiều rộng
                  height: 200, // Đặt chiều cao cho ảnh
                  fit: BoxFit.cover, // Đảm bảo ảnh không bị méo
                ),
              ),
            ),
            SizedBox(height: 10),
            Text('Tên Tour: ${tour.tourName}', style: TextStyle(fontSize: 18)),
            SizedBox(height: 10),
            Text('Mô tả: ${tour.description}'),
            SizedBox(height: 10),
            Text('Giá: ${tour.price}'),
            SizedBox(height: 10),
            Text('Số lượng: ${tour.quantity}'),
            SizedBox(height: 10),
            Text('Ngày bắt đầu: $startDateFormatted'),
            SizedBox(height: 10),
            Text('Ngày kết thúc: $endDateFormatted'),
          ],
        ),
      ),
    );
  }
}
