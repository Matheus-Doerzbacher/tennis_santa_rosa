import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:tennis_santa_rosa/core/env.dart';
import 'package:tennis_santa_rosa/core/utils/db_print.dart';
import 'package:tennis_santa_rosa/core/utils/encryptPassword.dart';
import 'package:tennis_santa_rosa/core/utils/repository.dart';
import 'package:tennis_santa_rosa/modules/auth/_model/usuario_model.dart';
import 'package:tennis_santa_rosa/modules/jogador/_model/jogador_model.dart';
import 'package:tennis_santa_rosa/modules/jogador/controller/jogador_controller.dart';
import 'package:tennis_santa_rosa/modules/jogador/repositories/get_jogador_by_login_repository.dart';

class AuthController extends ChangeNotifier {
  final GetJogadorByLoginRepository _getJogadorByLoginRepository;
  // final UpdateJogadoresRepository _updateJogadoresRepository;

  AuthController(
    this._getJogadorByLoginRepository,
    // this._updateJogadoresRepository,
  );

  UserModel? _usuario;
  UserModel? get usuario => _usuario;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  bool get isAuthenticated => usuario != null;

  // Realiza o login
  Future<bool> login(String login, String senha) async {
    _isLoading = true;
    notifyListeners();
    UserModel? usuario;
    try {
      if (login == Env.userLogin && senha == Env.userPassword) {
        usuario = UserModel(
          uid: '0',
          login: login,
          nome: 'Admin',
          isAdmin: true,
        );
      } else {
        final jogador = await _getJogadorByLoginRepository(login);

        final senhaCriptografada = encryptPassword(senha);

        if (jogador?.senha == null || jogador?.senha != senhaCriptografada) {
          return false;
        }
        usuario = UserModel(
          uid: jogador!.uid!,
          login: jogador.login,
          nome: jogador.nome,
          isAdmin: jogador.isAdmin,
        );

        await Modular.get<JogadorController>()
            .updateJogadorLogado(jogador.uid!);
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
        _usuario = UserModel.fromJson(usuarioJson);
        notifyListeners();
        return true;
      }

      await Modular.get<JogadorController>().updateJogadorLogado(_usuario!.uid);
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

  Future<bool> updateUsuario(JogadorModel jogador) async {
    try {
      final usuario = UserModel(
        uid: jogador.uid!,
        login: jogador.login,
        nome: jogador.nome,
        isAdmin: jogador.isAdmin,
      );
      _usuario = usuario;
      await Repository.save('usuario', usuario.toJson());
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
