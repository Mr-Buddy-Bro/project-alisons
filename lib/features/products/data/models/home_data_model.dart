import 'banner_model.dart';
import 'category_model.dart';
import 'product_model.dart';

class HomeDataModel {
  final List<BannerModel> banners;
  final List<CategoryModel> categories;
  final List<ProductModel> newArrivals;
  final List<ProductModel> bestSeller;
  final List<ProductModel> flashSale;
  final List<ProductModel> suggestedProducts;
  final List<ProductModel> ourProducts;
  final int cartCount;
  final int notificationCount;

  HomeDataModel({
    required this.banners,
    required this.categories,
    required this.newArrivals,
    required this.bestSeller,
    required this.flashSale,
    required this.suggestedProducts,
    required this.ourProducts,
    required this.cartCount,
    required this.notificationCount,
  });

  factory HomeDataModel.fromJson(Map<String, dynamic> json) {
    List<ProductModel> parseProducts(dynamic list) {
      if (list == null || list is! List) return [];
      return list
          .map((e) => ProductModel.fromJson(e as Map<String, dynamic>))
          .toList();
    }

    List<BannerModel> parseBanners(dynamic list) {
      if (list == null || list is! List) return [];
      return list
          .map((e) => BannerModel.fromJson(e as Map<String, dynamic>))
          .toList();
    }

    List<CategoryModel> parseCategories(dynamic list) {
      if (list == null || list is! List) return [];
      return list
          .map((e) => CategoryModel.fromJson(e as Map<String, dynamic>))
          .toList();
    }

    final b1 = parseBanners(json['banner1']);
    final b2 = parseBanners(json['banner2']);

    return HomeDataModel(
      banners: [...b1, ...b2],
      categories: parseCategories(json['categories']),
      newArrivals: parseProducts(json['newarrivals']),
      bestSeller: parseProducts(json['best_seller']),
      flashSale: parseProducts(json['flash_sail']),
      suggestedProducts: parseProducts(json['suggested_products']),
      ourProducts: parseProducts(json['our_products']),
      cartCount: json['cartcount'] as int? ?? 0,
      notificationCount: json['notification_count'] as int? ?? 0,
    );
  }
}
