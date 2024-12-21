import 'dart:convert';
import 'package:dio/dio.dart';
import 'dart:html' as html; // Để sử dụng File trong môi trường web
import '../models/tour.dart';

class ApiService {
  final String baseUrl = 'https://localhost:5001/api';
  final Dio dio = Dio();


  // Lấy danh sách các thể loại (categories) từ API
  Future<List<Category>> fetchCategories() async {
    try {
      final response = await dio.get('$baseUrl/CategoriesApi');

      if (response.statusCode == 200) {
        final List<dynamic> categoryList = response.data['\$values'];
        return categoryList.map((categoryJson) => Category.fromJson(categoryJson)).toList();
      } else {
        throw Exception('Lỗi khi tải thể loại, mã trạng thái: ${response.statusCode}');
      }
    } catch (error) {
      throw Exception('Lỗi khi gọi API để lấy thể loại: $error');
    }
  }

  // Lấy danh sách các tour từ API
  Future<List<Tour>> fetchTours() async {
    try {
      final response = await dio.get('$baseUrl/Tours');

      if (response.statusCode == 200) {
        final List<dynamic> tourJson = response.data['\$values'];
        return tourJson.map((json) => Tour.fromJson(json)).toList();
      } else {
        throw Exception('Lỗi khi tải danh sách tour, mã trạng thái: ${response.statusCode}');
      }
    } catch (error) {
      throw Exception('Lỗi khi gọi API: $error');
    }
  }

  // Thêm một tour với hình ảnh sử dụng Dio cho môi trường Web
  Future<bool> addTour(Tour tour, html.File imgFile) async {
    try {
      // Đọc file hình ảnh dưới dạng byte
      final reader = html.FileReader();
      reader.readAsArrayBuffer(imgFile); // Đọc file dưới dạng ArrayBuffer

      // Đợi cho việc đọc file hoàn tất
      await reader.onLoadEnd.first;

      // Tạo FormData
      var formData = FormData.fromMap({
        'TourName': tour.tourName,
        'Description': tour.description,
        'Price': tour.price.toString(),
        'CategoryId': tour.categoryId.toString(),
        'Quantity': tour.quantity.toString(),
        'StartDate': tour.startDate.toIso8601String(),
        'EndDate': tour.endDate.toIso8601String(),
      });

      // Kiểm tra xem đã có dữ liệu tệp chưa
      if (reader.result != null) {
        // Chuyển file hình ảnh thành MultipartFile cho Web
        formData.files.add(MapEntry(
          'img', // Tên trường này phải giống với tên trường trong API backend
          MultipartFile.fromBytes(reader.result as List<int>, filename: imgFile.name),
        ));

      } else {
        print('Lỗi khi đọc file hình ảnh');
        return false;
      }

      // Gửi yêu cầu POST để thêm tour
      var response = await dio.post(
        '$baseUrl/Tours',
        data: formData,
        options: Options(
          headers: {
            'Content-Type': 'multipart/form-data',
          },
        ),
      );

      // Kiểm tra mã trạng thái trả về
      if (response.statusCode == 201) {
        print('Tour đã được thêm thành công');
        return true;
      } else {
        print('Thất bại với mã trạng thái: ${response.statusCode}');
        return false;
      }
    } catch (error) {
      print('Lỗi: $error');
      throw Exception('Lỗi khi gọi API để thêm tour: $error');
    }
  }

  // Chỉnh sửa một tour đã tồn tại
  Future<bool> editTour(int tourId, Tour tour) async {
    try {
      final response = await dio.put(
        '$baseUrl/Tours/$tourId',
        data: json.encode(tour.toJson()), // Chuyển Tour thành JSON
        options: Options(headers: {'Content-Type': 'application/json'}),
      );

      if (response.statusCode == 204) {
        return true; // Thành công
      } else {
        throw Exception('Lỗi khi chỉnh sửa tour, mã trạng thái: ${response.statusCode}');
      }
    } catch (error) {
      throw Exception('Lỗi khi gọi API để chỉnh sửa tour: $error');
    }
  }

  // Xóa một tour
  Future<bool> deleteTour(int tourId) async {
    try {
      final response = await dio.delete('$baseUrl/Tours/$tourId');

      if (response.statusCode == 204) {
        return true; // Thành công
      } else {
        throw Exception('Lỗi khi xóa tour, mã trạng thái: ${response.statusCode}');
      }
    } catch (error) {
      throw Exception('Lỗi khi gọi API để xóa tour: $error');
    }
  }
}
