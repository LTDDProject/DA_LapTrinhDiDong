import 'package:flutter/material.dart';
import '../models/tour.dart';  // Import the Tour model

class TourDetailPage extends StatelessWidget {
  final Tour tour; // The tour object passed from the previous page

  const TourDetailPage({super.key, required this.tour});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(tour.tourName), // Display tour name as the app bar title
        actions: [
          IconButton(
            icon: Icon(
              Icons.favorite_border, // Favorite icon
              color: Colors.red, // Icon color (red)
            ),
            onPressed: () {
              // Add action to handle favorite functionality, e.g., add to favorites
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Added to Favorites!')),
              );
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Display image of the tour
            Container(
              height: 250,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(
                    'assets/images/${tour.img.toLowerCase().replaceAll(' ', '_')}',
                  ),
                  fit: BoxFit.cover,
                ),
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            const SizedBox(height: 10),
            // Display tour name below the image with attractive styling
            Container(
              alignment: Alignment.center,
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              width: double.infinity,
              color: Colors.deepPurple, // Background color for the name
              child: Text(
                tour.tourName,
                style: const TextStyle(
                  fontSize: 22, // Larger font size
                  fontWeight: FontWeight.bold,
                  color: Colors.white, // White text color
                ),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 20),
            // Display tour details with icons
            Row(
              children: [
                Icon(
                  Icons.attach_money, // Price icon
                  color: Colors.green, // Icon color (green)
                ),
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
                Icon(
                  Icons.add_circle_outline, // Quantity icon
                  color: Colors.orange, // Icon color (orange)
                ),
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
                Icon(
                  Icons.date_range, // Start Date icon
                  color: Colors.blue, // Icon color (blue)
                ),
                const SizedBox(width: 8),
                Text(
                  'Thời gian: ${tour.startDate.toString().split(' ')[0]} - ${tour.endDate.toString().split(' ')[0]}',
                  style: const TextStyle(fontSize: 16, color: Colors.grey),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                const SizedBox(width: 8),
                // Mô tả sẽ tự động xuống dòng nếu cần
                Expanded(
                  child: Text(
                    'Mô tả: ${tour.description}',
                    style: const TextStyle(fontSize: 16, color: Colors.black),
                    softWrap: true, // Cho phép xuống dòng tự động
                    maxLines: null, // Không giới hạn số dòng
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }
}
