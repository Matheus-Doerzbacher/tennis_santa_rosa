import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:tennis_santa_rosa/modules/jogador/_model/jogador_model.dart';
import 'package:tennis_santa_rosa/modules/ranking/_models/desafio_model.dart';
import 'package:tennis_santa_rosa/modules/ranking/_views/_components/card_desafio_component.dart';
import 'package:tennis_santa_rosa/modules/ranking/controllers/desafios_controller.dart';

class DesafiosPage extends StatefulWidget {
  const DesafiosPage({super.key});

  @override
  State<DesafiosPage> createState() => _DesafiosPageState();
}

class _DesafiosPageState extends State<DesafiosPage> {
  @override
  Widget build(BuildContext context) {
    final controller = Modular.get<DesafiosController>();

    JogadorModel? getUsuario(String uidJogador) {
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
            final desafiosPendentes = desafios
                .where((d) => d.status == StatusDesafio.pendente)
                .toList();
            final desafiosNaoPendentes = desafios
                .where((d) => d.status != StatusDesafio.pendente)
                .toList();

            return ListView(
              children: [
                const Padding(
                  padding: EdgeInsets.all(16),
                  child: Text(
                    'Desafios Pendentes',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
                ...desafiosPendentes.map((desafio) {
                  final desafiante = getUsuario(desafio.idUsuarioDesafiante);
                  final desafiado = getUsuario(desafio.idUsuarioDesafiado);
                  return Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: CardDesafioComponent(
                      desafio: desafio,
                      desafiante: desafiante,
                      desafiado: desafiado,
                    ),
                  );
                }).toList(),
                const Padding(
                  padding: EdgeInsets.all(16),
                  child: Text(
                    'Desafios Finalizados',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
                ...desafiosNaoPendentes.map((desafio) {
                  final desafiante = getUsuario(desafio.idUsuarioDesafiante);
                  final desafiado = getUsuario(desafio.idUsuarioDesafiado);
                  return Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: CardDesafioComponent(
                      desafio: desafio,
                      desafiante: desafiante,
                      desafiado: desafiado,
                    ),
                  );
                }).toList(),
              ],
            );
          }
        },
      ),
    );
  }
}
