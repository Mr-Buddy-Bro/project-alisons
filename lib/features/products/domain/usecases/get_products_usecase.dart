import 'package:project_alisons/features/products/data/models/product_model.dart';
import '../repositories/i_product_repository.dart';

class GetProductsUseCase {
  final IProductRepository repository;

  GetProductsUseCase(this.repository);

  Future<List<ProductModel>> call({
    required String by,
    required String value,
    int page = 1,
    String? sortBy,
    String? sortOrder,
  }) {
    return repository.getProducts(
      by: by,
      value: value,
      page: page,
      sortBy: sortBy,
      sortOrder: sortOrder,
    );
  }
}
