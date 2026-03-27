import 'package:project_alisons/core/network/api_constants.dart';

class ProductModel {
  final String id;
  final String slug;
  final String name;
  final String image;
  final double originalPrice;
  final double currentPrice;
  final String category;
  final String store;
  final String symbolLeft;
  final bool isFavorite;
  final int quantity;

  ProductModel({
    String? id,
    required this.name,
    required this.image,
    required this.originalPrice,
    required this.currentPrice,
    required this.category,
    this.slug = '',
    this.store = '',
    this.symbolLeft = '₹',
    this.isFavorite = false,
    this.quantity = 0,
  }) : id = id ?? slug;

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    final slug = json['slug']?.toString() ?? '';
    final rawImage = json['image']?.toString() ?? '';
    final image = ApiConstants.productImageUrl(rawImage);
    return ProductModel(
      id: slug,
      slug: slug,
      name: json['name']?.toString() ?? '',
      image: image,
      originalPrice: double.tryParse(json['oldprice']?.toString() ?? '0') ?? 0,
      currentPrice: double.tryParse(json['price']?.toString() ?? '0') ?? 0,
      category: json['manufacturer']?.toString() ?? '',
      store: json['store']?.toString() ?? '',
      symbolLeft: json['symbol_left']?.toString() ?? '₹',
    );
  }

  ProductModel copyWith({
    String? id,
    String? slug,
    String? name,
    String? image,
    double? originalPrice,
    double? currentPrice,
    String? category,
    String? store,
    String? symbolLeft,
    bool? isFavorite,
    int? quantity,
  }) {
    return ProductModel(
      id: id ?? this.id,
      slug: slug ?? this.slug,
      name: name ?? this.name,
      image: image ?? this.image,
      originalPrice: originalPrice ?? this.originalPrice,
      currentPrice: currentPrice ?? this.currentPrice,
      category: category ?? this.category,
      store: store ?? this.store,
      symbolLeft: symbolLeft ?? this.symbolLeft,
      isFavorite: isFavorite ?? this.isFavorite,
      quantity: quantity ?? this.quantity,
    );
  }
}
