import 'package:flutter/cupertino.dart';
import 'package:tennis_santa_rosa/core/utils/db_print.dart';
import 'package:tennis_santa_rosa/modules/ranking/_models/desafio_model.dart';
import 'package:tennis_santa_rosa/modules/ranking/repositories/stram_desafios_repository.dart';
import 'package:tennis_santa_rosa/modules/usuario/_model/usuario_model.dart';
import 'package:tennis_santa_rosa/modules/usuario/repositories/fetch_usuarios_repository.dart';

class DesafiosController extends ChangeNotifier {
  final StreamDesafiosRepository _streamDesafiosRepository;
  final FetchUsuariosRepository _fetchUsuariosRepository;

  DesafiosController(
    this._streamDesafiosRepository,
    this._fetchUsuariosRepository,
  ) {
    getUsuarios();
  }

  List<UsuarioModel> _usuarios = [];
  List<UsuarioModel> get usuarios => _usuarios;

  Stream<List<DesafioModel>> streamDesafios() => _streamDesafiosRepository();

  Future<List<UsuarioModel>> getUsuarios() async {
    try {
      _usuarios = await _fetchUsuariosRepository();
      notifyListeners();
    } catch (e) {
      dbPrint('Erro ao buscar usuários: $e');
      throw Exception('Erro ao buscar usuários: $e');
    }
    return _usuarios;
  }
}
