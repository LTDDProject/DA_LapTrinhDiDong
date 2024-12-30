import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/category.dart';

class CategoryApi {
  static const String baseUrl = "http://192.168.1.107:5001/api/CategoriesApi";

  // Lấy tất cả danh mục
  Future<List<Category>> fetchCategories() async {
    final response = await http.get(Uri.parse(baseUrl));

    if (response.statusCode == 200) {
      // Giải mã phản hồi JSON
      final Map<String, dynamic> data = json.decode(response.body);

      // Truy xuất khóa '$values' để lấy danh sách các danh mục
      final List<dynamic> categoryList = data['\$values'];

      // Chuyển đổi danh sách các đối tượng JSON thành các đối tượng Category
      return categoryList.map((categoryJson) => Category.fromJson(categoryJson)).toList();
    } else {
      throw Exception('Lỗi khi tải danh mục');
    }
  }

  // Tạo một danh mục mới
  Future<Category> createCategory(Category category) async {
    final response = await http.post(
      Uri.parse(baseUrl),
      headers: {"Content-Type": "application/json"},
      body: json.encode(category.toJson()),
    );

    if (response.statusCode == 201) {
      return Category.fromJson(json.decode(response.body));
    } else {
      throw Exception('Lỗi khi tạo danh mục');
    }
  }

  // Cập nhật một danh mục đã tồn tại
  Future<void> updateCategory(int id, Category category) async {
    final response = await http.put(
      Uri.parse('$baseUrl/$id'),
      headers: {"Content-Type": "application/json"},
      body: json.encode(category.toJson()),
    );

    if (response.statusCode != 204) {
      throw Exception('Lỗi khi cập nhật danh mục');
    }
  }

  // Xóa một danh mục
  Future<void> deleteCategory(int id) async {
    final response = await http.delete(Uri.parse('$baseUrl/$id'));

    if (response.statusCode != 204) {
      throw Exception('Lỗi khi xóa danh mục');
    }
  }
}
