import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:project_alisons/features/cart/presentation/bloc/cart_state.dart';
import 'package:project_alisons/features/products/data/models/product_model.dart';

class CartCubit extends Cubit<CartState> {
  CartCubit() : super(const CartState());

  void addProduct(ProductModel product, {int quantity = 1}) {
    if (quantity <= 0) return;

    final key = _productKey(product);
    final items = List<CartItem>.from(state.items);
    final existingIndex =
        items.indexWhere((item) => _productKey(item.product) == key);

    if (existingIndex >= 0) {
      final existing = items[existingIndex];
      items[existingIndex] = existing.copyWith(
        quantity: existing.quantity + quantity,
      );
    } else {
      items.add(CartItem(product: product, quantity: quantity));
    }

    emit(state.copyWith(items: items));
  }

  void increaseQuantity(ProductModel product) {
    addProduct(product, quantity: 1);
  }

  void decreaseQuantity(ProductModel product) {
    final key = _productKey(product);
    final items = List<CartItem>.from(state.items);
    final existingIndex =
        items.indexWhere((item) => _productKey(item.product) == key);
    if (existingIndex < 0) return;

    final existing = items[existingIndex];
    final nextQty = existing.quantity - 1;

    if (nextQty <= 0) {
      items.removeAt(existingIndex);
    } else {
      items[existingIndex] = existing.copyWith(quantity: nextQty);
    }

    emit(state.copyWith(items: items));
  }

  void removeProduct(ProductModel product) {
    final key = _productKey(product);
    final items = state.items
        .where((item) => _productKey(item.product) != key)
        .toList(growable: false);
    emit(state.copyWith(items: items));
  }

  void clearCart() {
    emit(const CartState());
  }

  String _productKey(ProductModel product) {
    if (product.id.isNotEmpty) return product.id;
    if (product.slug.isNotEmpty) return product.slug;
    return product.name;
  }
}
