import 'package:flutter/material.dart';
import 'package:tennis_santa_rosa/core/utils/db_print.dart';
import 'package:tennis_santa_rosa/modules/usuario/_model/usuario_model.dart';
import 'package:tennis_santa_rosa/modules/usuario/repositories/fetch_usuarios_repository.dart';

class UsuarioController extends ChangeNotifier {
  final FetchUsuariosRepository fetchUsuariosRepository;

  UsuarioController(this.fetchUsuariosRepository) {
    fetchUsuarios();
  }

  List<UsuarioModel?> _usuarios = [];
  bool _isLoading = false;

  List<UsuarioModel?> get usuarios => _usuarios;
  bool get isLoading => _isLoading;

  Future<void> fetchUsuarios() async {
    _isLoading = true;
    notifyListeners();
    try {
      _usuarios = await fetchUsuariosRepository.call();
    } catch (e) {
      dbPrint(e);
      throw Exception(e);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
