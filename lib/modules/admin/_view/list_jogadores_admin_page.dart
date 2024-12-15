import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:tennis_santa_rosa/modules/jogador/_model/jogador_model.dart';
import 'package:tennis_santa_rosa/modules/jogador/controller/jogador_controller.dart';

class ListJogadoresAdminPage extends StatelessWidget {
  const ListJogadoresAdminPage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Modular.get<JogadorController>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Jogadores'),
        actions: [
          TextButton.icon(
            onPressed: () async {
              await Modular.to.pushNamed('/admin/add-usuario');
            },
            icon: const Icon(Icons.add),
            label: const Text('Adicionar'),
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: StreamBuilder<List<JogadorModel>>(
                  stream: controller.streamJogadores(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (snapshot.hasError) {
                      return Center(child: Text('Erro: ${snapshot.error}'));
                    } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      return const Center(
                        child: Text(
                          'Nenhum usuário encontrado.',
                        ),
                      );
                    } else {
                      final usuarios = snapshot.data!;
                      return ListView.builder(
                        itemCount: usuarios.length,
                        itemBuilder: (context, index) {
                          final usuario = usuarios[index];
                          return Column(
                            children: [
                              ListTile(
                                title: Text(usuario.nome ?? usuario.login),
                                trailing: IconButton(
                                  onPressed: () {
                                    Modular.to.pushNamed(
                                      '/jogador/update-usuario',
                                      arguments: usuario,
                                    );
                                  },
                                  icon: const Icon(Icons.edit),
                                ),
                              ),
                              const Divider(),
                            ],
                          );
                        },
                      );
                    }
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
