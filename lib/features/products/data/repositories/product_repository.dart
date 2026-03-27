import 'package:project_alisons/features/products/data/datasources/product_remote_datasource.dart';
import 'package:project_alisons/features/products/data/models/home_data_model.dart';
import 'package:project_alisons/features/products/data/models/product_model.dart';
import 'package:project_alisons/features/products/domain/repositories/i_product_repository.dart';

class ProductRepository implements IProductRepository {
  final ProductRemoteDataSource _dataSource;

  ProductRepository(this._dataSource);

  @override
  Future<HomeDataModel> getHomeData() => _dataSource.getHomeData();

  @override
  Future<List<ProductModel>> getProducts({
    required String by,
    required String value,
    int page = 1,
    String? sortBy,
    String? sortOrder,
  }) =>
      _dataSource.getProducts(
        by: by,
        value: value,
        page: page,
        sortBy: sortBy,
        sortOrder: sortOrder,
      );

  @override
  Future<ProductModel> getProductDetail({
    required String slug,
    required String store,
  }) =>
      _dataSource.getProductDetail(slug: slug, store: store);

  @override
  Future<void> addToCart({
    required String slug,
    required String store,
    required int quantity,
  }) =>
      _dataSource.addToCart(slug: slug, store: store, quantity: quantity);
}
