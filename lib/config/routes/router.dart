import 'package:go_router/go_router.dart';
import 'package:project_alisons/core/storage/local_storage.dart';
import 'package:project_alisons/features/auth/presentation/pages/login_page.dart';
import 'package:project_alisons/features/products/data/models/product_model.dart';
import 'package:project_alisons/features/products/presentation/pages/home_page.dart';
import 'package:project_alisons/features/products/presentation/pages/product_detail_page.dart';
import 'package:project_alisons/features/products/presentation/pages/products_list_page.dart';

final GoRouter router = GoRouter(
  initialLocation: '/home',
  redirect: (context, state) {
    final isLoggedIn = LocalStorage.instance.isLoggedIn;
    final isLoginRoute = state.matchedLocation == '/login';
    if (!isLoggedIn && !isLoginRoute) return '/login';
    if (isLoggedIn && isLoginRoute) return '/home';
    return null;
  },
  routes: <RouteBase>[
    GoRoute(
      path: '/login',
      name: 'login',
      builder: (context, state) => const LoginPage(),
    ),
    GoRoute(
      path: '/home',
      name: 'home',
      builder: (context, state) => const HomePage(),
    ),
    GoRoute(
      path: '/products',
      name: 'products',
      builder: (context, state) {
        final extra = state.extra as Map<String, dynamic>?;
        final category = extra?['value'] as String? ??
            state.uri.queryParameters['category'];
        return ProductsListPage(category: category);
      },
    ),
    GoRoute(
      path: '/product-detail',
      name: 'productDetail',
      builder: (context, state) {
        final product = state.extra as ProductModel;
        return ProductDetailPage(product: product);
      },
    ),
  ],
);
