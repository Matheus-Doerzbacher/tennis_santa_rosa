import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:tennis_santa_rosa/modules/ranking/controllers/ranking_controller.dart';
import 'package:tennis_santa_rosa/modules/usuario/controller/usuario_controller.dart';

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

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<UsuarioController>();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ranking'),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: controller.usuarios.length,
              itemBuilder: (context, index) {
                final jogador = controller.usuarios[index]!;
                return ListTile(
                  leading: Text(jogador.posicaoRankingAtual.toString()),
                  title: Text(jogador.login),
                  subtitle: Text(jogador.jogosNoMes.toString()),
                );
              },
            ),
          ),
          ElevatedButton(
            onPressed: () => Modular.to.pushNamed('/admin/'),
            child: const Text('Admin Page'),
          ),
          const SizedBox(height: 50),
        ],
      ),
    );
  }
}
