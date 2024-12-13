import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tennis_santa_rosa/core/utils/db_print.dart';
import 'package:tennis_santa_rosa/modules/jogador/_model/jogador_model.dart';

class StreamJogadoresRepository {
  Stream<List<JogadorModel>> call() {
    try {
      final firestore = FirebaseFirestore.instance;
      return firestore.collection('usuarios').snapshots().map((snapshot) {
        final usuarios = snapshot.docs
            .map((doc) => JogadorModel.fromJson(doc.data()))
            .toList()
          ..sort(
            (a, b) => (a.posicaoRankingAtual ?? 0)
                .compareTo(b.posicaoRankingAtual ?? 0),
          );
        return usuarios;
      });
    } catch (e) {
      const msg = 'Erro ao buscar usuários';
      dbPrint('$msg\n$e');
      throw Exception('$msg\n$e');
    }
  }
}
