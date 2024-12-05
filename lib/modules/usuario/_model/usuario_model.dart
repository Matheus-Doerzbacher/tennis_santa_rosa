import 'dart:convert';

import 'package:crypto/crypto.dart';

enum Situacao {
  ferias,
  machucado,
  ativo,
}

class UsuarioModel {
  String? uid;
  String? nome;
  String login;
  String senha;
  String? telefone;
  Situacao situacao;
  DateTime dataCriacao;
  int posicaoRankingAtual;
  int? posicaoRankingAnterior;
  bool temDesafio;
  DateTime? dataUltimoJogo;
  bool? venceuUltimoJogo;
  int jogosNoMes;
  String? urlImage;
  bool isAdmin;

  UsuarioModel({
    this.uid,
    this.nome,
    required this.login,
    required String senha,
    this.telefone,
    this.situacao = Situacao.ativo,
    DateTime? dataCriacao,
    required this.posicaoRankingAtual,
    this.posicaoRankingAnterior,
    this.temDesafio = false,
    this.dataUltimoJogo,
    this.venceuUltimoJogo,
    this.jogosNoMes = 0,
    this.urlImage,
    this.isAdmin = false,
  })  : dataCriacao = dataCriacao ?? DateTime.now(),
        senha = encryptPassword(senha);

  static String encryptPassword(String password) {
    final bytes = utf8.encode(password);
    final digest = sha256.convert(bytes);
    return digest.toString();
  }

  factory UsuarioModel.fromJson(Map<String, dynamic> json) {
    return UsuarioModel._(
      uid: json['uid'],
      nome: json['nome'],
      login: json['login'],
      senha: json['senha'],
      telefone: json['telefone'],
      situacao: Situacao.values[json['situacao']],
      dataCriacao: DateTime.parse(json['dataCriacao']),
      posicaoRankingAtual: json['posicaoRankingAtual'],
      posicaoRankingAnterior: json['posicaoRankingAnterior'],
      temDesafio: json['temDesafio'],
      dataUltimoJogo: json['dataUltimoJogo'] != null
          ? DateTime.parse(json['dataUltimoJogo'])
          : null,
      venceuUltimoJogo: json['venceuUltimoJogo'],
      jogosNoMes: json['jogosNoMes'],
      urlImage: json['urlImage'],
      isAdmin: json['isAdmin'],
    );
  }

  UsuarioModel._({
    this.uid,
    this.nome,
    required this.login,
    required this.senha,
    this.telefone,
    this.situacao = Situacao.ativo,
    required this.dataCriacao,
    required this.posicaoRankingAtual,
    this.posicaoRankingAnterior,
    this.temDesafio = false,
    this.dataUltimoJogo,
    this.venceuUltimoJogo,
    this.jogosNoMes = 0,
    this.urlImage,
    this.isAdmin = false,
  });

  Map<String, dynamic> toJson() {
    return {
      'uid': uid,
      'nome': nome,
      'login': login,
      'senha': senha,
      'telefone': telefone,
      'situacao': situacao.index,
      'dataCriacao': dataCriacao.toIso8601String(),
      'posicaoRankingAtual': posicaoRankingAtual,
      'posicaoRankingAnterior': posicaoRankingAnterior,
      'temDesafio': temDesafio,
      'dataUltimoJogo': dataUltimoJogo?.toIso8601String(),
      'venceuUltimoJogo': venceuUltimoJogo,
      'jogosNoMes': jogosNoMes,
      'urlImage': urlImage,
      'isAdmin': isAdmin,
    };
  }

  UsuarioModel copyWith({
    String? uid,
    String? nome,
    String? login,
    String? senha,
    String? telefone,
    Situacao? situacao,
    DateTime? dataCriacao,
    int? posicaoRankingAtual,
    int? posicaoRankingAnterior,
    bool? temDesafio,
    DateTime? dataUltimoJogo,
    bool? venceuUltimoJogo,
    int? jogosNoMes,
    String? urlImage,
    bool? isAdmin,
  }) {
    return UsuarioModel(
      uid: uid ?? this.uid,
      nome: nome ?? this.nome,
      login: login ?? this.login,
      senha: senha != null ? encryptPassword(senha) : this.senha,
      telefone: telefone ?? this.telefone,
      situacao: situacao ?? this.situacao,
      dataCriacao: dataCriacao ?? this.dataCriacao,
      posicaoRankingAtual: posicaoRankingAtual ?? this.posicaoRankingAtual,
      posicaoRankingAnterior:
          posicaoRankingAnterior ?? this.posicaoRankingAnterior,
      temDesafio: temDesafio ?? this.temDesafio,
      dataUltimoJogo: dataUltimoJogo ?? this.dataUltimoJogo,
      venceuUltimoJogo: venceuUltimoJogo ?? this.venceuUltimoJogo,
      jogosNoMes: jogosNoMes ?? this.jogosNoMes,
      urlImage: urlImage ?? this.urlImage,
      isAdmin: isAdmin ?? this.isAdmin,
    );
  }
}
