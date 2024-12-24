import 'package:flutter/material.dart';
import '../../models/hotel.dart';
import '../../services/hotel_service.dart';

class HotelEditPage extends StatefulWidget {
  final Hotel hotel;

  HotelEditPage({required this.hotel});

  @override
  _HotelEditPageState createState() => _HotelEditPageState();
}

class _HotelEditPageState extends State<HotelEditPage> {
  late TextEditingController hotelNameController;
  late TextEditingController descriptionController;
  late TextEditingController addressController;

  @override
  void initState() {
    super.initState();
    hotelNameController = TextEditingController(text: widget.hotel.hotelName);
    descriptionController = TextEditingController(text: widget.hotel.description ?? '');
    addressController = TextEditingController(text: widget.hotel.address ?? '');
  }

  void _updateHotel() async {
    final name = hotelNameController.text;
    final description = descriptionController.text;
    final address = addressController.text;
    final hotel = Hotel(
        hotelId: widget.hotel.hotelId,
        hotelName: name,
        description: description,
        address: address);

    try {
      await HotelApi().updateHotel(widget.hotel.hotelId, hotel);
      Navigator.pop(context); // Close the edit page
    } catch (e) {
      _showErrorDialog('Failed to update hotel');
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
        title: Text('Edit Hotel'),
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
            SizedBox(height: 12),
            TextField(
              controller: addressController,
              decoration: InputDecoration(labelText: 'Address'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _updateHotel,
              child: Text('Update Hotel'),
            ),
          ],
        ),
      ),
    );
  }
}
