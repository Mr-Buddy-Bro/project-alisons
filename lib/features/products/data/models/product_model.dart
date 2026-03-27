class ProductModel {
  final String id;
  final String name;
  final String image;
  final double originalPrice;
  final double currentPrice;
  final String category;
  final bool isFavorite;
  final int quantity;

  ProductModel({
    required this.id,
    required this.name,
    required this.image,
    required this.originalPrice,
    required this.currentPrice,
    required this.category,
    this.isFavorite = false,
    this.quantity = 0,
  });

  ProductModel copyWith({
    String? id,
    String? name,
    String? image,
    double? originalPrice,
    double? currentPrice,
    String? category,
    bool? isFavorite,
    int? quantity,
  }) {
    return ProductModel(
      id: id ?? this.id,
      name: name ?? this.name,
      image: image ?? this.image,
      originalPrice: originalPrice ?? this.originalPrice,
      currentPrice: currentPrice ?? this.currentPrice,
      category: category ?? this.category,
      isFavorite: isFavorite ?? this.isFavorite,
      quantity: quantity ?? this.quantity,
    );
  }
}
