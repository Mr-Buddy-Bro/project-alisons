import 'package:project_alisons/features/products/data/models/product_model.dart';

abstract class ProductsState {}

class ProductsInitial extends ProductsState {}

class ProductsLoading extends ProductsState {}

class ProductsLoaded extends ProductsState {
  final List<ProductModel> products;
  final bool hasMore;
  final int currentPage;

  ProductsLoaded({
    required this.products,
    required this.hasMore,
    required this.currentPage,
  });

  ProductsLoaded copyWith({
    List<ProductModel>? products,
    bool? hasMore,
    int? currentPage,
  }) {
    return ProductsLoaded(
      products: products ?? this.products,
      hasMore: hasMore ?? this.hasMore,
      currentPage: currentPage ?? this.currentPage,
    );
  }
}

class ProductsError extends ProductsState {
  final String message;
  ProductsError(this.message);
}
