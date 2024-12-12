import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:tennis_santa_rosa/core/utils/db_print.dart';
import 'package:tennis_santa_rosa/modules/auth/controller/auth_controller.dart';

class SalvarImagemJogadorRepository {
  Future<String> call(File imagem) async {
    try {
      final storage = FirebaseStorage.instance;
      final ref = storage
          .ref()
          .child('jogadores')
          .child(Modular.get<AuthController>().usuario?.login ?? '');
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
