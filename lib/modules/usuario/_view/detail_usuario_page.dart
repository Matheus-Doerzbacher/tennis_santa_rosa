import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:tennis_santa_rosa/modules/auth/controller/auth_controller.dart';

class DetailUsuarioPage extends StatelessWidget {
  const DetailUsuarioPage({super.key});

  @override
  Widget build(BuildContext context) {
    final usuario = Modular.get<AuthController>().usuario;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detalhes Iniciais'),
      ),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(usuario!.nome ?? ''),
            FilledButton(
              onPressed: () {
                Modular.get<AuthController>().logout();
                Modular.to.navigate('/auth/login');
              },
              child: const Text('Sair'),
            ),
          ],
        ),
      ),
    );
  }
}
