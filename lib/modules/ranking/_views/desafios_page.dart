import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:tennis_santa_rosa/modules/ranking/_models/desafio_model.dart';
import 'package:tennis_santa_rosa/modules/ranking/_views/_components/card_desafio_component.dart';
import 'package:tennis_santa_rosa/modules/ranking/controllers/desafios_controller.dart';
import 'package:tennis_santa_rosa/modules/usuario/_model/usuario_model.dart';

class DesafiosPage extends StatefulWidget {
  const DesafiosPage({super.key});

  @override
  State<DesafiosPage> createState() => _DesafiosPageState();
}

class _DesafiosPageState extends State<DesafiosPage> {
  @override
  Widget build(BuildContext context) {
    final controller = Modular.get<DesafiosController>();

    UsuarioModel? getUsuario(String uidJogador) {
      return controller.usuarios
          .where((usuario) => usuario.uid == uidJogador)
          .firstOrNull;
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Desafios'),
      ),
      body: StreamBuilder<List<DesafioModel>>(
        stream: controller.streamDesafios(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Erro: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('Nenhum usuário encontrado.'));
          } else {
            final desafios = snapshot.data!;
            return ListView.builder(
              itemCount: desafios.length,
              itemBuilder: (context, index) {
                final desafio = desafios[index];
                final desafiante = getUsuario(desafio.idUsuarioDesafiante);
                final desafiado = getUsuario(desafio.idUsuarioDesafiado);
                return Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: CardDesafioComponent(
                    desafio: desafio,
                    desafiante: desafiante!,
                    desafiado: desafiado!,
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}
