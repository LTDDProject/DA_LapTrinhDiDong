class Category {
  final int categoryId;
  final String categoryName;

  Category({
    required this.categoryId,
    required this.categoryName,
  });

  // From JSON to Category object
  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      categoryId: json['categoryId'],
      categoryName: json['categoryName'],
    );
  }

  // To JSON (use when sending data)
  Map<String, dynamic> toJson() {
    return {
      'categoryId': categoryId,
      'categoryName': categoryName,
    };
  }
}

class Tour {
  final int id;
  String tourName;
  DateTime startDate;
  DateTime endDate;
  double price;
  String img;
  String description;
  int quantity;
  int categoryId;
  Category? category; // Thêm thuộc tính Category để ánh xạ qua categoryId

  Tour({
    required this.id,
    required this.tourName,
    required this.startDate,
    required this.endDate,
    required this.price,
    required this.img,
    required this.description,
    required this.quantity,
    required this.categoryId,
    this.category, // Category có thể null hoặc được lấy từ categoryId
  });

  // From JSON to Tour object
  factory Tour.fromJson(Map<String, dynamic> json) {
    return Tour(
      id: json['id'] ?? 0, // Default to 0 if id is null
      tourName: json['tourName'] ?? 'Unknown', // Default to 'Unknown' if tourName is null
      startDate: json['startDate'] != null ? DateTime.parse(json['startDate']) : DateTime.now(),
      endDate: json['endDate'] != null ? DateTime.parse(json['endDate']) : DateTime.now(),
      price: json['price'] != null ? json['price'].toDouble() : 0.0,
      img: json['img'] ?? '', // Default to empty string if img is null
      description: json['description'] ?? '', // Default to empty string if description is null
      quantity: json['quantity'] ?? 0, // Default to 0 if quantity is null
      categoryId: json['categoryId'] ?? 0, // Default to 0 if categoryId is null
      category: json['category'] != null ? Category.fromJson(json['category']) : null, // Lấy thông tin Category nếu có
    );
  }

  // To JSON (use when sending data)
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'tourName': tourName,
      'startDate': startDate.toIso8601String(), // Convert DateTime to ISO string
      'endDate': endDate.toIso8601String(), // Convert DateTime to ISO string
      'price': price,
      'img': img,
      'description': description,
      'quantity': quantity,
      'categoryId': categoryId,
      'category': category?.toJson(), // Lưu thông tin Category
    };
  }
}
