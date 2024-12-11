import 'package:flutter/material.dart';
import 'package:tennis_santa_rosa/core/utils/db_print.dart';
import 'package:tennis_santa_rosa/modules/ranking/_models/desafio.dart';
import 'package:tennis_santa_rosa/modules/ranking/repositories/novo_desafio_repository.dart';
import 'package:tennis_santa_rosa/modules/usuario/repositories/get_usuario_by_uid_repository.dart';
import 'package:tennis_santa_rosa/modules/usuario/repositories/update_usuario_repository.dart';

class DetailJogadorRankingController extends ChangeNotifier {
  final NovoDesafioRepository _novoDesafioRepository;
  final GetUsuarioByIdRepository _getUsuarioByIdRepository;
  final UpdateUsuarioRepository _updateUsuarioRepository;

  DetailJogadorRankingController(
    this._novoDesafioRepository,
    this._updateUsuarioRepository,
    this._getUsuarioByIdRepository,
  );

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
        if (usuario.temDesafio ||
            usuario.uidDesafiante?.isNotEmpty == true ||
            usuarioDesafiado.temDesafio ||
            usuarioDesafiado.uidDesafiante?.isNotEmpty == true) {
          return false;
        }

        final result = await _novoDesafioRepository(desafio);

        if (!result) {
          return false;
        }

        usuario = usuario.copyWith(
          temDesafio: true,
          uidDesafiante: desafio.idUsuarioDesafiado,
        );
        await _updateUsuarioRepository(usuario);

        // USUARIO DESAFIADO
        usuarioDesafiado = usuarioDesafiado.copyWith(
          temDesafio: true,
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
}
