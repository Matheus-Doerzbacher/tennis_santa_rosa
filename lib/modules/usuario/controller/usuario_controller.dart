import 'package:flutter/material.dart';
import 'package:tennis_santa_rosa/core/utils/db_print.dart';
import 'package:tennis_santa_rosa/modules/usuario/_model/usuario_model.dart';
import 'package:tennis_santa_rosa/modules/usuario/repositories/add_usuario_repository.dart';
import 'package:tennis_santa_rosa/modules/usuario/repositories/fetch_usuarios_repository.dart';

class UsuarioController extends ChangeNotifier {
  final FetchUsuariosRepository fetchUsuariosRepository;
  final AddUsuarioRepository addUsuarioRepository;

  UsuarioController(
    this.fetchUsuariosRepository,
    this.addUsuarioRepository,
  ) {
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
      _usuarios = await fetchUsuariosRepository();
      _usuarios.sort(
        (a, b) => a!.posicaoRankingAtual.compareTo(b!.posicaoRankingAtual),
      );
      notifyListeners();
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
      final success = await addUsuarioRepository(usuario);
      if (success) {
        await fetchUsuarios();
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
