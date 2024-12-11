import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:tennis_santa_rosa/core/env.dart';
import 'package:tennis_santa_rosa/modules/ranking/controllers/ranking_controller.dart';
import 'package:tennis_santa_rosa/modules/usuario/_model/usuario_model.dart';

class RankingPage extends StatelessWidget {
  const RankingPage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<RankingController>();

    // funcao que retorna os dados do desafiante
    String? nomeDesafiante(String uidDesafiante, List<UsuarioModel> jogadores) {
      return jogadores
          .firstWhere(
            (jogador) => jogador.uid == uidDesafiante,
          )
          .nome;
    }

    // Função para retornar o ícone de posição do ranking
    dynamic positionRanking(int posicaoRankingAtual) {
      if (posicaoRankingAtual == 1) {
        return const Stack(
          alignment: Alignment.center,
          children: [
            Icon(
              Icons.emoji_events,
              color: Colors.yellow,
              size: 30,
            ),
            Positioned(
              top: 3,
              child: Text('1'),
            ),
          ],
        );
      } else if (posicaoRankingAtual == 2) {
        return const Stack(
          alignment: Alignment.center,
          children: [
            Icon(
              Icons.emoji_events,
              color: Colors.grey,
              size: 30,
            ),
            Positioned(
              top: 3,
              child: Text(
                '2',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        );
      } else if (posicaoRankingAtual == 3) {
        return const Stack(
          alignment: Alignment.center,
          children: [
            Icon(
              Icons.emoji_events,
              color: Colors.orange,
              size: 30,
            ),
            Positioned(
              top: 3,
              child: Text('3'),
            ),
          ],
        );
      } else {
        return Container(
          width: 30,
          height: 30,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: Colors.grey[300],
            borderRadius: BorderRadius.circular(15),
          ),
          child: Text(
            posicaoRankingAtual.toString(),
            style: Theme.of(context).textTheme.bodyMedium,
            textAlign: TextAlign.center,
          ),
        );
      }
    }

    // funcao que retorna o resultado da posicao do ranking anterior
    dynamic positionRankingAnterior(UsuarioModel jogador) {
      final result = (jogador.posicaoRankingAnterior ?? 0) -
          (jogador.posicaoRankingAtual ?? 0);
      Widget? icon;
      Widget text = const Text('');

      if (result == 0) {
        icon = const Icon(Icons.remove);
      } else if (result > 0) {
        text = Text(
          result.toString(),
          style: const TextStyle(color: Colors.green),
        );
        icon = const Icon(Icons.arrow_upward, color: Colors.green);
      } else {
        text = Text(
          result.toString(),
          style: const TextStyle(color: Colors.red),
        );
        icon = const Icon(Icons.arrow_downward, color: Colors.red);
      }
      return Expanded(
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            text,
            icon,
          ],
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Ranking'),
      ),
      body: StreamBuilder<List<UsuarioModel>>(
        stream: controller.streamRanking(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Erro: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('Nenhum usuário encontrado.'));
          } else {
            final jogadores = snapshot.data;
            final groupCount =
                (jogadores!.length / Env.jogadoresPorGrupo).ceil();
            return ListView.builder(
              itemCount: groupCount,
              itemBuilder: (context, groupIndex) {
                final startIndex = groupIndex * Env.jogadoresPorGrupo;
                final endIndex = (startIndex + Env.jogadoresPorGrupo)
                    .clamp(0, jogadores.length);
                final group = jogadores.sublist(startIndex, endIndex);

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ...group
                        .map(
                          (jogador) => SizedBox(
                            height: 60,
                            child: ListTile(
                              onTap: () => Modular.to.pushNamed(
                                '/ranking/detail-jogador/',
                                arguments: jogador,
                              ),
                              leading: positionRanking(
                                jogador.posicaoRankingAtual ?? 0,
                              ),
                              title: Text(
                                jogador.nome ?? jogador.login,
                                style: Theme.of(context).textTheme.titleMedium,
                              ),
                              subtitle: Text(
                                'Jogos no mês: ${jogador.jogosNoMes}',
                              ),
                              trailing: Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 8),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    positionRankingAnterior(jogador),
                                    if (jogador.temDesafio &&
                                        jogador.uidDesafiante != null)
                                      Text(
                                        // ignore: lines_longer_than_80_chars
                                        'D: ${nomeDesafiante(jogador.uidDesafiante ?? '', jogadores)}',
                                        style: Theme.of(context)
                                            .textTheme
                                            .titleSmall,
                                      )
                                    else
                                      const SizedBox.shrink(),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        )
                        .toList(),
                    const SizedBox(height: 16),
                    if (groupIndex < groupCount - 1) const Divider(),
                  ],
                );
              },
            );
          }
        },
      ),
    );
  }
}
