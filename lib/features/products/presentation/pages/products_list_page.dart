import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:project_alisons/config/assets/svg_assets.dart';
import 'package:project_alisons/config/theme/app_colors.dart';
import 'package:project_alisons/features/products/data/models/product_model.dart';
import 'package:project_alisons/features/products/data/repositories/product_repository.dart';
import 'package:project_alisons/features/products/presentation/widgets/product_card.dart';

class ProductsListPage extends StatefulWidget {
  final String? category;

  const ProductsListPage({
    super.key,
    this.category,
  });

  @override
  State<ProductsListPage> createState() => _ProductsListPageState();
}

class _ProductsListPageState extends State<ProductsListPage> {
  late ProductRepository _repository;
  late ScrollController _scrollController;

  int _currentPage = 1;
  final int _pageSize = 8;
  List<ProductModel> _products = [];
  bool _isLoading = false;
  bool _hasMorePages = true;

  @override
  void initState() {
    super.initState();
    _repository = ProductRepository();
    _scrollController = ScrollController();
    _loadProducts();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _loadProducts({bool reset = false}) async {
    if (_isLoading) return;

    setState(() {
      if (reset) {
        _currentPage = 1;
        _products = [];
        _hasMorePages = true;
      }
      _isLoading = true;
    });

    try {
      final products = await _repository.getProducts(
        page: _currentPage,
        pageSize: _pageSize,
        category: widget.category,
      );

      final total = await _repository.getTotalProducts(
        category: widget.category,
      );

      setState(() {
        if (reset) {
          _products = products;
        } else {
          _products.addAll(products);
        }
        _hasMorePages = (_currentPage * _pageSize) < total;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error loading products: $e')),
        );
      }
    }
  }

  Future<void> _loadNextPage() async {
    if (_hasMorePages && !_isLoading) {
      _currentPage++;
      await _loadProducts();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        elevation: 0,
        leading: GestureDetector(
          onTap: () => context.pop(),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: SvgPicture.asset(
              SvgAssets.arrowLeft,
              colorFilter: const ColorFilter.mode(
                AppColors.black,
                BlendMode.srcIn,
              ),
            ),
          ),
        ),
        title: Text(
          widget.category ?? 'Products',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                color: AppColors.black,
              ),
        ),
        centerTitle: false,
        actions: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: SvgPicture.asset(
              SvgAssets.filter,
              colorFilter: const ColorFilter.mode(
                AppColors.grey,
                BlendMode.srcIn,
              ),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: _products.isEmpty && !_isLoading
                ? Center(
                    child: Text(
                      'No products found',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  )
                : GridView.builder(
                    padding: const EdgeInsets.all(16),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      mainAxisSpacing: 12,
                      crossAxisSpacing: 12,
                      childAspectRatio: 0.7,
                    ),
                    itemCount:
                        _products.length + (_hasMorePages ? 1 : 0),
                    itemBuilder: (context, index) {
                      if (index == _products.length) {
                        _loadNextPage();
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      }

                      return ProductCard(
                        product: _products[index],
                        onTap: () => context.push(
                          '/product-detail',
                          extra: _products[index],
                        ),
                        onAddToCart: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                '${_products[index].name} added to cart',
                              ),
                            ),
                          );
                        },
                        onToggleFavorite: () {
                          setState(() {
                            _products[index] = _products[index].copyWith(
                              isFavorite: !_products[index].isFavorite,
                            );
                          });
                        },
                      );
                    },
                  ),
          ),
          // Sort & Filter Bar
          if (_products.isNotEmpty)
            Container(
              color: AppColors.white,
              height: 64,
              child: Row(
                children: [
                  Expanded(
                    child: InkWell(
                      onTap: () {},
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SvgPicture.asset(
                            SvgAssets.sort,
                            width: 20,
                            height: 20,
                            colorFilter: const ColorFilter.mode(
                              AppColors.black,
                              BlendMode.srcIn,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'Sort By',
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium
                                ?.copyWith(fontWeight: FontWeight.w700),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Container(
                    width: 1,
                    height: 32,
                    color: AppColors.borderColorLight,
                  ),
                  Expanded(
                    child: InkWell(
                      onTap: () {},
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Stack(
                            clipBehavior: Clip.none,
                            children: [
                              SvgPicture.asset(
                                SvgAssets.filter,
                                width: 20,
                                height: 20,
                                colorFilter: const ColorFilter.mode(
                                  AppColors.black,
                                  BlendMode.srcIn,
                                ),
                              ),
                              Positioned(
                                top: -3,
                                left: -3,
                                child: Container(
                                  width: 9,
                                  height: 9,
                                  decoration: const BoxDecoration(
                                    color: AppColors.primary,
                                    shape: BoxShape.circle,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'Filter',
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium
                                ?.copyWith(fontWeight: FontWeight.w700),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
