import 'dart:convert';

import 'package:crypto/crypto.dart';

enum Situacao {
  ferias,
  machucado,
  ativo,
}

class UsuarioModel {
  // informacoes do usuario
  String? uid;
  String? nome;
  String login;
  String senha;
  String? telefone;
  DateTime dataCriacao;
  String? urlImage;
  bool isAdmin;
  // ranking
  Situacao situacao;
  int posicaoRankingAtual;
  int posicaoRankingAnterior;
  DateTime? dataUltimoJogo;
  bool? venceuUltimoJogo;
  int jogosNoMes;
  // desafio
  bool temDesafio;
  String? uidDesafiante;

  UsuarioModel({
    // informacoes do usuario
    this.uid,
    this.nome,
    required this.login,
    required String senha,
    this.telefone,
    DateTime? dataCriacao,
    this.urlImage,
    this.isAdmin = false,
    // ranking
    this.situacao = Situacao.ativo,
    required this.posicaoRankingAtual,
    required this.posicaoRankingAnterior,
    this.dataUltimoJogo,
    this.venceuUltimoJogo,
    this.jogosNoMes = 0,
    // desafio
    this.temDesafio = false,
    this.uidDesafiante,
  })  : dataCriacao = dataCriacao ?? DateTime.now(),
        senha = encryptPassword(senha);

  static String encryptPassword(String password) {
    final bytes = utf8.encode(password);
    final digest = sha256.convert(bytes);
    return digest.toString();
  }

  factory UsuarioModel.fromJson(Map<String, dynamic> json) {
    final usuario = UsuarioModel(
      // informacoes do usuario
      uid: json['uid'],
      nome: json['nome'],
      login: json['login'],
      senha: '',
      telefone: json['telefone'],
      dataCriacao: DateTime.parse(json['dataCriacao']),
      urlImage: json['urlImage'],
      isAdmin: json['isAdmin'],
      // ranking
      situacao: Situacao.values[json['situacao']],
      posicaoRankingAtual: json['posicaoRankingAtual'],
      posicaoRankingAnterior: json['posicaoRankingAnterior'],
      dataUltimoJogo: json['dataUltimoJogo'] != null
          ? DateTime.parse(json['dataUltimoJogo'])
          : null,
      venceuUltimoJogo: json['venceuUltimoJogo'],
      jogosNoMes: json['jogosNoMes'],
      // desafio
      temDesafio: json['temDesafio'],
      uidDesafiante: json['uidDesafiante'],
    )..senha = json['senha'];

    return usuario;
  }

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
      'uidDesafiante': uidDesafiante,
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
    String? uidDesafiante,
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
      uidDesafiante: uidDesafiante ?? this.uidDesafiante,
    );
  }
}
