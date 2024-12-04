import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tennis_santa_rosa/modules/usuario/_model/usuario_model.dart';

class GetUsuarioRepository {
  Future<UsuarioModel?> call(String login) async {
    final firestore = FirebaseFirestore.instance;

    final docRef = await firestore
        .collection('usuarios')
        .where('login', isEqualTo: login)
        .get();

    if (docRef.docs.isNotEmpty) {
      final usuarioJson = docRef.docs.first.data();
      final usuario = UsuarioModel.fromJson(usuarioJson);
      return usuario;
    }
    return null;
  }
}
