import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:project_alisons/config/assets/svg_assets.dart';
import 'package:project_alisons/config/theme/app_colors.dart';
import 'package:project_alisons/features/products/data/datasources/product_remote_datasource.dart';
import 'package:project_alisons/features/products/data/models/product_detail_data.dart';
import 'package:project_alisons/features/products/data/models/product_model.dart';
import 'package:project_alisons/features/products/presentation/widgets/product_card.dart';

class ProductDetailPage extends StatefulWidget {
  final ProductModel product;

  const ProductDetailPage({super.key, required this.product});

  @override
  State<ProductDetailPage> createState() => _ProductDetailPageState();
}

class _ProductDetailPageState extends State<ProductDetailPage> {
  final PageController _imageController = PageController();
  final ProductRemoteDataSource _dataSource = ProductRemoteDataSource();
  int _currentImageIndex = 0;
  bool _isFavorite = false;
  bool _isLoadingDetails = true;
  List<ProductModel> _relatedProducts = [];
  List<String> _detailImages = [];
  String _description = '';
  ProductModel? _detailProduct;

  List<String> get _images => [
        if (_detailImages.isNotEmpty) ..._detailImages else widget.product.image,
      ];

  ProductModel get _activeProduct => _detailProduct ?? widget.product;

  int get _discountPct =>
      _activeProduct.originalPrice > 0
          ? (((_activeProduct.originalPrice - _activeProduct.currentPrice) /
                          _activeProduct.originalPrice) *
                      100)
                  .round()
          : 0;

  @override
  void initState() {
    super.initState();
    _isFavorite = widget.product.isFavorite;
    _loadProductDetails();
  }

  @override
  void dispose() {
    _imageController.dispose();
    super.dispose();
  }

  Widget _buildProductImage(String imageUrl) {
    if (imageUrl.isNotEmpty) {
      return CachedNetworkImage(
        imageUrl: imageUrl,
        fit: BoxFit.contain,
        placeholder: (_, _) =>
            const Center(child: CircularProgressIndicator()),
        errorWidget: (_, _, _) => const Icon(Icons.broken_image, size: 60),
      );
    }
    return const Icon(Icons.image_not_supported, size: 60, color: AppColors.grey);
  }

  Future<void> _loadProductDetails() async {
    if (widget.product.slug.isEmpty || widget.product.store.isEmpty) {
      if (mounted) setState(() => _isLoadingDetails = false);
      return;
    }

    try {
      final ProductDetailData detail = await _dataSource.getProductDetailData(
        slug: widget.product.slug,
        store: widget.product.store,
      );
      if (!mounted) return;
      setState(() {
        _detailProduct = detail.product;
        _relatedProducts = detail.relatedProducts;
        _detailImages = detail.images;
        _description = detail.description;
        _isFavorite = detail.product.isFavorite;
        _isLoadingDetails = false;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() => _isLoadingDetails = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF2F2F2),
      appBar: AppBar(
        backgroundColor: AppColors.white,
        elevation: 0,
        leading: GestureDetector(
          onTap: () => context.pop(),
          child: Padding(
            padding: const EdgeInsets.all(14),
            child: SvgPicture.asset(
              SvgAssets.arrowLeft,
              colorFilter:
                  const ColorFilter.mode(AppColors.black, BlendMode.srcIn),
            ),
          ),
        ),
        actions: [
          GestureDetector(
            onTap: () {},
            child: Padding(
              padding: const EdgeInsets.all(14),
              child: SvgPicture.asset(SvgAssets.search,
                  colorFilter: const ColorFilter.mode(
                      AppColors.black, BlendMode.srcIn),
                  width: 22,
                  height: 22),
            ),
          ),
          GestureDetector(
            onTap: () {},
            child: Padding(
              padding: const EdgeInsets.fromLTRB(0, 14, 16, 14),
              child: SvgPicture.asset(SvgAssets.cart,
                  colorFilter: const ColorFilter.mode(
                      AppColors.black, BlendMode.srcIn),
                  width: 22,
                  height: 22),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image Carousel
            Container(
              color: AppColors.white,
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  Stack(
                    children: [
                      Container(
                        height: 280,
                        decoration: BoxDecoration(
                          color: AppColors.white,
                          borderRadius: BorderRadius.circular(12),
                          border:
                              Border.all(color: AppColors.borderColorLight),
                        ),
                        padding: const EdgeInsets.all(24),
                        child: PageView.builder(
                          controller: _imageController,
                          itemCount: _images.length,
                          onPageChanged: (i) =>
                              setState(() => _currentImageIndex = i),
                          itemBuilder: (_, i) =>
                              _buildProductImage(_images[i]),
                        ),
                      ),
                      Positioned(
                        top: 12,
                        right: 12,
                        child: GestureDetector(
                          onTap: () =>
                              setState(() => _isFavorite = !_isFavorite),
                          child: SvgPicture.asset(
                            SvgAssets.heart,
                            colorFilter: ColorFilter.mode(
                              _isFavorite ? Colors.red : AppColors.primary,
                              BlendMode.srcIn,
                            ),
                            width: 24,
                            height: 24,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(
                      _images.length,
                      (i) => AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        margin: const EdgeInsets.symmetric(horizontal: 4),
                        width: i == _currentImageIndex ? 20 : 8,
                        height: 8,
                        decoration: BoxDecoration(
                          color: i == _currentImageIndex
                              ? AppColors.primary
                              : AppColors.borderColor,
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Product Info
            Container(
              color: AppColors.white,
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              _activeProduct.name,
                              style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.black),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              _activeProduct.category,
                              style: const TextStyle(
                                  fontSize: 13, color: AppColors.greyDark),
                            ),
                            if (_activeProduct.store.isNotEmpty)
                              Text(
                                _activeProduct.store,
                                style: const TextStyle(
                                    fontSize: 12, color: AppColors.primary),
                              ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        child: Row(
                          children: [
                            Text(
                              '${_activeProduct.symbolLeft} ${_activeProduct.currentPrice.toStringAsFixed(2)}',
                              style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.primary),
                            ),
                            const SizedBox(width: 10),
                            Text(
                              '${_activeProduct.symbolLeft} ${_activeProduct.originalPrice.toStringAsFixed(2)}',
                              style: const TextStyle(
                                  fontSize: 14,
                                  color: AppColors.grey,
                                  decoration: TextDecoration.lineThrough,
                                  decorationColor: AppColors.grey,
                                  fontWeight: FontWeight.bold),
                            ),
                            if (_discountPct > 0) ...[
                              const SizedBox(width: 8),
                              Text(
                                '($_discountPct% off)',
                                style: const TextStyle(
                                    fontSize: 13,
                                    color: AppColors.primary,
                                    fontWeight: FontWeight.w600),
                              ),
                            ],
                          ],
                        ),
                      ),
                      GestureDetector(
                        onTap: () {},
                        child: Container(
                          width: 34,
                          height: 34,
                          decoration: const BoxDecoration(
                            color: AppColors.greyExtraLight,
                            shape: BoxShape.circle,
                          ),
                          child: Center(
                            child: SvgPicture.asset(SvgAssets.share,
                                colorFilter: const ColorFilter.mode(
                                    AppColors.black, BlendMode.srcIn),
                                width: 16,
                                height: 16),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 8),

            // Description
            Container(
              color: AppColors.white,
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Description',
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: AppColors.black)),
                  const SizedBox(height: 10),
                  Text(
                    _description.isNotEmpty
                        ? _description
                        : 'Premium quality ${_activeProduct.name} sourced directly from trusted suppliers. '
                            'Carefully processed to retain natural goodness and deliver the best quality.',
                    style: const TextStyle(
                        fontSize: 14, color: AppColors.greyDark, height: 1.6),
                  ),
                ],
              ),
            ),

            if (_isLoadingDetails)
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 24),
                child: Center(child: CircularProgressIndicator()),
              ),
            if (_relatedProducts.isNotEmpty)
              Container(
                color: AppColors.white,
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Related Products',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: AppColors.black,
                      ),
                    ),
                    const SizedBox(height: 12),
                    SizedBox(
                      height: 260,
                      child: ListView.separated(
                        scrollDirection: Axis.horizontal,
                        itemCount: _relatedProducts.length,
                        separatorBuilder: (_, _) => const SizedBox(width: 12),
                        itemBuilder: (context, index) {
                          final related = _relatedProducts[index];
                          return SizedBox(
                            width: 170,
                            child: ProductCard(
                              product: related,
                              isCompact: true,
                              onTap: () => context.push(
                                '/product-detail',
                                extra: related,
                              ),
                              onAddToCart: () {},
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            if (!_isLoadingDetails && _relatedProducts.isEmpty)
              Container(
                width: double.infinity,
                color: AppColors.white,
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 20),
                child: const Text(
                  'No related products found',
                  style: TextStyle(
                    fontSize: 14,
                    color: AppColors.greyDark,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            const SizedBox(height: 8),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 28),
        color: AppColors.white,
        child: SizedBox(
          height: 52,
          child: ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
              elevation: 0,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('Add To Cart',
                    style: TextStyle(
                        color: AppColors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold)),
                const SizedBox(width: 10),
                SvgPicture.asset(SvgAssets.cart,
                    colorFilter: const ColorFilter.mode(
                        AppColors.white, BlendMode.srcIn),
                    width: 20,
                    height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
