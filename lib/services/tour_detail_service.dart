import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/tourdetail.dart';

class TourDetailApiService {
  final String baseUrl = "https://localhost:5001/api"; // Đảm bảo URL chính xác

  // Hàm lấy danh sách chi tiết tour
  Future<List<TourDetail>> fetchTourDetails() async {
    final url = Uri.parse('$baseUrl/TourDetails'); // Cập nhật URL chính xác
    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        // Giải mã phản hồi JSON thành Map, và truy xuất trường '$values' chứa danh sách
        final Map<String, dynamic> data = json.decode(response.body);

        // Truy xuất danh sách chi tiết tour từ trường '$values'
        final List<dynamic> tourDetailList = data['\$values'];  // Chú ý ký tự escape của "$"

        // Chuyển đổi danh sách các đối tượng JSON thành các đối tượng TourDetail
        return tourDetailList.map((tourDetailJson) => TourDetail.fromJson(tourDetailJson)).toList();
      } else {
        throw Exception('Failed to load tour details. Status code: ${response.statusCode}');
      }
    } catch (error) {
      throw Exception('Error fetching tour details: $error');
    }
  }

  // Hàm lấy danh sách tour
  Future<List<Tour>> fetchTours() async {
    final url = Uri.parse('$baseUrl/Tours'); // Cập nhật URL chính xác
    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        // Giải mã phản hồi JSON thành Map và chuyển thành danh sách các Tour
        final List<dynamic> tourList = json.decode(response.body);

        return tourList.map((tourJson) => Tour.fromJson(tourJson)).toList();
      } else {
        throw Exception('Failed to load tours. Status code: ${response.statusCode}');
      }
    } catch (error) {
      throw Exception('Error fetching tours: $error');
    }
  }

  // Hàm lấy danh sách khách sạn
  Future<List<Hotel>> fetchHotels() async {
    final url = Uri.parse('$baseUrl/Hotels'); // Cập nhật URL chính xác
    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        // Giải mã phản hồi JSON thành Map và chuyển thành danh sách các Hotel
        final List<dynamic> hotelList = json.decode(response.body);

        return hotelList.map((hotelJson) => Hotel.fromJson(hotelJson)).toList();
      } else {
        throw Exception('Failed to load hotels. Status code: ${response.statusCode}');
      }
    } catch (error) {
      throw Exception('Error fetching hotels: $error');
    }
  }

  // Hàm lấy danh sách phương tiện
  Future<List<Vehicle>> fetchVehicles() async {
    final url = Uri.parse('$baseUrl/Vehicles'); // Cập nhật URL chính xác
    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        // Giải mã phản hồi JSON thành Map và chuyển thành danh sách các Vehicle
        final List<dynamic> vehicleList = json.decode(response.body);

        return vehicleList.map((vehicleJson) => Vehicle.fromJson(vehicleJson)).toList();
      } else {
        throw Exception('Failed to load vehicles. Status code: ${response.statusCode}');
      }
    } catch (error) {
      throw Exception('Error fetching vehicles: $error');
    }
  }

  // Hàm thêm chi tiết tour
  Future<void> addTourDetail(TourDetail tourDetail) async {
    final url = Uri.parse('$baseUrl/TourDetails'); // Cập nhật URL chính xác
    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: json.encode(tourDetail.toJson()),
      );

      if (response.statusCode == 201) {
        // Thành công
        print('Tour detail added successfully');
      } else {
        throw Exception('Failed to add tour detail. Status code: ${response.statusCode}');
      }
    } catch (error) {
      throw Exception('Error adding tour detail: $error');
    }
  }

  // Hàm cập nhật chi tiết tour
  Future<void> updateTourDetail(TourDetail tourDetail) async {
    final url = Uri.parse('$baseUrl/TourDetails/${tourDetail.tourDetailId}');
    try {
      final response = await http.put(
        url,
        headers: {'Content-Type': 'application/json'},
        body: json.encode(tourDetail.toJson()),
      );

      if (response.statusCode == 200) {
        // Thành công
        print('Tour detail updated successfully');
      } else {
        throw Exception('Failed to update tour detail. Status code: ${response.statusCode}');
      }
    } catch (error) {
      throw Exception('Error updating tour detail: $error');
    }
  }

}
