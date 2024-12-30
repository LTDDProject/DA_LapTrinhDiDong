import 'package:http/http.dart' as http;
import 'dart:convert';

class BookingService {
  static const String baseUrl = 'https://localhost:5001/api/v1';

  Future<String?> bookTour(int tourId, int quantity, String userId) async {
    final response = await http.post(
      Uri.parse('$baseUrl/book-tour'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $userId',
      },
      body: json.encode({
        'TourId': tourId,
        'Quantity': quantity,
      }),
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      return data['bookingId'].toString();
    } else {
      // Handle error response
      print('Failed to book tour: ${response.statusCode}');
      return null;
    }
  }

  Future<String?> createPaymentUrl(String bookingId, String userId) async {
    final response = await http.post(
      Uri.parse('$baseUrl/payment/create'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $userId', // Thêm header Authorization
      },
      body: json.encode({
        'BookingId': bookingId,
      }),
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      return data['paymentUrl'];
    } else {
      // Handle error response
      print('Failed to create payment URL: ${response.statusCode}');
      return null;
    }
  }
}
