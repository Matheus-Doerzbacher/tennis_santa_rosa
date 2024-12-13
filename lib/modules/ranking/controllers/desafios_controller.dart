import 'package:flutter/cupertino.dart';
import 'package:tennis_santa_rosa/core/utils/db_print.dart';
import 'package:tennis_santa_rosa/modules/jogador/_model/jogador_model.dart';
import 'package:tennis_santa_rosa/modules/jogador/repositories/fetch_jogador_repository.dart';
import 'package:tennis_santa_rosa/modules/ranking/_models/desafio_model.dart';
import 'package:tennis_santa_rosa/modules/ranking/repositories/stram_desafios_repository.dart';

class DesafiosController extends ChangeNotifier {
  final StreamDesafiosRepository _streamDesafiosRepository;
  final FetchJogadoresRepository _fetchJogadoresRepository;

  DesafiosController(
    this._streamDesafiosRepository,
    this._fetchJogadoresRepository,
  ) {
    getUsuarios();
  }

  List<JogadorModel> _usuarios = [];
  List<JogadorModel> get usuarios => _usuarios;

  Stream<List<DesafioModel>> streamDesafios() => _streamDesafiosRepository();

  Future<List<JogadorModel>> getUsuarios() async {
    try {
      _usuarios = await _fetchJogadoresRepository();
      notifyListeners();
    } catch (e) {
      dbPrint('Erro ao buscar usuários: $e');
      throw Exception('Erro ao buscar usuários: $e');
    }
    return _usuarios;
  }
}
