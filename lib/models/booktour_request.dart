class BookTourRequest {
  final int tourId;
  final int quantity;
  final int userId;  // Add userId here

  BookTourRequest({
    required this.tourId,
    required this.quantity,
    required this.userId,  // Pass userId when creating the object
  });

  // Convert the object to JSON for the request body
  Map<String, dynamic> toJson() {
    return {
      'tourId': tourId,
      'quantity': quantity,
      'userId': userId,  // Include userId in the JSON
    };
  }
}
