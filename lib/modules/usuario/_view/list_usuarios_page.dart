import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
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
                child: StreamBuilder<void>(
                  stream: controller.fetchUsuarios(),
                  builder: (context, snapshot) {
                    final usuarios = controller.usuarios;
                    return ListView.builder(
                      itemCount: usuarios.length,
                      itemBuilder: (context, index) {
                        final usuario = usuarios[index];
                        return Column(
                          children: [
                            ListTile(
                              title:
                                  Text(usuario?.nome ?? usuario?.login ?? ''),
                              subtitle: Text(
                                usuario?.posicaoRankingAtual.toString() ?? '',
                              ),
                            ),
                            const Divider(),
                          ],
                        );
                      },
                    );
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
