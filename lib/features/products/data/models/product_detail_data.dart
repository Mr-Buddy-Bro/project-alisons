import 'package:project_alisons/core/network/api_constants.dart';
import 'package:project_alisons/features/products/data/models/product_model.dart';

class ProductDetailData {
  final ProductModel product;
  final List<ProductModel> relatedProducts;
  final List<String> images;
  final String description;

  ProductDetailData({
    required this.product,
    required this.relatedProducts,
    required this.images,
    required this.description,
  });

  factory ProductDetailData.fromJson(Map<String, dynamic> json) {
    final productJson = json['product'] as Map<String, dynamic>? ?? {};
    final relatedRaw =
        (productJson['related_products'] as List<dynamic>?) ??
            (json['related_products'] as List<dynamic>?) ??
            const <dynamic>[];
    final imagesRaw = productJson['images'] as List<dynamic>? ?? const <dynamic>[];

    return ProductDetailData(
      product: ProductModel.fromJson(productJson),
      relatedProducts: relatedRaw
          .whereType<Map<String, dynamic>>()
          .map(ProductModel.fromJson)
          .toList(),
      images: imagesRaw
          .whereType<Map<String, dynamic>>()
          .map((e) => ApiConstants.productImageUrl(e['image']?.toString() ?? ''))
          .where((url) => url.isNotEmpty)
          .toList(),
      description: productJson['app_description']?.toString().trim().isNotEmpty == true
          ? productJson['app_description'].toString()
          : productJson['description']?.toString() ?? '',
    );
  }
}
