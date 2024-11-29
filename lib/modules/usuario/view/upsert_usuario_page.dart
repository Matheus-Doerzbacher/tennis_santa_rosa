import 'dart:math';

import 'package:flutter/material.dart';

class UpsertUsuarioPage extends StatefulWidget {
  const UpsertUsuarioPage({super.key});

  @override
  State<UpsertUsuarioPage> createState() => _UpsertUsuarioPageState();
}

class _UpsertUsuarioPageState extends State<UpsertUsuarioPage> {
  final _formKey = GlobalKey<FormState>();
  final _nomeController = TextEditingController();
  final _emailController = TextEditingController();
  final _senhaController = TextEditingController();

  void gerarSenha() {
    final random = Random();
    const availableChars =
        'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
    final randomString = StringBuffer();

    for (var i = 0; i < 6; i++) {
      final randomIndex = random.nextInt(availableChars.codeUnits.length);
      randomString.write(availableChars[randomIndex]);
    }

    setState(() {
      _senhaController.text = randomString.toString();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Novo Jogador'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              // NOME
              TextFormField(
                controller: _nomeController,
                decoration: const InputDecoration(labelText: 'Nome'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Nome é obrigatório';
                  }

                  if (value.length < 3) {
                    return 'Nome deve ter mais de 3 caracteres';
                  }
                  return null;
                },
              ),
              // EMAIL
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(labelText: 'Email'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Email é obrigatório';
                  }

                  if (!value.contains('@')) {
                    return 'Email inválido';
                  }
                  return null;
                },
              ),
              // SENHA
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _senhaController,
                      decoration: const InputDecoration(labelText: 'Senha'),
                    ),
                  ),
                  // Expanded(
                  //   child: Text(_senhaController.text),
                  // ),
                  TextButton(
                    onPressed: gerarSenha,
                    child: const Text('Gerar senha'),
                  ),
                  // TextButton(
                  //   onPressed: () {
                  //     if (_senha != null) {
                  //       Clipboard.setData(ClipboardData(text: _senha!));
                  //     }
                  //   },
                  //   child: const Text('Copiar senha'),
                  // ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
