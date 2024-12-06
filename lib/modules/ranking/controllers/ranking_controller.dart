import 'package:flutter/material.dart';
import 'package:tennis_santa_rosa/core/utils/db_print.dart';
import 'package:tennis_santa_rosa/modules/usuario/_model/usuario_model.dart';
import 'package:tennis_santa_rosa/modules/usuario/repositories/fetch_usuarios_repository.dart';

class RankingController extends ChangeNotifier {
  final FetchUsuariosRepository _fetchUsuariosRepository;
  RankingController(this._fetchUsuariosRepository) {
    getRanking();
  }

  List<UsuarioModel> _jogadores = [];
  List<UsuarioModel> get jogadores => _jogadores;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  Stream<void> getRanking() async* {
    _isLoading = true;
    notifyListeners();
    try {
      await for (final jogadores in _fetchUsuariosRepository()) {
        _jogadores = jogadores;
        _jogadores.sort(
          (a, b) => a.posicaoRankingAtual.compareTo(b.posicaoRankingAtual),
        );
        notifyListeners();
        yield null; // Emite um valor nulo para indicar que há uma atualização
      }
    } catch (e) {
      dbPrint(e);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
