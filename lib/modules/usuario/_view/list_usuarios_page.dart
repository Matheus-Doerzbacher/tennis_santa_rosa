import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:tennis_santa_rosa/modules/usuario/_model/usuario_model.dart';
import 'package:tennis_santa_rosa/modules/usuario/controller/usuario_controller.dart';

class ListUsuariosPage extends StatelessWidget {
  const ListUsuariosPage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<UsuarioController>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Jogadores'),
        actions: [
          TextButton.icon(
            onPressed: () async {
              await Modular.to.pushNamed('/usuario/add-usuario');
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
                child: StreamBuilder<List<UsuarioModel>>(
                  stream: controller.streamUsuarios(),
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
                                subtitle: Text(
                                  usuario.posicaoRankingAtual.toString(),
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
