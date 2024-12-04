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
        leading: IconButton(
          onPressed: () => Modular.to.navigate('/'),
          icon: const Icon(Icons.arrow_back),
        ),
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
            if (controller.isLoading)
              const CircularProgressIndicator()
            else if (controller.usuarios.isNotEmpty)
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: ListView.builder(
                    itemCount: controller.usuarios.length,
                    itemBuilder: (context, index) {
                      final usuario = controller.usuarios[index];
                      return Column(
                        children: [
                          ListTile(
                            title: Text(usuario?.login ?? ''),
                            subtitle: Text(
                              usuario?.posicaoRankingAtual.toString() ?? '',
                            ),
                          ),
                          const Divider(),
                        ],
                      );
                    },
                  ),
                ),
              )
            else
              const Text('Não foram encontrados usuarios'),
          ],
        ),
      ),
    );
  }
}
