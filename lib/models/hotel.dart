class Hotel {
  final int hotelId;
  final String hotelName;
  final String description;
  final String address;

  Hotel({
    required this.hotelId,
    required this.hotelName,
    required this.description,
    required this.address,
  });


  factory Hotel.fromJson(Map<String, dynamic> json) {
    return Hotel(
      hotelId: json['hotelId'] ?? 0,
      hotelName: json['hotelName'] ?? 'Unknown',
      description: json['description'] ?? 'No Description',
      address: json['address'] ?? 'No Address',
    );
  }


  Map<String, dynamic> toJson() {
    return {
      'hotelId': hotelId,
      'hotelName': hotelName,
      'description': description,
      'address': address,
    };
  }
}
