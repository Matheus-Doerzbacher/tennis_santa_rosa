import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:tennis_santa_rosa/modules/auth/controller/auth_controller.dart';
import 'package:tennis_santa_rosa/modules/jogador/_model/usuario_model.dart';
import 'package:tennis_santa_rosa/modules/ranking/_models/desafio_model.dart';
import 'package:tennis_santa_rosa/modules/ranking/_views/_components/card_desafio_component.dart';
import 'package:tennis_santa_rosa/modules/ranking/controllers/detail_jogador_ranking_controller.dart';

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
        title: const Text('Perfil do Usuário'),
        actions: [
          Row(
            children: [
              IconButton(
                onPressed: () {
                  Modular.get<AuthController>().logout();
                  Modular.to.navigate('/auth/login');
                },
                icon: const Icon(Icons.exit_to_app),
              ),
              IconButton(
                onPressed: () {},
                icon: const Icon(Icons.edit),
              ),
            ],
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            Row(
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
                const Spacer(),
                const Text('Resultados:'),
                const SizedBox(width: 8),
                Text(
                  controller.desafios
                      .where((d) => d.idUsuarioVencedor == widget.usuario.uid)
                      .length
                      .toString(),
                  style: Theme.of(context).textTheme.titleMedium!.copyWith(
                        color: Colors.green,
                        fontWeight: FontWeight.bold,
                      ),
                ),
                const Text(' / '),
                Text(
                  controller.desafios
                      .where((d) => d.idUsuarioPerdedor == widget.usuario.uid)
                      .length
                      .toString(),
                  style: Theme.of(context).textTheme.titleMedium!.copyWith(
                        color: Colors.red,
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Card(
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
                      Icons.exposure_plus_2,
                      context,
                    ),
                    _buildStatCard(
                      'Total de Jogos',
                      controller.desafios
                          .where((d) => d.status == StatusDesafio.finalizado)
                          .length,
                      Icons.sports_tennis,
                      context,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 8),
            if (widget.usuario.situacao == Situacao.ferias)
              _buildCardSituacao(
                'Jogador em férias',
                Icons.sunny,
                Colors.yellow,
              ),
            if (widget.usuario.situacao == Situacao.machucado)
              _buildCardSituacao(
                'Jogador machucado',
                Icons.local_hospital,
                Colors.red,
              ),
            if (desafioPendente?.idUsuarioDesafiante == widget.usuario.uid!)
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  FilledButton.icon(
                    onPressed: () {},
                    icon: const Icon(Icons.check),
                    label: const Text('Subir resultado'),
                  ),
                  FilledButton.icon(
                    onPressed: () {},
                    icon: const Icon(Icons.close),
                    label: const Text('Cancelar'),
                    style: FilledButton.styleFrom(
                      backgroundColor: Theme.of(context).colorScheme.error,
                    ),
                  ),
                ],
              ),
            if (desafioPendente?.idUsuarioDesafiado == widget.usuario.uid!)
              FilledButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.close),
                label: const Text('Recusar desafio'),
                style: FilledButton.styleFrom(
                  backgroundColor: Theme.of(context).colorScheme.error,
                ),
              ),
            const SizedBox(height: 8),
            if (widget.usuario.uid !=
                Modular.get<AuthController>().usuario!.uid)
              FilledButton.icon(
                onPressed: podeDesafiar ? onSubmitNovoDesafio : null,
                icon:
                    controller.isLoadingButton ? null : const Icon(Icons.stars),
                label: controller.isLoadingButton
                    ? const CircularProgressIndicator()
                    : const Text('Desafiar pelo ranking'),
              ),
            const SizedBox(height: 8),
            if (controller.isLoading)
              const Expanded(
                child: Center(
                  child: CircularProgressIndicator(),
                ),
              )
            else
              Expanded(
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
          ],
        ),
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
        Icon(icon, size: 25, color: Theme.of(context).colorScheme.primary),
        const SizedBox(height: 8),
        Text(
          count.toString(),
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          title,
          style: Theme.of(context).textTheme.bodyMedium,
        ),
      ],
    );
  }

  Widget _buildCardSituacao(String mensagem, IconData icon, Color color) {
    return Card(
      child: Container(
        padding: const EdgeInsets.all(8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(mensagem),
            const SizedBox(width: 8),
            Icon(icon, color: color),
          ],
        ),
      ),
    );
  }
}
