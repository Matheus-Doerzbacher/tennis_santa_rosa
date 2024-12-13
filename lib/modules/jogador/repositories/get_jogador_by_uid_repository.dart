import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tennis_santa_rosa/modules/jogador/_model/jogador_model.dart';

class GetJogadorByUidRepository {
  Future<JogadorModel?> call(String uid) async {
    final firestore = FirebaseFirestore.instance;

    final docRef = await firestore.collection('usuarios').doc(uid).get();

    if (docRef.exists) {
      final usuarioJson = docRef.data();
      final usuario = JogadorModel.fromJson(usuarioJson!);
      return usuario;
    }
    return null;
  }
}
