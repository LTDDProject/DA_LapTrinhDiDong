class Vehicle {
  final int vehicleId;
  final String vehicleName;
  final String description;

  Vehicle({
    required this.vehicleId,
    required this.vehicleName,
    required this.description,
  });

  // Factory constructor để tạo đối tượng Vehicle từ JSON
  factory Vehicle.fromJson(Map<String, dynamic> json) {
    return Vehicle(
      vehicleId: json['vehicleId'],
      vehicleName: json['vehicleName'],
      description: json['description'],
    );
  }

  // Phương thức toJson để chuyển đối tượng Vehicle thành JSON
  Map<String, dynamic> toJson() {
    return {
      'vehicleId': vehicleId,
      'vehicleName': vehicleName,
      'description': description,
    };
  }
}
