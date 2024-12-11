import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tennis_santa_rosa/core/utils/db_print.dart';
import 'package:tennis_santa_rosa/modules/ranking/_models/desafio.dart';

class NovoDesafioRepository {
  Future<bool> call(DesafioModel desafio) async {
    try {
      final firestore = FirebaseFirestore.instance;
      final desafioRef = firestore.collection('desafios').doc();
      final desafioAtualizado = desafio.copyWith(id: desafioRef.id);
      await desafioRef.set(desafioAtualizado.toJson());
      return true;
    } catch (e) {
      dbPrint('Erro ao criar desafio: $e');
      throw Exception('Erro ao criar desafio: $e');
    }
  }
}
