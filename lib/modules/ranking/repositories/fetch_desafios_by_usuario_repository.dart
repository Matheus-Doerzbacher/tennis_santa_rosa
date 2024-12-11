import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tennis_santa_rosa/core/utils/db_print.dart';
import 'package:tennis_santa_rosa/modules/ranking/_models/desafio_model.dart';

class FetchDesafiosByUsuarioRepository {
  Future<List<DesafioModel>> call(String uid) async {
    try {
      final firestore = FirebaseFirestore.instance;
      final docRef = firestore.collection('desafios');

      // Consulta para uidDesafiado
      final snapshotDesafiado =
          await docRef.where('idUsuarioDesafiado', isEqualTo: uid).get();

      // Consulta para uidDesafiante
      final snapshotDesafiante =
          await docRef.where('idUsuarioDesafiante', isEqualTo: uid).get();

      // Combina os resultados das duas consultas
      final desafios = [
        ...snapshotDesafiado.docs,
        ...snapshotDesafiante.docs,
      ].map((doc) => DesafioModel.fromJson(doc.data())).toList();

      return desafios;
    } catch (e) {
      dbPrint('Erro ao buscar desafios: $e');
      throw Exception('Erro ao buscar desafios: $e');
    }
  }
}
