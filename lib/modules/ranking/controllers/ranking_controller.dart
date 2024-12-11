import 'package:flutter/material.dart';
import 'package:tennis_santa_rosa/core/env.dart';
import 'package:tennis_santa_rosa/modules/usuario/_model/usuario_model.dart';
import 'package:tennis_santa_rosa/modules/usuario/repositories/stream_usuarios_repository.dart';

class RankingController extends ChangeNotifier {
  final StreamUsuariosRepository _streamUsuariosRepository;
  RankingController(this._streamUsuariosRepository);

  Stream<List<UsuarioModel>> streamRanking() => _streamUsuariosRepository();

  bool podeDesafiar(UsuarioModel usuario, UsuarioModel usuarioDesafiado) {
    if (usuario.uid == usuarioDesafiado.uid) {
      return false;
    }
    if (usuario.posicaoRankingAtual! < usuarioDesafiado.posicaoRankingAtual!) {
      return false;
    }
    if (usuario.temDesafio || usuarioDesafiado.temDesafio) {
      return false;
    }

    const qtdeJogadoresPorGrupo = Env.jogadoresPorGrupo;

    // Nova lógica para grupos
    final grupoUsuario =
        (usuario.posicaoRankingAtual! - 1) ~/ qtdeJogadoresPorGrupo;
    final grupoDesafiado =
        (usuarioDesafiado.posicaoRankingAtual! - 1) ~/ qtdeJogadoresPorGrupo;

    if (grupoUsuario - 1 == grupoDesafiado) {
      // Verifica se o usuário está entre os 2 primeiros do seu grupo
      // e se o desafiado está entre os 2 últimos do grupo acima
      final posicaoNoGrupoUsuario =
          usuario.posicaoRankingAtual! - grupoUsuario * qtdeJogadoresPorGrupo;
      final posicaoNoGrupoDesafiado = usuarioDesafiado.posicaoRankingAtual! -
          grupoDesafiado * qtdeJogadoresPorGrupo;

      if (posicaoNoGrupoUsuario > 2 ||
          posicaoNoGrupoDesafiado < qtdeJogadoresPorGrupo - 1) {
        return false;
      }
    }

    return true;
  }
}
