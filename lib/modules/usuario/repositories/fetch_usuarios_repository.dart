import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tennis_santa_rosa/core/utils/db_print.dart';
import 'package:tennis_santa_rosa/modules/usuario/_model/usuario_model.dart';

class FetchUsuariosRepository {
  Future<List<UsuarioModel>> call() async {
    try {
      final firestore = FirebaseFirestore.instance;
      final snapshot = await firestore.collection('usuarios').get();
      final usuarios =
          snapshot.docs.map((doc) => UsuarioModel.fromJson(doc.data())).toList()
            ..sort(
              (a, b) => (a.posicaoRankingAtual ?? 0)
                  .compareTo(b.posicaoRankingAtual ?? 0),
            );
      return usuarios;
    } catch (e) {
      const msg = 'Erro ao buscar usuários';
      dbPrint('$msg\n$e');
      throw Exception('$msg\n$e');
    }
  }
}
