class Revenue {
  final String quarter;  // Đại diện cho quý
  final double totalRevenue;  // Tổng doanh thu

  Revenue({required this.quarter, required this.totalRevenue});

  // Hàm tạo đối tượng Revenue từ dữ liệu JSON
  factory Revenue.fromJson(Map<String, dynamic> json) {
    // Kiểm tra và xử lý trường hợp có thể null
    return Revenue(
      quarter: json['quarter'] ?? 'Unknown',  // Nếu 'quarter' là null, gán 'Unknown' thay thế
      totalRevenue: json['totalRevenue'] != null ? json['totalRevenue'].toDouble() : 0.0,  // Nếu 'totalRevenue' là null, gán 0.0 thay thế
    );
  }
}
