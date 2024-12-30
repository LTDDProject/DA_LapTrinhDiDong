import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/hotel.dart';

class HotelApi {
  static const String baseUrl = "http://192.168.1.107:5001/api/HotelsApi";

  // Lấy tất cả khách sạn
  Future<List<Hotel>> fetchHotels() async {
    final response = await http.get(Uri.parse(baseUrl));

    if (response.statusCode == 200) {
      // Giải mã phản hồi JSON
      final Map<String, dynamic> data = json.decode(response.body);

      // Truy xuất khóa '$values' để lấy danh sách các khách sạn
      if (data.containsKey('\$values')) {
        final List<dynamic> hotelList = data['\$values'];

        // Chuyển đổi danh sách các đối tượng JSON thành các đối tượng Hotel
        return hotelList.map((hotelJson) => Hotel.fromJson(hotelJson)).toList();
      } else {
        throw Exception('Không tìm thấy danh sách khách sạn trong dữ liệu');
      }
    } else {
      throw Exception('Lỗi khi tải khách sạn');
    }
  }


  // Tạo một khách sạn mới
  Future<Hotel> createHotel(Hotel hotel) async {
    final response = await http.post(
      Uri.parse(baseUrl),
      headers: {"Content-Type": "application/json"},
      body: json.encode(hotel.toJson()),
    );

    if (response.statusCode == 201) {
      return Hotel.fromJson(json.decode(response.body));
    } else {
      throw Exception('Lỗi khi tạo khách sạn');
    }
  }

  // Cập nhật một khách sạn đã tồn tại
  Future<void> updateHotel(int id, Hotel hotel) async {
    final response = await http.put(
      Uri.parse('$baseUrl/$id'),
      headers: {"Content-Type": "application/json"},
      body: json.encode(hotel.toJson()),
    );

    if (response.statusCode != 204) {
      throw Exception('Lỗi khi cập nhật khách sạn');
    }
  }

  // Xóa một khách sạn
  Future<void> deleteHotel(int id) async {
    final response = await http.delete(Uri.parse('$baseUrl/$id'));

    if (response.statusCode != 204) {
      throw Exception('Lỗi khi xóa khách sạn');
    }
  }
}
