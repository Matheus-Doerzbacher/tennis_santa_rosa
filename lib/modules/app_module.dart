import 'package:flutter_modular/flutter_modular.dart';
import 'package:tennis_santa_rosa/modules/admin/admin_module.dart';
import 'package:tennis_santa_rosa/modules/usuario/usuario_module.dart';

class AppModule extends Module {
  @override
  void routes(RouteManager r) {
    r
      ..module(Modular.initialRoute, module: AdminModule())
      ..module('/usuario', module: UsuarioModule());
  }
}
