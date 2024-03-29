import 'package:cep_app/page/state_subclass/home_controller.dart';
import 'package:cep_app/page/state_subclass/home_state.dart';
import 'package:cep_app/widgets/search_button.dart';
import 'package:cep_app/widgets/search_input.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:validatorless/validatorless.dart';

import '../../widgets/result_card.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final HomeController homeController = HomeController();
  final controller = TextEditingController();
  final formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: BlocListener<HomeController, HomeState>(
        bloc: homeController,
        listener: (context, state) {
          if (state is HomeFailure) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Não foi possível carregar CEP!'),
              ),
            );
          }
        },
        child: Scaffold(
          appBar: AppBar(
            title: const Center(child: Text('Buscador de CEP')),
          ),
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Form(
                key: formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 10),
                    SearchInput(
                      validator: Validatorless.multiple(
                        [
                          Validatorless.required('CEP obrigatório'),
                          Validatorless.min(8, 'Insira os 8 dígitos do CEP')
                        ],
                      ),
                      searchController: controller,
                      hintText: 'Insira um CEP válido',
                    ),
                    const SizedBox(height: 10),
                    SearchButton(
                        text: 'Procurar',
                        onPressed: () async {
                          final valid =
                              formKey.currentState?.validate() ?? false;
                          if (valid) {
                            homeController.buscaCep(controller.text);
                          }
                        }),
                    const SizedBox(height: 20),
                    //Visibility
                    BlocBuilder<HomeController, HomeState>(
                      bloc: homeController,
                      builder: (context, state) {
                        return Visibility(
                          visible: state is HomeLoading,
                          replacement: const Center(child: SizedBox.shrink()),
                          child:
                              const Center(child: CircularProgressIndicator()),
                        );
                      },
                    ),
                    BlocBuilder<HomeController, HomeState>(
                      bloc: homeController,
                      builder: (context, state) {
                        if (state is HomeLoaded) {
                          if (state.enderecoModel.cep.isEmpty) {
                            return const SizedBox.shrink();
                          } else {
                            return ResultCard(
                                text:
                                    '${state.enderecoModel.logradouro}, ${state.enderecoModel.bairro}, ${state.enderecoModel.localidade}, ${state.enderecoModel.uf}',
                                subtitle:
                                    '${state.enderecoModel.cep}, ${state.enderecoModel.ddd}');
                          }
                        } else {
                          return const Center(child: SizedBox.shrink());
                        }
                      },
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
