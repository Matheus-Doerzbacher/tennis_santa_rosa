import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:tennis_santa_rosa/modules/auth/controller/auth_controller.dart';
import 'package:tennis_santa_rosa/modules/ranking/_models/desafio_model.dart';
import 'package:tennis_santa_rosa/modules/ranking/controllers/detail_jogador_ranking_controller.dart';
import 'package:tennis_santa_rosa/modules/ranking/controllers/ranking_controller.dart';
import 'package:tennis_santa_rosa/modules/usuario/_model/usuario_model.dart';

class DetailJogadorRankingPage extends StatelessWidget {
  final UsuarioModel usuario;

  const DetailJogadorRankingPage({super.key, required this.usuario});

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<DetailJogadorRankingController>();

    Future<void> onSubmitNovoDesafio() async {
      final novoDesafio = DesafioModel(
        idUsuarioDesafiante: Modular.get<AuthController>().usuario!.uid!,
        idUsuarioDesafiado: usuario.uid!,
        data: DateTime.now(),
      );

      final response = await controller.novoDesafio(novoDesafio);
      if (response && context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Desafio realizado com sucesso'),
          ),
        );
        Modular.to.pop();
      } else if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'Jogador já possui um desafio',
            ),
          ),
        );
      }
    }

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text('Perfil do Usuário'),
      ),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 40,
                  child: Icon(
                    Icons.person,
                    size: 40,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
                const SizedBox(width: 16),
                Text(
                  usuario.nome ?? usuario.login,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildStatCard(
                      'Pos. Ranking',
                      usuario.posicaoRankingAtual ?? 0,
                      Icons.emoji_events,
                      context,
                    ),
                    _buildStatCard(
                      'Jogos no mes',
                      usuario.jogosNoMes,
                      Icons.sports_tennis,
                      context,
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),
          FilledButton.icon(
            onPressed: Modular.get<RankingController>().podeDesafiar(
                      Modular.get<AuthController>().usuario!,
                      usuario,
                    ) ||
                    controller.isLoading
                ? onSubmitNovoDesafio
                : null,
            icon: controller.isLoading
                ? const CircularProgressIndicator()
                : const Icon(Icons.stars),
            label: const Text('Desafiar pelo ranking'),
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(
    String title,
    int count,
    IconData icon,
    BuildContext context,
  ) {
    return Column(
      children: [
        Icon(icon, size: 30, color: Theme.of(context).colorScheme.primary),
        const SizedBox(height: 8),
        Text(
          count.toString(),
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          title,
          style: const TextStyle(
            fontSize: 16,
            color: Colors.grey,
          ),
        ),
      ],
    );
  }
}
