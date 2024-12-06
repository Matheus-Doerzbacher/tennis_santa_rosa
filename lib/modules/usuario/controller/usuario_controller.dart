import 'package:flutter/material.dart';
import 'package:tennis_santa_rosa/core/utils/db_print.dart';
import 'package:tennis_santa_rosa/modules/usuario/_model/usuario_model.dart';
import 'package:tennis_santa_rosa/modules/usuario/repositories/add_usuario_repository.dart';
import 'package:tennis_santa_rosa/modules/usuario/repositories/fetch_usuarios_repository.dart';

class UsuarioController extends ChangeNotifier {
  final FetchUsuariosRepository _fetchUsuariosRepository;
  final AddUsuarioRepository _addUsuarioRepository;

  UsuarioController(
    this._fetchUsuariosRepository,
    this._addUsuarioRepository,
  ) {
    fetchUsuarios();
  }

  List<UsuarioModel?> _usuarios = [];
  bool _isLoading = false;

  List<UsuarioModel?> get usuarios => _usuarios;
  bool get isLoading => _isLoading;

  Stream<void> fetchUsuarios() async* {
    _isLoading = true;
    notifyListeners();
    try {
      await for (final usuarios in _fetchUsuariosRepository()) {
        _usuarios = usuarios;
        _usuarios.sort(
          (a, b) => a!.posicaoRankingAtual.compareTo(b!.posicaoRankingAtual),
        );
        notifyListeners();

        // Emite um valor nulo para indicar que a atualização foi feita
        yield null;
      }
    } catch (e) {
      dbPrint(e);
      throw Exception(e);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> addUsuario(UsuarioModel usuario) async {
    _isLoading = true;
    notifyListeners();
    try {
      final success = await _addUsuarioRepository(usuario);
      if (success) {
        fetchUsuarios();
      } else {
        throw Exception('Erro ao adicionar usuário');
      }
      return success;
    } catch (e) {
      dbPrint(e);
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
