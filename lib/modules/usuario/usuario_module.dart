import 'package:flutter_modular/flutter_modular.dart';
import 'package:provider/provider.dart';
import 'package:tennis_santa_rosa/modules/usuario/controller/usuario_controller.dart';
import 'package:tennis_santa_rosa/modules/usuario/repositories/add_usuario_repository.dart';
import 'package:tennis_santa_rosa/modules/usuario/repositories/fetch_usuarios_repository.dart';
import 'package:tennis_santa_rosa/modules/usuario/view/detail_usuario_page.dart';
import 'package:tennis_santa_rosa/modules/usuario/view/list_usuarios_page.dart';
import 'package:tennis_santa_rosa/modules/usuario/view/login_page.dart';
import 'package:tennis_santa_rosa/modules/usuario/view/upsert_usuario/add_usuario_page.dart';

class UsuarioModule extends Module {
  @override
  void binds(Injector i) {
    i
      ..add(FetchUsuariosRepository.new)
      ..add(AddUsuarioRepository.new)

      // CONTROLLER
      ..addLazySingleton(
        () => UsuarioController(
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
        '/login/',
        child: (context) => const LoginPage(),
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
