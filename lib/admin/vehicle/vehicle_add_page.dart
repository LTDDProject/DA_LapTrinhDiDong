import 'package:flutter/material.dart';
import '../../models/vehicle.dart';
import '../../services/vehicle_service.dart';

class VehicleAddPage extends StatefulWidget {
  @override
  _VehicleAddPageState createState() => _VehicleAddPageState();
}

class _VehicleAddPageState extends State<VehicleAddPage> {
  final vehicleNameController = TextEditingController();
  final descriptionController = TextEditingController();

  void _addVehicle() async {
    final name = vehicleNameController.text;
    final description = descriptionController.text;
    final vehicle = Vehicle(vehicleId: 0, vehicleName: name, description: description);

    try {
      await VehicleApi().createVehicle(vehicle);
      Navigator.pop(context); // Close the add vehicle page
    } catch (e) {
      _showErrorDialog('Failed to add vehicle');
    }
  }

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Vehicle'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: vehicleNameController,
              decoration: InputDecoration(labelText: 'Vehicle Name'),
            ),
            SizedBox(height: 12),
            TextField(
              controller: descriptionController,
              decoration: InputDecoration(labelText: 'Description'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _addVehicle,
              child: Text('Add Vehicle'),
            ),
          ],
        ),
      ),
    );
  }
}
