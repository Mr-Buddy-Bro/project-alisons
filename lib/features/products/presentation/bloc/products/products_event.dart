abstract class ProductsEvent {}

class ProductsFetched extends ProductsEvent {
  final String by;
  final String value;
  final int page;
  final String? sortBy;
  final String? sortOrder;

  ProductsFetched({
    required this.by,
    required this.value,
    this.page = 1,
    this.sortBy,
    this.sortOrder,
  });
}

class ProductsNextPageFetched extends ProductsEvent {}
