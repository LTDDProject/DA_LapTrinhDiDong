import 'package:flutter/material.dart';
import '../../models/tourdetail.dart';

class TourDetailInfoPage extends StatelessWidget {
  final TourDetail tourDetail;

  // Khởi tạo TourDetailInfoPage với đối tượng TourDetail
  TourDetailInfoPage({required this.tourDetail});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Chi tiết TourDetail'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Hiển thị thông tin Tour
            Text(
              'Tour: ${tourDetail.tour?.tourName ?? 'No Tour Name'}',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            // Hiển thị thông tin Hotel
            Text(
              'Hotel: ${tourDetail.hotel?.name ?? 'No Hotel'}',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 10),
            // Hiển thị thông tin Vehicle
            Text(
              'Vehicle: ${tourDetail.vehicle?.vehicleName ?? 'No Vehicle'}',
              style: TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}
