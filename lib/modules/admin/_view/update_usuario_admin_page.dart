import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:tennis_santa_rosa/modules/admin/_view/_components/selecionar_foto.dart';
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
  File? _imageSelected;
  String? _urlImage;

  void _handleImagePick(File image) {
    setState(() {
      _imageSelected = image;
      _urlImage = null;
    });
  }

  Future<void> _handleSubmit() async {
    var imageUrl = '';

    if (_imageSelected != null) {
      imageUrl = await controller.salvarImageJogador(_imageSelected!);

      if (imageUrl.isEmpty) {
        throw Exception('Houve um problema ao salvar o livro');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Atualizar Usuário'),
      ),
      body: Column(
        children: [
          SelecionarFotoWidget(
            onImagePick: _handleImagePick,
            urlImage: _urlImage,
          ),
          Text(widget.usuario.nome ?? widget.usuario.login),
          FilledButton(
            onPressed: _handleSubmit,
            child: const Text('Atualizar'),
          ),
        ],
      ),
    );
  }
}
