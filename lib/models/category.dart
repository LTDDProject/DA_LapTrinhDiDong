class Category {
  int categoryId;
  String categoryName;
  String? description;

  Category({
    required this.categoryId,
    required this.categoryName,
    this.description,
  });

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      categoryId: json['categoryId'],
      categoryName: json['categoryName'],
      description: json['description'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'categoryId': categoryId,
      'categoryName': categoryName,
      'description': description,
    };
  }
}
