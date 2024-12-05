import 'package:flutter_modular/flutter_modular.dart';
import 'package:provider/provider.dart';
import 'package:tennis_santa_rosa/modules/usuario/_view/detail_usuario_page.dart';
import 'package:tennis_santa_rosa/modules/usuario/_view/list_usuarios_page.dart';
import 'package:tennis_santa_rosa/modules/usuario/_view/upsert_usuario/add_usuario_page.dart';
import 'package:tennis_santa_rosa/modules/usuario/controller/usuario_controller.dart';
import 'package:tennis_santa_rosa/modules/usuario/repositories/add_usuario_repository.dart';
import 'package:tennis_santa_rosa/modules/usuario/repositories/fetch_usuarios_repository.dart';

class UsuarioModule extends Module {
  @override
  void exportedBinds(Injector i) {
    i.add(FetchUsuariosRepository.new, key: 'exportedFetchUsuariosRepository');
    super.exportedBinds(i);
  }

  @override
  void binds(Injector i) {
    i
      ..add(AddUsuarioRepository.new)
      ..add(FetchUsuariosRepository.new)

      // CONTROLLERS
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

// class AuthGuard extends RouteGuard {
//   AuthGuard() : super(redirectTo: '/login/');

//   @override
//   Future<bool> canActivate(String path, ModularRoute route) async {
//     final controller = Modular.get<AuthController>();
//     if (!controller.isAuthenticated) {
//       await controller.load();
//     }

//     return controller.isAuthenticated;
//   }
// }

// class LoginGuard extends RouteGuard {
//   LoginGuard() : super(redirectTo: '/');

//   @override
//   Future<bool> canActivate(String path, ModularRoute route) async {
//     final controller = Modular.get<AuthController>();
//     return !controller.isAuthenticated;
//   }
// }
