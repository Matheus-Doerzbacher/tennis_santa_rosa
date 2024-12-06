import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:tennis_santa_rosa/modules/auth/controller/auth_controller.dart';
import 'package:tennis_santa_rosa/modules/ranking/controllers/ranking_controller.dart';

class RankingPage extends StatefulWidget {
  const RankingPage({super.key});

  @override
  State<RankingPage> createState() => _RankingPageState();
}

class _RankingPageState extends State<RankingPage> {
  @override
  void initState() {
    super.initState();
    Modular.get<RankingController>().getRanking().then(
          (_) => {if (mounted) setState(() {})},
        );
  }

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
        margin: const EdgeInsets.only(left: 5),
        width: 20,
        height: 20,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: Colors.grey,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Text(
          posicaoRankingAtual.toString(),
          style: Theme.of(context).textTheme.bodyMedium,
          textAlign: TextAlign.center,
        ),
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
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: controller.jogadores.length,
                itemBuilder: (context, index) {
                  final jogador = controller.jogadores[index];
                  return ListTile(
                    leading: positionRanking(jogador.posicaoRankingAtual),
                    title: Text(jogador.nome ?? jogador.login),
                    subtitle: Text('Jogos no mês: ${jogador.jogosNoMes}'),
                    trailing: Text(jogador.temDesafio ? '✅' : '❌'),
                  );
                },
              ),
            ),
            if (Modular.get<AuthController>().usuario?.isAdmin == true)
              ElevatedButton(
                onPressed: () => Modular.to.pushNamed('/admin/'),
                child: const Text('Admin Page'),
              ),
            ElevatedButton(
              onPressed: () {
                Modular.get<AuthController>().logout();
                Modular.to.navigate('/auth/login/');
              },
              child: const Text('Logout'),
            ),
            const SizedBox(height: 50),
          ],
        ),
      ),
    );
  }
}
