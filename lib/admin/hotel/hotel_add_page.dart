import 'package:flutter/material.dart';
import '../../models/hotel.dart';
import '../../services/hotel_service.dart';

class HotelAddPage extends StatefulWidget {
  @override
  _HotelAddPageState createState() => _HotelAddPageState();
}

class _HotelAddPageState extends State<HotelAddPage> {
  final hotelNameController = TextEditingController();
  final descriptionController = TextEditingController();
  final addressController = TextEditingController();

  void _addHotel() async {
    final name = hotelNameController.text;
    final description = descriptionController.text;
    final address = addressController.text;
    final hotel = Hotel(hotelId: 0, hotelName: name, description: description, address: address);

    try {
      await HotelApi().createHotel(hotel);
      Navigator.pop(context); // Close the add hotel page
    } catch (e) {
      _showErrorDialog('Failed to add hotel');
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
        title: Text('Add Hotel'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: hotelNameController,
              decoration: InputDecoration(labelText: 'Hotel Name'),
            ),
            SizedBox(height: 12),
            TextField(
              controller: descriptionController,
              decoration: InputDecoration(labelText: 'Description'),
            ),
            SizedBox(height: 20),
            TextField(
              controller: addressController,
              decoration: InputDecoration(labelText: 'Address'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _addHotel,
              child: Text('Add Hotel'),
            ),
          ],
        ),
      ),
    );
  }
}
