class ApiConstants {
  static const String baseUrl = 'https://sungod.demospro2023.in.net/api';
  static const String imageBaseUrl = 'https://sungod.demospro2023.in.net';

  static const String loginEndpoint = '/login';
  static const String homeEndpoint = '/home/en';
  static const String productsEndpoint = '/products/en';
  static const String productDetailEndpoint = '/product-details/en';
  static const String addToCartEndpoint = '/cart/add/en';

  static String categoryImageUrl(String filename) {
    if (filename.isEmpty) return '';
    if (filename.startsWith('http')) return filename;
    return '$imageBaseUrl/images/category/$filename';
  }

  static String bannerImageUrl(String filename) {
    if (filename.isEmpty) return '';
    if (filename.startsWith('http')) return filename;
    return '$imageBaseUrl/images/banner/$filename';
  }

  static String productImageUrl(String filename) {
    if (filename.isEmpty) return '';
    if (filename.startsWith('http')) return filename;
    return '$imageBaseUrl/images/product/$filename';
  }
}
