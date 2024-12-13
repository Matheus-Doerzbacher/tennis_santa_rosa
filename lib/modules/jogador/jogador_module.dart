import 'package:flutter_modular/flutter_modular.dart';
import 'package:tennis_santa_rosa/modules/jogador/controller/usuario_controller.dart';
import 'package:tennis_santa_rosa/modules/jogador/repositories/add_jogador_repository.dart';
import 'package:tennis_santa_rosa/modules/jogador/repositories/fetch_usuarios_repository.dart';
import 'package:tennis_santa_rosa/modules/jogador/repositories/get_usuario_by_login_repository.dart';
import 'package:tennis_santa_rosa/modules/jogador/repositories/get_usuario_by_uid_repository.dart';
import 'package:tennis_santa_rosa/modules/jogador/repositories/salvar_imagem_jogador_repository.dart';
import 'package:tennis_santa_rosa/modules/jogador/repositories/stream_usuarios_repository.dart';
import 'package:tennis_santa_rosa/modules/jogador/repositories/update_usuario_repository.dart';

class UsuarioModule extends Module {
  @override
  void exportedBinds(Injector i) {
    i
      ..add(
        StreamUsuariosRepository.new,
        key: 'exportedStreamUsuariosRepository',
      )
      ..add(
        UpdateUsuarioRepository.new,
        key: 'exportedUpdateUsuarioRepository',
      )
      ..add(
        GetUsuarioByLoginRepository.new,
        key: 'exportedGetUsuarioByLoginRepository',
      )
      ..add(
        GetUsuarioByIdRepository.new,
        key: 'exportedGetUsuarioByIdRepository',
      )
      ..add(
        FetchUsuariosRepository.new,
        key: 'exportedFetchUsuariosRepository',
      )
      ..add(
        SalvarImagemJogadorRepository.new,
        key: 'exportedSalvarImagemJogadorRepository',
      );

    super.exportedBinds(i);
  }

  @override
  void binds(Injector i) {
    i
      ..add(AddJogadorRepository.new)
      ..add(StreamUsuariosRepository.new)
      ..add(UpdateUsuarioRepository.new)
      ..add(GetUsuarioByLoginRepository.new)
      ..add(FetchUsuariosRepository.new)
      ..add(GetUsuarioByIdRepository.new)
      ..add(SalvarImagemJogadorRepository.new)
      // CONTROLLERS
      ..addLazySingleton(
        () => UsuarioController(i()),
      );
    super.binds(i);
  }
}
