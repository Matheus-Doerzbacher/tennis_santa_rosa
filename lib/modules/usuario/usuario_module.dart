import 'package:flutter_modular/flutter_modular.dart';
import 'package:provider/provider.dart';
import 'package:tennis_santa_rosa/modules/usuario/_view/detail_usuario_page.dart';
import 'package:tennis_santa_rosa/modules/usuario/_view/list_usuarios_page.dart';
import 'package:tennis_santa_rosa/modules/usuario/_view/login_page.dart';
import 'package:tennis_santa_rosa/modules/usuario/_view/upsert_usuario/add_usuario_page.dart';
import 'package:tennis_santa_rosa/modules/usuario/controller/auth_controller.dart';
import 'package:tennis_santa_rosa/modules/usuario/controller/usuario_controller.dart';
import 'package:tennis_santa_rosa/modules/usuario/repositories/add_usuario_repository.dart';
import 'package:tennis_santa_rosa/modules/usuario/repositories/fetch_usuarios_repository.dart';
import 'package:tennis_santa_rosa/modules/usuario/repositories/get_usuario_repository.dart';

class UsuarioModule extends Module {
  @override
  void binds(Injector i) {
    i
      ..add(FetchUsuariosRepository.new)
      ..add(AddUsuarioRepository.new)
      ..add(GetUsuarioRepository.new)

      // CONTROLLERS
      ..addLazySingleton(() => AuthController(i()))
      ..addLazySingleton(() => UsuarioController(i(), i()));
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
        '/login/',
        child: (context) => ChangeNotifierProvider(
          create: (context) => Modular.get<AuthController>(),
          child: const LoginPage(),
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
