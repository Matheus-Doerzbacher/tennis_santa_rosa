import 'package:flutter/material.dart';
import 'package:tennis_santa_rosa/core/utils/db_print.dart';
import 'package:tennis_santa_rosa/modules/ranking/_models/desafio_model.dart';
import 'package:tennis_santa_rosa/modules/ranking/repositories/fetch_desafios_by_usuario_repository.dart';
import 'package:tennis_santa_rosa/modules/ranking/repositories/novo_desafio_repository.dart';
import 'package:tennis_santa_rosa/modules/usuario/_model/usuario_model.dart';
import 'package:tennis_santa_rosa/modules/usuario/repositories/fetch_usuarios_repository.dart';
import 'package:tennis_santa_rosa/modules/usuario/repositories/get_usuario_by_uid_repository.dart';
import 'package:tennis_santa_rosa/modules/usuario/repositories/update_usuario_repository.dart';

class DetailJogadorRankingController extends ChangeNotifier {
  final NovoDesafioRepository _novoDesafioRepository;
  final GetUsuarioByIdRepository _getUsuarioByIdRepository;
  final UpdateUsuarioRepository _updateUsuarioRepository;
  final FetchUsuariosRepository _fetchUsuariosRepository;
  final FetchDesafiosByUsuarioRepository _fetchDesafiosByUsuarioRepository;

  DetailJogadorRankingController(
    this._novoDesafioRepository,
    this._updateUsuarioRepository,
    this._getUsuarioByIdRepository,
    this._fetchUsuariosRepository,
    this._fetchDesafiosByUsuarioRepository,
  );

  List<UsuarioModel> _usuarios = [];
  List<DesafioModel> _desafios = [];

  List<UsuarioModel> get usuarios => _usuarios;
  List<DesafioModel> get desafios => _desafios;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  Future<bool> novoDesafio(DesafioModel desafio) async {
    try {
      _isLoading = true;
      notifyListeners();

      var usuario =
          await _getUsuarioByIdRepository(desafio.idUsuarioDesafiante);
      var usuarioDesafiado =
          await _getUsuarioByIdRepository(desafio.idUsuarioDesafiado);

      if (usuario != null && usuarioDesafiado != null) {
        // USUARIO DESAFIANTE
        if (usuario.temDesafio || usuarioDesafiado.temDesafio) {
          return false;
        }

        final result = await _novoDesafioRepository(desafio);

        if (!result) {
          return false;
        }

        usuario = usuario.copyWith(
          uidDesafiante: desafio.idUsuarioDesafiado,
        );
        await _updateUsuarioRepository(usuario);

        // USUARIO DESAFIADO
        usuarioDesafiado = usuarioDesafiado.copyWith(
          uidDesafiante: desafio.idUsuarioDesafiante,
        );
        await _updateUsuarioRepository(usuarioDesafiado);

        return true;
      }

      return false;
    } catch (e) {
      dbPrint('Erro ao criar desafio: $e');
      throw Exception('Erro ao criar desafio: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> getUsuarios() async {
    try {
      _isLoading = true;
      notifyListeners();

      _usuarios = await _fetchUsuariosRepository();
      notifyListeners();
    } catch (e) {
      dbPrint('Erro ao buscar usuário: $e');
      throw Exception('Erro ao buscar usuário: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> getDesafios(String uid) async {
    try {
      _isLoading = true;
      notifyListeners();

      _desafios = await _fetchDesafiosByUsuarioRepository(uid);
      notifyListeners();
    } catch (e) {
      dbPrint('Erro ao buscar desafios: $e');
      throw Exception('Erro ao buscar desafios: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
