import 'package:tennis_santa_rosa/modules/ranking/_models/desafio_model.dart';
import 'package:tennis_santa_rosa/modules/ranking/repositories/stram_desafios_repository.dart';
import 'package:tennis_santa_rosa/modules/usuario/_model/usuario_model.dart';
import 'package:tennis_santa_rosa/modules/usuario/repositories/fetch_usuarios_repository.dart';

class DesafiosController {
  final StreamDesafiosRepository _streamDesafiosRepository;
  final FetchUsuariosRepository _fetchUsuariosRepository;

  DesafiosController(
    this._streamDesafiosRepository,
    this._fetchUsuariosRepository,
  );

  Stream<List<DesafioModel>> streamDesafios() => _streamDesafiosRepository();

  Future<List<UsuarioModel>> getUsuarios() async {
    return _fetchUsuariosRepository();
  }
}
