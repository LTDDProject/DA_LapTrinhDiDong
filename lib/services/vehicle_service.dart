import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/vehicle.dart';

class VehicleApi {
  static const String baseUrl = "https://localhost:5001/api/VehiclesApi";

  Future<List<Vehicle>> fetchVehicles() async {
    final response = await http.get(Uri.parse(baseUrl));

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);

      if (data.containsKey('\$values')) {
        final List<dynamic> vehicleList = data['\$values'];

        return vehicleList.map((vehicleJson) => Vehicle.fromJson(vehicleJson)).toList();
      } else {
        throw Exception('Không tìm thấy danh sách phương tiện trong dữ liệu');
      }
    } else {
      throw Exception('Lỗi khi tải phương tiện');
    }
  }

  Future<Vehicle> createVehicle(Vehicle vehicle) async {
    final response = await http.post(
      Uri.parse(baseUrl),
      headers: {"Content-Type": "application/json"},
      body: json.encode(vehicle.toJson()),
    );

    if (response.statusCode == 201) {
      return Vehicle.fromJson(json.decode(response.body));
    } else {
      throw Exception('Lỗi khi tạo phương tiện');
    }
  }

  Future<void> updateVehicle(int id, Vehicle vehicle) async {
    final response = await http.put(
      Uri.parse('$baseUrl/$id'),
      headers: {"Content-Type": "application/json"},
      body: json.encode(vehicle.toJson()),
    );

    if (response.statusCode != 204) {
      throw Exception('Lỗi khi cập nhật phương tiện');
    }
  }

  Future<void> deleteVehicle(int id) async {
    final response = await http.delete(Uri.parse('$baseUrl/$id'));

    if (response.statusCode != 204) {
      throw Exception('Lỗi khi xóa phương tiện');
    }
  }
}
