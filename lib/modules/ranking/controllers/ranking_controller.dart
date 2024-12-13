import 'package:flutter/material.dart';
import 'package:tennis_santa_rosa/modules/jogador/_model/usuario_model.dart';
import 'package:tennis_santa_rosa/modules/jogador/repositories/stream_usuarios_repository.dart';

class RankingController extends ChangeNotifier {
  final StreamUsuariosRepository _streamUsuariosRepository;
  RankingController(this._streamUsuariosRepository);

  Stream<List<UsuarioModel>> streamRanking() => _streamUsuariosRepository();
}
