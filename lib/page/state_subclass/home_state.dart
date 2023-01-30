//Onde ficam as variáveis de estado

import 'package:cep_app/models/endereco_model.dart';

abstract class HomeState {}

class HomeInitial extends HomeState {}

class HomeLoading extends HomeState {}

class HomeFailure extends HomeState {}

class HomeLoaded extends HomeState {
  final EnderecoModel enderecoModel;

  HomeLoaded({required this.enderecoModel});
}

//Depois de definir todos os estados que a tela vai passar, cria-se a controller