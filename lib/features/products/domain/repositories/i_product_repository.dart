import 'package:project_alisons/features/products/data/models/home_data_model.dart';
import 'package:project_alisons/features/products/data/models/product_model.dart';

abstract class IProductRepository {
  Future<HomeDataModel> getHomeData();

  Future<List<ProductModel>> getProducts({
    required String by,
    required String value,
    int page = 1,
    String? sortBy,
    String? sortOrder,
  });

  Future<ProductModel> getProductDetail({
    required String slug,
    required String store,
  });

  Future<void> addToCart({
    required String slug,
    required String store,
    required int quantity,
  });
}
