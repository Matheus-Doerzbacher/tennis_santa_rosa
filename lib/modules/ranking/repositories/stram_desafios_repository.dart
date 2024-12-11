import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tennis_santa_rosa/core/utils/db_print.dart';
import 'package:tennis_santa_rosa/modules/ranking/_models/desafio_model.dart';

class StreamDesafiosRepository {
  Stream<List<DesafioModel>> call() {
    try {
      final firestore = FirebaseFirestore.instance;
      return firestore.collection('desafios').snapshots().map((snapshot) {
        final desafios = snapshot.docs
            .map((doc) => DesafioModel.fromJson(doc.data()))
            .toList()
          ..sort(
            (a, b) => (b.data).compareTo(a.data),
          );

        return desafios;
      });
    } catch (e) {
      dbPrint('Erro ao buscar desafios: $e');
      throw Exception('Erro ao buscar desafios: $e');
    }
  }
}
