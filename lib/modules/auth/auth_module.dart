import 'package:flutter_modular/flutter_modular.dart';
import 'package:provider/provider.dart';
import 'package:tennis_santa_rosa/modules/auth/_view/detalhes_iniciais_page.dart';
import 'package:tennis_santa_rosa/modules/auth/_view/login_page.dart';
import 'package:tennis_santa_rosa/modules/auth/controller/auth_controller.dart';
import 'package:tennis_santa_rosa/modules/jogador/jogador_module.dart';

class AuthModule extends Module {
  @override
  List<Module> get imports => [UsuarioModule()];

  @override
  void binds(Injector i) {
    i.addLazySingleton(() => AuthController(i()));
  }

  @override
  void routes(RouteManager r) {
    r
      ..child('/login/', child: (context) => const LoginPage())
      ..child(
        '/config/',
        child: (context) => ChangeNotifierProvider(
          create: (context) => Modular.get<AuthController>(),
          child: const DetalhesIniciaisPage(),
        ),
      );
  }
}
