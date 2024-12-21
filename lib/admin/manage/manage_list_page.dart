import 'package:flutter/material.dart';
import '../../services/manage_service.dart';
import '../../models/manage.dart';
import 'manage_add_page.dart';
import 'manage_edit_page.dart';
import 'manage_detail_page.dart'; // Import the ManageDetailPage

class ManagePage extends StatefulWidget {
  @override
  _ManagePageState createState() => _ManagePageState();
}

class _ManagePageState extends State<ManagePage> {
  List<Manage> manages = [];
  final ManageService manageService = ManageService(); // Tạo instance của ManageService

  @override
  void initState() {
    super.initState();
    fetchManages();
  }

  // Lấy danh sách quản lý từ API
  Future<void> fetchManages() async {
    try {
      var fetchedManages = await manageService.fetchManages();
      setState(() {
        manages = fetchedManages;
      });
    } catch (e) {
      print('Lỗi khi lấy dữ liệu quản lý: $e');
    }
  }

  // Thay đổi trạng thái (khóa/mở khóa)
  Future<void> toggleStatus(int id) async {
    try {
      await manageService.toggleStatus(id);
      fetchManages();  // Làm mới danh sách sau khi thay đổi trạng thái
    } catch (e) {
      print('Lỗi khi thay đổi trạng thái: $e');
    }
  }

  // Xóa tài khoản quản lý
  Future<void> deleteManage(int id) async {
    try {
      await manageService.deleteManage(id);
      fetchManages();  // Làm mới danh sách sau khi xóa
    } catch (e) {
      print('Lỗi khi xóa quản lý: $e');
    }
  }

  // Hiển thị form chỉnh sửa
  void _showEditForm(Manage manage) {
    showDialog(
      context: context,
      builder: (context) => EditManageForm(
        manage: manage,
        manageService: manageService,
        onUpdated: fetchManages,  // Truyền callback để làm mới danh sách
      ),
    );
  }

  // Hiển thị form thêm mới
  void _showAddForm() {
    showDialog(
      context: context,
      builder: (context) => AddManageForm(
        manageService: manageService,
        onAdded: fetchManages,  // Truyền callback để làm mới danh sách
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Quản lý tài khoản'),
        backgroundColor: Colors.blueAccent,
      ),
      body: ListView.builder(
        itemCount: manages.length,
        itemBuilder: (context, index) {
          var manage = manages[index];
          return Card(
            margin: EdgeInsets.symmetric(vertical: 8, horizontal: 10),
            elevation: 5,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: ListTile(
              contentPadding: EdgeInsets.all(10),
              title: Text(
                manage.username,
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              subtitle: Text(
                'Trạng thái: ${manage.status}\nVai trò: ${manage.role ? "Admin" : "Nhân viên"}',
                style: TextStyle(color: Colors.grey[600]),
              ),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: Icon(Icons.lock),
                    onPressed: () => toggleStatus(manage.idMng),
                    tooltip: 'Thay đổi trạng thái',
                  ),
                  IconButton(
                    icon: Icon(Icons.edit),
                    onPressed: () => _showEditForm(manage),
                    tooltip: 'Chỉnh sửa',
                  ),
                  IconButton(
                    icon: Icon(Icons.delete),
                    onPressed: () => deleteManage(manage.idMng),
                    tooltip: 'Xóa',
                  ),
                  IconButton(
                    icon: Icon(Icons.visibility),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ManageDetailPage(manage: manage),
                        ),
                      );
                    },
                    tooltip: 'Xem chi tiết',
                  ),
                ],
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddForm,
        child: Icon(Icons.add),
      ),
    );
  }
}
