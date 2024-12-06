import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tennis_santa_rosa/core/utils/db_print.dart';
import 'package:tennis_santa_rosa/modules/usuario/_model/usuario_model.dart';

class FetchUsuariosRepository {
  Stream<List<UsuarioModel>> call() {
    try {
      final firestore = FirebaseFirestore.instance;
      return firestore.collection('usuarios').snapshots().map((snapshot) {
        return snapshot.docs
            .map((doc) => UsuarioModel.fromJson(doc.data()))
            .toList();
      });
    } catch (e) {
      const msg = 'Erro ao buscar usuários';
      dbPrint('$msg\n$e');
      throw Exception('$msg\n$e');
    }
  }
}
