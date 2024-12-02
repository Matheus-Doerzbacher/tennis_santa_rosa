import 'package:flutter_modular/flutter_modular.dart';
import 'package:tennis_santa_rosa/modules/usuario/usuario_module.dart';

class CoreModule extends Module {
  @override
  List<Module> get imports => [UsuarioModule()];
}
