import 'package:flutter_modular/flutter_modular.dart';
import 'package:provider/provider.dart';
import 'package:tennis_santa_rosa/modules/auth/controller/auth_controller.dart';
import 'package:tennis_santa_rosa/modules/ranking/_viwes/ranking_page.dart';
import 'package:tennis_santa_rosa/modules/ranking/controllers/ranking_controller.dart';
import 'package:tennis_santa_rosa/modules/usuario/usuario_module.dart';

class RankingModule extends Module {
  @override
  List<Module> get imports => [UsuarioModule()];

  @override
  void binds(Injector i) {
    i.addLazySingleton<RankingController>(() => RankingController(i()));
  }

  @override
  void routes(RouteManager r) {
    r.child(
      Modular.initialRoute,
      child: (context) => ChangeNotifierProvider(
        create: (context) => Modular.get<RankingController>(),
        child: const RankingPage(),
      ),
      guards: [NameGuard()],
    );
  }
}

class NameGuard extends RouteGuard {
  NameGuard() : super(redirectTo: '/usuario/detail-usuario');

  @override
  Future<bool> canActivate(String path, ModularRoute route) async {
    final controller = Modular.get<AuthController>();
    final usuario = controller.usuario;

    if (usuario?.nome == null || usuario?.nome?.isEmpty == true) {
      return false;
    }

    return true;
  }
}
