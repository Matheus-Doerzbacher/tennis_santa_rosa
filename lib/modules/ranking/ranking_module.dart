import 'package:flutter_modular/flutter_modular.dart';
import 'package:provider/provider.dart';
import 'package:tennis_santa_rosa/modules/ranking/_views/detail_jogador_ranking_page.dart';
import 'package:tennis_santa_rosa/modules/ranking/_views/ranking_page.dart';
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
    r
      ..child(
        Modular.initialRoute,
        child: (context) => ChangeNotifierProvider(
          create: (context) => Modular.get<RankingController>(),
          child: const RankingPage(),
        ),
      )
      ..child(
        '/detail-jogador/:uid',
        child: (context) => DetailJogadorRankingPage(
          usuario: Modular.args.data,
        ),
      );
  }
}
