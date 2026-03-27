import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:project_alisons/config/assets/svg_assets.dart';
import 'package:project_alisons/config/theme/app_colors.dart';
import 'package:project_alisons/features/products/data/repositories/product_repository.dart';
import 'package:project_alisons/features/products/presentation/widgets/category_card.dart';
import 'package:project_alisons/features/products/presentation/widgets/product_card.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final ProductRepository _repository = ProductRepository();
  final PageController _promotionController =
      PageController(viewportFraction: 0.88);

  late Future _categoriesFuture;
  late Future _featuredFuture;
  late Future _dailyBestFuture;
  late Future _recentlyAddedFuture;
  late Future _popularFuture;
  late Future _trendingFuture;

  @override
  void initState() {
    super.initState();
    _categoriesFuture = _repository.getCategories();
    _featuredFuture = _repository.getFeaturedProducts();
    _dailyBestFuture = _repository.getDailyBestSelling();
    _recentlyAddedFuture = _repository.getProducts(page: 1, pageSize: 5);
    _popularFuture = _repository.getProducts(page: 2, pageSize: 5);
    _trendingFuture = _repository.getProducts(page: 3, pageSize: 5);
  }

  @override
  void dispose() {
    _promotionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        elevation: 0,
        titleSpacing: 16,
        title: Row(
          children: [
            SvgPicture.asset(
              SvgAssets.shop,
              colorFilter: const ColorFilter.mode(AppColors.white, BlendMode.srcIn),
              width: 32,
              height: 32,
            ),
          ],
        ),
        actions: [
          GestureDetector(
            onTap: () {},
            child: SvgPicture.asset(
              SvgAssets.search,
              colorFilter: const ColorFilter.mode(AppColors.white, BlendMode.srcIn),
              width: 22,
              height: 22,
            ),
          ),
          const SizedBox(width: 18),
          GestureDetector(
            onTap: () {},
            child: SvgPicture.asset(
              SvgAssets.heart,
              colorFilter: const ColorFilter.mode(AppColors.white, BlendMode.srcIn),
              width: 22,
              height: 22,
            ),
          ),
          const SizedBox(width: 18),
          GestureDetector(
            onTap: () {},
            child: SvgPicture.asset(
              SvgAssets.notification,
              colorFilter: const ColorFilter.mode(AppColors.white, BlendMode.srcIn),
              width: 22,
              height: 22,
            ),
          ),
          const SizedBox(width: 16),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Promotion Banner Carousel
            Builder(
              builder: (context) {
                final screenWidth = MediaQuery.of(context).size.width;
                final bannerW = screenWidth * 0.88 - 24;
                final bannerH = (bannerW * 0.54).clamp(150.0, 220.0);
                return SizedBox(
                  height: bannerH + 30,
                  child: PageView(
                    controller: _promotionController,
                    clipBehavior: Clip.none,
                    children: [
                      _buildPromotionBanner(
                        'Hurry Up! Get 10% Off',
                        'Go Natural with\nUnpolished Grains',
                        const Color.fromARGB(255, 237, 116, 11),
                        const Color(0xFFF5B97A),
                      ),
                      _buildPromotionBanner(
                        'Hurry Up! Get 20% Off',
                        'Power Your Day\nwith Nuts & Dry Fruits',
                        const Color(0xFF6B4EC9),
                        const Color(0xFF9B7EE8),
                      ),
                    ],
                  ),
                );
              },
            ),

            // Categories
            _buildSectionHeader('Categories'),
            SizedBox(
              height: 128,
              child: FutureBuilder(
                future: _categoriesFuture,
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  return ListView.separated(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: snapshot.data!.length,
                    separatorBuilder: (_, _) => const SizedBox(width: 12),
                    itemBuilder: (context, index) {
                      return CategoryCard(category: snapshot.data![index]);
                    },
                  );
                },
              ),
            ),

            const SizedBox(height: 8),

            // Featured Products
            _buildProductSection('Featured Products', _featuredFuture),
            const SizedBox(height: 8),

            // Daily Best Selling
            _buildProductSection('Daily Best Selling', _dailyBestFuture),

            // Second promo banner
            _buildPromotionBanner(
              'Hurry Up! Get 20% Off',
              'Power Your Day\nwith Nuts & Dry Fruits',
              const Color(0xFF6B4EC9),
              const Color(0xFF9B7EE8),
            ),

            const SizedBox(height: 8),

            // Recently Added
            _buildProductSection('Recently Added', _recentlyAddedFuture),
            const SizedBox(height: 8),

            // Popular Products
            _buildProductSection('Popular Products', _popularFuture),
            const SizedBox(height: 8),

            // Trending Products
            _buildProductSection('Trending Products', _trendingFuture),

            const SizedBox(height: 24),
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomNavBar(),
    );
  }

  Widget _buildProductSection(String title, Future future) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionHeader(title),
        SizedBox(
          height: 260,
          child: FutureBuilder(
            future: future,
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return const Center(child: CircularProgressIndicator());
              }
              return ListView.separated(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: snapshot.data!.length,
                separatorBuilder: (_, _) => const SizedBox(width: 12),
                itemBuilder: (context, index) {
                  return SizedBox(
                    width: 170,
                    child: ProductCard(
                      product: snapshot.data![index],
                      isCompact: true,
                      onTap: () => context.push(
                        '/product-detail',
                        extra: snapshot.data![index],
                      ),
                      onAddToCart: () {},
                    ),
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildPromotionBanner(
    String title,
    String subtitle,
    Color colorStart,
    Color colorEnd,
  ) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 30, 12, 0),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final w = constraints.maxWidth;
          final h = (w * 0.54).clamp(150.0, 220.0);
          final imageW = (w * 0.52).clamp(140.0, 200.0);
          final contentRightPad = (w * 0.44).clamp(120.0, 170.0);
          final titleSize = (w * 0.034).clamp(11.0, 14.0);
          final subtitleSize = (w * 0.047).clamp(14.0, 19.0);
          final btnHPad = (w * 0.062).clamp(16.0, 28.0);

          return Stack(
            clipBehavior: Clip.none,
            children: [
              Container(
                height: h,
                width: double.maxFinite,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  gradient: LinearGradient(
                    colors: [colorStart, colorEnd],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                padding: EdgeInsets.fromLTRB(22, 20, contentRightPad, 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        color: AppColors.white,
                        fontSize: titleSize,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    SizedBox(height: h * 0.03),
                    Text(
                      subtitle,
                      maxLines: 2,
                      style: TextStyle(
                        color: AppColors.white,
                        fontSize: subtitleSize,
                        fontWeight: FontWeight.bold,
                        height: 1.2,
                      ),
                    ),
                    SizedBox(height: h * 0.07),
                    ElevatedButton(
                      onPressed: () => context.push('/products'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.white,
                        foregroundColor: colorStart,
                        padding: EdgeInsets.symmetric(
                            horizontal: btnHPad, vertical: 10),
                        elevation: 0,
                        shape: const StadiumBorder(),
                      ),
                      child: Text(
                        'Shop Now',
                        style: TextStyle(
                          color: colorStart,
                          fontWeight: FontWeight.bold,
                          fontSize: (w * 0.037).clamp(12.0, 15.0),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Positioned(
                right: 0,
                top: -30,
                bottom: 0,
                width: imageW,
                child: Image.asset(
                  'assets/images/featured_image.png',
                  fit: BoxFit.contain,
                  alignment: Alignment.bottomRight,
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 12, 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: AppColors.primaryDark,
            ),
          ),
          Row(
            children: [
              GestureDetector(
                onTap: () {},
                child: const Icon(Icons.chevron_left, size: 22, color: AppColors.greyDark),
              ),
              GestureDetector(
                onTap: () => context.push('/products'),
                child: const Icon(Icons.chevron_right, size: 22, color: AppColors.greyDark),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildBottomNavBar() {
    final items = [
      {'icon': SvgAssets.shop, 'label': 'Home'},
      {'icon': SvgAssets.category, 'label': 'Categories'},
      {'icon': SvgAssets.cart, 'label': 'Cart'},
      {'icon': SvgAssets.shop, 'label': 'Profile'},
    ];

    return Container(
      height: 70,
      decoration: const BoxDecoration(
        color: AppColors.white,
        border: Border(top: BorderSide(color: AppColors.borderColorLight)),
      ),
      child: Row(
        children: List.generate(items.length, (index) {
          final isActive = index == 0;
          final color = isActive ? AppColors.primary : AppColors.grey;
          return Expanded(
            child: GestureDetector(
              onTap: () {},
              behavior: HitTestBehavior.opaque,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SvgPicture.asset(
                    items[index]['icon']!,
                    colorFilter: ColorFilter.mode(color, BlendMode.srcIn),
                    width: 24,
                    height: 24,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    items[index]['label']!,
                    style: TextStyle(
                      fontSize: 11,
                      color: color,
                      fontWeight: isActive ? FontWeight.w600 : FontWeight.normal,
                    ),
                  ),
                ],
              ),
            ),
          );
        }),
      ),
    );
  }
}
