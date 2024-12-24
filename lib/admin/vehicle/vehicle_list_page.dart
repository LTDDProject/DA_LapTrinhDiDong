import 'package:flutter/material.dart';
import '../../models/vehicle.dart';
import '../../services/vehicle_service.dart';
import 'vehicle_add_page.dart';
import 'vehicle_edit_page.dart';
import 'vehicle_detail_page.dart';

class VehicleListPage extends StatefulWidget {
  @override
  _VehicleListPageState createState() => _VehicleListPageState();
}

class _VehicleListPageState extends State<VehicleListPage> {
  late Future<List<Vehicle>> vehicles;

  @override
  void initState() {
    super.initState();
    vehicles = VehicleApi().fetchVehicles(); // Fetch vehicles
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Vehicles'),
      ),
      body: FutureBuilder<List<Vehicle>>(
        future: vehicles,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          if (snapshot.data == null || snapshot.data!.isEmpty) {
            return Center(child: Text('No vehicles available'));
          }

          final vehiclesList = snapshot.data!;
          return ListView.builder(
            itemCount: vehiclesList.length,
            itemBuilder: (context, index) {
              final vehicle = vehiclesList[index];
              return Card(
                margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                elevation: 2,
                child: ListTile(
                  title: Text(vehicle.vehicleName),
                  subtitle: Text(vehicle.description),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: Icon(Icons.edit),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => VehicleEditPage(vehicle: vehicle),
                            ),
                          );
                        },
                      ),
                      IconButton(
                        icon: Icon(Icons.delete),
                        onPressed: () {
                          _deleteVehicle(vehicle.vehicleId, vehiclesList);
                        },
                      ),
                    ],
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => VehicleDetailPage(vehicle: vehicle),
                      ),
                    );
                  },
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => VehicleAddPage(),
            ),
          );
        },
        child: Icon(Icons.add),
        tooltip: 'Add Vehicle',
      ),
    );
  }

  // Xóa phương tiện và cập nhật lại danh sách
  void _deleteVehicle(int id, List<Vehicle> currentVehicles) async {
    try {
      await VehicleApi().deleteVehicle(id);
      // Cập nhật lại danh sách sau khi xóa
      setState(() {
        currentVehicles.removeWhere((vehicle) => vehicle.vehicleId == id);
      });
      _showSuccessDialog('Vehicle deleted successfully!');
    } catch (e) {
      _showErrorDialog('Failed to delete vehicle');
    }
  }

  // Hiển thị hộp thoại lỗi
  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Error'),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }

  // Hiển thị hộp thoại thành công khi xóa phương tiện
  void _showSuccessDialog(String message) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Success'),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }
}
