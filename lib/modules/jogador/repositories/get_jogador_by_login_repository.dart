import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tennis_santa_rosa/modules/jogador/_model/jogador_model.dart';

class GetJogadorByLoginRepository {
  Future<JogadorModel?> call(String login) async {
    final firestore = FirebaseFirestore.instance;

    final docRef = await firestore
        .collection('usuarios')
        .where('login', isEqualTo: login.toLowerCase())
        .get();

    if (docRef.docs.isNotEmpty) {
      final usuarioJson = docRef.docs.first.data();
      final usuario = JogadorModel.fromJson(usuarioJson);
      return usuario;
    }
    return null;
  }
}
