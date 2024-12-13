import 'dart:io';

import 'package:flutter/material.dart';
import 'package:tennis_santa_rosa/core/utils/db_print.dart';
import 'package:tennis_santa_rosa/core/utils/encryptPassword.dart';
import 'package:tennis_santa_rosa/modules/jogador/_model/usuario_model.dart';
import 'package:tennis_santa_rosa/modules/jogador/repositories/add_jogador_repository.dart';
import 'package:tennis_santa_rosa/modules/jogador/repositories/fetch_usuarios_repository.dart';
import 'package:tennis_santa_rosa/modules/jogador/repositories/salvar_imagem_jogador_repository.dart';
import 'package:tennis_santa_rosa/modules/jogador/repositories/stream_usuarios_repository.dart';
import 'package:tennis_santa_rosa/modules/jogador/repositories/update_usuario_repository.dart';

class AdminController extends ChangeNotifier {
  final StreamUsuariosRepository _streamUsuariosRepository;
  final FetchUsuariosRepository _fetchUsuariosRepository;
  final AddJogadorRepository _addJogadorRepository;
  final SalvarImagemJogadorRepository _salvarImageJogadorRepository;
  final UpdateUsuarioRepository _updateUsuarioRepository;

  AdminController(
    this._streamUsuariosRepository,
    this._fetchUsuariosRepository,
    this._addJogadorRepository,
    this._salvarImageJogadorRepository,
    this._updateUsuarioRepository,
  );

  List<UsuarioModel?> _usuarios = [];
  bool _isLoading = false;

  List<UsuarioModel?> get usuarios => _usuarios;
  bool get isLoading => _isLoading;

  Stream<List<UsuarioModel>> streamUsuarios() => _streamUsuariosRepository();

  Future<void> getUsuarios() async {
    _isLoading = true;
    notifyListeners();
    try {
      final usuarios = await _fetchUsuariosRepository();
      _usuarios = usuarios;
      notifyListeners();
    } catch (e) {
      dbPrint(e);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> addUsuario(UsuarioModel usuario) async {
    _isLoading = true;
    notifyListeners();
    try {
      final usuarios = await _fetchUsuariosRepository();
      final usuarioAtualizado = usuario.copyWith(
        posicaoRankingAtual: usuarios.length + 1,
        posicaoRankingAnterior: usuarios.length + 1,
        senha: encryptPassword(usuario.senha),
      );

      final success = await _addJogadorRepository(usuarioAtualizado);
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

  Future<bool> updateUsuario(UsuarioModel usuario) async {
    _isLoading = true;
    notifyListeners();
    try {
      final success = await _updateUsuarioRepository(usuario);
      return success;
    } catch (e) {
      dbPrint(e);
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<String> salvarImageJogador(File imagem, String uid) async {
    try {
      _isLoading = true;
      notifyListeners();
      final url = await _salvarImageJogadorRepository(imagem, uid);
      return url;
    } catch (e) {
      dbPrint(e);
      return '';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
