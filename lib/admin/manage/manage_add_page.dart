import 'package:flutter/material.dart';
import '../../services/manage_service.dart';
import '../../models/manage.dart';

class AddManageForm extends StatefulWidget {
  final ManageService manageService;
  final VoidCallback onAdded;  // Add the callback parameter

  AddManageForm({required this.manageService, required this.onAdded});

  @override
  _AddManageFormState createState() => _AddManageFormState();
}

class _AddManageFormState extends State<AddManageForm> {
  final _formKey = GlobalKey<FormState>();
  late String username;
  late String password;
  bool role = false;
  String status = 'Unlocked';

  void _submitForm() async {
    if (_formKey.currentState?.validate() ?? false) {
      _formKey.currentState?.save();
      final newManage = Manage(
        idMng: 0,  // id sẽ được gán tự động từ API
        username: username,
        password: password,
        role: role,
        status: status,
      );
      try {
        await widget.manageService.addManage(newManage); // Call service to add the new manage
        widget.onAdded();  // Call the callback to refresh the list
        Navigator.pop(context);  // Close the form after adding the new account
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Tài khoản đã được thêm thành công')));
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Không thể thêm tài khoản')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Thêm tài khoản quản lý'),
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              decoration: InputDecoration(labelText: 'Username'),
              validator: (value) => value!.isEmpty ? 'Vui lòng nhập tên người dùng' : null,
              onSaved: (value) => username = value!,
            ),
            TextFormField(
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
              onPressed: _submitForm,
              child: Text('Thêm tài khoản'),
            ),
          ],
        ),
      ),
    );
  }
}
