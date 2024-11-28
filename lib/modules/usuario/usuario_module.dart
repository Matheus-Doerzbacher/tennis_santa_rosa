import 'package:flutter_modular/flutter_modular.dart';
import 'package:tennis_santa_rosa/modules/usuario/view/detail_usuario_page.dart';
import 'package:tennis_santa_rosa/modules/usuario/view/login_page.dart';
import 'package:tennis_santa_rosa/modules/usuario/view/upsert_usuario_page.dart';

class UsuarioModule extends Module {
  @override
  void routes(RouteManager r) {
    r
      ..child(
        '/login/',
        child: (context) => const LoginPage(),
      )
      ..child(
        '/upsert-usuario/',
        child: (context) => const UpsertUsuarioPage(),
      )
      ..child(
        '/detail-usuario/',
        child: (context) => const DetailUsuarioPage(),
      );
  }
}
