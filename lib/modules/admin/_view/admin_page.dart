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
              onPressed: () {
                Modular.to.navigate('/usuario/list-usuarios');
              },
              child: const Text('Jogadores'),
            ),
            ElevatedButton(
              onPressed: () {
                Modular.to.navigate('/usuario/login/');
              },
              child: const Text('Login'),
            ),
          ],
        ),
      ),
    );
  }
}
