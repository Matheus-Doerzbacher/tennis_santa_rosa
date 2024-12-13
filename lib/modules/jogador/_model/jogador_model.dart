enum Situacao {
  ferias,
  machucado,
  ativo,
}

class JogadorModel {
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
  int? posicaoRankingAtual;
  int? posicaoRankingAnterior;
  DateTime? dataUltimoJogo;
  bool? venceuUltimoJogo;
  int jogosNoMes;
  // desafio
  String? uidDesafiante;
  String? uidUltimoDesafio;

  JogadorModel({
    // informacoes do usuario
    this.uid,
    this.nome,
    required this.login,
    required this.senha,
    this.telefone,
    DateTime? dataCriacao,
    this.urlImage,
    this.isAdmin = false,
    // ranking
    this.situacao = Situacao.ativo,
    this.posicaoRankingAtual,
    this.posicaoRankingAnterior,
    this.dataUltimoJogo,
    this.venceuUltimoJogo,
    this.jogosNoMes = 0,
    // desafio
    this.uidDesafiante,
    this.uidUltimoDesafio,
  }) : dataCriacao = dataCriacao ?? DateTime.now();

  bool get temDesafio => uidDesafiante?.isNotEmpty == true;

  factory JogadorModel.fromJson(Map<String, dynamic> json) {
    final usuario = JogadorModel(
      // informacoes do usuario
      uid: json['uid'],
      nome: json['nome'],
      login: json['login'],
      senha: json['senha'],
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
      uidDesafiante: json['uidDesafiante'],
      uidUltimoDesafio: json['uidUltimoDesafio'],
    );

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
      'dataUltimoJogo': dataUltimoJogo?.toIso8601String(),
      'venceuUltimoJogo': venceuUltimoJogo,
      'jogosNoMes': jogosNoMes,
      'urlImage': urlImage,
      'isAdmin': isAdmin,
      'uidDesafiante': uidDesafiante,
      'uidUltimoDesafio': uidUltimoDesafio,
    };
  }

  JogadorModel copyWith({
    String? uid,
    String? nome,
    String? login,
    String? senha,
    String? telefone,
    Situacao? situacao,
    DateTime? dataCriacao,
    int? posicaoRankingAtual,
    int? posicaoRankingAnterior,
    DateTime? dataUltimoJogo,
    bool? venceuUltimoJogo,
    int? jogosNoMes,
    String? urlImage,
    bool? isAdmin,
    String? uidDesafiante,
    String? uidUltimoDesafio,
    DateTime? dataUltimoDesafio,
  }) {
    return JogadorModel(
      uid: uid ?? this.uid,
      nome: nome ?? this.nome,
      login: login ?? this.login,
      senha: senha ?? this.senha,
      telefone: telefone ?? this.telefone,
      situacao: situacao ?? this.situacao,
      dataCriacao: dataCriacao ?? this.dataCriacao,
      posicaoRankingAtual: posicaoRankingAtual ?? this.posicaoRankingAtual,
      posicaoRankingAnterior:
          posicaoRankingAnterior ?? this.posicaoRankingAnterior,
      dataUltimoJogo: dataUltimoJogo ?? this.dataUltimoJogo,
      venceuUltimoJogo: venceuUltimoJogo ?? this.venceuUltimoJogo,
      jogosNoMes: jogosNoMes ?? this.jogosNoMes,
      urlImage: urlImage ?? this.urlImage,
      isAdmin: isAdmin ?? this.isAdmin,
      uidDesafiante: uidDesafiante ?? this.uidDesafiante,
      uidUltimoDesafio: uidUltimoDesafio ?? this.uidUltimoDesafio,
    );
  }
}
