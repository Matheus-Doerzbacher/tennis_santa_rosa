import 'package:flutter_modular/flutter_modular.dart';
import 'package:tennis_santa_rosa/modules/auth/_view/login_page.dart';
import 'package:tennis_santa_rosa/modules/auth/controller/auth_controller.dart';
import 'package:tennis_santa_rosa/modules/auth/repositories/get_usuario_repository.dart';

class AuthModule extends Module {
  @override
  void binds(Injector i) {
    i
      ..add<GetUsuarioByLoginRepository>(GetUsuarioByLoginRepository.new)
      ..addLazySingleton<AuthController>(() => AuthController(i()));
  }

  @override
  void routes(RouteManager r) {
    r.child('/login/', child: (context) => const LoginPage());
  }
}
