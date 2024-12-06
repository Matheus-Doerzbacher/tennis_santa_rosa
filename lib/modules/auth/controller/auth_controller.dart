import 'package:flutter/material.dart';
import 'package:tennis_santa_rosa/core/env.dart';
import 'package:tennis_santa_rosa/core/utils/db_print.dart';
import 'package:tennis_santa_rosa/core/utils/repository.dart';
import 'package:tennis_santa_rosa/modules/usuario/_model/usuario_model.dart';
import 'package:tennis_santa_rosa/modules/usuario/repositories/get_usuario_by_login_repository.dart';
import 'package:tennis_santa_rosa/modules/usuario/repositories/update_usuario_repository.dart';

class AuthController extends ChangeNotifier {
  final GetUsuarioByLoginRepository _getUsuarioByLoginRepository;
  final UpdateUsuarioRepository _updateUsuarioRepository;

  AuthController(
    this._getUsuarioByLoginRepository,
    this._updateUsuarioRepository,
  );

  UsuarioModel? _usuario;
  UsuarioModel? get usuario => _usuario;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  bool get isAuthenticated => usuario != null;

  // Realiza o login
  Future<bool> login(String login, String senha) async {
    _isLoading = true;
    notifyListeners();
    UsuarioModel? usuario;
    try {
      if (login == Env.userLogin && senha == Env.userPassword) {
        usuario = UsuarioModel(
          login: login,
          senha: senha,
          posicaoRankingAtual: 0,
          posicaoRankingAnterior: 0,
          nome: 'Admin',
          isAdmin: true,
        );
      } else {
        usuario = await _getUsuarioByLoginRepository(login);

        final senhaCriptografada = UsuarioModel.encryptPassword(senha);

        if (usuario?.senha == null || usuario?.senha != senhaCriptografada) {
          return false;
        }
      }

      if (usuario == null) {
        return false;
      }

      await Repository.save('usuario', usuario.toJson());
      _usuario = usuario;
      notifyListeners();
      return true;
    } catch (e) {
      dbPrint(e);
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Carrega o usuário do repositório
  Future<bool> load() async {
    try {
      _isLoading = true;
      notifyListeners();
      final usuarioJson = await Repository.read('usuario');

      if (usuarioJson != null) {
        _usuario = UsuarioModel.fromJson(usuarioJson);
        notifyListeners();
        return true;
      }
      return false;
    } catch (e) {
      dbPrint(e);
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Realiza o logout
  Future<bool> logout() async {
    try {
      _isLoading = true;
      notifyListeners();
      await Repository.remove('usuario');
      dbPrint(await Repository.read('usuario'));
      _usuario = null;
      notifyListeners();
      return true;
    } catch (e) {
      dbPrint(e);
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> updateUsuario(UsuarioModel usuario) async {
    try {
      _isLoading = true;
      notifyListeners();
      final result = await _updateUsuarioRepository(usuario);
      if (result) {
        _usuario = usuario;
        await Repository.save('usuario', usuario.toJson());
        return true;
      }
      return false;
    } catch (e) {
      dbPrint(e);
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
