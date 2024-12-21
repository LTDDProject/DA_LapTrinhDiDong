import 'package:flutter/material.dart';
import '../../models/category.dart';
import '../../services/category_service.dart';

class CategoryAddPage extends StatefulWidget {
  @override
  _CategoryAddPageState createState() => _CategoryAddPageState();
}

class _CategoryAddPageState extends State<CategoryAddPage> {
  final categoryNameController = TextEditingController();
  final descriptionController = TextEditingController();

  void _addCategory() async {
    final name = categoryNameController.text;
    final description = descriptionController.text;
    final category = Category(categoryId: 0, categoryName: name, description: description);

    try {
      await CategoryApi().createCategory(category);
      Navigator.pop(context); // Close the add category page
    } catch (e) {
      _showErrorDialog('Failed to add category');
    }
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Error'),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Category'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: categoryNameController,
              decoration: InputDecoration(labelText: 'Category Name'),
            ),
            SizedBox(height: 12),
            TextField(
              controller: descriptionController,
              decoration: InputDecoration(labelText: 'Description'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _addCategory,
              child: Text('Add Category'),
            ),
          ],
        ),
      ),
    );
  }
}
