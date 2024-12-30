class PaymentRequest {
  final int tourId;
  final int userId;
  final double total;

  PaymentRequest({
    required this.tourId,
    required this.userId,
    required this.total,
  });

  Map<String, dynamic> toJson() {
    return {
      'TourId': tourId,
      'UserId': userId,
      'Total': total,
    };
  }
}
