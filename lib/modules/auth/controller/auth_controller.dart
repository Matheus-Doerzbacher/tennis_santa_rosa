import 'package:flutter/material.dart';
import 'package:tennis_santa_rosa/core/utils/db_print.dart';
import 'package:tennis_santa_rosa/core/utils/repository.dart';
import 'package:tennis_santa_rosa/modules/auth/repositories/get_usuario_repository.dart';
import 'package:tennis_santa_rosa/modules/usuario/_model/usuario_model.dart';

class AuthController extends ChangeNotifier {
  final GetUsuarioByLoginRepository _getUsuarioByLoginRepository;

  AuthController(this._getUsuarioByLoginRepository);

  UsuarioModel? _usuario;
  UsuarioModel? get usuario => _usuario;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  bool get isAuthenticated => usuario != null;

  // Realiza o login
  Future<bool> login(String login, String senha) async {
    _isLoading = true;
    notifyListeners();
    try {
      final usuario = await _getUsuarioByLoginRepository(login);

      final senhaCriptografada = UsuarioModel.encryptPassword(senha);

      if (usuario != null && usuario.senha == senhaCriptografada) {
        final usuarioJson = usuario.toJson();
        await Repository.save('usuario', usuarioJson);
        _usuario = usuario;
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
}
