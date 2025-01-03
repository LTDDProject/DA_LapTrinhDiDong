import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/booking.dart';
import '../models/quarterlyrevenue.dart';
import '../models/monthlyrevenue.dart';
import '../services/auth_service.dart';

class BookingService {
  final String baseUrl = "http://192.168.1.107:5001/api/BookingsApi";

  // Lấy danh sách tất cả booking
  Future<List<Booking>> getBookings() async {
    final response = await http.get(Uri.parse(baseUrl));

    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonResponse = json.decode(response.body);

      if (jsonResponse.containsKey("\$values")) {
        final List<dynamic> values = jsonResponse["\$values"];
        return values.map((json) => Booking.fromJson(json)).toList();
      } else {
        throw Exception("Unexpected JSON format");
      }
    } else {
      throw Exception("Failed to load bookings");
    }
  }

  // Lấy danh sách booking của người dùng theo userId
  Future<List<Booking>> getBookingsByUserId(int userId) async {
    final response = await http.get(Uri.parse('$baseUrl/user/$userId'));

    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonResponse = json.decode(response.body);

      if (jsonResponse.containsKey("\$values")) {
        final List<dynamic> values = jsonResponse["\$values"];
        return values.map((json) => Booking.fromJson(json)).toList();
      } else {
        throw Exception("Unexpected JSON format");
      }
    } else {
      throw Exception("Failed to load bookings for user");
    }
  }

  // Tạo mới booking
  Future<Booking> createBooking(Booking booking) async {
    final response = await http.post(
      Uri.parse(baseUrl),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(booking.toJson()),
    );

    if (response.statusCode == 201) {
      return Booking.fromJson(json.decode(response.body));
    } else {
      throw Exception("Failed to create booking");
    }
  }

  // Cập nhật thông tin booking
  Future<void> updateBooking(int id, Booking booking) async {
    final response = await http.put(
      Uri.parse('$baseUrl/$id'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(booking.toJson()),
    );

    if (response.statusCode != 204) {
      throw Exception("Failed to update booking");
    }
  }

  // Xóa booking
  Future<void> deleteBooking(int id) async {
    final response = await http.delete(Uri.parse('$baseUrl/$id'));

    if (response.statusCode != 204) {
      throw Exception("Failed to delete booking");
    }
  }

  Future<List<MonthlyRevenue>> getRevenue() async {
    final response = await http.get(Uri.parse('$baseUrl/Revenue'));

    if (response.statusCode == 200) {
      try {
        // Giải mã JSON phản hồi từ API
        final Map<String, dynamic> data = json.decode(response.body);

        // Kiểm tra nếu trường '$values' có trong JSON
        if (data.containsKey("\$values")) {
          final List<dynamic> revenueData = data["\$values"];

          // Chuyển đổi danh sách thành List<Revenue>
          return revenueData.map((json) => MonthlyRevenue.fromJson(json)).toList();
        } else {
          throw Exception("Key '\$values' not found in response.");
        }
      } catch (e) {
        throw Exception("Failed to parse revenue data: $e");
      }
    } else {
      throw Exception(
          "Failed to load revenue data, status code: ${response.statusCode}");
    }
  }

  // Lấy doanh thu theo quý
  Future<List<Revenue>> getQuarterlyRevenue() async {
    final response = await http.get(Uri.parse('$baseUrl/QuarterlyRevenue'));

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      final List<
          dynamic> revenueData = data['\$values']; // Lấy dữ liệu từ trường '$values'

      // Chuyển đổi danh sách thành List<Revenue>
      return revenueData.map((json) => Revenue.fromJson(json)).toList();
    } else {
      throw Exception("Failed to load quarterly revenue data");
    }
  }

  // Hủy booking
  Future<bool> cancelBooking(int bookingId) async {
    final response = await http.put(
      Uri.parse('$baseUrl/cancel/$bookingId'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${await AuthService.getToken()}', // Giả sử có phương thức lấy token
      },
    );

    if (response.statusCode == 200) {
      return true; // Hủy booking thành công
    } else {
      return false; // Hủy booking thất bại
    }
  }
}
