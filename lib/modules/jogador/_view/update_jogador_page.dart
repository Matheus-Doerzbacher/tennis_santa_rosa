import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:tennis_santa_rosa/core/utils/db_print.dart';
import 'package:tennis_santa_rosa/core/utils/encryptPassword.dart';
import 'package:tennis_santa_rosa/modules/admin/_view/_components/selecionar_foto.dart';
import 'package:tennis_santa_rosa/modules/jogador/_model/jogador_model.dart';
import 'package:tennis_santa_rosa/modules/jogador/controller/jogador_controller.dart';

class UpdateJogadorPage extends StatefulWidget {
  final JogadorModel jogador;
  const UpdateJogadorPage({super.key, required this.jogador});

  @override
  State<UpdateJogadorPage> createState() => _UpdateJogadorPageState();
}

class _UpdateJogadorPageState extends State<UpdateJogadorPage> {
  final controller = Modular.get<JogadorController>();

  final _formKey = GlobalKey<FormState>();
  final _nomeController = TextEditingController();
  final _senhaController = TextEditingController();
  final _confirmarSenhaController = TextEditingController();
  final _telefoneController = TextEditingController();
  File? _imageSelected;
  String? _urlImage;

  @override
  void initState() {
    super.initState();
    _nomeController.text = widget.jogador.nome ?? '';
    _telefoneController.text = widget.jogador.telefone ?? '';
    _urlImage = widget.jogador.urlImage;
  }

  @override
  void dispose() {
    _nomeController.dispose();
    _senhaController.dispose();
    _confirmarSenhaController.dispose();
    _telefoneController.dispose();
    super.dispose();
  }

  void _handleImagePick(File image) {
    setState(() {
      _imageSelected = image;
      _urlImage = null;
    });
  }

  Future<void> _handleSubmit() async {
    if (!_formKey.currentState!.validate()) return;

    var imageUrl = '';
    try {
      if (_imageSelected != null) {
        imageUrl = await controller.salvarImageJogador(
          _imageSelected!,
          widget.jogador.uid!,
        );

        if (imageUrl.isEmpty) {
          throw Exception('Houve um problema ao salvar a imagem');
        }
      } else {
        imageUrl = _urlImage ?? '';
      }

      final jogadorAtualizado = widget.jogador.copyWith(
        nome: _nomeController.text,
        telefone: _telefoneController.text,
        urlImage: imageUrl,
        senha: _senhaController.text.isNotEmpty
            ? encryptPassword(_senhaController.text)
            : widget.jogador.senha,
      );

      await controller.updateJogador(jogadorAtualizado);
      Modular.to.pop();
    } catch (error) {
      dbPrint(error);
    }
  }

  @override
  Widget build(BuildContext context) {
    final watch = context.watch<JogadorController>();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Atualizar Jogador'),
      ),
      body: Container(
        padding: const EdgeInsets.all(24),
        width: double.infinity,
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              SelecionarFotoWidget(
                onImagePick: _handleImagePick,
                urlImage: _urlImage,
              ),
              TextFormField(
                controller: _nomeController,
                decoration: const InputDecoration(labelText: 'Nome'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Nome é obrigatório';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _telefoneController,
                decoration: const InputDecoration(labelText: 'Telefone'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Telefone é obrigatório';
                  }
                  return null;
                },
              ),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _senhaController,
                      decoration:
                          const InputDecoration(labelText: 'Nova Senha'),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: TextFormField(
                      controller: _confirmarSenhaController,
                      decoration:
                          const InputDecoration(labelText: 'Confirmar Senha'),
                      validator: (value) {
                        if (_senhaController.text != value) {
                          return 'As senhas não correspondem';
                        }
                        return null;
                      },
                    ),
                  ),
                ],
              ),
              const Spacer(),
              SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: watch.isLoading ? null : _handleSubmit,
                  child: watch.isLoading
                      ? const CircularProgressIndicator()
                      : const Text('Atualizar'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
