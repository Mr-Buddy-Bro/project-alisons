import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:project_alisons/config/assets/svg_assets.dart';
import 'package:project_alisons/config/theme/app_colors.dart';
import 'package:project_alisons/core/storage/local_storage.dart';
import 'package:project_alisons/features/cart/presentation/bloc/cart_cubit.dart';
import 'package:project_alisons/features/cart/presentation/bloc/cart_state.dart';
import 'package:project_alisons/features/products/data/models/banner_model.dart';
import 'package:project_alisons/features/products/data/models/home_data_model.dart';
import 'package:project_alisons/features/products/data/models/product_model.dart';
import 'package:project_alisons/features/products/presentation/bloc/home/home_bloc.dart';
import 'package:project_alisons/features/products/presentation/bloc/home/home_event.dart';
import 'package:project_alisons/features/products/presentation/bloc/home/home_state.dart';
import 'package:project_alisons/features/products/presentation/widgets/category_card.dart';
import 'package:project_alisons/features/products/presentation/widgets/product_card.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  void _addToCart(ProductModel product) {
    context.read<CartCubit>().addProduct(product);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('${product.name} added to cart')),
    );
  }

  Future<void> _handleHiddenLogout() async {
    final shouldLogout = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Logout'),
          content: const Text('Do you want to logout?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(false),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(true),
              child: const Text('Logout'),
            ),
          ],
        );
      },
    );

    if (shouldLogout != true) return;

    try {
      await LocalStorage.instance.clearAuth();
      if (!mounted) return;
      context.read<CartCubit>().clearCart();
      if (!mounted) return;
      context.go('/login');
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Unable to logout. Please try again.')),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    context.read<HomeBloc>().add(HomeDataFetched());
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
            GestureDetector(
              onLongPress: _handleHiddenLogout,
              child: Image.asset(
                'assets/images/logo.png',
                height: 28,
                fit: BoxFit.contain,
              ),
            ),
          ],
        ),
        actions: [
          GestureDetector(
            onTap: () {},
            child: SvgPicture.asset(SvgAssets.search,
                colorFilter:
                    const ColorFilter.mode(AppColors.white, BlendMode.srcIn),
                width: 22,
                height: 22),
          ),
          const SizedBox(width: 18),
          GestureDetector(
            onTap: () {},
            child: SvgPicture.asset(SvgAssets.heart,
                colorFilter:
                    const ColorFilter.mode(AppColors.white, BlendMode.srcIn),
                width: 22,
                height: 22),
          ),
          const SizedBox(width: 18),
          GestureDetector(
            onTap: () {},
            child: SvgPicture.asset(SvgAssets.notification,
                colorFilter:
                    const ColorFilter.mode(AppColors.white, BlendMode.srcIn),
                width: 22,
                height: 22),
          ),
          const SizedBox(width: 16),
        ],
      ),
      body: BlocBuilder<HomeBloc, HomeState>(
        builder: (context, state) {
          if (state is HomeLoading || state is HomeInitial) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state is HomeError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(state.message,
                      textAlign: TextAlign.center,
                      style: const TextStyle(color: AppColors.greyDark)),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () =>
                        context.read<HomeBloc>().add(HomeDataFetched()),
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }
          final data = (state as HomeLoaded).data;
          return _buildContent(data);
        },
      ),
      bottomNavigationBar: _buildBottomNavBar(),
    );
  }

  Widget _buildContent(HomeDataModel data) {
    final hasAnySection = data.banners.isNotEmpty ||
        data.categories.isNotEmpty ||
        data.newArrivals.isNotEmpty ||
        data.bestSeller.isNotEmpty ||
        data.flashSale.isNotEmpty ||
        data.suggestedProducts.isNotEmpty ||
        data.ourProducts.isNotEmpty;

    if (!hasAnySection) {
      return _buildEmptyHomeState();
    }

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (data.banners.isNotEmpty) _buildBannerCarousel(data.banners),
          if (data.categories.isNotEmpty) ...[
            _buildSectionHeader('Categories'),
            SizedBox(
              height: 128,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: data.categories.length,
                separatorBuilder: (_, _) => const SizedBox(width: 12),
                itemBuilder: (context, index) =>
                    CategoryCard(category: data.categories[index]),
              ),
            ),
            const SizedBox(height: 8),
          ],
          if (data.newArrivals.isNotEmpty)
            _buildProductSection('New Arrivals', data.newArrivals),
          if (data.bestSeller.isNotEmpty) ...[
            const SizedBox(height: 8),
            _buildProductSection('Best Seller', data.bestSeller),
          ],
          if (data.banners.isEmpty)
            _buildStaticPromoBanner(
              'Hurry Up! Get 20% Off',
              'Power Your Day\nwith Nuts & Dry Fruits',
              const Color(0xFF6B4EC9),
              const Color(0xFF9B7EE8),
            ),
          const SizedBox(height: 8),
          if (data.flashSale.isNotEmpty)
            _buildProductSection('Flash Sale', data.flashSale),
          if (data.suggestedProducts.isNotEmpty) ...[
            const SizedBox(height: 8),
            _buildProductSection('Suggested For You', data.suggestedProducts),
          ],
          if (data.ourProducts.isNotEmpty) ...[
            const SizedBox(height: 8),
            _buildProductSection('Our Products', data.ourProducts),
          ],
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _buildEmptyHomeState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.inventory_2_outlined,
              size: 56,
              color: AppColors.grey,
            ),
            const SizedBox(height: 12),
            const Text(
              'Nothing to show right now',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: AppColors.black,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Please try refreshing in a moment.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 14, color: AppColors.greyDark),
            ),
            const SizedBox(height: 18),
            OutlinedButton(
              onPressed: () => context.read<HomeBloc>().add(HomeDataFetched()),
              child: const Text('Refresh'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBannerCarousel(List<BannerModel> banners) {
    return Padding(
      padding: const EdgeInsets.only(top: 16),
      child: CarouselSlider.builder(
        itemCount: banners.length,
        itemBuilder: (context, index, realIndex) {
          final banner = banners[index];
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: banner.image.isNotEmpty
                  ? CachedNetworkImage(
                      imageUrl: banner.image,
                      width: double.infinity,
                      fit: BoxFit.cover,
                      placeholder: (_, _) =>
                          Container(color: AppColors.greyExtraLight),
                      errorWidget: (_, _, _) =>
                          _buildBannerFallback(banner.title, banner.subTitle),
                    )
                  : _buildBannerFallback(banner.title, banner.subTitle),
            ),
          );
        },
        options: CarouselOptions(
          height: 140,
          viewportFraction: 0.88,
          enlargeCenterPage: true,
          enlargeFactor: 0.22,
          enableInfiniteScroll: banners.length > 1,
          autoPlay: banners.length > 1,
          autoPlayInterval: const Duration(seconds: 4),
        ),
      ),
    );
  }

  Widget _buildBannerFallback(String title, String subtitle) {
    return _buildStaticPromoBanner(
      title.isNotEmpty ? title : 'Hurry Up! Get 10% Off',
      subtitle.isNotEmpty ? subtitle : 'Go Natural with\nUnpolished Grains',
      const Color(0xFFED740B),
      const Color(0xFFF5B97A),
    );
  }

  Widget _buildProductSection(String title, List<ProductModel> products) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionHeader(title),
        SizedBox(
          height: 260,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: products.length,
            separatorBuilder: (_, _) => const SizedBox(width: 12),
            itemBuilder: (context, index) {
              return SizedBox(
                width: 170,
                child: ProductCard(
                  product: products[index],
                  isCompact: true,
                  onTap: () => context.push(
                    '/product-detail',
                    extra: products[index],
                  ),
                  onAddToCart: () => _addToCart(products[index]),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildStaticPromoBanner(
    String title,
    String subtitle,
    Color colorStart,
    Color colorEnd,
  ) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 30, 12, 0),
      child: LayoutBuilder(builder: (context, constraints) {
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
                  Text(title,
                      style: TextStyle(
                          color: AppColors.white,
                          fontSize: titleSize,
                          fontWeight: FontWeight.w400)),
                  SizedBox(height: h * 0.03),
                  Text(subtitle,
                      maxLines: 2,
                      style: TextStyle(
                          color: AppColors.white,
                          fontSize: subtitleSize,
                          fontWeight: FontWeight.bold,
                          height: 1.2)),
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
                    child: Text('Shop Now',
                        style: TextStyle(
                            color: colorStart,
                            fontWeight: FontWeight.bold,
                            fontSize: (w * 0.037).clamp(12.0, 15.0))),
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
      }),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 12, 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title,
              style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primaryDark)),
          Row(
            children: [
              GestureDetector(
                onTap: () {},
                child: const Icon(Icons.chevron_left,
                    size: 22, color: AppColors.greyDark),
              ),
              GestureDetector(
                onTap: () => context.push('/products'),
                child: const Icon(Icons.chevron_right,
                    size: 22, color: AppColors.greyDark),
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
      {'icon': SvgAssets.profile, 'label': 'Profile'},
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
              onTap: () {
                if (index == 2) {
                  context.push('/cart');
                }
              },
              behavior: HitTestBehavior.opaque,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (index == 2)
                    BlocBuilder<CartCubit, CartState>(
                      builder: (context, state) {
                        return Stack(
                          clipBehavior: Clip.none,
                          children: [
                            SvgPicture.asset(
                              items[index]['icon']!,
                              colorFilter:
                                  ColorFilter.mode(color, BlendMode.srcIn),
                              width: 24,
                              height: 24,
                            ),
                            if (state.totalItems > 0)
                              Positioned(
                                top: -6,
                                right: -10,
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 5, vertical: 1),
                                  decoration: const BoxDecoration(
                                    color: AppColors.primary,
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10)),
                                  ),
                                  child: Text(
                                    '${state.totalItems}',
                                    style: const TextStyle(
                                      color: AppColors.white,
                                      fontSize: 9,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                          ],
                        );
                      },
                    )
                  else
                    SvgPicture.asset(items[index]['icon']!,
                        colorFilter: ColorFilter.mode(color, BlendMode.srcIn),
                        width: 24,
                        height: 24),
                  const SizedBox(height: 4),
                  Text(items[index]['label']!,
                      style: TextStyle(
                          fontSize: 11,
                          color: color,
                          fontWeight: isActive
                              ? FontWeight.w600
                              : FontWeight.normal)),
                ],
              ),
            ),
          );
        }),
      ),
    );
  }
}
