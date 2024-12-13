import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tennis_santa_rosa/core/utils/db_print.dart';
import 'package:tennis_santa_rosa/modules/jogador/_model/jogador_model.dart';

class UpdateJogadorRepository {
  Future<bool> call(JogadorModel jogador) async {
    try {
      final firestore = FirebaseFirestore.instance;
      final docRef =
          await firestore.collection('usuarios').doc(jogador.uid).get();

      if (docRef.exists) {
        await docRef.reference.update(jogador.toJson());
        return true;
      }
      return false;
    } catch (e) {
      dbPrint(e);
      return false;
    }
  }
}
