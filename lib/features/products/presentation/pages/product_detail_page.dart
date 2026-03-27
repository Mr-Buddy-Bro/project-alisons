import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:project_alisons/config/assets/svg_assets.dart';
import 'package:project_alisons/config/theme/app_colors.dart';
import 'package:project_alisons/features/products/data/models/product_model.dart';
import 'package:project_alisons/features/products/data/repositories/product_repository.dart';
import 'package:project_alisons/features/products/presentation/widgets/product_card.dart';

class ProductDetailPage extends StatefulWidget {
  final ProductModel product;

  const ProductDetailPage({super.key, required this.product});

  @override
  State<ProductDetailPage> createState() => _ProductDetailPageState();
}

class _ProductDetailPageState extends State<ProductDetailPage> {
  final PageController _imageController = PageController();
  late Future _relatedFuture;
  int _currentImageIndex = 0;
  bool _isFavorite = false;

  List<String> get _images => [
        widget.product.image,
        widget.product.image,
        widget.product.image,
        widget.product.image,
      ];

  int get _discountPct =>
      (((widget.product.originalPrice - widget.product.currentPrice) /
                  widget.product.originalPrice) *
              100)
          .round();

  @override
  void initState() {
    super.initState();
    _isFavorite = widget.product.isFavorite;
    _relatedFuture = ProductRepository().getProducts(page: 1, pageSize: 6);
  }

  @override
  void dispose() {
    _imageController.dispose();
    super.dispose();
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
              colorFilter: const ColorFilter.mode(AppColors.black, BlendMode.srcIn),
            ),
          ),
        ),
        actions: [
          GestureDetector(
            onTap: () {},
            child: Padding(
              padding: const EdgeInsets.all(14),
              child: SvgPicture.asset(
                SvgAssets.search,
                colorFilter: const ColorFilter.mode(AppColors.black, BlendMode.srcIn),
                width: 22,
                height: 22,
              ),
            ),
          ),
          GestureDetector(
            onTap: () {},
            child: Padding(
              padding: const EdgeInsets.fromLTRB(0, 14, 16, 14),
              child: SvgPicture.asset(
                SvgAssets.cart,
                colorFilter: const ColorFilter.mode(AppColors.black, BlendMode.srcIn),
                width: 22,
                height: 22,
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Image Carousel ────────────────────────────────────────
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
                          border: Border.all(color: AppColors.borderColorLight),
                        ),
                        padding: const EdgeInsets.all(24),
                        child: PageView.builder(
                          controller: _imageController,
                          itemCount: _images.length,
                          onPageChanged: (i) =>
                              setState(() => _currentImageIndex = i),
                          itemBuilder: (_, i) => Image.asset(
                            _images[i],
                            fit: BoxFit.contain,
                          ),
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
                  // Dot indicators
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

            // const SizedBox(height: 8),

            // ── Product Info ──────────────────────────────────────────
            Container(
              color: AppColors.white,
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.product.name,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: AppColors.black,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            widget.product.category,
                            style: const TextStyle(
                              fontSize: 13,
                              color: AppColors.greyDark,
                            ),
                          ),
                        ],
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
                              '₹ ${widget.product.currentPrice.toStringAsFixed(2)}',
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: AppColors.primary,
                              ),
                            ),
                            const SizedBox(width: 10),
                            Text(
                              '₹${widget.product.originalPrice.toStringAsFixed(2)}',
                              style: const TextStyle(
                                fontSize: 14,
                                color: AppColors.grey,
                                decoration: TextDecoration.lineThrough,
                                decorationColor: AppColors.grey,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              '($_discountPct% off)',
                              style: const TextStyle(
                                fontSize: 13,
                                color: AppColors.primary,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
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
                            child: SvgPicture.asset(
                              SvgAssets.share,
                              colorFilter: const ColorFilter.mode(
                                  AppColors.black, BlendMode.srcIn),
                              width: 16,
                              height: 16,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 8),

            // ── Description ───────────────────────────────────────────
            Container(
              color: AppColors.white,
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Description',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: AppColors.black,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'Premium quality ${widget.product.name} sourced directly from trusted farmers. '
                    'Natural and unrefined, packed with essential nutrients. '
                    'Perfect for daily cooking, these products are carefully processed '
                    'to retain their natural goodness and deliver the best taste and quality to your kitchen.',
                    style: const TextStyle(
                      fontSize: 14,
                      color: AppColors.greyDark,
                      height: 1.6,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 8),

            // ── Related Products ──────────────────────────────────────
            Container(
              color: AppColors.white,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Padding(
                    padding: EdgeInsets.all(16),
                    child: Text(
                      'Related Products',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: AppColors.black,
                      ),
                    ),
                  ),
                  FutureBuilder(
                    future: _relatedFuture,
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) {
                        return const SizedBox(
                          height: 220,
                          child: Center(child: CircularProgressIndicator()),
                        );
                      }
                      final products = snapshot.data as List<ProductModel>;
                      return SizedBox(
                        height: 265,
                        child: ListView.separated(
                          padding: EdgeInsets.symmetric(horizontal: 16),
                          scrollDirection: Axis.horizontal,
                          itemCount: products.length,
                          separatorBuilder: (_, _) =>
                              const SizedBox(width: 12),
                          itemBuilder: (context, index) => SizedBox(
                            width: 160,
                            child: ProductCard(
                              product: products[index],
                              isCompact: true,
                              onToggleFavorite: () {},
                              onAddToCart: () {},
                              onTap: () => context.push(
                                '/product-detail',
                                extra: products[index],
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                  SizedBox(height: 12),
                ],
              ),
            ),

            const SizedBox(height: 8),
          ],
        ),
      ),

      // ── Add To Cart Bottom Bar ────────────────────────────────────
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
                borderRadius: BorderRadius.circular(10),
              ),
              elevation: 0,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'Add To Cart',
                  style: TextStyle(
                    color: AppColors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(width: 10),
                SvgPicture.asset(
                  SvgAssets.cart,
                  colorFilter: const ColorFilter.mode(
                      AppColors.white, BlendMode.srcIn),
                  width: 20,
                  height: 20,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ── Related Product Card ──────────────────────────────────────────────────
class _RelatedProductCard extends StatefulWidget {
  final ProductModel product;
  final bool showQuantitySelector;

  const _RelatedProductCard({
    required this.product,
    this.showQuantitySelector = false,
  });

  @override
  State<_RelatedProductCard> createState() => _RelatedProductCardState();
}

class _RelatedProductCardState extends State<_RelatedProductCard> {
  int _qty = 1;
  bool _isFavorite = false;

  int get _discountPct =>
      (((widget.product.originalPrice - widget.product.currentPrice) /
                  widget.product.originalPrice) *
              100)
          .round();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 160,
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.borderColorLight),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Stack(
            children: [
              Container(
                height: 120,
                decoration: const BoxDecoration(
                  color: AppColors.white,
                  borderRadius:
                      BorderRadius.vertical(top: Radius.circular(12)),
                ),
                padding: const EdgeInsets.all(10),
                child: Image.asset(
                  widget.product.image,
                  fit: BoxFit.contain,
                  width: double.infinity,
                ),
              ),
              if (_discountPct > 0)
                Positioned(
                  top: 8,
                  left: 8,
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      '$_discountPct% off',
                      style: const TextStyle(
                        color: AppColors.white,
                        fontSize: 9,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              Positioned(
                top: 8,
                right: 8,
                child: GestureDetector(
                  onTap: () => setState(() => _isFavorite = !_isFavorite),
                  child: SvgPicture.asset(
                    SvgAssets.heart,
                    colorFilter: ColorFilter.mode(
                      _isFavorite ? Colors.red : AppColors.primary,
                      BlendMode.srcIn,
                    ),
                    width: 18,
                    height: 18,
                  ),
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(10, 8, 10, 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.product.name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: AppColors.black,
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Text(
                      '₹ ${widget.product.currentPrice.toStringAsFixed(2)}',
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: AppColors.black,
                      ),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '₹${widget.product.originalPrice.toStringAsFixed(2)}',
                      style: const TextStyle(
                        fontSize: 10,
                        color: AppColors.grey,
                        decoration: TextDecoration.lineThrough,
                        decorationColor: AppColors.grey,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                widget.showQuantitySelector
                    ? _buildQuantitySelector()
                    : _buildAddButton(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuantitySelector() {
    return Container(
      height: 36,
      decoration: BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Expanded(
            child: GestureDetector(
              onTap: () => setState(() => _qty = (_qty - 1).clamp(1, 99)),
              child: const Center(
                child: Text('−',
                    style: TextStyle(
                        color: AppColors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold)),
              ),
            ),
          ),
          Container(width: 1, height: 20, color: Color(0x66FFFFFF)),
          Expanded(
            child: Center(
              child: Text('$_qty',
                  style: const TextStyle(
                      color: AppColors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.bold)),
            ),
          ),
          Container(width: 1, height: 20, color: Color(0x66FFFFFF)),
          Expanded(
            child: GestureDetector(
              onTap: () => setState(() => _qty++),
              child: const Center(
                child: Text('+',
                    style: TextStyle(
                        color: AppColors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold)),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAddButton() {
    return SizedBox(
      width: double.infinity,
      height: 36,
      child: OutlinedButton(
        onPressed: () {},
        style: OutlinedButton.styleFrom(
          padding: EdgeInsets.zero,
          side: const BorderSide(color: AppColors.borderColorLight),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          backgroundColor: AppColors.white,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Add',
                style: TextStyle(
                    color: AppColors.primary,
                    fontWeight: FontWeight.bold,
                    fontSize: 13)),
            const SizedBox(width: 5),
            SvgPicture.asset(
              SvgAssets.cart,
              colorFilter:
                  const ColorFilter.mode(AppColors.primary, BlendMode.srcIn),
              width: 13,
              height: 13,
            ),
          ],
        ),
      ),
    );
  }
}
