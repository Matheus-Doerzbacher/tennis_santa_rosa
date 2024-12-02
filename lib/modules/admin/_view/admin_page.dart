import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';

class AdminPage extends StatelessWidget {
  const AdminPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ElevatedButton(
              onPressed: () async {
                await Modular.to.pushNamed('/usuario/list-usuarios');
              },
              child: const Text('Jogadores'),
            ),
          ],
        ),
      ),
    );
  }
}
