import '../repositories/i_product_repository.dart';

class AddToCartUseCase {
  final IProductRepository repository;

  AddToCartUseCase(this.repository);

  Future<void> call({
    required String slug,
    required String store,
    required int quantity,
  }) {
    return repository.addToCart(slug: slug, store: store, quantity: quantity);
  }
}
