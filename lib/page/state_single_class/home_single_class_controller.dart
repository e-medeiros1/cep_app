import 'package:bloc/bloc.dart';
import 'package:cep_app/page/state_single_class/home_state.dart';
import 'package:cep_app/repositories/cep_repository.dart';

import '../../repositories/cep_repository_impl.dart';

class HomeSingleClassController extends Cubit<HomeState> {
  final CepRepository cepRepository = CepRepositoryImpl();
  HomeSingleClassController() : super(HomeState());

  Future<void> buscaCep(String cep) async {
    try {
      emit(state.copyWith(status: HomeStatus.loading));
      final enderecoModel = await cepRepository.getCep(cep);
      emit(state.copyWith(
          status: HomeStatus.loaded, enderecoModel: enderecoModel));
    } catch (e) {
      emit(state.copyWith(status: HomeStatus.failure));
    }
  }
}
