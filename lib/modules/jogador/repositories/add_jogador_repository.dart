import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tennis_santa_rosa/core/utils/db_print.dart';
import 'package:tennis_santa_rosa/modules/jogador/_model/usuario_model.dart';

class AddJogadorRepository {
  Future<bool> call(UsuarioModel usuario) async {
    try {
      final firestore = FirebaseFirestore.instance;
      final docRef = firestore.collection('usuarios').doc();
      usuario.uid = docRef.id;
      await docRef.set(usuario.toJson());
      return true;
    } catch (e) {
      dbPrint(e);
      return false;
    }
  }
}
