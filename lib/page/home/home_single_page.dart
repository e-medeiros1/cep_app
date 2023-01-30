import 'package:cep_app/page/state_single_class/home_state.dart';
import 'package:cep_app/widgets/search_button.dart';
import 'package:cep_app/widgets/search_input.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:validatorless/validatorless.dart';

import '../../widgets/result_card.dart';
import '../state_single_class/home_single_class_controller.dart';

class HomeSinglePage extends StatefulWidget {
  const HomeSinglePage({super.key});

  @override
  State<HomeSinglePage> createState() => _HomeSinglePageState();
}

class _HomeSinglePageState extends State<HomeSinglePage> {
  final HomeSingleClassController homeSingleClassController =
      HomeSingleClassController();
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
      child: BlocListener<HomeSingleClassController, HomeState>(
        bloc: homeSingleClassController,
        listener: (context, state) {
          if (state.status == HomeStatus.failure) {
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
                            homeSingleClassController.buscaCep(controller.text);
                          }
                        }),
                    const SizedBox(height: 20),
                    //Visibility
                    BlocBuilder<HomeSingleClassController, HomeState>(
                      bloc: homeSingleClassController,
                      builder: (context, state) {
                        return Visibility(
                          visible: state.status == HomeStatus.loading,
                          replacement: const Center(child: SizedBox.shrink()),
                          child:
                              const Center(child: CircularProgressIndicator()),
                        );
                      },
                    ),
                    BlocBuilder<HomeSingleClassController, HomeState>(
                      bloc: homeSingleClassController,
                      builder: (context, state) {
                        if (state.status == HomeStatus.loaded) {
                          if (state.enderecoModel!.cep.isEmpty) {
                            return const SizedBox.shrink();
                          } else {
                            return ResultCard(
                                text:
                                    '${state.enderecoModel?.logradouro}, ${state.enderecoModel?.bairro}, ${state.enderecoModel?.localidade}, ${state.enderecoModel?.uf}',
                                subtitle:
                                    '${state.enderecoModel?.cep}, ${state.enderecoModel?.ddd}');
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
