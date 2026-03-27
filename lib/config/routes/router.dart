import 'package:go_router/go_router.dart';
import 'package:project_alisons/features/auth/presentation/login_page.dart';
import 'package:project_alisons/features/products/presentation/pages/home_page.dart';
import 'package:project_alisons/features/products/presentation/pages/product_detail_page.dart';
import 'package:project_alisons/features/products/presentation/pages/products_list_page.dart';

final GoRouter router = GoRouter(
  initialLocation: '/home',
  routes: <RouteBase>[
    GoRoute(
      path: '/login',
      builder: (context, state) => const LoginPage(),
      name: 'login',
    ),
    GoRoute(
      path: '/home',
      builder: (context, state) => const HomePage(),
      name: 'home',
    ),
    GoRoute(
      path: '/products',
      builder: (context, state) {
        final category = state.uri.queryParameters['category'];
        return ProductsListPage(category: category);
      },
      name: 'products',
    ),
    GoRoute(
      path: '/product-detail',
      builder: (context, state) {
        final product = state.extra as dynamic;
        return ProductDetailPage(product: product);
      },
      name: 'productDetail',
    ),
  ],
);
