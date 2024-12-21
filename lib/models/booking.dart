
class Booking {
  int? bookingId;
  int? userId;
  int? tourId;
  double? total;
  DateTime? bookingDate;
  String? status;

  Booking({
    this.bookingId,
    this.userId,
    this.tourId,
    this.total,
    this.bookingDate,
    this.status,
  });

  // Parse from JSON
  factory Booking.fromJson(Map<String, dynamic> json) {
    return Booking(
      bookingId: json['bookingId'],
      userId: json['userId'],
      tourId: json['tourId'],
      total: (json['total'] != null) ? json['total'].toDouble() : 0.0,
      bookingDate: (json['bookingDate'] != null) ? DateTime.parse(json['bookingDate']) : null,
      status: json['status'] ?? 'Không xác định', // Giá trị mặc định
    );
  }


  // Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'bookingId': bookingId,
      'userId': userId,
      'tourId': tourId,
      'total': total,
      'bookingDate': bookingDate?.toIso8601String(),
      'status': status,
    };
  }
}