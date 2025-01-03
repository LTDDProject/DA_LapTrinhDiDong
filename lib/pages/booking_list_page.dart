import 'package:flutter/material.dart';
import '../../services/booking_service.dart';
import '../../models/booking.dart';
import '../../services/auth_service.dart';

class UserBookingListPage extends StatefulWidget {
  @override
  _UserBookingListPageState createState() => _UserBookingListPageState();
}

class _UserBookingListPageState extends State<UserBookingListPage> {
  final BookingService _bookingService = BookingService();
  late Future<List<Booking>> _futureBookings = Future.value([]); // Khởi tạo _futureBookings

  @override
  void initState() {
    super.initState();
    _loadUserBookings();
  }

  Future<void> _loadUserBookings() async {
    final userId = await AuthService.getUserId();
    if (userId != null) {
      setState(() {
        _futureBookings = _bookingService.getBookingsByUserId(userId);
      });
    } else {
      setState(() {
        _futureBookings = Future.error("Không tìm thấy thông tin người dùng.");
      });
    }
  }

  Future<void> _cancelBooking(int bookingId) async {
    try {
      final success = await _bookingService.cancelBooking(bookingId);
      if (success) {
        // Reload bookings after canceling
        _loadUserBookings();
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text("Booking đã được hủy thành công!"),
        ));
      } else {
        // Nếu không thành công, hiển thị thông báo lỗi
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text("Lỗi khi hủy booking. Vui lòng thử lại."),
        ));
      }
    } catch (e) {
      // Hiển thị lỗi kết nối nếu có ngoại lệ
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("Lỗi kết nối: ${e.toString()}"),
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Danh sách Booking của bạn"),
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
                      "Tour: ${booking.tourId}\nTổng: \$${booking.total}\nNgày đặt: ${booking.bookingDate?.toLocal().toString().split(' ')[0]}\nTrạng thái: ${booking.status}",
                    ),
                    isThreeLine: true,
                    trailing: IconButton(
                      icon: Icon(Icons.cancel),
                      onPressed: () {
                        // Kiểm tra nếu booking.bookingId không phải là null
                        if (booking.bookingId != null) {
                          _cancelBooking(booking.bookingId!); // Sử dụng dấu `!` để ép kiểu từ int? sang int
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content: Text("ID booking không hợp lệ."),
                          ));
                        }
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
}
