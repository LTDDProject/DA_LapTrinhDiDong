import 'package:flutter/material.dart';
import '../../models/category.dart';
import '../../services/category_service.dart';

class CategoryEditPage extends StatefulWidget {
  final Category category;

  CategoryEditPage({required this.category});

  @override
  _CategoryEditPageState createState() => _CategoryEditPageState();
}

class _CategoryEditPageState extends State<CategoryEditPage> {
  late TextEditingController categoryNameController;
  late TextEditingController descriptionController;

  @override
  void initState() {
    super.initState();
    categoryNameController = TextEditingController(text: widget.category.categoryName);
    descriptionController = TextEditingController(text: widget.category.description ?? '');
  }

  void _updateCategory() async {
    final name = categoryNameController.text;
    final description = descriptionController.text;
    final category = Category(categoryId: widget.category.categoryId, categoryName: name, description: description);

    try {
      await CategoryApi().updateCategory(widget.category.categoryId, category);
      Navigator.pop(context); // Close the edit page
    } catch (e) {
      _showErrorDialog('Failed to update category');
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
        title: Text('Edit Category'),
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
              onPressed: _updateCategory,
              child: Text('Update Category'),
            ),
          ],
        ),
      ),
    );
  }
}
