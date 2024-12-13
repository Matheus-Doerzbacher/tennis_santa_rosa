import 'package:flutter_modular/flutter_modular.dart';
import 'package:provider/provider.dart';
import 'package:tennis_santa_rosa/modules/jogador/jogador_module.dart';
import 'package:tennis_santa_rosa/modules/ranking/_views/detail_jogador_ranking_page.dart';
import 'package:tennis_santa_rosa/modules/ranking/_views/ranking_page.dart';
import 'package:tennis_santa_rosa/modules/ranking/controllers/desafios_controller.dart';
import 'package:tennis_santa_rosa/modules/ranking/controllers/detail_jogador_ranking_controller.dart';
import 'package:tennis_santa_rosa/modules/ranking/controllers/ranking_controller.dart';
import 'package:tennis_santa_rosa/modules/ranking/repositories/fetch_desafios_by_usuario_repository.dart';
import 'package:tennis_santa_rosa/modules/ranking/repositories/fetch_desafios_repository%20copy%202.dart';
import 'package:tennis_santa_rosa/modules/ranking/repositories/novo_desafio_repository.dart';
import 'package:tennis_santa_rosa/modules/ranking/repositories/stram_desafios_repository.dart';

class RankingModule extends Module {
  @override
  List<Module> get imports => [UsuarioModule()];

  @override
  void binds(Injector i) {
    i
      ..add(NovoDesafioRepository.new)
      ..add(FetchDesafiosRepository.new)
      ..add(StreamDesafiosRepository.new)
      ..add(FetchDesafiosByUsuarioRepository.new)

      // CONTROLLERS
      ..addLazySingleton(() => RankingController(i()))
      ..addLazySingleton(
        () => DetailJogadorRankingController(
          i(),
          i(),
          i(),
          i(),
          i(),
        ),
      )
      ..addLazySingleton(() => DesafiosController(i(), i()));
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
        child: (context) => ChangeNotifierProvider(
          create: (context) => Modular.get<DetailJogadorRankingController>(),
          child: DetailJogadorRankingPage(
            usuario: Modular.args.data,
          ),
        ),
      );
  }
}
