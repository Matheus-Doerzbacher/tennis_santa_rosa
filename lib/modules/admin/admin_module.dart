import 'package:flutter_modular/flutter_modular.dart';
import 'package:tennis_santa_rosa/modules/admin/_view/add_usuario_admin_page.dart';
import 'package:tennis_santa_rosa/modules/admin/_view/admin_page.dart';
import 'package:tennis_santa_rosa/modules/admin/_view/list_usuario_admin_page.dart';
import 'package:tennis_santa_rosa/modules/admin/controller/admin_controller.dart';
import 'package:tennis_santa_rosa/modules/usuario/usuario_module.dart';

class AdminModule extends Module {
  @override
  List<Module> get imports => [UsuarioModule()];

  @override
  void binds(Injector i) {
    i.addLazySingleton(() => AdminController(i(), i(), i()));
  }

  @override
  void routes(RouteManager r) {
    r
      ..child(
        Modular.initialRoute,
        child: (context) => const AdminPage(),
      )
      ..child(
        '/list-usuarios',
        child: (context) => const ListUsuarioAdminPage(),
      )
      ..child(
        '/add-usuario',
        child: (context) => const AddUsuarioAdminPage(),
      );
  }
}
