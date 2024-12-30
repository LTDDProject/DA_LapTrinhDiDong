import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/booking.dart';


class BookingService {
  final String baseUrl = "http://192.168.1.107:5001/api/BookingsApi";

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

  Future<Booking> getBooking(int id) async {
    final response = await http.get(Uri.parse('$baseUrl/$id'));

    if (response.statusCode == 200) {
      return Booking.fromJson(json.decode(response.body));
    } else {
      throw Exception("Failed to load booking");
    }
  }

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

  Future<void> deleteBooking(int id) async {
    final response = await http.delete(Uri.parse('$baseUrl/$id'));

    if (response.statusCode != 204) {
      throw Exception("Failed to delete booking");
    }
  }

  Future<List<dynamic>> getRevenue() async {
    final response = await http.get(Uri.parse('$baseUrl/Revenue'));

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception("Failed to load revenue data");
    }
  }

  Future<List<dynamic>> getQuarterlyRevenue() async {
    final response = await http.get(Uri.parse('$baseUrl/QuarterlyRevenue'));

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception("Failed to load quarterly revenue data");
    }
  }
}
