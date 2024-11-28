enum Situacao {
  ferias,
  machucado,
  ativo,
}

class UsuarioModel {
  final String? uid;
  final String nome;
  final String email;
  final String senha;
  final String telefone;
  final Situacao situacao;
  final DateTime dataCriacao;
  final int posicaoRankingAtual;
  final int posicaoRankingAnterior;
  final bool temDesafio;
  final DateTime? dataUltimoJogo;
  final bool? venceuUltimoJogo;
  final int jogosNoMes;

  UsuarioModel({
    this.uid,
    required this.nome,
    required this.email,
    required this.senha,
    required this.telefone,
    required this.situacao,
    required this.dataCriacao,
    required this.posicaoRankingAtual,
    required this.posicaoRankingAnterior,
    this.temDesafio = false,
    this.dataUltimoJogo,
    this.venceuUltimoJogo,
    this.jogosNoMes = 0,
  });

  factory UsuarioModel.fromJson(Map<String, dynamic> json) {
    return UsuarioModel(
      uid: json['uid'],
      nome: json['nome'],
      email: json['email'],
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
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'uid': uid,
      'nome': nome,
      'email': email,
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
    };
  }

  UsuarioModel copyWith({
    String? uid,
    String? nome,
    String? email,
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
  }) {
    return UsuarioModel(
      uid: uid ?? this.uid,
      nome: nome ?? this.nome,
      email: email ?? this.email,
      senha: senha ?? this.senha,
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
    );
  }
}
