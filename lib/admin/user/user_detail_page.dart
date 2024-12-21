import 'package:flutter/material.dart';
import '../../services/user_service.dart';
import '../../models/user.dart';

class UserDetailPage extends StatefulWidget {
  final int userId;

  const UserDetailPage({Key? key, required this.userId}) : super(key: key);

  @override
  _UserDetailPageState createState() => _UserDetailPageState();
}

class _UserDetailPageState extends State<UserDetailPage> {
  final UserService userService = UserService();
  User? user;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchUserDetails();
  }

  void fetchUserDetails() async {
    try {
      final fetchedUser = await userService.fetchUserDetails(widget.userId);
      setState(() {
        user = fetchedUser;
        isLoading = false;
      });
    } catch (error) {
      setState(() {
        isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error fetching user details: $error")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Chi tiết người dùng"),
        centerTitle: true,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : user == null
          ? const Center(child: Text("Không tìm thấy thông tin người dùng"))
          : SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15.0),
            ),
            elevation: 4,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Ảnh đại diện
                  Center(
                    child: CircleAvatar(
                      radius: 50,
                      backgroundColor: Colors.blue,
                      child: Text(
                        user!.username[0].toUpperCase(),
                        style: const TextStyle(
                          fontSize: 40,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Họ và tên
                  _buildDetailRow("Họ và tên", user!.username),

                  // Email
                  _buildDetailRow("Email", user!.email),

                  // Số điện thoại
                  _buildDetailRow(
                      "Số điện thoại", user!.phone ?? "Không có"),

                  // Địa chỉ
                  _buildDetailRow(
                      "Địa chỉ", user!.address ?? "Không có"),

                  // Ngày sinh
                  _buildDetailRow(
                    "Ngày sinh",
                    user!.dateOfBirth != null
                        ? "${user!.dateOfBirth!.day}/${user!.dateOfBirth!.month}/${user!.dateOfBirth!.year}"
                        : "Không có",
                  ),

                  // Nút quay lại
                  const SizedBox(height: 20),
                  Center(
                    child: ElevatedButton.icon(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: const Icon(Icons.arrow_back),
                      label: const Text("Quay lại"),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 24, vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // Widget hiển thị từng dòng thông tin chi tiết
  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "$label:",
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                fontSize: 18,
                color: Colors.black54,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
