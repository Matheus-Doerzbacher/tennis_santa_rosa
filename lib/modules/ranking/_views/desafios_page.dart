import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:intl/intl.dart';
import 'package:tennis_santa_rosa/modules/ranking/_models/desafio_model.dart';
import 'package:tennis_santa_rosa/modules/ranking/controllers/desafios_controller.dart';
import 'package:tennis_santa_rosa/modules/usuario/_model/usuario_model.dart';

class DesafiosPage extends StatefulWidget {
  const DesafiosPage({super.key});

  @override
  State<DesafiosPage> createState() => _DesafiosPageState();
}

class _DesafiosPageState extends State<DesafiosPage> {
  List<UsuarioModel> usuarios = [];

  @override
  void initState() {
    Modular.get<DesafiosController>().getUsuarios().then((value) {
      if (mounted) {
        setState(() {
          usuarios.addAll(value);
        });
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final controller = Modular.get<DesafiosController>();

    UsuarioModel getUsuario(String uidJogador) {
      return usuarios.firstWhere((usuario) => usuario.uid == uidJogador);
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
                String capitalize(String word) {
                  if (word.isEmpty) return word;
                  return word[0].toUpperCase() + word.substring(1);
                }

                final desafio = desafios[index];
                final desafiante = getUsuario(desafio.idUsuarioDesafiante);
                final desafiado = getUsuario(desafio.idUsuarioDesafiado);
                return Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Card(
                    child: Padding(
                      padding: const EdgeInsets.all(8),
                      child: Column(
                        children: [
                          if (desafio.status == StatusDesafio.pendente)
                            Column(
                              children: [
                                SizedBox(
                                  width: double.infinity,
                                  child: Text(
                                    'Data Desafio: ${DateFormat(
                                      "EEE dd 'de' MMM",
                                      'pt_BR',
                                    ).format(desafio.data).split(' ').map(
                                          (word) => word == 'de'
                                              ? word
                                              : capitalize(word),
                                        ).join(' ')}',
                                    textAlign: TextAlign.right,
                                  ),
                                ),
                                SizedBox(
                                  width: double.infinity,
                                  child: Text(
                                    'Vence: ${DateFormat(
                                      "EEE dd 'de' MMM",
                                      'pt_BR',
                                    ).format(
                                          desafio.data
                                              .add(const Duration(days: 8)),
                                        ).split(' ').map(
                                          (word) => word == 'de'
                                              ? word
                                              : capitalize(word),
                                        ).join(' ')}',
                                    textAlign: TextAlign.right,
                                  ),
                                ),
                              ],
                            ),
                          if (desafio.status == StatusDesafio.finalizado)
                            SizedBox(
                              width: double.infinity,
                              child: Text(
                                'Jogado: ${DateFormat(
                                  "EEE dd 'de' MMM",
                                  'pt_BR',
                                ).format(
                                      desafio.dataJogo!,
                                    ).split(' ').map(
                                      (word) => word == 'de'
                                          ? word
                                          : capitalize(word),
                                    ).join(' ')}',
                                textAlign: TextAlign.right,
                              ),
                            ),

                          // DESAFIANTE
                          _buildDesafioResultado(
                            desafio: desafio,
                            jogador: desafiante,
                            context: context,
                            isDesafiante: true,
                          ),
                          const SizedBox(height: 8),
                          // DESAFIADO
                          _buildDesafioResultado(
                            desafio: desafio,
                            jogador: desafiado,
                            context: context,
                            isDesafiante: false,
                          ),
                          const SizedBox(height: 8),
                          Text('Status: ${desafio.status.name}'),
                        ],
                      ),
                    ),
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }

  Widget _buildDesafioResultado({
    required DesafioModel desafio,
    required UsuarioModel jogador,
    required BuildContext context,
    required bool isDesafiante,
  }) {
    return Row(
      children: [
        CircleAvatar(
          foregroundImage:
              jogador.urlImage != null ? NetworkImage(jogador.urlImage!) : null,
          backgroundColor: Colors.grey,
          child: Text(jogador.nome![0]),
        ),
        const SizedBox(width: 8),
        Text(
          jogador.nome!,
          style: desafio.idUsuarioVencedor == jogador.uid
              ? Theme.of(context).textTheme.titleMedium
              : Theme.of(context).textTheme.bodyMedium,
        ),
        if (desafio.idUsuarioVencedor == jogador.uid)
          const Icon(Icons.check, color: Colors.green),
        const Spacer(),
        if (desafio.status == StatusDesafio.finalizado)
          Row(
            children: [
              Text(
                isDesafiante
                    ? '${desafio.game1Desafiante}'
                    : '${desafio.game1Desafiado}',
                style: desafio.game1Desafiante! > desafio.game1Desafiado!
                    ? isDesafiante
                        ? Theme.of(context).textTheme.titleMedium
                        : Theme.of(context).textTheme.bodyMedium
                    : isDesafiante
                        ? Theme.of(context).textTheme.bodyMedium
                        : Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(width: 16),
              Text(
                isDesafiante
                    ? '${desafio.game2Desafiante}'
                    : '${desafio.game2Desafiado}',
                style: desafio.game2Desafiante! > desafio.game2Desafiado!
                    ? isDesafiante
                        ? Theme.of(context).textTheme.titleMedium
                        : Theme.of(context).textTheme.bodyMedium
                    : isDesafiante
                        ? Theme.of(context).textTheme.bodyMedium
                        : Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(width: 16),
              if (desafio.tieBreakDesafiado != null &&
                  desafio.tieBreakDesafiante != null)
                Text(
                  isDesafiante
                      ? 'T${desafio.tieBreakDesafiante}'
                      : 'T${desafio.tieBreakDesafiado}',
                  style:
                      desafio.tieBreakDesafiante! > desafio.tieBreakDesafiado!
                          ? isDesafiante
                              ? Theme.of(context).textTheme.titleMedium
                              : Theme.of(context).textTheme.bodyMedium
                          : isDesafiante
                              ? Theme.of(context).textTheme.bodyMedium
                              : Theme.of(context).textTheme.titleMedium,
                ),
            ],
          )
        else
          const SizedBox.shrink(),
      ],
    );
  }
}
