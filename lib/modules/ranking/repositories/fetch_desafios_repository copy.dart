import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tennis_santa_rosa/core/utils/db_print.dart';
import 'package:tennis_santa_rosa/modules/ranking/_models/desafio_model.dart';

class FetchDesafiosRepository {
  Future<List<DesafioModel>> call() async {
    try {
      final firestore = FirebaseFirestore.instance;
      final docRef = firestore.collection('desafios');
      final snapshot = await docRef.get();
      final desafios = snapshot.docs
          .map((doc) => DesafioModel.fromJson(doc.data()))
          .toList();
      return desafios;
    } catch (e) {
      dbPrint('Erro ao buscar desafios: $e');
      throw Exception('Erro ao buscar desafios: $e');
    }
  }
}
