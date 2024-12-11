enum StatusDesafio {
  pendente, // Quando criado o desafio
  cancelado, // Quando a um cancelamento mutuo
  recusado, // Quando o desafiado recusa o desafio
  finalizado, // Quando é finalizado o desafio
}

class DesafioModel {
  final String? id;
  final String idUsuarioDesafiante;
  final String idUsuarioDesafiado;
  final DateTime data;
  final StatusDesafio status;
  final int? game1Desafiante;
  final int? game1Desafiado;
  final int? game2Desafiante;
  final int? game2Desafiado;
  final int? tieBreakDesafiante;
  final int? tieBreakDesafiado;
  final String? idUsuarioVencedor;
  final String? idUsuarioPerdedor;

  DesafioModel({
    this.id,
    required this.idUsuarioDesafiante,
    required this.idUsuarioDesafiado,
    required this.data,
    this.status = StatusDesafio.pendente,
    this.game1Desafiante,
    this.game1Desafiado,
    this.game2Desafiante,
    this.game2Desafiado,
    this.tieBreakDesafiante,
    this.tieBreakDesafiado,
    this.idUsuarioVencedor,
    this.idUsuarioPerdedor,
  });

  factory DesafioModel.fromJson(Map<String, dynamic> json) {
    return DesafioModel(
      id: json['id'],
      idUsuarioDesafiante: json['idUsuarioDesafiante'],
      idUsuarioDesafiado: json['idUsuarioDesafiado'],
      data: DateTime.parse(json['data']),
      status: StatusDesafio.values[json['status']],
      game1Desafiante: json['game1Desafiante'],
      game1Desafiado: json['game1Desafiado'],
      game2Desafiante: json['game2Desafiante'],
      game2Desafiado: json['game2Desafiado'],
      tieBreakDesafiante: json['tieBreakDesafiante'],
      tieBreakDesafiado: json['tieBreakDesafiado'],
      idUsuarioVencedor: json['idUsuarioVencedor'],
      idUsuarioPerdedor: json['idUsuarioPerdedor'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'idUsuarioDesafiante': idUsuarioDesafiante,
      'idUsuarioDesafiado': idUsuarioDesafiado,
      'data': data.toIso8601String(),
      'status': status.index,
      'game1Desafiante': game1Desafiante,
      'game1Desafiado': game1Desafiado,
      'game2Desafiante': game2Desafiante,
      'game2Desafiado': game2Desafiado,
      'tieBreakDesafiante': tieBreakDesafiante,
      'tieBreakDesafiado': tieBreakDesafiado,
      'idUsuarioVencedor': idUsuarioVencedor,
      'idUsuarioPerdedor': idUsuarioPerdedor,
    };
  }

  DesafioModel copyWith({
    String? id,
    String? idUsuarioDesafiante,
    String? idUsuarioDesafiado,
    DateTime? data,
    StatusDesafio? status,
    int? game1Desafiante,
    int? game1Desafiado,
    int? game2Desafiante,
    int? game2Desafiado,
    int? tieBreakDesafiante,
    int? tieBreakDesafiado,
    String? idUsuarioVencedor,
    String? idUsuarioPerdedor,
  }) {
    return DesafioModel(
      id: id ?? this.id,
      idUsuarioDesafiante: idUsuarioDesafiante ?? this.idUsuarioDesafiante,
      idUsuarioDesafiado: idUsuarioDesafiado ?? this.idUsuarioDesafiado,
      data: data ?? this.data,
      status: status ?? this.status,
      game1Desafiante: game1Desafiante ?? this.game1Desafiante,
      game1Desafiado: game1Desafiado ?? this.game1Desafiado,
      game2Desafiante: game2Desafiante ?? this.game2Desafiante,
      game2Desafiado: game2Desafiado ?? this.game2Desafiado,
      tieBreakDesafiante: tieBreakDesafiante ?? this.tieBreakDesafiante,
      tieBreakDesafiado: tieBreakDesafiado ?? this.tieBreakDesafiado,
      idUsuarioVencedor: idUsuarioVencedor ?? this.idUsuarioVencedor,
      idUsuarioPerdedor: idUsuarioPerdedor ?? this.idUsuarioPerdedor,
    );
  }
}
