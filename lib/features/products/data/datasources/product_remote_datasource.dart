import 'package:dio/dio.dart';
import 'package:project_alisons/core/errors/app_exception.dart';
import 'package:project_alisons/core/errors/error_mapper.dart';
import 'package:project_alisons/core/network/api_client.dart';
import 'package:project_alisons/core/network/api_constants.dart';
import 'package:project_alisons/core/storage/local_storage.dart';
import '../models/home_data_model.dart';
import '../models/product_detail_data.dart';
import '../models/product_model.dart';

class ProductRemoteDataSource {
  final Dio _dio = ApiClient.instance.dio;

  Map<String, String> get _authParams => {
        'id': LocalStorage.instance.userId,
        'token': LocalStorage.instance.token,
      };

  Future<HomeDataModel> getHomeData() async {
    _validateSession();
    try {
      final response = await _dio.post(
        ApiConstants.homeEndpoint,
        queryParameters: _authParams,
      );
      final data = _asMap(response.data);
      if (!_isSuccess(data['success'])) {
        throw AppException(data['message']?.toString() ?? 'Failed to load home data');
      }
      return HomeDataModel.fromJson(data);
    } on DioException catch (e) {
      throw AppException(ErrorMapper.message(e));
    } catch (e) {
      throw AppException(ErrorMapper.message(e, fallback: 'Failed to load home data'));
    }
  }

  Future<List<ProductModel>> getProducts({
    required String by,
    required String value,
    int page = 1,
    String? sortBy,
    String? sortOrder,
  }) async {
    _validateSession();
    final params = <String, String>{
      ..._authParams,
      'by': by,
      'value': value,
      'page': page.toString(),
    };
    if (sortBy != null && sortBy.isNotEmpty) params['sort_by'] = sortBy;
    if (sortOrder != null && sortOrder.isNotEmpty) {
      params['sort_order'] = sortOrder;
    }

    try {
      final response = await _dio.post(
        ApiConstants.productsEndpoint,
        queryParameters: params,
      );
      final data = _asMap(response.data);
      if (!_isSuccess(data['success'])) {
        throw AppException(data['message']?.toString() ?? 'Failed to load products');
      }

      final productsNode = data['products'];
      List<dynamic> list = const [];
      if (productsNode is List<dynamic>) {
        list = productsNode;
      } else if (productsNode is Map<String, dynamic>) {
        final nested = productsNode['return'] as Map<String, dynamic>?;
        list = (nested?['data'] as List<dynamic>?) ?? const [];
      }

      return list
          .whereType<Map<String, dynamic>>()
          .map(ProductModel.fromJson)
          .toList();
    } on DioException catch (e) {
      throw AppException(ErrorMapper.message(e));
    } catch (e) {
      throw AppException(ErrorMapper.message(e, fallback: 'Failed to load products'));
    }
  }

  Future<ProductModel> getProductDetail({
    required String slug,
    required String store,
  }) async {
    _validateSession();
    try {
      final response = await _dio.post(
        '${ApiConstants.productDetailEndpoint}/$slug',
        queryParameters: {
          ..._authParams,
          'store': store,
        },
      );

      final data = _asMap(response.data);
      if (!_isSuccess(data['success'])) {
        throw AppException(data['message']?.toString() ?? 'Failed to load product details');
      }
      final product = data['product'] as Map<String, dynamic>?;
      if (product == null) throw const AppException('Product not found');
      return ProductModel.fromJson(product);
    } on DioException catch (e) {
      throw AppException(ErrorMapper.message(e));
    } catch (e) {
      throw AppException(ErrorMapper.message(e, fallback: 'Failed to load product details'));
    }
  }

  Future<ProductDetailData> getProductDetailData({
    required String slug,
    required String store,
  }) async {
    _validateSession();
    try {
      final response = await _dio.post(
        '${ApiConstants.productDetailEndpoint}/$slug',
        queryParameters: {
          ..._authParams,
          'store': store,
        },
      );

      final data = _asMap(response.data);
      if (!_isSuccess(data['success'])) {
        throw AppException(data['message']?.toString() ?? 'Failed to load product details');
      }
      final product = data['product'] as Map<String, dynamic>?;
      if (product == null) throw const AppException('Product not found');
      return ProductDetailData.fromJson(data);
    } on DioException catch (e) {
      throw AppException(ErrorMapper.message(e));
    } catch (e) {
      throw AppException(ErrorMapper.message(e, fallback: 'Failed to load product details'));
    }
  }

  Future<void> addToCart({
    required String slug,
    required String store,
    required int quantity,
  }) async {
    _validateSession();
    try {
      final response = await _dio.post(
        ApiConstants.addToCartEndpoint,
        queryParameters: {
          ..._authParams,
          'slug': slug,
          'store': store,
          'quantity': quantity.toString(),
        },
      );
      final data = _asMap(response.data);
      if (!_isSuccess(data['success'])) {
        throw AppException(data['message']?.toString() ?? 'Failed to add product to cart');
      }
    } on DioException catch (e) {
      throw AppException(ErrorMapper.message(e));
    } catch (e) {
      throw AppException(ErrorMapper.message(e, fallback: 'Failed to add product to cart'));
    }
  }

  void _validateSession() {
    if (LocalStorage.instance.userId.isEmpty || LocalStorage.instance.token.isEmpty) {
      throw const AppException('Session expired. Please log in again.');
    }
  }

  Map<String, dynamic> _asMap(dynamic value) {
    if (value is Map<String, dynamic>) return value;
    throw const AppException('Invalid response from server.');
  }

  bool _isSuccess(dynamic value) => value == 1 || value == '1' || value == true;
}
