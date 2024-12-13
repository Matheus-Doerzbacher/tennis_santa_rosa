import 'package:flutter_modular/flutter_modular.dart';
import 'package:provider/provider.dart';
import 'package:tennis_santa_rosa/modules/admin/_view/add_usuario_admin_page.dart';
import 'package:tennis_santa_rosa/modules/admin/_view/admin_page.dart';
import 'package:tennis_santa_rosa/modules/admin/_view/list_jogadores_admin_page.dart';
import 'package:tennis_santa_rosa/modules/admin/_view/update_jogador_admin_page.dart';
import 'package:tennis_santa_rosa/modules/jogador/controller/jogador_controller.dart';

class AdminModule extends Module {
  @override
  void routes(RouteManager r) {
    r
      ..child(
        Modular.initialRoute,
        child: (context) => const AdminPage(),
      )
      ..child(
        '/list-usuarios',
        child: (context) => const ListJogadoresAdminPage(),
      )
      ..child(
        '/add-usuario',
        child: (context) => const AddUsuarioAdminPage(),
      )
      ..child(
        '/update-usuario',
        child: (context) => ChangeNotifierProvider(
          create: (context) => Modular.get<JogadorController>(),
          child: UpdateJogadorAdminPage(
            jogador: Modular.args.data,
          ),
        ),
      );
  }
}
