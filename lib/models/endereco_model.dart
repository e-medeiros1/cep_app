import 'dart:convert';

// ignore_for_file: public_member_api_docs, sort_constructors_first

class EnderecoModel {
  final String cep;
  final String logradouro;
  final String bairro;
  final String localidade;
  final int ddd;
  EnderecoModel({
    required this.cep,
    required this.logradouro,
    required this.bairro,
    required this.localidade,
    required this.ddd,
  });

  

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'cep': cep,
      'logradouro': logradouro,
      'bairro': bairro,
      'localidade': localidade,
      'ddd': ddd,
    };
  }

  factory EnderecoModel.fromMap(Map<String, dynamic> map) {
    return EnderecoModel(
      cep: map['cep'] as String,
      logradouro: map['logradouro'] as String,
      bairro: map['bairro'] as String,
      localidade: map['localidade'] as String,
      ddd: map['ddd'] as int,
    );
  }

  String toJson() => json.encode(toMap());

  factory EnderecoModel.fromJson(String source) => EnderecoModel.fromMap(json.decode(source) as Map<String, dynamic>);
}
