import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:tennis_santa_rosa/core/utils/db_print.dart';

class SalvarImagemJogadorRepository {
  Future<String> call(File imagem, String uid) async {
    try {
      final storage = FirebaseStorage.instance;
      final ref = storage.ref().child('jogadores').child(uid);
      final uploadTask = ref.putFile(imagem);
      final downloadUrl = await uploadTask;
      final url = await downloadUrl.ref.getDownloadURL();
      return url;
    } catch (e) {
      dbPrint('Erro ao salvar imagem no storage $e');
      return '';
    }
  }
}
