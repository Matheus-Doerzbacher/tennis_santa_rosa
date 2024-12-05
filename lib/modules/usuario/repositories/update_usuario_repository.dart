import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tennis_santa_rosa/core/utils/db_print.dart';
import 'package:tennis_santa_rosa/modules/usuario/_model/usuario_model.dart';

class UpdateUsuarioRepository {
  Future<bool> call(UsuarioModel usuario) async {
    try {
      final firestore = FirebaseFirestore.instance;
      final docRef =
          await firestore.collection('usuarios').doc(usuario.uid).get();

      if (docRef.exists) {
        await docRef.reference.update(usuario.toJson());
        return true;
      }
      return false;
    } catch (e) {
      dbPrint(e);
      return false;
    }
  }
}
