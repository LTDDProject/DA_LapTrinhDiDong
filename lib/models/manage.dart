class Manage {
  final int idMng;
  final String username;
  final String password;
  final bool role;
  final String status;

  Manage({
    required this.idMng,
    required this.username,
    required this.password,
    required this.role,
    required this.status,
  });

  // Factory constructor to create a Manage object from JSON
  factory Manage.fromJson(Map<String, dynamic> json) {
    return Manage(
      idMng: json['idMng'] ?? 0,  // Gán giá trị mặc định nếu null
      username: json['username'] ?? 'Unknown', // Gán giá trị mặc định nếu null
      password: json['password'] ?? 'NoPassword', // Gán giá trị mặc định nếu null
      role: json['role'] ?? false, // Gán giá trị mặc định nếu null
      status: json['status'] ?? 'Unlocked',  // Gán giá trị mặc định nếu null
    );
  }


  // Method to convert the Manage object to JSON
  Map<String, dynamic> toJson() {
    return {
      'IdMng': idMng,
      'Username': username,
      'Password': password,
      'Role': role,
      'Status': status,
    };
  }
}
