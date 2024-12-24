import 'package:flutter/material.dart';
import '../../models/vehicle.dart';
import '../../services/vehicle_service.dart';

class VehicleEditPage extends StatefulWidget {
  final Vehicle vehicle;

  VehicleEditPage({required this.vehicle});

  @override
  _VehicleEditPageState createState() => _VehicleEditPageState();
}

class _VehicleEditPageState extends State<VehicleEditPage> {
  late TextEditingController vehicleNameController;
  late TextEditingController descriptionController;

  @override
  void initState() {
    super.initState();
    vehicleNameController = TextEditingController(text: widget.vehicle.vehicleName);
    descriptionController = TextEditingController(text: widget.vehicle.description ?? '');
  }

  void _updateVehicle() async {
    final name = vehicleNameController.text;
    final description = descriptionController.text;
    final vehicle = Vehicle(
      vehicleId: widget.vehicle.vehicleId,
      vehicleName: name,
      description: description

    );

    try {
      await VehicleApi().updateVehicle(widget.vehicle.vehicleId, vehicle);
      Navigator.pop(context); // Close the edit page
    } catch (e) {
      _showErrorDialog('Failed to update vehicle');
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
        title: Text('Edit Vehicle'),
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
              onPressed: _updateVehicle,
              child: Text('Update Vehicle'),
            ),
          ],
        ),
      ),
    );
  }
}
