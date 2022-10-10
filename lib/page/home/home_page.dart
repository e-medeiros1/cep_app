import 'package:cep_app/models/endereco_model.dart';
import 'package:cep_app/repositories/cep_repository.dart';
import 'package:cep_app/repositories/cep_repository_impl.dart';
import 'package:cep_app/widgets/result_card.dart';
import 'package:cep_app/widgets/search_button.dart';
import 'package:cep_app/widgets/search_input.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final CepRepository cepRepository = CepRepositoryImpl();
  EnderecoModel? enderecoModel;
  final controller = TextEditingController();
  final formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'CEP obrigatório';
                    }
                    return null;
                  },
                  searchController: controller,
                  hintText: 'Insira um CEP válido',
                ),
                const SizedBox(height: 10),
                SearchButton(
                    text: 'Procurar',
                    onPressed: () async {
                      final valid = formKey.currentState?.validate() ?? false;
                      if (valid) {
                        try {
                          final endereco =
                              await cepRepository.getCep(controller.text);
                          setState(() {
                            enderecoModel = endereco;
                          });
                        } catch (e) {
                          setState(() {
                            enderecoModel = null;
                          });
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                backgroundColor: Colors.white,
                                elevation: 2,
                                content: Text(
                                  'Erro ao consultar CEP',
                                  style: TextStyle(color: Colors.blue),
                                  textAlign: TextAlign.center,
                                )),
                          );
                        }
                      }
                    }),
                const SizedBox(height: 20),
                Visibility(
                  visible: enderecoModel != null,
                  replacement: const SizedBox.shrink(),
                  child: ResultCard(
                      text:
                          '${enderecoModel?.logradouro}, ${enderecoModel?.localidade}, ${enderecoModel?.bairro}',
                      subtitle: '${enderecoModel?.cep}, ${enderecoModel?.ddd}'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
