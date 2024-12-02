import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:tennis_santa_rosa/modules/usuario/controller/usuario_controller.dart';

class ListUsuariosPage extends StatelessWidget {
  const ListUsuariosPage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<UsuarioController>();

    return Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (controller.isLoading)
              const CircularProgressIndicator()
            else if (controller.usuarios.isNotEmpty)
              ListView.builder(
                itemCount: controller.usuarios.length,
                itemBuilder: (context, index) {
                  return Text(controller.usuarios[index]?.nome ?? '');
                },
              )
            else
              const Text('Não foram encontrados usuarios'),
            ElevatedButton(
              onPressed: () async {
                await Modular.to.pushNamed('/usuario/upsert-usuario');
              },
              child: const Text('Adicionar Jogador'),
            ),
          ],
        ),
      ),
    );
  }
}
