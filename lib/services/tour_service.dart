import 'dart:convert';
import 'package:dio/dio.dart';
import 'dart:io';
import '../models/tour.dart';

class ApiService {
  final String baseUrl = 'http://192.168.1.107:5001/api';
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
  Future<Tour> fetchTourById(int tourId) async {
    try {
      final response = await dio.get('http://192.168.1.107:5001/api/Tours/$tourId');
      if (response.statusCode == 200) {
        return Tour.fromJson(response.data);
      } else {
        throw Exception('API request failed with status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching tour: $e');
      throw Exception('Error fetching tour: $e');
    }
  }


  Future<bool> addTour(Tour tour, File imgFile) async {
    try {
      var formData = FormData.fromMap({
        'TourName': tour.tourName,
        'Description': tour.description,
        'Price': tour.price.toString(),
        'CategoryId': tour.categoryId.toString(),
        'Quantity': tour.quantity.toString(),
        'StartDate': tour.startDate.toIso8601String(),
        'EndDate': tour.endDate.toIso8601String(),
      });

      if (imgFile != null) {
        formData.files.add(MapEntry(
          'img',
          MultipartFile.fromFileSync(imgFile.path, filename: imgFile.path.split('/').last),
        ));
      }

      var response = await dio.post(
        '$baseUrl/Tours',
        data: formData,
        options: Options(headers: {
          'Content-Type': 'multipart/form-data',
        }),
      );

      if (response.statusCode == 201) {
        print('Tour đã được thêm thành công');
        return true;
      } else {
        print('Thất bại với mã trạng thái: ${response.statusCode}');
        return false;
      }
    } catch (error) {
      if (error is DioError) {
        if (error.type == DioErrorType.response) {
          print('DioError response: ${error.response?.statusCode}, ${error.response?.data}');
        } else if (error.type == DioErrorType.other) {
          print('DioError other: ${error.error}');
        } else {
          print('DioError: ${error.message}');
        }
      }
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
