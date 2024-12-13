import 'dart:io';

import 'package:flutter/material.dart';
import 'package:tennis_santa_rosa/core/utils/db_print.dart';
import 'package:tennis_santa_rosa/core/utils/encryptPassword.dart';
import 'package:tennis_santa_rosa/modules/jogador/_model/jogador_model.dart';
import 'package:tennis_santa_rosa/modules/jogador/repositories/add_jogador_repository.dart';
import 'package:tennis_santa_rosa/modules/jogador/repositories/fetch_jogador_repository.dart';
import 'package:tennis_santa_rosa/modules/jogador/repositories/get_jogador_by_uid_repository.dart';
import 'package:tennis_santa_rosa/modules/jogador/repositories/salvar_imagem_jogador_repository.dart';
import 'package:tennis_santa_rosa/modules/jogador/repositories/stream_jogadores_repository.dart';
import 'package:tennis_santa_rosa/modules/jogador/repositories/update_jogador_repository.dart';

class JogadorController extends ChangeNotifier {
  final StreamJogadoresRepository _streamJogadoresRepository;
  final FetchJogadoresRepository _fetchJogadoresRepository;
  final AddJogadorRepository _addJogadorRepository;
  final SalvarImagemJogadorRepository _salvarImageJogadorRepository;
  final UpdateJogadorRepository _updateJogadorRepository;
  final GetJogadorByUidRepository _getJogadorByUidRepository;

  JogadorController(
    this._streamJogadoresRepository,
    this._fetchJogadoresRepository,
    this._addJogadorRepository,
    this._salvarImageJogadorRepository,
    this._updateJogadorRepository,
    this._getJogadorByUidRepository,
  );

  JogadorModel? _jogadorLogado;
  List<JogadorModel?> _jogadores = [];
  bool _isLoading = false;

  JogadorModel? get jogadorLogado => _jogadorLogado;
  List<JogadorModel?> get jogadores => _jogadores;
  bool get isLoading => _isLoading;

  Stream<List<JogadorModel>> streamJogadores() => _streamJogadoresRepository();

  Future<void> getJogadores() async {
    _isLoading = true;
    notifyListeners();
    try {
      final jogadores = await _fetchJogadoresRepository();
      _jogadores = jogadores;
      notifyListeners();
    } catch (e) {
      dbPrint(e);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> addJogador(JogadorModel jogador) async {
    _isLoading = true;
    notifyListeners();
    try {
      final jogadores = await _fetchJogadoresRepository();
      final jogadorAtualizado = jogador.copyWith(
        posicaoRankingAtual: jogadores.length + 1,
        posicaoRankingAnterior: jogadores.length + 1,
        senha: encryptPassword(jogador.senha),
      );

      final success = await _addJogadorRepository(jogadorAtualizado);
      if (!success) {
        throw Exception('Erro ao adicionar jogador');
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

  Future<bool> updateJogador(JogadorModel jogador) async {
    _isLoading = true;
    notifyListeners();
    try {
      final success = await _updateJogadorRepository(jogador);

      if (success) {
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

  Future<void> updateJogadorLogado(String uid) async {
    _jogadorLogado = await _getJogadorByUidRepository(uid);
    notifyListeners();
  }
}
