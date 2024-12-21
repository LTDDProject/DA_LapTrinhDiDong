import 'package:flutter/material.dart';
import '../../services/user_service.dart';
import '../../models/user.dart';
import 'user_detail_page.dart';

class UserListPage extends StatefulWidget {
  const UserListPage({Key? key}) : super(key: key);

  @override
  _UserListPageState createState() => _UserListPageState();
}

class _UserListPageState extends State<UserListPage> {
  final UserService userService = UserService();
  List<User> users = [];

  @override
  void initState() {
    super.initState();
    fetchUsers();
  }

  void fetchUsers() async {
    try {
      final fetchedUsers = await userService.fetchUsers();
      setState(() {
        users = fetchedUsers;
      });
    } catch (error) {
      print("Error fetching users: $error");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Danh sách người dùng"),
        centerTitle: true,  // Center title for better alignment on small screens
      ),
      body: users.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
        itemCount: users.length,
        itemBuilder: (context, index) {
          final user = users[index];
          return Card(
            margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
            elevation: 5,
            child: ListTile(
              contentPadding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
              leading: CircleAvatar(
                backgroundColor: Colors.blue,
                child: Text(
                  user.username[0].toUpperCase(),
                  style: const TextStyle(color: Colors.white, fontSize: 20),
                ),
              ),
              title: Text(
                user.username,
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              subtitle: Text(
                user.email,
                style: const TextStyle(fontSize: 16),
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => UserDetailPage(userId: user.userId),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
