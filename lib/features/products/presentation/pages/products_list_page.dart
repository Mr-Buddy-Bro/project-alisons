import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:project_alisons/config/assets/svg_assets.dart';
import 'package:project_alisons/config/theme/app_colors.dart';
import 'package:project_alisons/features/cart/presentation/bloc/cart_cubit.dart';
import 'package:project_alisons/features/products/presentation/bloc/products/products_bloc.dart';
import 'package:project_alisons/features/products/presentation/bloc/products/products_event.dart';
import 'package:project_alisons/features/products/presentation/bloc/products/products_state.dart';
import 'package:project_alisons/features/products/presentation/widgets/product_card.dart';

class ProductsListPage extends StatefulWidget {
  final String? category;

  const ProductsListPage({super.key, this.category});

  @override
  State<ProductsListPage> createState() => _ProductsListPageState();
}

class _ProductsListPageState extends State<ProductsListPage> {
  late ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _scrollController.addListener(_onScroll);
    context.read<ProductsBloc>().add(ProductsFetched(
          by: 'category',
          value: widget.category ?? '',
        ));
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      context.read<ProductsBloc>().add(ProductsNextPageFetched());
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
            padding: const EdgeInsets.all(18),
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
          widget.category?.isNotEmpty == true ? widget.category! : 'Products',
          style: Theme.of(context)
              .textTheme
              .titleLarge
              ?.copyWith(color: AppColors.black),
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
      body: BlocBuilder<ProductsBloc, ProductsState>(
        builder: (context, state) {
          if (state is ProductsLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is ProductsError) {
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
                        context.read<ProductsBloc>().add(ProductsFetched(
                              by: 'category',
                              value: widget.category ?? '',
                            )),
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }

          if (state is ProductsLoaded) {
            if (state.products.isEmpty) {
              return Center(
                child: Text('No products found',
                    style: Theme.of(context).textTheme.bodyMedium),
              );
            }
            return Column(
              children: [
                Expanded(
                  child: GridView.builder(
                    controller: _scrollController,
                    padding: const EdgeInsets.all(16),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      mainAxisSpacing: 12,
                      crossAxisSpacing: 12,
                      childAspectRatio: 0.7,
                    ),
                    itemCount:
                        state.products.length + (state.hasMore ? 1 : 0),
                    itemBuilder: (context, index) {
                      if (index == state.products.length) {
                        return const Center(
                            child: CircularProgressIndicator());
                      }
                      final product = state.products[index];
                      return ProductCard(
                        product: product,
                        onTap: () => context.push(
                          '/product-detail',
                          extra: product,
                        ),
                        onAddToCart: () {
                          context.read<CartCubit>().addProduct(product);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                                content:
                                    Text('${product.name} added to cart')),
                          );
                        },
                        onToggleFavorite: () {},
                      );
                    },
                  ),
                ),
                _buildSortFilterBar(),
              ],
            );
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }

  Widget _buildSortFilterBar() {
    return Container(
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
                  SvgPicture.asset(SvgAssets.sort,
                      width: 20,
                      height: 20,
                      colorFilter: const ColorFilter.mode(
                          AppColors.black, BlendMode.srcIn)),
                  const SizedBox(width: 8),
                  Text('Sort By',
                      style: Theme.of(context)
                          .textTheme
                          .bodyMedium
                          ?.copyWith(fontWeight: FontWeight.w700)),
                ],
              ),
            ),
          ),
          Container(width: 1, height: 32, color: AppColors.borderColorLight),
          Expanded(
            child: InkWell(
              onTap: () {},
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Stack(
                    clipBehavior: Clip.none,
                    children: [
                      SvgPicture.asset(SvgAssets.filter,
                          width: 20,
                          height: 20,
                          colorFilter: const ColorFilter.mode(
                              AppColors.black, BlendMode.srcIn)),
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
                  Text('Filter',
                      style: Theme.of(context)
                          .textTheme
                          .bodyMedium
                          ?.copyWith(fontWeight: FontWeight.w700)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
