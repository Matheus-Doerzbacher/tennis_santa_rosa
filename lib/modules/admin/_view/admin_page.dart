import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:tennis_santa_rosa/modules/auth/controller/auth_controller.dart';

class AdminPage extends StatelessWidget {
  const AdminPage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Modular.get<AuthController>();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin'),
      ),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(controller.usuario?.login ?? ''),
            ElevatedButton(
              onPressed: () {
                Modular.to.pushNamed('/usuario/list-usuarios');
              },
              child: const Text('Jogadores'),
            ),
            ElevatedButton(
              onPressed: () {
                controller.logout();
                Modular.to.navigate('/auth/login/');
              },
              child: const Text('Logout'),
            ),
          ],
        ),
      ),
    );
  }
}
