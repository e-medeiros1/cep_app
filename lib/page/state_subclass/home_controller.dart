import 'package:bloc/bloc.dart';
import 'package:cep_app/page/state_subclass/home_state.dart';
import 'package:cep_app/repositories/cep_repository.dart';

import '../../repositories/cep_repository_impl.dart';

class HomeController extends Cubit<HomeState> {
  final CepRepository cepRepository = CepRepositoryImpl();

  HomeController() : super(HomeInitial());

  Future<void> buscaCep(String cep) async {
    try {
      emit(HomeLoading());
      final enderecoModel = await cepRepository.getCep(cep);
      emit(HomeLoaded(enderecoModel: enderecoModel));
    } catch (e) {
      emit(HomeFailure());
    }
  }
}
