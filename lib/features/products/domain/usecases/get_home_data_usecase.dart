import 'package:project_alisons/features/products/data/models/home_data_model.dart';
import '../repositories/i_product_repository.dart';

class GetHomeDataUseCase {
  final IProductRepository repository;

  GetHomeDataUseCase(this.repository);

  Future<HomeDataModel> call() => repository.getHomeData();
}
