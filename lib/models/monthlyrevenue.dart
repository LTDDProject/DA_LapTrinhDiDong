class MonthlyRevenue {
  final int year;
  final int month;
  final double totalRevenue;

  MonthlyRevenue({
    required this.year,
    required this.month,
    required this.totalRevenue,
  });

  factory MonthlyRevenue.fromJson(Map<String, dynamic> json) {
    return MonthlyRevenue(
      // Kiểm tra nếu 'Year' là null thì thay bằng giá trị mặc định, ví dụ: 0
      year: json['Year'] != null ? json['Year'] as int : 0,
      // Kiểm tra nếu 'Month' là null thì thay bằng giá trị mặc định, ví dụ: 0
      month: json['Month'] != null ? json['Month'] as int : 0,
      // Kiểm tra nếu 'TotalRevenue' là null thì thay bằng giá trị mặc định, ví dụ: 0.0
      totalRevenue: json['TotalRevenue'] != null
          ? (json['TotalRevenue'] as num).toDouble()
          : 0.0,
    );
  }
}
