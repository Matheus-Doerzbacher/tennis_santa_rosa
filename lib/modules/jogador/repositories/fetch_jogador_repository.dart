import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tennis_santa_rosa/core/utils/db_print.dart';
import 'package:tennis_santa_rosa/modules/jogador/_model/jogador_model.dart';

class FetchJogadoresRepository {
  Future<List<JogadorModel>> call() async {
    try {
      final firestore = FirebaseFirestore.instance;
      final snapshot = await firestore.collection('usuarios').get();
      final usuarios =
          snapshot.docs.map((doc) => JogadorModel.fromJson(doc.data())).toList()
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
