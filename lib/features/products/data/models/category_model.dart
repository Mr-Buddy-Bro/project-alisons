import 'package:project_alisons/core/network/api_constants.dart';

class CategoryModel {
  final String id;
  final String slug;
  final String name;
  final String image;
  final String description;

  CategoryModel({
    required this.id,
    required this.name,
    required this.image,
    this.slug = '',
    this.description = '',
  });

  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    // API wraps category inside a 'category' key with a 'subcategory' sibling
    final cat = json['category'] as Map<String, dynamic>? ?? json;
    final rawImage = cat['image']?.toString() ?? '';
    return CategoryModel(
      id: cat['id']?.toString() ?? '',
      slug: cat['slug']?.toString() ?? '',
      name: cat['name']?.toString() ?? '',
      image: ApiConstants.categoryImageUrl(rawImage),
      description: cat['description']?.toString() ?? '',
    );
  }
}
