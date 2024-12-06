import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:tennis_santa_rosa/modules/ranking/controllers/ranking_controller.dart';
import 'package:tennis_santa_rosa/modules/usuario/_model/usuario_model.dart';

class RankingPage extends StatefulWidget {
  const RankingPage({super.key});

  @override
  State<RankingPage> createState() => _RankingPageState();
}

class _RankingPageState extends State<RankingPage> {
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
    final result = jogador.posicaoRankingAnterior - jogador.posicaoRankingAtual;
    if (result == 0) {
      return const Icon(
        Icons.remove,
      );
    } else if (result > 0) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(result.toString(), style: const TextStyle(color: Colors.green)),
          const Icon(Icons.arrow_upward, color: Colors.green),
        ],
      );
    } else {
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            result.toString(),
            style: const TextStyle(color: Colors.red),
          ),
          const Icon(Icons.arrow_downward, color: Colors.red),
        ],
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<RankingController>();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ranking'),
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          await Modular.get<RankingController>().getRanking();
          if (mounted) setState(() {});
        },
        child: ListView.builder(
          itemCount: (controller.jogadores.length / 3).ceil(),
          itemBuilder: (context, groupIndex) {
            final startIndex = groupIndex * 3;
            final endIndex =
                (startIndex + 3).clamp(0, controller.jogadores.length);
            final group = controller.jogadores.sublist(startIndex, endIndex);

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ...group
                    .map(
                      (jogador) => SizedBox(
                        height: 60,
                        child: ListTile(
                          leading: positionRanking(jogador.posicaoRankingAtual),
                          title: Text(jogador.nome ?? jogador.login),
                          subtitle: Text('Jogos no mês: ${jogador.jogosNoMes}'),
                          trailing: positionRankingAnterior(jogador),
                        ),
                      ),
                    )
                    .toList(),
                const SizedBox(height: 20),
              ],
            );
          },
        ),
      ),
    );
  }
}
