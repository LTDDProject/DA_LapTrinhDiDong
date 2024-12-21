import 'package:flutter/material.dart';
import '../../models/category.dart';
import '../../services/category_service.dart';
import 'category_add_page.dart';
import 'category_edit_page.dart';
import 'category_detail_page.dart';

class CategoryListPage extends StatefulWidget {
  @override
  _CategoryListPageState createState() => _CategoryListPageState();
}

class _CategoryListPageState extends State<CategoryListPage> {
  late Future<List<Category>> categories;

  @override
  void initState() {
    super.initState();
    categories = CategoryApi().fetchCategories(); // Fetch categories
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Categories'),
      ),
      body: FutureBuilder<List<Category>>(
        future: categories,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          if (snapshot.data == null || snapshot.data!.isEmpty) {
            return Center(child: Text('No categories available'));
          }

          final categories = snapshot.data!;
          return ListView.builder(
            itemCount: categories.length,
            itemBuilder: (context, index) {
              final category = categories[index];
              return Card(
                margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                elevation: 2,
                child: ListTile(
                  title: Text(category.categoryName),
                  subtitle: Text(category.description ?? 'No description'),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: Icon(Icons.edit),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => CategoryEditPage(category: category),
                            ),
                          );
                        },
                      ),
                      IconButton(
                        icon: Icon(Icons.delete),
                        onPressed: () {
                          _deleteCategory(category.categoryId);
                        },
                      ),
                    ],
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => CategoryDetailPage(category: category),
                      ),
                    );
                  },
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => CategoryAddPage(),
            ),
          );
        },
        child: Icon(Icons.add),
        tooltip: 'Add Category',
      ),
    );
  }

  void _deleteCategory(int id) async {
    try {
      await CategoryApi().deleteCategory(id);
      setState(() {
        categories = CategoryApi().fetchCategories(); // Refresh list
      });
    } catch (e) {
      _showErrorDialog('Failed to delete category');
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
}
