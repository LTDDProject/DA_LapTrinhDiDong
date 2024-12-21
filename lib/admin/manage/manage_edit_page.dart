import 'package:flutter/material.dart';
import '../../services/manage_service.dart';
import '../../models/manage.dart';

class EditManageForm extends StatefulWidget {
  final Manage manage;
  final ManageService manageService;
  final VoidCallback onUpdated;  // Add the callback here

  EditManageForm({required this.manage, required this.manageService, required this.onUpdated});

  @override
  _EditManageFormState createState() => _EditManageFormState();
}

class _EditManageFormState extends State<EditManageForm> {
  final _formKey = GlobalKey<FormState>();
  late String username;
  late String password;
  late bool role;
  late String status;
  bool isLoading = false;

  void _submitForm() async {
    if (_formKey.currentState?.validate() ?? false) {
      _formKey.currentState?.save();
      setState(() {
        isLoading = true;
      });

      final updatedManage = Manage(
        idMng: widget.manage.idMng,  // Giữ nguyên idMng
        username: username,
        password: password,
        role: role,
        status: status,
      );

      try {
        await widget.manageService.updateManage(updatedManage);
        setState(() {
          isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Cập nhật tài khoản thành công')));
        widget.onUpdated();  // Call the callback to refresh the list
        Navigator.pop(context);  // Đóng form sau khi cập nhật thành công
      } catch (e) {
        setState(() {
          isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Không thể cập nhật tài khoản')));
      }
    }
  }

  @override
  void initState() {
    super.initState();
    username = widget.manage.username;
    password = widget.manage.password;
    role = widget.manage.role;
    status = widget.manage.status;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Chỉnh sửa tài khoản quản lý'),
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              initialValue: username,
              decoration: InputDecoration(labelText: 'Username'),
              validator: (value) => value!.isEmpty ? 'Vui lòng nhập tên người dùng' : null,
              onSaved: (value) => username = value!,
            ),
            TextFormField(
              initialValue: password,
              decoration: InputDecoration(labelText: 'Password'),
              obscureText: true,
              validator: (value) => value!.isEmpty ? 'Vui lòng nhập mật khẩu' : null,
              onSaved: (value) => password = value!,
            ),
            SwitchListTile(
              title: Text('Role'),
              value: role,
              onChanged: (value) {
                setState(() {
                  role = value;
                });
              },
            ),
            DropdownButton<String>(
              value: status,
              onChanged: (String? newValue) {
                setState(() {
                  status = newValue!;
                });
              },
              items: <String>['Unlocked', 'Locked']
                  .map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            ),
            ElevatedButton(
              onPressed: isLoading ? null : _submitForm,
              child: isLoading ? CircularProgressIndicator() : Text('Lưu thay đổi'),
            ),
          ],
        ),
      ),
    );
  }
}
