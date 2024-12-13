import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tennis_santa_rosa/core/utils/db_print.dart';
import 'package:tennis_santa_rosa/modules/jogador/_model/jogador_model.dart';

class AddJogadorRepository {
  Future<bool> call(JogadorModel jogador) async {
    try {
      final firestore = FirebaseFirestore.instance;
      final docRef = firestore.collection('usuarios').doc();
      jogador.uid = docRef.id;
      await docRef.set(jogador.toJson());
      return true;
    } catch (e) {
      dbPrint(e);
      return false;
    }
  }
}
