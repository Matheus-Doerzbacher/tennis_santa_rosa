import 'package:flutter/material.dart';
import 'package:tennis_santa_rosa/modules/jogador/_model/jogador_model.dart';
import 'package:tennis_santa_rosa/modules/jogador/repositories/stream_jogadores_repository.dart';

class RankingController extends ChangeNotifier {
  final StreamJogadoresRepository _streamJogadoresRepository;
  RankingController(this._streamJogadoresRepository);

  Stream<List<JogadorModel>> streamRanking() => _streamJogadoresRepository();
}
