import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:project_alisons/core/errors/error_mapper.dart';
import 'package:project_alisons/features/products/domain/usecases/get_home_data_usecase.dart';
import 'home_event.dart';
import 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final GetHomeDataUseCase _getHomeData;

  HomeBloc(this._getHomeData) : super(HomeInitial()) {
    on<HomeDataFetched>(_onHomeDataFetched);
  }

  Future<void> _onHomeDataFetched(
    HomeDataFetched event,
    Emitter<HomeState> emit,
  ) async {
    emit(HomeLoading());
    try {
      final data = await _getHomeData();
      emit(HomeLoaded(data));
    } catch (e) {
      emit(HomeError(ErrorMapper.message(e, fallback: 'Failed to load home data')));
    }
  }
}
