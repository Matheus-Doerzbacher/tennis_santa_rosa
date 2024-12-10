import 'package:flutter/material.dart';
import 'package:tennis_santa_rosa/core/utils/db_print.dart';
import 'package:tennis_santa_rosa/modules/usuario/_model/usuario_model.dart';
import 'package:tennis_santa_rosa/modules/usuario/repositories/add_usuario_repository.dart';
import 'package:tennis_santa_rosa/modules/usuario/repositories/fetch_usuarios_repository.dart';
import 'package:tennis_santa_rosa/modules/usuario/repositories/stream_usuarios_repository.dart';

class UsuarioController extends ChangeNotifier {
  final AddUsuarioRepository _addUsuarioRepository;
  final StreamUsuariosRepository _streamUsuariosRepository;
  final FetchUsuariosRepository _fetchUsuariosRepository;

  UsuarioController(
    this._addUsuarioRepository,
    this._streamUsuariosRepository,
    this._fetchUsuariosRepository,
  );

  final List<UsuarioModel?> _usuarios = [];
  bool _isLoading = false;

  List<UsuarioModel?> get usuarios => _usuarios;
  bool get isLoading => _isLoading;

  Stream<List<UsuarioModel>> streamUsuarios() => _streamUsuariosRepository();

  Future<bool> addUsuario(UsuarioModel usuario) async {
    _isLoading = true;
    notifyListeners();
    try {
      final usuarios = await _fetchUsuariosRepository();
      final usuarioAtualizado = usuario.copyWith(
        posicaoRankingAtual: usuarios.length + 1,
        posicaoRankingAnterior: usuarios.length + 1,
      );

      final success = await _addUsuarioRepository(usuarioAtualizado);
      if (!success) {
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
