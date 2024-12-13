import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:tennis_santa_rosa/core/env.dart';
import 'package:tennis_santa_rosa/core/utils/db_print.dart';
import 'package:tennis_santa_rosa/modules/auth/controller/auth_controller.dart';
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
  ) {
    getUsuarios();
    getUsuarioLogado();
  }

  List<UsuarioModel> _usuarios = [];
  List<DesafioModel> _desafios = [];
  UsuarioModel? _usuarioLogado;
  bool _isLoading = false;
  bool _isLoadingButton = false;

  List<UsuarioModel> get usuarios => _usuarios;
  List<DesafioModel> get desafios => _desafios;
  UsuarioModel? get usuarioLogado => _usuarioLogado;
  bool get isLoading => _isLoading;
  bool get isLoadingButton => _isLoadingButton;

  Future<bool> novoDesafio(DesafioModel desafio) async {
    try {
      _isLoadingButton = true;
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
      _isLoadingButton = false;
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

  Future<void> getUsuarioLogado() async {
    try {
      _isLoading = true;
      notifyListeners();
      final uid = Modular.get<AuthController>().usuario!.uid!;
      _usuarioLogado = await _getUsuarioByIdRepository(uid);
      notifyListeners();
    } catch (e) {
      dbPrint('Erro ao buscar usuário logado: $e');
      throw Exception('Erro ao buscar usuário logado: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  bool podeDesafiar(UsuarioModel usuario, UsuarioModel usuarioDesafiado) {
    // Verifica se o jogador é o mesmo do desafiado
    if (usuario.uid == usuarioDesafiado.uid) {
      return false;
    }
    // Verifica se o jogador está na frente do desafiado
    if (usuario.posicaoRankingAtual! < usuarioDesafiado.posicaoRankingAtual!) {
      return false;
    }
    // Verifica se o jogador já tem um desafio pendente
    if (usuario.temDesafio || usuarioDesafiado.temDesafio) {
      return false;
    }
    // Verifica se o ultimo desafio de ambos é o mesmo
    if (usuario.uidUltimoDesafio == usuarioDesafiado.uid &&
        usuarioDesafiado.uidUltimoDesafio == usuario.uid) {
      return false;
    }

    // Verifica se o usuário perdeu o último jogo e se ainda está no prazo
    if (usuario.venceuUltimoJogo != null && !usuario.venceuUltimoJogo!) {
      final agora = DateTime.now();
      final dataLimite = DateTime(
        usuario.dataUltimoJogo!.year,
        usuario.dataUltimoJogo!.month,
        usuario.dataUltimoJogo!.day + 1,
        12, // Meio-dia
      );

      if (agora.isBefore(dataLimite)) {
        return false;
      }
    }

    // Verifica se o desafiado venceu o ultimo jogo
    // e se ainda está no prazo de não receber um desafio
    if (usuarioDesafiado.venceuUltimoJogo != null &&
        usuarioDesafiado.venceuUltimoJogo!) {
      final agora = DateTime.now();
      final dataLimite = DateTime(
        usuarioDesafiado.dataUltimoJogo!.year,
        usuarioDesafiado.dataUltimoJogo!.month,
        usuarioDesafiado.dataUltimoJogo!.day + 1,
        12, // Meio-dia
      );

      if (agora.isBefore(dataLimite)) {
        return false;
      }
    }

    // Verifica se o usuário e o desafiado estão no mesmo grupo
    // e se o usariu esta entre os 2 primeiros do seu grupo
    // e se o desafiado esta entre os 2 ultimos do grupo acima
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
