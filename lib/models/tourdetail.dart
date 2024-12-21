class TourDetail {
  int? tourDetailId;
  Tour? tour;
  Hotel? hotel;
  Vehicle? vehicle;

  TourDetail({
    this.tourDetailId,
    this.tour,
    this.vehicle,
    this.hotel,
  });

  // Phương thức từ JSON
  factory TourDetail.fromJson(Map<String, dynamic> json) {
    return TourDetail(
      // Sử dụng int.tryParse để chuyển chuỗi sang int, nếu không phải số thì trả về null
      tourDetailId: json['tourDetailId'] != null
          ? int.tryParse(json['tourDetailId'].toString())
          : null,
      tour: json['tourName'] != null ? Tour.fromJson({'tourName': json['tourName']}) : null,
      vehicle: json['vehicleName'] != null ? Vehicle.fromJson({'vehicleName': json['vehicleName']}) : null,
      hotel: json['hotelName'] != null ? Hotel.fromJson({'hotelName': json['hotelName']}) : null,
    );
  }

  // Phương thức chuyển đối tượng thành JSON
  Map<String, dynamic> toJson() {
    return {
      'tourDetailId': tourDetailId,
      'tourName': tour?.tourName,
      'vehicleName': vehicle?.vehicleName,
      'hotelName': hotel?.name,
    };
  }
}

class Hotel {
  final String? name;

  Hotel({this.name});

  // Phương thức từ JSON
  factory Hotel.fromJson(Map<String, dynamic> json) {
    return Hotel(name: json['hotelName']);
  }

  // Phương thức chuyển đối tượng thành JSON
  Map<String, dynamic> toJson() {
    return {
      'hotelName': name,
    };
  }
}

class Vehicle {
  final String? vehicleName;

  Vehicle({this.vehicleName});

  // Phương thức từ JSON
  factory Vehicle.fromJson(Map<String, dynamic> json) {
    return Vehicle(vehicleName: json['vehicleName']);
  }

  // Phương thức chuyển đối tượng thành JSON
  Map<String, dynamic> toJson() {
    return {
      'vehicleName': vehicleName,
    };
  }
}

class Tour {
  final String? tourName;

  Tour({this.tourName});

  // Phương thức từ JSON
  factory Tour.fromJson(Map<String, dynamic> json) {
    return Tour(tourName: json['tourName']);
  }

  // Phương thức chuyển đối tượng thành JSON
  Map<String, dynamic> toJson() {
    return {
      'tourName': tourName,
    };
  }
}
