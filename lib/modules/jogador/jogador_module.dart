import 'package:flutter_modular/flutter_modular.dart';
import 'package:provider/provider.dart';
import 'package:tennis_santa_rosa/modules/jogador/_view/update_jogador_page.dart';
import 'package:tennis_santa_rosa/modules/jogador/controller/jogador_controller.dart';
import 'package:tennis_santa_rosa/modules/jogador/repositories/add_jogador_repository.dart';
import 'package:tennis_santa_rosa/modules/jogador/repositories/fetch_jogador_repository.dart';
import 'package:tennis_santa_rosa/modules/jogador/repositories/get_jogador_by_login_repository.dart';
import 'package:tennis_santa_rosa/modules/jogador/repositories/get_jogador_by_uid_repository.dart';
import 'package:tennis_santa_rosa/modules/jogador/repositories/salvar_imagem_jogador_repository.dart';
import 'package:tennis_santa_rosa/modules/jogador/repositories/stream_jogadores_repository.dart';
import 'package:tennis_santa_rosa/modules/jogador/repositories/update_jogador_repository.dart';

class JogadorModule extends Module {
  @override
  void exportedBinds(Injector i) {
    i
      ..add(
        StreamJogadoresRepository.new,
        key: 'exportedStreamJogadoresRepository',
      )
      ..add(
        UpdateJogadorRepository.new,
        key: 'exportedUpdateJogadoresRepository',
      )
      ..add(
        GetJogadorByLoginRepository.new,
        key: 'exportedGetJogadorByLoginRepository',
      )
      ..add(
        GetJogadorByUidRepository.new,
        key: 'exportedGetJogadorByUidRepository',
      )
      ..add(
        FetchJogadoresRepository.new,
        key: 'exportedFetchJogadoresRepository',
      )
      ..add(
        SalvarImagemJogadorRepository.new,
        key: 'exportedSalvarImagemJogadorRepository',
      );

    super.exportedBinds(i);
  }

  @override
  void binds(Injector i) {
    i
      ..add(AddJogadorRepository.new)
      ..add(StreamJogadoresRepository.new)
      ..add(UpdateJogadorRepository.new)
      ..add(GetJogadorByLoginRepository.new)
      ..add(FetchJogadoresRepository.new)
      ..add(GetJogadorByUidRepository.new)
      ..add(SalvarImagemJogadorRepository.new)
      // CONTROLLERS
      ..addLazySingleton(
        () => JogadorController(
          i(),
          i(),
          i(),
          i(),
          i(),
          i(),
        ),
      );
    super.binds(i);
  }

  @override
  void routes(RouteManager r) {
    r.child(
      '/update-usuario',
      child: (context) => ChangeNotifierProvider(
        create: (context) => Modular.get<JogadorController>(),
        child: UpdateJogadorPage(
          jogador: Modular.args.data,
        ),
      ),
    );
  }
}
