import 'package:flutter/material.dart';
import 'package:tennis_santa_rosa/modules/usuario/_model/usuario_model.dart';

class DetailJogadorRankingPage extends StatelessWidget {
  final UsuarioModel usuario;

  const DetailJogadorRankingPage({super.key, required this.usuario});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detalhes do Jogador'),
      ),
      body: Center(
        child: Text(usuario.nome ?? usuario.login),
      ),
    );
  }
}
