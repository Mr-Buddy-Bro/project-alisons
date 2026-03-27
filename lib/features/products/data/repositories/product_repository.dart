import 'package:project_alisons/features/products/data/models/category_model.dart';
import 'package:project_alisons/features/products/data/models/product_model.dart';

class ProductRepository {
  static final List<ProductModel> _allProducts = [
    ProductModel(
      id: '1',
      name: 'Unpolished Pulses',
      image: 'assets/images/login_header.png',
      originalPrice: 500,
      currentPrice: 450,
      category: 'Unpolished Pulses',
    ),
    ProductModel(
      id: '2',
      name: 'Unpolished Rice',
      image: 'assets/images/login_header.png',
      originalPrice: 600,
      currentPrice: 550,
      category: 'Unpolished Pulses',
    ),
    ProductModel(
      id: '3',
      name: 'Unpolished Millets',
      image: 'assets/images/login_header.png',
      originalPrice: 400,
      currentPrice: 380,
      category: 'Unpolished Pulses',
    ),
    ProductModel(
      id: '4',
      name: 'Chana dal 1kg',
      image: 'assets/images/login_header.png',
      originalPrice: 250,
      currentPrice: 240,
      category: 'Unpolished Pulses',
    ),
    ProductModel(
      id: '5',
      name: 'Roasted Chana 750g',
      image: 'assets/images/login_header.png',
      originalPrice: 300,
      currentPrice: 285,
      category: 'Unpolished Pulses',
    ),
    ProductModel(
      id: '6',
      name: 'Toor Dal 1kg',
      image: 'assets/images/login_header.png',
      originalPrice: 350,
      currentPrice: 320,
      category: 'Unpolished Pulses',
    ),
    ProductModel(
      id: '7',
      name: 'Red Chana 1kg',
      image: 'assets/images/login_header.png',
      originalPrice: 450,
      currentPrice: 420,
      category: 'Unpolished Pulses',
    ),
    ProductModel(
      id: '8',
      name: 'Grain Moong 500g',
      image: 'assets/images/login_header.png',
      originalPrice: 320,
      currentPrice: 300,
      category: 'Unpolished Pulses',
    ),
    ProductModel(
      id: '9',
      name: 'Moong Dal 1kg',
      image: 'assets/images/login_header.png',
      originalPrice: 380,
      currentPrice: 360,
      category: 'Unpolished Pulses',
    ),
    ProductModel(
      id: '10',
      name: 'Ground Nuts 500g',
      image: 'assets/images/login_header.png',
      originalPrice: 420,
      currentPrice: 400,
      category: 'Unpolished Pulses',
    ),
    ProductModel(
      id: '11',
      name: 'Uped Dal 1kg',
      image: 'assets/images/login_header.png',
      originalPrice: 500,
      currentPrice: 480,
      category: 'Unpolished Pulses',
    ),
    ProductModel(
      id: '12',
      name: 'Light pink salt 1kg',
      image: 'assets/images/login_header.png',
      originalPrice: 180,
      currentPrice: 160,
      category: 'Featured Products',
    ),
    ProductModel(
      id: '13',
      name: 'Lily mixes 1kg',
      image: 'assets/images/login_header.png',
      originalPrice: 450,
      currentPrice: 420,
      category: 'Featured Products',
    ),
    ProductModel(
      id: '14',
      name: 'Unpolished Stock food 1kg',
      image: 'assets/images/login_header.png',
      originalPrice: 350,
      currentPrice: 330,
      category: 'Daily Best Selling',
    ),
    ProductModel(
      id: '15',
      name: 'Brownish millet 1kg',
      image: 'assets/images/login_header.png',
      originalPrice: 400,
      currentPrice: 380,
      category: 'Daily Best Selling',
    ),
  ];

  static final List<CategoryModel> _categories = [
    CategoryModel(
      id: '1',
      name: 'Unpolished\nPulses',
      image: 'assets/images/login_header.png',
    ),
    CategoryModel(
      id: '2',
      name: 'Unpolished\nRice',
      image: 'assets/images/login_header.png',
    ),
    CategoryModel(
      id: '3',
      name: 'Unpolished\nMillets',
      image: 'assets/images/login_header.png',
    ),
    CategoryModel(
      id: '4',
      name: 'Nuts & Dry\nFruits',
      image: 'assets/images/login_header.png',
    ),
    CategoryModel(
      id: '5',
      name: 'Unpolished\nFlours',
      image: 'assets/images/login_header.png',
    ),
  ];

  // Get all products with pagination
  Future<List<ProductModel>> getProducts({
    required int page,
    required int pageSize,
    String? category,
  }) async {
    await Future.delayed(const Duration(milliseconds: 500));

    List<ProductModel> products = _allProducts;

    if (category != null && category.isNotEmpty) {
      products = products.where((p) => p.category == category).toList();
    }

    final startIndex = (page - 1) * pageSize;
    final endIndex = startIndex + pageSize;

    if (startIndex >= products.length) {
      return [];
    }

    return products.sublist(
      startIndex,
      endIndex > products.length ? products.length : endIndex,
    );
  }

  // Get total products count
  Future<int> getTotalProducts({String? category}) async {
    await Future.delayed(const Duration(milliseconds: 300));

    if (category != null && category.isNotEmpty) {
      return _allProducts.where((p) => p.category == category).length;
    }

    return _allProducts.length;
  }

  // Get all categories
  Future<List<CategoryModel>> getCategories() async {
    await Future.delayed(const Duration(milliseconds: 300));
    return _categories;
  }

  // Get featured products
  Future<List<ProductModel>> getFeaturedProducts() async {
    await Future.delayed(const Duration(milliseconds: 300));
    return _allProducts.where((p) => p.category == 'Featured Products').toList();
  }

  // Get daily best selling
  Future<List<ProductModel>> getDailyBestSelling() async {
    await Future.delayed(const Duration(milliseconds: 300));
    return _allProducts.where((p) => p.category == 'Daily Best Selling').toList();
  }
}
