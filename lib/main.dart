import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:project_alisons/config/routes/router.dart';
import 'package:project_alisons/config/theme/app_theme.dart';
import 'package:project_alisons/core/storage/local_storage.dart';
import 'package:project_alisons/features/auth/data/datasources/auth_remote_datasource.dart';
import 'package:project_alisons/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:project_alisons/features/auth/domain/usecases/login_usecase.dart';
import 'package:project_alisons/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:project_alisons/features/products/data/datasources/product_remote_datasource.dart';
import 'package:project_alisons/features/products/data/repositories/product_repository.dart';
import 'package:project_alisons/features/products/domain/usecases/get_home_data_usecase.dart';
import 'package:project_alisons/features/products/domain/usecases/get_products_usecase.dart';
import 'package:project_alisons/features/cart/presentation/bloc/cart_cubit.dart';
import 'package:project_alisons/features/products/presentation/bloc/home/home_bloc.dart';
import 'package:project_alisons/features/products/presentation/bloc/products/products_bloc.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await LocalStorage.instance.init();
  runApp(const MachineTask());
}

class MachineTask extends StatelessWidget {
  const MachineTask({super.key});

  @override
  Widget build(BuildContext context) {
    // Wire up dependencies
    final productDataSource = ProductRemoteDataSource();
    final productRepo = ProductRepository(productDataSource);

    final authDataSource = AuthRemoteDataSource();
    final authRepo = AuthRepositoryImpl(authDataSource);

    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => AuthBloc(LoginUseCase(authRepo)),
        ),
        BlocProvider(
          create: (_) => HomeBloc(GetHomeDataUseCase(productRepo)),
        ),
        BlocProvider(
          create: (_) => ProductsBloc(GetProductsUseCase(productRepo)),
        ),
        BlocProvider(
          create: (_) => CartCubit(),
        ),
      ],
      child: MaterialApp.router(
        debugShowCheckedModeBanner: false,
        title: 'Machine Task',
        theme: AppTheme.lightTheme,
        routerConfig: router,
      ),
    );
  }
}
