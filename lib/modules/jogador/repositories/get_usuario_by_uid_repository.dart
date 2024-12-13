import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tennis_santa_rosa/modules/jogador/_model/usuario_model.dart';

class GetUsuarioByIdRepository {
  Future<UsuarioModel?> call(String uid) async {
    final firestore = FirebaseFirestore.instance;

    final docRef = await firestore.collection('usuarios').doc(uid).get();

    if (docRef.exists) {
      final usuarioJson = docRef.data();
      final usuario = UsuarioModel.fromJson(usuarioJson!);
      return usuario;
    }
    return null;
  }
}
