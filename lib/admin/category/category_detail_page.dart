import 'package:flutter/material.dart';
import '../../models/category.dart';

class CategoryDetailPage extends StatelessWidget {
  final Category category;

  CategoryDetailPage({required this.category});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Category Details'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Category Name: ${category.categoryName}', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            SizedBox(height: 12),
            Text('Description: ${category.description ?? 'No description'}', style: TextStyle(fontSize: 16)),
          ],
        ),
      ),
    );
  }
}
