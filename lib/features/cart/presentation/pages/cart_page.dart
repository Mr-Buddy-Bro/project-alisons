import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:project_alisons/config/assets/svg_assets.dart';
import 'package:project_alisons/config/theme/app_colors.dart';
import 'package:project_alisons/features/cart/presentation/bloc/cart_cubit.dart';
import 'package:project_alisons/features/cart/presentation/bloc/cart_state.dart';

class CartPage extends StatelessWidget {
  const CartPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF2F2F2),
      appBar: AppBar(
        backgroundColor: AppColors.white,
        elevation: 0,
        leading: IconButton(
          onPressed: () => context.pop(),
          icon: SvgPicture.asset(
            SvgAssets.arrowLeft,
            colorFilter: const ColorFilter.mode(
              AppColors.black,
              BlendMode.srcIn,
            ),
          ),
        ),
        title: const Text(
          'Cart',
          style: TextStyle(
            color: AppColors.black,
            fontWeight: FontWeight.w700,
          ),
        ),
        actions: [
          BlocBuilder<CartCubit, CartState>(
            builder: (context, state) {
              if (state.isEmpty) return const SizedBox.shrink();
              return TextButton(
                onPressed: () => context.read<CartCubit>().clearCart(),
                child: const Text('Clear'),
              );
            },
          ),
        ],
      ),
      body: BlocBuilder<CartCubit, CartState>(
        builder: (context, state) {
          if (state.isEmpty) {
            return const _EmptyCartView();
          }

          return Column(
            children: [
              Expanded(
                child: ListView.separated(
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                  itemCount: state.items.length,
                  separatorBuilder: (_, _) => const SizedBox(height: 12),
                  itemBuilder: (context, index) {
                    final item = state.items[index];
                    return _CartItemTile(item: item);
                  },
                ),
              ),
              _CartSummary(totalItems: state.totalItems, totalAmount: state.totalAmount),
            ],
          );
        },
      ),
    );
  }
}

class _CartItemTile extends StatelessWidget {
  final CartItem item;

  const _CartItemTile({required this.item});

  @override
  Widget build(BuildContext context) {
    final product = item.product;

    return Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      padding: const EdgeInsets.all(12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Container(
              width: 78,
              height: 78,
              color: AppColors.greyExtraLight,
              child: product.image.isNotEmpty
                  ? CachedNetworkImage(
                      imageUrl: product.image,
                      fit: BoxFit.cover,
                      errorWidget: (_, _, _) => const Icon(
                        Icons.broken_image,
                        color: AppColors.grey,
                      ),
                    )
                  : const Icon(Icons.image_not_supported, color: AppColors.grey),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  product.name,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: AppColors.black,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  '${product.symbolLeft} ${product.currentPrice.toStringAsFixed(2)}',
                  style: const TextStyle(
                    color: AppColors.primary,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Qty: ${item.quantity}  •  Subtotal: ${product.symbolLeft} ${item.total.toStringAsFixed(2)}',
                  style: const TextStyle(
                    color: AppColors.greyDark,
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    _QtyButton(
                      label: '-',
                      onTap: () => context.read<CartCubit>().decreaseQuantity(product),
                    ),
                    Container(
                      width: 42,
                      alignment: Alignment.center,
                      child: Text(
                        '${item.quantity}',
                        style: const TextStyle(fontWeight: FontWeight.w700),
                      ),
                    ),
                    _QtyButton(
                      label: '+',
                      onTap: () => context.read<CartCubit>().increaseQuantity(product),
                    ),
                    const Spacer(),
                    IconButton(
                      onPressed: () => context.read<CartCubit>().removeProduct(product),
                      icon: const Icon(Icons.delete_outline, color: AppColors.greyDark),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _QtyButton extends StatelessWidget {
  final String label;
  final VoidCallback onTap;

  const _QtyButton({required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(6),
      child: Container(
        width: 28,
        height: 28,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(6),
          border: Border.all(color: AppColors.borderColorLight),
        ),
        alignment: Alignment.center,
        child: Text(
          label,
          style: const TextStyle(
            color: AppColors.primary,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}

class _CartSummary extends StatelessWidget {
  final int totalItems;
  final double totalAmount;

  const _CartSummary({required this.totalItems, required this.totalAmount});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.white,
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 28),
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                Text(
                  'Items: $totalItems',
                  style: const TextStyle(
                    color: AppColors.greyDark,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const Spacer(),
                Text(
                  'Total: ₹ ${totalAmount.toStringAsFixed(2)}',
                  style: const TextStyle(
                    color: AppColors.black,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Checkout is not connected yet.')),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: const Text('Proceed to Checkout'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _EmptyCartView extends StatelessWidget {
  const _EmptyCartView();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 28),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.shopping_cart_outlined, size: 56, color: AppColors.grey),
            const SizedBox(height: 12),
            const Text(
              'Your cart is empty',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Add products to see them here.',
              textAlign: TextAlign.center,
              style: TextStyle(color: AppColors.greyDark),
            ),
            const SizedBox(height: 18),
            OutlinedButton(
              onPressed: () => context.pop(),
              child: const Text('Continue Shopping'),
            ),
          ],
        ),
      ),
    );
  }
}
