import 'package:flutter_modular/flutter_modular.dart';
import 'package:provider/provider.dart';
import 'package:tennis_santa_rosa/modules/usuario/_view/detail_usuario_page.dart';
import 'package:tennis_santa_rosa/modules/usuario/_view/list_usuarios_page.dart';
import 'package:tennis_santa_rosa/modules/usuario/_view/upsert_usuario/add_usuario_page.dart';
import 'package:tennis_santa_rosa/modules/usuario/controller/usuario_controller.dart';
import 'package:tennis_santa_rosa/modules/usuario/repositories/add_usuario_repository.dart';
import 'package:tennis_santa_rosa/modules/usuario/repositories/fetch_usuarios_repository.dart';
import 'package:tennis_santa_rosa/modules/usuario/repositories/get_usuario_by_login_repository.dart';
import 'package:tennis_santa_rosa/modules/usuario/repositories/get_usuario_by_uid_repository.dart';
import 'package:tennis_santa_rosa/modules/usuario/repositories/stream_usuarios_repository.dart';
import 'package:tennis_santa_rosa/modules/usuario/repositories/update_usuario_repository.dart';

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
      );
    super.exportedBinds(i);
  }

  @override
  void binds(Injector i) {
    i
      ..add(AddUsuarioRepository.new)
      ..add(StreamUsuariosRepository.new)
      ..add(UpdateUsuarioRepository.new)
      ..add(GetUsuarioByLoginRepository.new)
      ..add(FetchUsuariosRepository.new)
      ..add(GetUsuarioByIdRepository.new)

      // CONTROLLERS
      ..addLazySingleton(
        () => UsuarioController(
          i(),
          i(),
          i(),
        ),
      );
    super.binds(i);
  }

  @override
  void routes(RouteManager r) {
    r
      ..child(
        '/list-usuarios/',
        child: (context) => ChangeNotifierProvider(
          create: (context) => Modular.get<UsuarioController>(),
          child: const ListUsuariosPage(),
        ),
      )
      ..child(
        '/add-usuario/',
        child: (context) => ChangeNotifierProvider(
          create: (context) => Modular.get<UsuarioController>(),
          child: const AddUsuarioPage(),
        ),
      )
      ..child(
        '/detail-usuario/',
        child: (context) => const DetailUsuarioPage(),
      );
  }
}
