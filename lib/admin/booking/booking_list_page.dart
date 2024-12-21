import 'package:flutter/material.dart';
import '../../services/booking_service.dart';
import '../../models/booking.dart';

class BookingListPage extends StatefulWidget {
  @override
  _BookingListPageState createState() => _BookingListPageState();
}

class _BookingListPageState extends State<BookingListPage> {
  final BookingService _bookingService = BookingService();
  late Future<List<Booking>> _futureBookings;

  @override
  void initState() {
    super.initState();
    _futureBookings = _bookingService.getBookings();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Danh sách Booking"),
      ),
      body: FutureBuilder<List<Booking>>(
        future: _futureBookings,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text("Lỗi: ${snapshot.error}"));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text("Không có booking nào."));
          } else {
            final bookings = snapshot.data!;
            return ListView.builder(
              itemCount: bookings.length,
              itemBuilder: (context, index) {
                final booking = bookings[index];
                return Card(
                  margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: ListTile(
                    title: Text("Booking ID: ${booking.bookingId}"),
                    subtitle: Text(
                        "User ID: ${booking.userId}\nTour ID: ${booking.tourId}\nTổng: \$${booking.total}\nNgày đặt: ${booking.bookingDate?.toLocal().toString().split(' ')[0]}\nTrạng thái: ${booking.status}"),
                    isThreeLine: true,
                    trailing: IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      onPressed: () async {
                        await _deleteBooking(booking.bookingId!);
                      },
                    ),
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }

  Future<void> _deleteBooking(int bookingId) async {
    try {
      await _bookingService.deleteBooking(bookingId);
      setState(() {
        _futureBookings = _bookingService.getBookings(); // Refresh bookings list
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Xóa booking thành công!")),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Lỗi khi xóa booking: $e")),
      );
    }
  }
}
