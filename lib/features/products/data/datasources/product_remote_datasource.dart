import 'package:dio/dio.dart';
import 'package:project_alisons/core/network/api_client.dart';
import 'package:project_alisons/core/network/api_constants.dart';
import 'package:project_alisons/core/storage/local_storage.dart';
import '../models/home_data_model.dart';
import '../models/product_model.dart';

class ProductRemoteDataSource {
  final Dio _dio = ApiClient.instance.dio;

  Map<String, String> get _authParams => {
        'id': LocalStorage.instance.userId,
        'token': LocalStorage.instance.token,
      };

  Future<HomeDataModel> getHomeData() async {
    final response = await _dio.post(
      ApiConstants.homeEndpoint,
      queryParameters: _authParams,
    );
    return HomeDataModel.fromJson(response.data as Map<String, dynamic>);
  }

  Future<List<ProductModel>> getProducts({
    required String by,
    required String value,
    int page = 1,
    String? sortBy,
    String? sortOrder,
  }) async {
    final params = {
      ..._authParams,
      'by': by,
      'value': value,
      'page': page.toString(),
      'sort_by': sortBy,
      'sort_order': sortOrder,
    };

    final response = await _dio.post(
      ApiConstants.productsEndpoint,
      queryParameters: params,
    );

    final data = response.data;
    final List<dynamic> list = data['products'] as List<dynamic>? ?? [];
    return list
        .map((e) => ProductModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<ProductModel> getProductDetail({
    required String slug,
    required String store,
  }) async {
    final response = await _dio.post(
      '${ApiConstants.productDetailEndpoint}/$slug',
      queryParameters: {
        ..._authParams,
        'store': store,
      },
    );

    final data = response.data as Map<String, dynamic>;
    final product = data['product'] as Map<String, dynamic>?;
    if (product == null) throw Exception('Product not found');
    return ProductModel.fromJson(product);
  }

  Future<void> addToCart({
    required String slug,
    required String store,
    required int quantity,
  }) async {
    await _dio.post(
      ApiConstants.addToCartEndpoint,
      queryParameters: {
        ..._authParams,
        'slug': slug,
        'store': store,
        'quantity': quantity.toString(),
      },
    );
  }
}
