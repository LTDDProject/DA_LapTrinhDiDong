import 'package:flutter/material.dart';
import '../../models/hotel.dart';
import '../../services/hotel_service.dart';
import 'hotel_add_page.dart';
import 'hotel_edit_page.dart';
import 'hotel_detail_page.dart';

class HotelListPage extends StatefulWidget {
  @override
  _HotelListPageState createState() => _HotelListPageState();
}

class _HotelListPageState extends State<HotelListPage> {
  late Future<List<Hotel>> hotels;

  @override
  void initState() {
    super.initState();
    hotels = HotelApi().fetchHotels(); // Fetch hotels
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Hotels'),
      ),
      body: FutureBuilder<List<Hotel>>(
        future: hotels,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          if (snapshot.data == null || snapshot.data!.isEmpty) {
            return Center(child: Text('No hotels available'));
          }

          final hotelsList = snapshot.data!; // Avoid name conflict
          return ListView.builder(
            itemCount: hotelsList.length,
            itemBuilder: (context, index) {
              final hotel = hotelsList[index];
              return Card(
                margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                elevation: 2,
                child: ListTile(
                  title: Text(hotel.hotelName),
                  subtitle: Text(hotel.description ?? 'No description'),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: Icon(Icons.edit),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => HotelEditPage(hotel: hotel),
                            ),
                          );
                        },
                      ),
                      IconButton(
                        icon: Icon(Icons.delete),
                        onPressed: () {
                          _deleteHotel(hotel.hotelId, hotelsList);
                        },
                      ),
                    ],
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => HotelDetailPage(hotel: hotel),
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
              builder: (context) => HotelAddPage(),
            ),
          );
        },
        child: Icon(Icons.add),
        tooltip: 'Add Hotel',
      ),
    );
  }

  // Xóa khách sạn và cập nhật lại danh sách
  void _deleteHotel(int id, List<Hotel> currentHotels) async {
    try {
      await HotelApi().deleteHotel(id);
      // Cập nhật lại danh sách sau khi xóa
      setState(() {
        currentHotels.removeWhere((hotel) => hotel.hotelId == id);
      });
      _showSuccessDialog('Hotel deleted successfully!');
    } catch (e) {
      _showErrorDialog('Failed to delete hotel');
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

  // Hiển thị hộp thoại thành công khi xóa khách sạn
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
