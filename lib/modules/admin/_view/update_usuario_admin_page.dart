import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:tennis_santa_rosa/modules/admin/controller/admin_controller.dart';
import 'package:tennis_santa_rosa/modules/usuario/_model/usuario_model.dart';

class UpdateUsuarioAdminPage extends StatefulWidget {
  final UsuarioModel usuario;
  const UpdateUsuarioAdminPage({super.key, required this.usuario});

  @override
  State<UpdateUsuarioAdminPage> createState() => _UpdateUsuarioAdminPageState();
}

class _UpdateUsuarioAdminPageState extends State<UpdateUsuarioAdminPage> {
  final controller = Modular.get<AdminController>();

  // final _formKey = GlobalKey<FormState>();
  // final _nomeController = TextEditingController();
  // final _loginController = TextEditingController();
  // final _senhaController = TextEditingController();
  // final _telefoneController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Atualizar Usuário'),
      ),
      body: Column(
        children: [
          Text(widget.usuario.nome ?? widget.usuario.login),
        ],
      ),
    );
  }
}
