import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ElevatedButton(
              onPressed: () async {
                Modular.to.navigate('/usuario/upsert-usuario');
              },
              child: const Text('Adicionar Jogador'),
            ),
          ],
        ),
      ),
    );
  }
}
