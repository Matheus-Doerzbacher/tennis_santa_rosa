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

  Future<void> getRanking() async {
    _isLoading = true;
    notifyListeners();
    try {
      _jogadores = await _fetchUsuariosRepository();
      _jogadores.sort(
        (a, b) => a.posicaoRankingAtual.compareTo(b.posicaoRankingAtual),
      );
      notifyListeners();
    } catch (e) {
      dbPrint(e);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
