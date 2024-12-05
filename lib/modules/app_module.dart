import 'package:flutter_modular/flutter_modular.dart';
import 'package:tennis_santa_rosa/modules/admin/admin_module.dart';
import 'package:tennis_santa_rosa/modules/auth/auth_module.dart';
import 'package:tennis_santa_rosa/modules/auth/controller/auth_controller.dart';
import 'package:tennis_santa_rosa/modules/ranking/ranking_module.dart';
import 'package:tennis_santa_rosa/modules/usuario/usuario_module.dart';

class AppModule extends Module {
  @override
  void binds(Injector i) {
    AuthModule().binds(i);
    UsuarioModule().binds(i);
  }

  @override
  void routes(RouteManager r) {
    r
      ..module(
        Modular.initialRoute,
        module: RankingModule(),
        guards: [AuthGuard()],
      )
      ..module(
        '/admin',
        module: AdminModule(),
        guards: [AuthGuard()],
      )
      ..module(
        '/usuario',
        module: UsuarioModule(),
        guards: [AuthGuard()],
      )
      ..module('/auth', module: AuthModule());
  }
}

class AuthGuard extends RouteGuard {
  AuthGuard() : super(redirectTo: '/auth/login/');

  @override
  Future<bool> canActivate(String path, ModularRoute route) async {
    final controller = Modular.get<AuthController>();
    if (!controller.isAuthenticated) {
      await controller.load();
    }

    return controller.isAuthenticated;
  }
}
