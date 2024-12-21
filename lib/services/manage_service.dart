import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/manage.dart'; // Assuming Manage is defined in a separate file

class ManageService {
  static const String baseUrl = "https://localhost:5001/api/admin/Manage";

  // Lấy danh sách các quản lý từ API
  Future<List<Manage>> fetchManages() async {
    final response = await http.get(Uri.parse(baseUrl));

    if (response.statusCode == 200) {
      // In ra phản hồi thô để kiểm tra dữ liệu
      print(response.body);

      // Kiểm tra nếu phản hồi không phải là null hoặc rỗng
      if (response.body.isNotEmpty) {
        // Giải mã phản hồi JSON
        final Map<String, dynamic> data = json.decode(response.body);

        // Kiểm tra nếu có khóa '$values' và khóa này không null
        if (data.containsKey('\$values') && data['\$values'] != null) {
          final List<dynamic> manageList = data['\$values'];  // Sử dụng \$values thay vì $values
          return manageList.map((manageJson) => Manage.fromJson(manageJson)).toList();
        } else {
          throw Exception('Không có dữ liệu quản lý trong phản hồi');
        }
      } else {
        throw Exception('Phản hồi từ server rỗng');
      }
    } else {
      throw Exception('Không thể tải danh sách quản lý, mã lỗi: ${response.statusCode}');
    }
  }


  // Thêm tài khoản manage
  Future<void> addManage(Manage manage) async {
    final response = await http.post(
      Uri.parse(baseUrl),
      headers: {"Content-Type": "application/json"},
      body: json.encode(manage.toJson()),  // Chuyển đối tượng Manage thành Map<String, dynamic>
    );

    if (response.statusCode == 201) {
      // Nếu thêm thành công, trả về danh sách mới nhất
      return;
    } else {
      throw Exception('Không thể thêm tài khoản');
    }
  }

  // Cập nhật tài khoản manage
  Future<void> updateManage(Manage manage) async {
    final response = await http.put(
      Uri.parse('$baseUrl/${manage.idMng}'),
      headers: {"Content-Type": "application/json"},
      body: json.encode(manage.toJson()),  // Chuyển đối tượng Manage thành Map<String, dynamic>
    );

    if (response.statusCode == 200) {
      return;
    } else {
      throw Exception('Không thể cập nhật tài khoản');
    }
  }


  // Chuyển trạng thái (khóa/mở khóa)
  Future<void> toggleStatus(int id) async {
    final response = await http.post(
      Uri.parse('$baseUrl/toggle-status/$id'),
    );

    if (response.statusCode != 200) {
      throw Exception('Không thể thay đổi trạng thái');
    }
  }

  // Xóa tài khoản manage
  Future<void> deleteManage(int id) async {
    final response = await http.delete(Uri.parse('$baseUrl/$id'));

    if (response.statusCode != 204) {
      throw Exception('Không thể xóa tài khoản');
    }
  }
}
