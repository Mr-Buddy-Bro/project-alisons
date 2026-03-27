import 'package:flutter_test/flutter_test.dart';
import 'package:project_alisons/features/cart/presentation/bloc/cart_cubit.dart';
import 'package:project_alisons/features/products/data/models/product_model.dart';

void main() {
  group('CartCubit', () {
    late CartCubit cubit;

    final p1 = ProductModel(
      id: 'p1',
      slug: 'product-1',
      name: 'Product 1',
      image: 'https://example.com/p1.jpg',
      originalPrice: 150,
      currentPrice: 100,
      category: 'Category A',
      store: 'store-a',
      symbolLeft: '₹',
    );

    final p1DuplicateDifferentStore = ProductModel(
      id: 'p1',
      slug: 'product-1',
      name: 'Product 1',
      image: 'https://example.com/p1.jpg',
      originalPrice: 150,
      currentPrice: 100,
      category: 'Category A',
      store: 'store-b',
      symbolLeft: '₹',
    );

    final p2 = ProductModel(
      id: 'p2',
      slug: 'product-2',
      name: 'Product 2',
      image: 'https://example.com/p2.jpg',
      originalPrice: 80,
      currentPrice: 50,
      category: 'Category B',
      store: 'store-a',
      symbolLeft: '₹',
    );

    setUp(() {
      cubit = CartCubit();
    });

    tearDown(() async {
      await cubit.close();
    });

    test('starts with empty cart', () {
      expect(cubit.state.items, isEmpty);
      expect(cubit.state.totalItems, 0);
      expect(cubit.state.totalAmount, 0);
    });

    test('addProduct adds new item', () {
      cubit.addProduct(p1);

      expect(cubit.state.items.length, 1);
      expect(cubit.state.items.first.product.id, 'p1');
      expect(cubit.state.items.first.quantity, 1);
      expect(cubit.state.totalItems, 1);
      expect(cubit.state.totalAmount, 100);
    });

    test('addProduct merges same product key and increments quantity', () {
      cubit.addProduct(p1);
      cubit.addProduct(p1DuplicateDifferentStore);

      expect(cubit.state.items.length, 1);
      expect(cubit.state.items.first.quantity, 2);
      expect(cubit.state.totalItems, 2);
      expect(cubit.state.totalAmount, 200);
    });

    test('decreaseQuantity removes item when quantity reaches zero', () {
      cubit.addProduct(p1, quantity: 1);
      cubit.decreaseQuantity(p1);

      expect(cubit.state.items, isEmpty);
      expect(cubit.state.totalItems, 0);
    });

    test('removeProduct removes only selected item', () {
      cubit.addProduct(p1, quantity: 2);
      cubit.addProduct(p2, quantity: 1);

      cubit.removeProduct(p1);

      expect(cubit.state.items.length, 1);
      expect(cubit.state.items.first.product.id, 'p2');
      expect(cubit.state.totalItems, 1);
      expect(cubit.state.totalAmount, 50);
    });

    test('clearCart resets all data', () {
      cubit.addProduct(p1, quantity: 2);
      cubit.addProduct(p2, quantity: 1);

      cubit.clearCart();

      expect(cubit.state.items, isEmpty);
      expect(cubit.state.totalItems, 0);
      expect(cubit.state.totalAmount, 0);
    });
  });
}
