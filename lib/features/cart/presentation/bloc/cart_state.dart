import 'package:project_alisons/features/products/data/models/product_model.dart';

class CartItem {
  final ProductModel product;
  final int quantity;

  const CartItem({required this.product, required this.quantity});

  double get total => product.currentPrice * quantity;

  CartItem copyWith({ProductModel? product, int? quantity}) {
    return CartItem(
      product: product ?? this.product,
      quantity: quantity ?? this.quantity,
    );
  }
}

class CartState {
  final List<CartItem> items;

  const CartState({this.items = const []});

  bool get isEmpty => items.isEmpty;

  int get totalItems =>
      items.fold<int>(0, (sum, item) => sum + item.quantity);

  double get totalAmount =>
      items.fold<double>(0, (sum, item) => sum + item.total);

  CartState copyWith({List<CartItem>? items}) {
    return CartState(items: items ?? this.items);
  }
}
