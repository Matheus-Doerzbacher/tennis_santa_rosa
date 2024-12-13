import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:tennis_santa_rosa/modules/auth/controller/auth_controller.dart';
import 'package:tennis_santa_rosa/modules/ranking/_models/desafio_model.dart';
import 'package:tennis_santa_rosa/modules/ranking/_views/_components/card_desafio_component.dart';
import 'package:tennis_santa_rosa/modules/ranking/controllers/detail_jogador_ranking_controller.dart';
import 'package:tennis_santa_rosa/modules/ranking/controllers/ranking_controller.dart';
import 'package:tennis_santa_rosa/modules/usuario/_model/usuario_model.dart';

class DetailJogadorRankingPage extends StatefulWidget {
  final UsuarioModel usuario;

  const DetailJogadorRankingPage({super.key, required this.usuario});

  @override
  State<DetailJogadorRankingPage> createState() =>
      _DetailJogadorRankingPageState();
}

class _DetailJogadorRankingPageState extends State<DetailJogadorRankingPage> {
  DesafioModel? desafioPendente;
  bool podeDesafiar = false;
  @override
  void initState() {
    super.initState();
    final controller = Modular.get<DetailJogadorRankingController>();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.getUsuarioLogado().then((_) {
        controller.getDesafios(widget.usuario.uid!).then((_) {
          if (mounted) {
            setState(
              () => desafioPendente = controller.desafios
                  .where(
                    (d) => d.status == StatusDesafio.pendente,
                  )
                  .firstOrNull,
            );
            setState(() {
              podeDesafiar = controller.podeDesafiar(
                controller.usuarioLogado!,
                widget.usuario,
              );
            });
          }
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<DetailJogadorRankingController>();

    UsuarioModel getUsuario(String uid) {
      return controller.usuarios.firstWhere((element) => element.uid == uid);
    }

    Future<void> onSubmitNovoDesafio() async {
      final novoDesafio = DesafioModel(
        idUsuarioDesafiante: Modular.get<AuthController>().usuario!.uid!,
        idUsuarioDesafiado: widget.usuario.uid!,
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
                  backgroundImage: widget.usuario.urlImage != null
                      ? NetworkImage(widget.usuario.urlImage!)
                      : null,
                  radius: 40,
                  child: widget.usuario.urlImage == null
                      ? Icon(
                          Icons.person,
                          size: 40,
                          color: Theme.of(context).colorScheme.primary,
                        )
                      : null,
                ),
                const SizedBox(width: 16),
                Text(
                  widget.usuario.nome ?? widget.usuario.login,
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
                      widget.usuario.posicaoRankingAtual ?? 0,
                      Icons.emoji_events,
                      context,
                    ),
                    _buildStatCard(
                      'Jogos no mes',
                      widget.usuario.jogosNoMes,
                      Icons.sports_tennis,
                      context,
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),
          if (widget.usuario.uid != Modular.get<AuthController>().usuario!.uid)
            FilledButton.icon(
              onPressed: podeDesafiar ? onSubmitNovoDesafio : null,
              icon: controller.isLoadingButton ? null : const Icon(Icons.stars),
              label: controller.isLoadingButton
                  ? const CircularProgressIndicator()
                  : const Text('Desafiar pelo ranking'),
            ),
          if (controller.isLoading)
            const Expanded(
              child: Center(
                child: CircularProgressIndicator(),
              ),
            )
          else
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8),
                child: ListView.builder(
                  itemCount: controller.desafios.length,
                  itemBuilder: (context, index) => CardDesafioComponent(
                    desafio: controller.desafios[index],
                    desafiante: getUsuario(
                      controller.desafios[index].idUsuarioDesafiante,
                    ),
                    desafiado: getUsuario(
                      controller.desafios[index].idUsuarioDesafiado,
                    ),
                  ),
                ),
              ),
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
