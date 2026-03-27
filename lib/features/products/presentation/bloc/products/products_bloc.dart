import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:project_alisons/features/products/data/models/product_model.dart';
import 'package:project_alisons/features/products/domain/usecases/get_products_usecase.dart';
import 'products_event.dart';
import 'products_state.dart';

class ProductsBloc extends Bloc<ProductsEvent, ProductsState> {
  final GetProductsUseCase _getProducts;

  String _currentBy = 'category';
  String _currentValue = '';
  String? _currentSortBy;
  String? _currentSortOrder;

  ProductsBloc(this._getProducts) : super(ProductsInitial()) {
    on<ProductsFetched>(_onProductsFetched);
    on<ProductsNextPageFetched>(_onNextPageFetched);
  }

  Future<void> _onProductsFetched(
    ProductsFetched event,
    Emitter<ProductsState> emit,
  ) async {
    emit(ProductsLoading());
    _currentBy = event.by;
    _currentValue = event.value;
    _currentSortBy = event.sortBy;
    _currentSortOrder = event.sortOrder;

    try {
      final products = await _getProducts(
        by: _currentBy,
        value: _currentValue,
        page: 1,
        sortBy: _currentSortBy,
        sortOrder: _currentSortOrder,
      );
      emit(ProductsLoaded(
        products: products,
        hasMore: products.length >= 10,
        currentPage: 1,
      ));
    } catch (e) {
      emit(ProductsError(e.toString()));
    }
  }

  Future<void> _onNextPageFetched(
    ProductsNextPageFetched event,
    Emitter<ProductsState> emit,
  ) async {
    final current = state;
    if (current is! ProductsLoaded || !current.hasMore) return;

    final nextPage = current.currentPage + 1;
    try {
      final newProducts = await _getProducts(
        by: _currentBy,
        value: _currentValue,
        page: nextPage,
        sortBy: _currentSortBy,
        sortOrder: _currentSortOrder,
      );
      final allProducts = List<ProductModel>.from(current.products)
        ..addAll(newProducts);
      emit(current.copyWith(
        products: allProducts,
        hasMore: newProducts.length >= 10,
        currentPage: nextPage,
      ));
    } catch (e) {
      emit(ProductsError(e.toString()));
    }
  }
}
