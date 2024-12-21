import 'dart:convert';

class User {
  int userId;
  String username;
  String password;
  String email;
  String phone;
  DateTime? dateOfBirth;
  String? address;

  // Constructor
  User({
    required this.userId,
    required this.username,
    required this.password,
    required this.email,
    required this.phone,
    this.dateOfBirth,
    this.address,
  });

  // Chuyển từ JSON sang User object
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      userId: json['userId'],
      username: json['username'],
      password: json['password'],
      email: json['email'],
      phone: json['phone'],
      dateOfBirth: json['dateOfBirth'] != null
          ? DateTime.parse(json['dateOfBirth'])
          : null,
      address: json['address'],
    );
  }

  // Chuyển từ User object sang JSON
  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'username': username,
      'password': password,
      'email': email,
      'phone': phone,
      'dateOfBirth': dateOfBirth?.toIso8601String(),
      'address': address,
    };
  }
}
